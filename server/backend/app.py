"""
Main Flask Application for Vehicle Traffic Monitoring System
"""
import os
import json
import socket
import threading
from datetime import datetime, timedelta
from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_socketio import SocketIO, emit

from config import config
from database.models import db, Device, TrafficData, Alert, SystemLog
from services.device_monitor import DeviceMonitor
from services.data_analyzer import DataAnalyzer

# Initialize Flask app
app = Flask(__name__)
app.config.from_object(config[os.getenv('FLASK_ENV', 'development')])

# Initialize extensions
CORS(app)
socketio = SocketIO(app, cors_allowed_origins="*")
db.init_app(app)

# Initialize services
device_monitor = DeviceMonitor(app, db)
data_analyzer = DataAnalyzer(app, db)

# ==================== TCP Server for Device Communication ====================

class TCPServer:
    """TCP Server to receive data from devices"""

    def __init__(self, host, port):
        self.host = host
        self.port = port
        self.server_socket = None
        self.running = False

    def start(self):
        """Start TCP server"""
        self.server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.server_socket.bind((self.host, self.port))
        self.server_socket.listen(10)
        self.running = True

        print(f"TCP Server started on {self.host}:{self.port}")

        while self.running:
            try:
                client_socket, address = self.server_socket.accept()
                print(f"Connection from {address}")

                # Handle client in separate thread
                client_thread = threading.Thread(
                    target=self.handle_client,
                    args=(client_socket, address)
                )
                client_thread.daemon = True
                client_thread.start()
            except Exception as e:
                if self.running:
                    print(f"Error accepting connection: {e}")

    def handle_client(self, client_socket, address):
        """Handle client connection"""
        buffer = ""

        try:
            while True:
                data = client_socket.recv(4096).decode('utf-8')
                if not data:
                    break

                buffer += data

                # Process complete JSON messages (separated by newline)
                while '\n' in buffer:
                    line, buffer = buffer.split('\n', 1)
                    if line.strip():
                        self.process_message(line.strip(), address)

        except Exception as e:
            print(f"Error handling client {address}: {e}")
        finally:
            client_socket.close()
            print(f"Connection closed from {address}")

    def process_message(self, message, address):
        """Process received message from device"""
        try:
            data = json.loads(message)

            with app.app_context():
                # Get or create device
                device = Device.query.filter_by(device_id=data['device_id']).first()

                if not device:
                    device = Device(
                        device_id=data['device_id'],
                        device_name=data.get('location', f'Device {data["device_id"]}'),
                        location=data.get('location', 'Unknown')
                    )
                    db.session.add(device)
                    db.session.flush()

                # Update device status
                device.last_seen = datetime.utcnow()
                device.status = 'online'
                device.battery_voltage = data.get('battery_voltage')
                device.firmware_version = data.get('firmware_version')
                device.hardware_version = data.get('hardware_version')

                # Parse timestamp
                timestamp = datetime.fromisoformat(data['timestamp'].replace('Z', '+00:00'))

                # Extract lane data
                lanes = data.get('lanes', [])
                lane1_data = lanes[0] if len(lanes) > 0 else {}
                lane2_data = lanes[1] if len(lanes) > 1 else {}

                # Create traffic data record
                traffic_data = TrafficData(
                    device_id=device.id,
                    timestamp=timestamp,
                    interval_minutes=data.get('interval_minutes', 10),
                    temperature=data.get('temperature'),
                    humidity=data.get('humidity'),

                    # Lane 1
                    lane1_total=lane1_data.get('total_vehicles', 0),
                    lane1_class_x=lane1_data.get('vehicles', {}).get('class_X', {}).get('count', 0),
                    lane1_class_a=lane1_data.get('vehicles', {}).get('class_A', {}).get('count', 0),
                    lane1_class_b=lane1_data.get('vehicles', {}).get('class_B', {}).get('count', 0),
                    lane1_class_c=lane1_data.get('vehicles', {}).get('class_C', {}).get('count', 0),
                    lane1_class_d=lane1_data.get('vehicles', {}).get('class_D', {}).get('count', 0),
                    lane1_class_e=lane1_data.get('vehicles', {}).get('class_E', {}).get('count', 0),
                    lane1_avg_speed=self._get_avg_speed(lane1_data.get('vehicles', {})),
                    lane1_occupancy=lane1_data.get('occupancy_rate', 0),
                    lane1_violations=self._get_total_violations(lane1_data.get('vehicles', {})),

                    # Lane 2
                    lane2_total=lane2_data.get('total_vehicles', 0),
                    lane2_class_x=lane2_data.get('vehicles', {}).get('class_X', {}).get('count', 0),
                    lane2_class_a=lane2_data.get('vehicles', {}).get('class_A', {}).get('count', 0),
                    lane2_class_b=lane2_data.get('vehicles', {}).get('class_B', {}).get('count', 0),
                    lane2_class_c=lane2_data.get('vehicles', {}).get('class_C', {}).get('count', 0),
                    lane2_class_d=lane2_data.get('vehicles', {}).get('class_D', {}).get('count', 0),
                    lane2_class_e=lane2_data.get('vehicles', {}).get('class_E', {}).get('count', 0),
                    lane2_avg_speed=self._get_avg_speed(lane2_data.get('vehicles', {})),
                    lane2_occupancy=lane2_data.get('occupancy_rate', 0),
                    lane2_violations=self._get_total_violations(lane2_data.get('vehicles', {})),

                    # Sensor status
                    sensor_status=data.get('sensor_status'),
                    raw_data=data
                )

                db.session.add(traffic_data)

                # Update device total vehicles
                device.total_vehicles += (lane1_data.get('total_vehicles', 0) +
                                         lane2_data.get('total_vehicles', 0))

                db.session.commit()

                # Emit real-time update via WebSocket
                socketio.emit('traffic_update', {
                    'device_id': device.device_id,
                    'timestamp': timestamp.isoformat(),
                    'total_vehicles': traffic_data.lane1_total + traffic_data.lane2_total
                })

                print(f"Data received from {device.device_id}: {traffic_data.lane1_total + traffic_data.lane2_total} vehicles")

                # Run health checks
                device_monitor.check_device_health(device.id)

        except Exception as e:
            print(f"Error processing message: {e}")
            import traceback
            traceback.print_exc()

    def _get_avg_speed(self, vehicles_data):
        """Calculate average speed from vehicle data"""
        total_speed = 0
        total_count = 0

        for class_data in vehicles_data.values():
            count = class_data.get('count', 0)
            avg_speed = class_data.get('avg_speed', 0)
            total_speed += avg_speed * count
            total_count += count

        return total_speed / total_count if total_count > 0 else 0

    def _get_total_violations(self, vehicles_data):
        """Get total violations from vehicle data"""
        return sum(class_data.get('violations', 0) for class_data in vehicles_data.values())

    def stop(self):
        """Stop TCP server"""
        self.running = False
        if self.server_socket:
            self.server_socket.close()


# ==================== REST API Endpoints ====================

@app.route('/api/devices', methods=['GET'])
def get_devices():
    """Get all devices"""
    devices = Device.query.all()
    return jsonify([device.to_dict() for device in devices])


@app.route('/api/devices/<device_id>', methods=['GET'])
def get_device(device_id):
    """Get specific device"""
    device = Device.query.filter_by(device_id=device_id).first_or_404()
    return jsonify(device.to_dict())


@app.route('/api/devices/<device_id>/traffic', methods=['GET'])
def get_device_traffic(device_id):
    """Get traffic data for device"""
    device = Device.query.filter_by(device_id=device_id).first_or_404()

    # Get query parameters
    start_date = request.args.get('start_date')
    end_date = request.args.get('end_date')
    limit = request.args.get('limit', 100, type=int)
    
    # Enforce maximum limit to prevent performance issues
    MAX_LIMIT = 1000
    limit = min(limit, MAX_LIMIT)

    query = TrafficData.query.filter_by(device_id=device.id)

    if start_date:
        query = query.filter(TrafficData.timestamp >= datetime.fromisoformat(start_date))
    if end_date:
        query = query.filter(TrafficData.timestamp <= datetime.fromisoformat(end_date))

    traffic_data = query.order_by(TrafficData.timestamp.desc()).limit(limit).all()

    return jsonify([data.to_dict() for data in traffic_data])


@app.route('/api/devices/<device_id>/stats', methods=['GET'])
def get_device_stats(device_id):
    """Get statistics for device"""
    device = Device.query.filter_by(device_id=device_id).first_or_404()

    # Get time range
    hours = request.args.get('hours', 24, type=int)
    start_time = datetime.utcnow() - timedelta(hours=hours)

    stats = data_analyzer.get_device_statistics(device.id, start_time)

    return jsonify(stats)


@app.route('/api/alerts', methods=['GET'])
def get_alerts():
    """Get all alerts"""
    active_only = request.args.get('active_only', 'false').lower() == 'true'

    query = Alert.query

    if active_only:
        query = query.filter_by(resolved=False)

    alerts = query.order_by(Alert.created_at.desc()).limit(100).all()

    return jsonify([alert.to_dict() for alert in alerts])


@app.route('/api/alerts/<int:alert_id>/acknowledge', methods=['POST'])
def acknowledge_alert(alert_id):
    """Acknowledge an alert"""
    alert = Alert.query.get_or_404(alert_id)
    alert.acknowledged = True
    db.session.commit()

    return jsonify(alert.to_dict())


@app.route('/api/alerts/<int:alert_id>/resolve', methods=['POST'])
def resolve_alert(alert_id):
    """Resolve an alert"""
    alert = Alert.query.get_or_404(alert_id)
    alert.resolved = True
    alert.resolved_at = datetime.utcnow()
    db.session.commit()

    return jsonify(alert.to_dict())


@app.route('/api/dashboard/summary', methods=['GET'])
def get_dashboard_summary():
    """Get dashboard summary"""
    summary = {
        'total_devices': Device.query.count(),
        'online_devices': Device.query.filter_by(status='online').count(),
        'offline_devices': Device.query.filter_by(status='offline').count(),
        'active_alerts': Alert.query.filter_by(resolved=False).count(),
        'total_vehicles_today': data_analyzer.get_total_vehicles_today(),
        'last_update': datetime.utcnow().isoformat()
    }

    return jsonify(summary)


@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.utcnow().isoformat()
    })


# ==================== WebSocket Events ====================

@socketio.on('connect')
def handle_connect():
    """Handle WebSocket connection"""
    print('Client connected')
    emit('connected', {'message': 'Connected to VTMS server'})


@socketio.on('disconnect')
def handle_disconnect():
    """Handle WebSocket disconnection"""
    print('Client disconnected')


# ==================== Initialization ====================

def init_db():
    """Initialize database"""
    with app.app_context():
        db.create_all()
        print("Database initialized")


if __name__ == '__main__':
    # Initialize database
    init_db()

    # Start TCP server in separate thread
    tcp_server = TCPServer(
        app.config['TCP_LISTEN_HOST'],
        app.config['TCP_LISTEN_PORT']
    )

    tcp_thread = threading.Thread(target=tcp_server.start)
    tcp_thread.daemon = True
    tcp_thread.start()

    # Start device monitor in background
    device_monitor.start_monitoring()

    # Start Flask app with SocketIO
    socketio.run(
        app,
        host='0.0.0.0',
        port=app.config['WEB_LISTEN_PORT'],
        debug=app.config['DEBUG']
    )
