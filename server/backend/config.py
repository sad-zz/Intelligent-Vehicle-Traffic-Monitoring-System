"""
Server Configuration
"""
import os
from datetime import timedelta

class Config:
    """Base configuration"""
    # Flask
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'dev-secret-key-change-in-production'

    # Database
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
        'postgresql://vtms:vtms_password@localhost:5432/vehicle_traffic_db'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_ECHO = False

    # Redis (for caching and real-time data)
    REDIS_URL = os.environ.get('REDIS_URL') or 'redis://localhost:6379/0'

    # Server Settings
    TCP_LISTEN_HOST = '0.0.0.0'
    TCP_LISTEN_PORT = 8080
    WEB_LISTEN_PORT = 5000

    # Device Settings
    MAX_DEVICES = 200
    DEVICE_TIMEOUT_MINUTES = 30  # Device considered offline after this
    DEVICE_LOW_TRAFFIC_THRESHOLD = 0.1  # 10% of average

    # Data Retention
    DATA_RETENTION_DAYS = 365  # Keep data for 1 year

    # Alert Settings
    ENABLE_ALERTS = True
    ALERT_EMAIL = os.environ.get('ALERT_EMAIL')

    # Security
    DEVICE_AUTH_REQUIRED = True
    API_KEY_HEADER = 'X-API-Key'

class DevelopmentConfig(Config):
    """Development configuration"""
    DEBUG = True
    SQLALCHEMY_ECHO = True

class ProductionConfig(Config):
    """Production configuration"""
    DEBUG = False
    SQLALCHEMY_ECHO = False

# Config dictionary
config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'default': DevelopmentConfig
}
