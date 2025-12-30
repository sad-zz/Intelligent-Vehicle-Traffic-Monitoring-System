"""
Device Health Monitoring Service
Monitors devices and generates alerts for issues
"""
from datetime import datetime, timedelta
from sqlalchemy import func
from apscheduler.schedulers.background import BackgroundScheduler
from database.models import Device, TrafficData, Alert


class DeviceMonitor:
    """Monitor device health and generate alerts"""

    def __init__(self, app, db):
        self.app = app
        self.db = db
        self.scheduler = BackgroundScheduler()

    def start_monitoring(self):
        """Start background monitoring"""
        # Check all devices every 5 minutes
        self.scheduler.add_job(
            func=self.check_all_devices,
            trigger='interval',
            minutes=5,
            id='check_all_devices'
        )

        self.scheduler.start()
        print("Device monitoring started")

    def check_all_devices(self):
        """Check health of all devices"""
        with self.app.app_context():
            devices = self.db.session.query(Device).filter_by(enabled=True).all()

            for device in devices:
                self.check_device_health(device.id)

    def check_device_health(self, device_id):
        """Check health of specific device"""
        device = self.db.session.query(Device).get(device_id)

        if not device or not device.enabled:
            return

        now = datetime.utcnow()

        # Check 1: Device offline (no data received)
        if device.last_seen:
            time_since_last_seen = now - device.last_seen
            timeout_minutes = self.app.config['DEVICE_TIMEOUT_MINUTES']

            if time_since_last_seen > timedelta(minutes=timeout_minutes):
                self._create_alert(
                    device=device,
                    alert_type='device_offline',
                    severity='error',
                    message=f'Device {device.device_id} has been offline for {int(time_since_last_seen.total_seconds() / 60)} minutes',
                    details={'last_seen': device.last_seen.isoformat()}
                )

                if device.status != 'offline':
                    device.status = 'offline'
                    self.db.session.commit()

        # Check 2: Low battery
        if device.battery_voltage and device.battery_voltage < 11.0:
            self._create_alert(
                device=device,
                alert_type='low_battery',
                severity='warning',
                message=f'Device {device.device_id} has low battery: {device.battery_voltage}V',
                details={'battery_voltage': device.battery_voltage}
            )

        # Check 3: Low traffic (compared to average)
        self._check_low_traffic(device)

        # Check 4: Sensor errors
        self._check_sensor_errors(device)

    def _check_low_traffic(self, device):
        """Check if traffic is abnormally low"""
        # Get traffic data for last hour
        one_hour_ago = datetime.utcnow() - timedelta(hours=1)

        # Use SQL aggregation for better performance
        device_stats = self.db.session.query(
            func.count(TrafficData.id).label('count'),
            func.sum(TrafficData.lane1_total + TrafficData.lane2_total).label('total_vehicles')
        ).filter(
            TrafficData.device_id == device.id,
            TrafficData.timestamp >= one_hour_ago
        ).first()

        if not device_stats or device_stats.count == 0:
            return

        # Calculate average vehicles per interval
        avg_per_interval = device_stats.total_vehicles / device_stats.count if device_stats.count > 0 else 0

        # Get average from all devices for comparison
        all_devices_avg = self._get_system_average_traffic(one_hour_ago)

        # If this device is less than 10% of system average, raise alert
        threshold = self.app.config['DEVICE_LOW_TRAFFIC_THRESHOLD']

        if all_devices_avg > 0 and avg_per_interval < (all_devices_avg * threshold):
            self._create_alert(
                device=device,
                alert_type='low_traffic',
                severity='warning',
                message=f'Device {device.device_id} reporting abnormally low traffic',
                details={
                    'device_average': avg_per_interval,
                    'system_average': all_devices_avg,
                    'threshold': threshold
                }
            )

    def _check_sensor_errors(self, device):
        """Check for sensor errors"""
        # Get most recent traffic data
        recent_data = self.db.session.query(TrafficData).filter(
            TrafficData.device_id == device.id
        ).order_by(TrafficData.timestamp.desc()).first()

        if not recent_data or not recent_data.sensor_status:
            return

        sensor_status = recent_data.sensor_status

        # Check each sensor
        for sensor_id, status in sensor_status.items():
            if status != 'ok':
                self._create_alert(
                    device=device,
                    alert_type='sensor_error',
                    severity='error',
                    message=f'Device {device.device_id} sensor {sensor_id} error: {status}',
                    details={
                        'sensor_id': sensor_id,
                        'sensor_status': status
                    }
                )

    def _get_system_average_traffic(self, since):
        """Get average traffic across all devices"""
        # Use SQL aggregation for better performance
        system_stats = self.db.session.query(
            func.count(TrafficData.id).label('count'),
            func.sum(TrafficData.lane1_total + TrafficData.lane2_total).label('total_vehicles')
        ).filter(
            TrafficData.timestamp >= since
        ).first()

        if not system_stats or system_stats.count == 0:
            return 0

        return system_stats.total_vehicles / system_stats.count

    def _create_alert(self, device, alert_type, severity, message, details):
        """Create alert if one doesn't already exist"""
        # Check if similar unresolved alert exists
        existing_alert = self.db.session.query(Alert).filter(
            Alert.device_id == device.id,
            Alert.alert_type == alert_type,
            Alert.resolved == False
        ).first()

        if existing_alert:
            # Update existing alert
            existing_alert.message = message
            existing_alert.details = details
            existing_alert.created_at = datetime.utcnow()
        else:
            # Create new alert
            alert = Alert(
                device_id=device.id,
                alert_type=alert_type,
                severity=severity,
                message=message,
                details=details
            )
            self.db.session.add(alert)

        self.db.session.commit()

        print(f"Alert created: {alert_type} for device {device.device_id}")
