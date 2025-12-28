"""
Data Analysis Service
Provides statistical analysis of traffic data
"""
from datetime import datetime, timedelta
from sqlalchemy import func
from database.models import Device, TrafficData


class DataAnalyzer:
    """Analyze traffic data and generate statistics"""

    def __init__(self, app, db):
        self.app = app
        self.db = db

    def get_device_statistics(self, device_id, start_time=None, end_time=None):
        """Get statistics for a specific device"""
        if start_time is None:
            start_time = datetime.utcnow() - timedelta(days=1)

        if end_time is None:
            end_time = datetime.utcnow()

        # Query traffic data
        query = self.db.session.query(TrafficData).filter(
            TrafficData.device_id == device_id,
            TrafficData.timestamp >= start_time,
            TrafficData.timestamp <= end_time
        )

        traffic_data = query.all()

        if not traffic_data:
            return {
                'device_id': device_id,
                'start_time': start_time.isoformat(),
                'end_time': end_time.isoformat(),
                'total_vehicles': 0,
                'lanes': []
            }

        # Calculate statistics
        total_vehicles = sum(d.lane1_total + d.lane2_total for d in traffic_data)

        lane1_stats = self._calculate_lane_stats(traffic_data, lane=1)
        lane2_stats = self._calculate_lane_stats(traffic_data, lane=2)

        return {
            'device_id': device_id,
            'start_time': start_time.isoformat(),
            'end_time': end_time.isoformat(),
            'total_vehicles': total_vehicles,
            'data_points': len(traffic_data),
            'lanes': [lane1_stats, lane2_stats],
            'avg_temperature': sum(d.temperature or 0 for d in traffic_data) / len(traffic_data),
            'avg_humidity': sum(d.humidity or 0 for d in traffic_data) / len(traffic_data)
        }

    def _calculate_lane_stats(self, traffic_data, lane):
        """Calculate statistics for a specific lane"""
        if lane == 1:
            total = sum(d.lane1_total for d in traffic_data)
            classes = {
                'X': sum(d.lane1_class_x for d in traffic_data),
                'A': sum(d.lane1_class_a for d in traffic_data),
                'B': sum(d.lane1_class_b for d in traffic_data),
                'C': sum(d.lane1_class_c for d in traffic_data),
                'D': sum(d.lane1_class_d for d in traffic_data),
                'E': sum(d.lane1_class_e for d in traffic_data)
            }
            avg_speed = sum(d.lane1_avg_speed or 0 for d in traffic_data) / len(traffic_data)
            avg_occupancy = sum(d.lane1_occupancy or 0 for d in traffic_data) / len(traffic_data)
            violations = sum(d.lane1_violations for d in traffic_data)
        else:
            total = sum(d.lane2_total for d in traffic_data)
            classes = {
                'X': sum(d.lane2_class_x for d in traffic_data),
                'A': sum(d.lane2_class_a for d in traffic_data),
                'B': sum(d.lane2_class_b for d in traffic_data),
                'C': sum(d.lane2_class_c for d in traffic_data),
                'D': sum(d.lane2_class_d for d in traffic_data),
                'E': sum(d.lane2_class_e for d in traffic_data)
            }
            avg_speed = sum(d.lane2_avg_speed or 0 for d in traffic_data) / len(traffic_data)
            avg_occupancy = sum(d.lane2_occupancy or 0 for d in traffic_data) / len(traffic_data)
            violations = sum(d.lane2_violations for d in traffic_data)

        return {
            'lane_id': lane,
            'total_vehicles': total,
            'vehicle_classes': classes,
            'avg_speed': round(avg_speed, 2),
            'avg_occupancy': round(avg_occupancy, 2),
            'total_violations': violations
        }

    def get_total_vehicles_today(self):
        """Get total vehicles across all devices today"""
        today_start = datetime.utcnow().replace(hour=0, minute=0, second=0, microsecond=0)

        result = self.db.session.query(
            func.sum(TrafficData.lane1_total + TrafficData.lane2_total)
        ).filter(
            TrafficData.timestamp >= today_start
        ).scalar()

        return result or 0

    def get_hourly_statistics(self, device_id, date):
        """Get hourly statistics for a specific device and date"""
        start_time = datetime.combine(date, datetime.min.time())
        end_time = start_time + timedelta(days=1)

        traffic_data = self.db.session.query(TrafficData).filter(
            TrafficData.device_id == device_id,
            TrafficData.timestamp >= start_time,
            TrafficData.timestamp < end_time
        ).order_by(TrafficData.timestamp).all()

        # Group by hour
        hourly_data = {}
        for data in traffic_data:
            hour = data.timestamp.hour
            if hour not in hourly_data:
                hourly_data[hour] = {
                    'hour': hour,
                    'total_vehicles': 0,
                    'lane1_total': 0,
                    'lane2_total': 0,
                    'data_points': 0
                }

            hourly_data[hour]['total_vehicles'] += data.lane1_total + data.lane2_total
            hourly_data[hour]['lane1_total'] += data.lane1_total
            hourly_data[hour]['lane2_total'] += data.lane2_total
            hourly_data[hour]['data_points'] += 1

        return sorted(hourly_data.values(), key=lambda x: x['hour'])

    def get_class_distribution(self, device_id, start_time=None, end_time=None):
        """Get vehicle class distribution"""
        if start_time is None:
            start_time = datetime.utcnow() - timedelta(days=7)

        if end_time is None:
            end_time = datetime.utcnow()

        query = self.db.session.query(TrafficData).filter(
            TrafficData.device_id == device_id,
            TrafficData.timestamp >= start_time,
            TrafficData.timestamp <= end_time
        )

        traffic_data = query.all()

        if not traffic_data:
            return {}

        # Sum all classes
        distribution = {
            'X': sum(d.lane1_class_x + d.lane2_class_x for d in traffic_data),
            'A': sum(d.lane1_class_a + d.lane2_class_a for d in traffic_data),
            'B': sum(d.lane1_class_b + d.lane2_class_b for d in traffic_data),
            'C': sum(d.lane1_class_c + d.lane2_class_c for d in traffic_data),
            'D': sum(d.lane1_class_d + d.lane2_class_d for d in traffic_data),
            'E': sum(d.lane1_class_e + d.lane2_class_e for d in traffic_data)
        }

        total = sum(distribution.values())

        # Calculate percentages
        if total > 0:
            for key in distribution:
                distribution[key] = {
                    'count': distribution[key],
                    'percentage': round((distribution[key] / total) * 100, 2)
                }

        return distribution

    def get_system_overview(self):
        """Get system-wide overview statistics"""
        now = datetime.utcnow()
        last_24h = now - timedelta(hours=24)

        total_devices = self.db.session.query(Device).count()
        online_devices = self.db.session.query(Device).filter_by(status='online').count()

        # Total vehicles in last 24h
        vehicles_24h = self.db.session.query(
            func.sum(TrafficData.lane1_total + TrafficData.lane2_total)
        ).filter(
            TrafficData.timestamp >= last_24h
        ).scalar() or 0

        # Get top 5 busiest devices
        top_devices = self.db.session.query(
            Device.device_id,
            Device.device_name,
            func.sum(TrafficData.lane1_total + TrafficData.lane2_total).label('total')
        ).join(TrafficData).filter(
            TrafficData.timestamp >= last_24h
        ).group_by(Device.id, Device.device_id, Device.device_name).order_by(
            func.sum(TrafficData.lane1_total + TrafficData.lane2_total).desc()
        ).limit(5).all()

        return {
            'total_devices': total_devices,
            'online_devices': online_devices,
            'offline_devices': total_devices - online_devices,
            'vehicles_24h': vehicles_24h,
            'top_devices': [
                {
                    'device_id': d[0],
                    'device_name': d[1],
                    'total_vehicles': d[2]
                }
                for d in top_devices
            ],
            'timestamp': now.isoformat()
        }
