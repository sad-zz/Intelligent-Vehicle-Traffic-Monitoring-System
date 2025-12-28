-- Vehicle Traffic Monitoring System Database Schema
-- PostgreSQL 12+

-- Create database (run as postgres user)
-- CREATE DATABASE vehicle_traffic_db;

-- Connect to database
\c vehicle_traffic_db;

-- Enable extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";  -- For text search

-- ========================================
-- Devices Table
-- ========================================
CREATE TABLE IF NOT EXISTS devices (
    id SERIAL PRIMARY KEY,
    device_id VARCHAR(50) UNIQUE NOT NULL,
    device_name VARCHAR(100),
    location VARCHAR(200),

    -- Hardware info
    hardware_version VARCHAR(50),
    firmware_version VARCHAR(50),

    -- Configuration
    num_lanes INTEGER DEFAULT 2,
    enabled BOOLEAN DEFAULT TRUE,

    -- Status
    last_seen TIMESTAMP,
    status VARCHAR(20) DEFAULT 'offline',  -- online, offline, error
    battery_voltage FLOAT,
    signal_quality INTEGER,

    -- Statistics
    total_vehicles BIGINT DEFAULT 0,

    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for devices
CREATE INDEX idx_devices_device_id ON devices(device_id);
CREATE INDEX idx_devices_status ON devices(status);
CREATE INDEX idx_devices_last_seen ON devices(last_seen);

-- ========================================
-- Traffic Data Table
-- ========================================
CREATE TABLE IF NOT EXISTS traffic_data (
    id BIGSERIAL PRIMARY KEY,
    device_id INTEGER NOT NULL REFERENCES devices(id) ON DELETE CASCADE,

    -- Timing
    timestamp TIMESTAMP NOT NULL,
    interval_minutes INTEGER DEFAULT 10,

    -- Environmental
    temperature FLOAT,
    humidity FLOAT,

    -- Lane 1 Data
    lane1_total INTEGER DEFAULT 0,
    lane1_class_x INTEGER DEFAULT 0,  -- Motorcycles
    lane1_class_a INTEGER DEFAULT 0,  -- Cars
    lane1_class_b INTEGER DEFAULT 0,  -- Vans
    lane1_class_c INTEGER DEFAULT 0,  -- Buses
    lane1_class_d INTEGER DEFAULT 0,  -- Heavy trucks
    lane1_class_e INTEGER DEFAULT 0,  -- Trailers
    lane1_avg_speed FLOAT,
    lane1_occupancy FLOAT,
    lane1_violations INTEGER DEFAULT 0,

    -- Lane 2 Data
    lane2_total INTEGER DEFAULT 0,
    lane2_class_x INTEGER DEFAULT 0,
    lane2_class_a INTEGER DEFAULT 0,
    lane2_class_b INTEGER DEFAULT 0,
    lane2_class_c INTEGER DEFAULT 0,
    lane2_class_d INTEGER DEFAULT 0,
    lane2_class_e INTEGER DEFAULT 0,
    lane2_avg_speed FLOAT,
    lane2_occupancy FLOAT,
    lane2_violations INTEGER DEFAULT 0,

    -- Sensor Status
    sensor_status JSONB,

    -- Raw data (optional)
    raw_data JSONB,

    -- Timestamp
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for traffic_data
CREATE INDEX idx_traffic_data_device_id ON traffic_data(device_id);
CREATE INDEX idx_traffic_data_timestamp ON traffic_data(timestamp);
CREATE INDEX idx_traffic_data_created_at ON traffic_data(created_at);
CREATE INDEX idx_traffic_data_device_timestamp ON traffic_data(device_id, timestamp);

-- Partitioning by month for better performance (PostgreSQL 10+)
-- Example for creating partitions:
-- CREATE TABLE traffic_data_2025_12 PARTITION OF traffic_data
--     FOR VALUES FROM ('2025-12-01') TO ('2026-01-01');

-- ========================================
-- Alerts Table
-- ========================================
CREATE TABLE IF NOT EXISTS alerts (
    id BIGSERIAL PRIMARY KEY,
    device_id INTEGER REFERENCES devices(id) ON DELETE SET NULL,

    -- Alert info
    alert_type VARCHAR(50) NOT NULL,  -- offline, low_traffic, sensor_error, etc.
    severity VARCHAR(20) DEFAULT 'warning',  -- info, warning, error, critical
    message TEXT,
    details JSONB,

    -- Status
    acknowledged BOOLEAN DEFAULT FALSE,
    resolved BOOLEAN DEFAULT FALSE,
    resolved_at TIMESTAMP,

    -- Timestamp
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for alerts
CREATE INDEX idx_alerts_device_id ON alerts(device_id);
CREATE INDEX idx_alerts_alert_type ON alerts(alert_type);
CREATE INDEX idx_alerts_severity ON alerts(severity);
CREATE INDEX idx_alerts_created_at ON alerts(created_at);
CREATE INDEX idx_alerts_resolved ON alerts(resolved);

-- ========================================
-- System Logs Table
-- ========================================
CREATE TABLE IF NOT EXISTS system_logs (
    id BIGSERIAL PRIMARY KEY,

    -- Log info
    level VARCHAR(20),  -- DEBUG, INFO, WARNING, ERROR
    component VARCHAR(50),
    message TEXT,
    details JSONB,

    -- Context
    device_id VARCHAR(50),
    user_id VARCHAR(50),
    ip_address VARCHAR(50),

    -- Timestamp
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for system_logs
CREATE INDEX idx_system_logs_level ON system_logs(level);
CREATE INDEX idx_system_logs_created_at ON system_logs(created_at);
CREATE INDEX idx_system_logs_device_id ON system_logs(device_id);

-- ========================================
-- Views
-- ========================================

-- View for current device status
CREATE OR REPLACE VIEW device_status_view AS
SELECT
    d.id,
    d.device_id,
    d.device_name,
    d.location,
    d.status,
    d.last_seen,
    d.battery_voltage,
    d.total_vehicles,
    COUNT(DISTINCT a.id) as active_alerts,
    (
        SELECT SUM(td.lane1_total + td.lane2_total)
        FROM traffic_data td
        WHERE td.device_id = d.id
        AND td.timestamp >= CURRENT_TIMESTAMP - INTERVAL '24 hours'
    ) as vehicles_24h
FROM devices d
LEFT JOIN alerts a ON a.device_id = d.id AND a.resolved = FALSE
GROUP BY d.id;

-- View for hourly traffic statistics
CREATE OR REPLACE VIEW hourly_traffic_stats AS
SELECT
    device_id,
    DATE_TRUNC('hour', timestamp) as hour,
    SUM(lane1_total + lane2_total) as total_vehicles,
    AVG(lane1_avg_speed) as lane1_avg_speed,
    AVG(lane2_avg_speed) as lane2_avg_speed,
    AVG(temperature) as avg_temperature,
    AVG(humidity) as avg_humidity
FROM traffic_data
WHERE timestamp >= CURRENT_TIMESTAMP - INTERVAL '7 days'
GROUP BY device_id, DATE_TRUNC('hour', timestamp)
ORDER BY hour DESC;

-- ========================================
-- Functions
-- ========================================

-- Function to update device updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for devices table
CREATE TRIGGER update_devices_updated_at
BEFORE UPDATE ON devices
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Function to clean old data
CREATE OR REPLACE FUNCTION cleanup_old_data(retention_days INTEGER DEFAULT 365)
RETURNS void AS $$
BEGIN
    -- Delete old traffic data
    DELETE FROM traffic_data
    WHERE created_at < CURRENT_TIMESTAMP - (retention_days || ' days')::INTERVAL;

    -- Delete old resolved alerts
    DELETE FROM alerts
    WHERE resolved = TRUE
    AND resolved_at < CURRENT_TIMESTAMP - (retention_days || ' days')::INTERVAL;

    -- Delete old logs
    DELETE FROM system_logs
    WHERE created_at < CURRENT_TIMESTAMP - (retention_days || ' days')::INTERVAL;

    -- Vacuum tables
    VACUUM ANALYZE traffic_data;
    VACUUM ANALYZE alerts;
    VACUUM ANALYZE system_logs;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- Sample Data (for testing)
-- ========================================

-- Insert sample device
INSERT INTO devices (device_id, device_name, location, hardware_version, firmware_version, status)
VALUES
    ('DEVICE001', 'Tehran Azadi Axis 1', 'Tehran - Azadi Square', 'STM32F407-V1', '1.0.0', 'online'),
    ('DEVICE002', 'Tehran Enghelab Axis 1', 'Tehran - Enghelab Square', 'STM32F407-V1', '1.0.0', 'online')
ON CONFLICT (device_id) DO NOTHING;

-- ========================================
-- Maintenance
-- ========================================

-- Create a scheduled job to cleanup old data (requires pg_cron extension)
-- SELECT cron.schedule('cleanup-old-data', '0 2 * * *', 'SELECT cleanup_old_data(365)');

-- Grant permissions (adjust as needed)
-- GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO vtms;
-- GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO vtms;

-- ========================================
-- Performance Optimization
-- ========================================

-- Analyze tables for query optimization
ANALYZE devices;
ANALYZE traffic_data;
ANALYZE alerts;
ANALYZE system_logs;

-- Vacuum tables
VACUUM ANALYZE devices;
VACUUM ANALYZE traffic_data;
VACUUM ANALYZE alerts;
VACUUM ANALYZE system_logs;

COMMENT ON TABLE devices IS 'IoT devices/sensor nodes';
COMMENT ON TABLE traffic_data IS 'Traffic data collected from devices every 10 minutes';
COMMENT ON TABLE alerts IS 'System alerts and notifications';
COMMENT ON TABLE system_logs IS 'System activity logs';
