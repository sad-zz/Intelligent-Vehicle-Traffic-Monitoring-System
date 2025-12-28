#!/bin/bash
# Simple server startup script

echo "========================================="
echo "Vehicle Traffic Monitoring Server"
echo "========================================="

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "[SETUP] Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "[SETUP] Activating virtual environment..."
source venv/bin/activate

# Install requirements
echo "[SETUP] Installing dependencies..."
pip install -q -r requirements.txt

# Initialize database
echo "[SETUP] Initializing database..."
python3 << EOF
from app import app, db
with app.app_context():
    db.create_all()
    print("[OK] Database initialized")
EOF

# Start server
echo "========================================="
echo "[START] Starting server on port 8080..."
echo "========================================="
python3 app.py
