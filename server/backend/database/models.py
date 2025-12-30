"""
Database Models for Vehicle Traffic Monitoring System
"""
from datetime import datetime
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import Index

db = SQLAlchemy()

class Device(db.Model):
    """Device/Sensor Node"""
    __tablename__ = 'devices'

    id = db.Column(db.Integer, primary_key=True)
    device_id = db.Column(db.String(50), unique=True, nullable=False, index=True)
    device_name = db.Column(db.String(100))
    location = db.Column(db.String(200))

    # Hardware info
    hardware_version = db.Column(db.String(50))
    firmware_version = db.Column(db.String(50))

    # Configuration
    num_lanes = db.Column(db.Integer, default=2)
    enabled = db.Column(db.Boolean, default=True)

    # Status
    last_seen = db.Column(db.DateTime, index=True)
    status = db.Column(db.String(20), default='offline', index=True)  # online, offline, error
    battery_voltage = db.Column(db.Float)
    signal_quality = db.Column(db.Integer)

    # Statistics
    total_vehicles = db.Column(db.BigInteger, default=0)

    # Relationships
    traffic_data = db.relationship('TrafficData', back_populates='device',
                                   cascade='all, delete-orphan')
    alerts = db.relationship('Alert', back_populates='device',
                            cascade='all, delete-orphan')

    # Timestamps
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    def __repr__(self):
        return f'<Device {self.device_id}>'

    def to_dict(self):
        return {
            'id': self.id,
            'device_id': self.device_id,
            'device_name': self.device_name,
            'location': self.location,
            'hardware_version': self.hardware_version,
            'firmware_version': self.firmware_version,
            'num_lanes': self.num_lanes,
            'enabled': self.enabled,
            'last_seen': self.last_seen.isoformat() if self.last_seen else None,
            'status': self.status,
            'battery_voltage': self.battery_voltage,
            'signal_quality': self.signal_quality,
            'total_vehicles': self.total_vehicles,
            'created_at': self.created_at.isoformat(),
            'updated_at': self.updated_at.isoformat()
        }


class TrafficData(db.Model):
    """Traffic data from devices (every 10 minutes)"""
    __tablename__ = 'traffic_data'

    id = db.Column(db.BigInteger, primary_key=True)
    device_id = db.Column(db.Integer, db.ForeignKey('devices.id'), nullable=False, index=True)

    # Timing
    timestamp = db.Column(db.DateTime, nullable=False, index=True)
    interval_minutes = db.Column(db.Integer, default=10)

    # Environmental
    temperature = db.Column(db.Float)
    humidity = db.Column(db.Float)

    # Lane 1 Data
    lane1_total = db.Column(db.Integer, default=0)
    lane1_class_x = db.Column(db.Integer, default=0)  # Motorcycles
    lane1_class_a = db.Column(db.Integer, default=0)  # Cars
    lane1_class_b = db.Column(db.Integer, default=0)  # Vans
    lane1_class_c = db.Column(db.Integer, default=0)  # Buses
    lane1_class_d = db.Column(db.Integer, default=0)  # Heavy trucks
    lane1_class_e = db.Column(db.Integer, default=0)  # Trailers
    lane1_avg_speed = db.Column(db.Float)
    lane1_occupancy = db.Column(db.Float)
    lane1_violations = db.Column(db.Integer, default=0)

    # Lane 2 Data
    lane2_total = db.Column(db.Integer, default=0)
    lane2_class_x = db.Column(db.Integer, default=0)
    lane2_class_a = db.Column(db.Integer, default=0)
    lane2_class_b = db.Column(db.Integer, default=0)
    lane2_class_c = db.Column(db.Integer, default=0)
    lane2_class_d = db.Column(db.Integer, default=0)
    lane2_class_e = db.Column(db.Integer, default=0)
    lane2_avg_speed = db.Column(db.Float)
    lane2_occupancy = db.Column(db.Float)
    lane2_violations = db.Column(db.Integer, default=0)

    # Sensor Status (JSON or separate fields)
    sensor_status = db.Column(db.JSON)

    # Raw data (optional, for debugging)
    raw_data = db.Column(db.JSON)

    # Relationships
    device = db.relationship('Device', back_populates='traffic_data')

    # Timestamp
    created_at = db.Column(db.DateTime, default=datetime.utcnow, index=True)

    # Indexes for performance
    __table_args__ = (
        Index('idx_device_timestamp', 'device_id', 'timestamp'),
        Index('idx_timestamp_created', 'timestamp', 'created_at'),
    )

    def __repr__(self):
        return f'<TrafficData {self.device_id} @ {self.timestamp}>'

    def to_dict(self):
        return {
            'id': self.id,
            'device_id': self.device_id,
            'timestamp': self.timestamp.isoformat(),
            'interval_minutes': self.interval_minutes,
            'temperature': self.temperature,
            'humidity': self.humidity,
            'lane1': {
                'total': self.lane1_total,
                'classes': {
                    'X': self.lane1_class_x,
                    'A': self.lane1_class_a,
                    'B': self.lane1_class_b,
                    'C': self.lane1_class_c,
                    'D': self.lane1_class_d,
                    'E': self.lane1_class_e
                },
                'avg_speed': self.lane1_avg_speed,
                'occupancy': self.lane1_occupancy,
                'violations': self.lane1_violations
            },
            'lane2': {
                'total': self.lane2_total,
                'classes': {
                    'X': self.lane2_class_x,
                    'A': self.lane2_class_a,
                    'B': self.lane2_class_b,
                    'C': self.lane2_class_c,
                    'D': self.lane2_class_d,
                    'E': self.lane2_class_e
                },
                'avg_speed': self.lane2_avg_speed,
                'occupancy': self.lane2_occupancy,
                'violations': self.lane2_violations
            },
            'sensor_status': self.sensor_status,
            'created_at': self.created_at.isoformat()
        }


class Alert(db.Model):
    """System alerts and notifications"""
    __tablename__ = 'alerts'

    id = db.Column(db.BigInteger, primary_key=True)
    device_id = db.Column(db.Integer, db.ForeignKey('devices.id'), index=True)

    # Alert info
    alert_type = db.Column(db.String(50), nullable=False, index=True)  # offline, low_traffic, sensor_error, etc.
    severity = db.Column(db.String(20), default='warning')  # info, warning, error, critical
    message = db.Column(db.Text)
    details = db.Column(db.JSON)

    # Status
    acknowledged = db.Column(db.Boolean, default=False)
    resolved = db.Column(db.Boolean, default=False, index=True)
    resolved_at = db.Column(db.DateTime)

    # Relationships
    device = db.relationship('Device', back_populates='alerts')

    # Timestamps
    created_at = db.Column(db.DateTime, default=datetime.utcnow, index=True)
    
    # Composite indexes for common queries
    __table_args__ = (
        Index('idx_device_alert_resolved', 'device_id', 'alert_type', 'resolved'),
        Index('idx_resolved_created', 'resolved', 'created_at'),
    )

    def __repr__(self):
        return f'<Alert {self.alert_type} for Device {self.device_id}>'

    def to_dict(self):
        return {
            'id': self.id,
            'device_id': self.device_id,
            'alert_type': self.alert_type,
            'severity': self.severity,
            'message': self.message,
            'details': self.details,
            'acknowledged': self.acknowledged,
            'resolved': self.resolved,
            'resolved_at': self.resolved_at.isoformat() if self.resolved_at else None,
            'created_at': self.created_at.isoformat()
        }


class SystemLog(db.Model):
    """System activity logs"""
    __tablename__ = 'system_logs'

    id = db.Column(db.BigInteger, primary_key=True)

    # Log info
    level = db.Column(db.String(20), index=True)  # DEBUG, INFO, WARNING, ERROR
    component = db.Column(db.String(50))
    message = db.Column(db.Text)
    details = db.Column(db.JSON)

    # Context
    device_id = db.Column(db.String(50), index=True)
    user_id = db.Column(db.String(50))
    ip_address = db.Column(db.String(50))

    # Timestamp
    created_at = db.Column(db.DateTime, default=datetime.utcnow, index=True)

    def __repr__(self):
        return f'<SystemLog {self.level}: {self.message}>'
