@echo off
REM Simple server startup script for Windows

echo =========================================
echo Vehicle Traffic Monitoring Server
echo =========================================

REM Check if virtual environment exists
if not exist "venv" (
    echo [SETUP] Creating virtual environment...
    python -m venv venv
)

REM Activate virtual environment
echo [SETUP] Activating virtual environment...
call venv\Scripts\activate.bat

REM Install requirements
echo [SETUP] Installing dependencies...
pip install -q -r requirements.txt

REM Initialize database
echo [SETUP] Initializing database...
python -c "from app import app, db; app.app_context().push(); db.create_all(); print('[OK] Database initialized')"

REM Start server
echo =========================================
echo [START] Starting server on port 8080...
echo =========================================
python app.py

pause
