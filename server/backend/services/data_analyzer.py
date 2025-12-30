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

        # Use SQL aggregations for better performance
        aggregates = self.db.session.query(
            func.count(TrafficData.id).label('data_points'),
            func.sum(TrafficData.lane1_total + TrafficData.lane2_total).label('total_vehicles'),
            func.avg(TrafficData.temperature).label('avg_temperature'),
            func.avg(TrafficData.humidity).label('avg_humidity'),
            # Lane 1 aggregations
            func.sum(TrafficData.lane1_total).label('lane1_total'),
            func.sum(TrafficData.lane1_class_x).label('lane1_class_x'),
            func.sum(TrafficData.lane1_class_a).label('lane1_class_a'),
            func.sum(TrafficData.lane1_class_b).label('lane1_class_b'),
            func.sum(TrafficData.lane1_class_c).label('lane1_class_c'),
            func.sum(TrafficData.lane1_class_d).label('lane1_class_d'),
            func.sum(TrafficData.lane1_class_e).label('lane1_class_e'),
            func.avg(TrafficData.lane1_avg_speed).label('lane1_avg_speed'),
            func.avg(TrafficData.lane1_occupancy).label('lane1_avg_occupancy'),
            func.sum(TrafficData.lane1_violations).label('lane1_violations'),
            # Lane 2 aggregations
            func.sum(TrafficData.lane2_total).label('lane2_total'),
            func.sum(TrafficData.lane2_class_x).label('lane2_class_x'),
            func.sum(TrafficData.lane2_class_a).label('lane2_class_a'),
            func.sum(TrafficData.lane2_class_b).label('lane2_class_b'),
            func.sum(TrafficData.lane2_class_c).label('lane2_class_c'),
            func.sum(TrafficData.lane2_class_d).label('lane2_class_d'),
            func.sum(TrafficData.lane2_class_e).label('lane2_class_e'),
            func.avg(TrafficData.lane2_avg_speed).label('lane2_avg_speed'),
            func.avg(TrafficData.lane2_occupancy).label('lane2_avg_occupancy'),
            func.sum(TrafficData.lane2_violations).label('lane2_violations')
        ).filter(
            TrafficData.device_id == device_id,
            TrafficData.timestamp >= start_time,
            TrafficData.timestamp <= end_time
        ).first()

        if not aggregates or aggregates.data_points == 0:
            return {
                'device_id': device_id,
                'start_time': start_time.isoformat(),
                'end_time': end_time.isoformat(),
                'total_vehicles': 0,
                'lanes': []
            }

        # Build lane statistics from aggregated data
        lane1_stats = {
            'lane_id': 1,
            'total_vehicles': aggregates.lane1_total or 0,
            'vehicle_classes': {
                'X': aggregates.lane1_class_x or 0,
                'A': aggregates.lane1_class_a or 0,
                'B': aggregates.lane1_class_b or 0,
                'C': aggregates.lane1_class_c or 0,
                'D': aggregates.lane1_class_d or 0,
                'E': aggregates.lane1_class_e or 0
            },
            'avg_speed': round(aggregates.lane1_avg_speed or 0, 2),
            'avg_occupancy': round(aggregates.lane1_avg_occupancy or 0, 2),
            'total_violations': aggregates.lane1_violations or 0
        }

        lane2_stats = {
            'lane_id': 2,
            'total_vehicles': aggregates.lane2_total or 0,
            'vehicle_classes': {
                'X': aggregates.lane2_class_x or 0,
                'A': aggregates.lane2_class_a or 0,
                'B': aggregates.lane2_class_b or 0,
                'C': aggregates.lane2_class_c or 0,
                'D': aggregates.lane2_class_d or 0,
                'E': aggregates.lane2_class_e or 0
            },
            'avg_speed': round(aggregates.lane2_avg_speed or 0, 2),
            'avg_occupancy': round(aggregates.lane2_avg_occupancy or 0, 2),
            'total_violations': aggregates.lane2_violations or 0
        }

        return {
            'device_id': device_id,
            'start_time': start_time.isoformat(),
            'end_time': end_time.isoformat(),
            'total_vehicles': aggregates.total_vehicles or 0,
            'data_points': aggregates.data_points,
            'lanes': [lane1_stats, lane2_stats],
            'avg_temperature': round(aggregates.avg_temperature or 0, 2),
            'avg_humidity': round(aggregates.avg_humidity or 0, 2)
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

        # Use SQL GROUP BY for better performance
        from sqlalchemy import extract
        
        hourly_aggregates = self.db.session.query(
            extract('hour', TrafficData.timestamp).label('hour'),
            func.sum(TrafficData.lane1_total + TrafficData.lane2_total).label('total_vehicles'),
            func.sum(TrafficData.lane1_total).label('lane1_total'),
            func.sum(TrafficData.lane2_total).label('lane2_total'),
            func.count(TrafficData.id).label('data_points')
        ).filter(
            TrafficData.device_id == device_id,
            TrafficData.timestamp >= start_time,
            TrafficData.timestamp < end_time
        ).group_by(extract('hour', TrafficData.timestamp)).all()

        # Convert to dictionary format
        hourly_data = [
            {
                'hour': int(row.hour),
                'total_vehicles': row.total_vehicles or 0,
                'lane1_total': row.lane1_total or 0,
                'lane2_total': row.lane2_total or 0,
                'data_points': row.data_points
            }
            for row in hourly_aggregates
        ]

        return sorted(hourly_data, key=lambda x: x['hour'])

    def get_class_distribution(self, device_id, start_time=None, end_time=None):
        """Get vehicle class distribution"""
        if start_time is None:
            start_time = datetime.utcnow() - timedelta(days=7)

        if end_time is None:
            end_time = datetime.utcnow()

        # Use SQL aggregations for better performance
        aggregates = self.db.session.query(
            func.sum(TrafficData.lane1_class_x + TrafficData.lane2_class_x).label('class_x'),
            func.sum(TrafficData.lane1_class_a + TrafficData.lane2_class_a).label('class_a'),
            func.sum(TrafficData.lane1_class_b + TrafficData.lane2_class_b).label('class_b'),
            func.sum(TrafficData.lane1_class_c + TrafficData.lane2_class_c).label('class_c'),
            func.sum(TrafficData.lane1_class_d + TrafficData.lane2_class_d).label('class_d'),
            func.sum(TrafficData.lane1_class_e + TrafficData.lane2_class_e).label('class_e')
        ).filter(
            TrafficData.device_id == device_id,
            TrafficData.timestamp >= start_time,
            TrafficData.timestamp <= end_time
        ).first()

        if not aggregates:
            return {}

        # Sum all classes
        distribution = {
            'X': aggregates.class_x or 0,
            'A': aggregates.class_a or 0,
            'B': aggregates.class_b or 0,
            'C': aggregates.class_c or 0,
            'D': aggregates.class_d or 0,
            'E': aggregates.class_e or 0
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
