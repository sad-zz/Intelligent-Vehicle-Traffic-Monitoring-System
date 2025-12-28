# سیستم نظارت بر تردد خودروهای هوشمند

یک سیستم کامل IoT برای شمارش، طبقه‌بندی و تحلیل تردد خودروها با استفاده از سنسورهای القایی/مغناطیسی

## ویژگی‌ها

### سمت دستگاه (Firmware)
- ✅ تشخیص خودکار خودرو با سنسورهای القایی 4 کاناله
- ✅ طبقه‌بندی خودرو به 6 کلاس (موتورسیکلت، سواری، ون، اتوبوس، کامیون، تریلی)
- ✅ اندازه‌گیری سرعت و طول خودرو
- ✅ تشخیص جهت حرکت
- ✅ ارسال داده‌ها از طریق GPRS (SIM800L) هر 10 دقیقه
- ✅ سنسور دما و رطوبت (DHT22/SHT30)
- ✅ Watchdog برای پایداری سیستم
- ✅ مدیریت انرژی برای مصرف کم
- ✅ ذخیره محلی روی SD Card
- ✅ رابط Serial برای تنظیمات و دیباگ

### سمت سرور (Backend)
- ✅ دریافت داده از تا 200 دستگاه همزمان
- ✅ پایگاه داده PostgreSQL
- ✅ API RESTful برای دسترسی به داده‌ها
- ✅ تشخیص خودکار دستگاه‌های معیوب
- ✅ سیستم هشدار (Alert)
- ✅ تحلیل و گزارش‌گیری
- ✅ WebSocket برای به‌روزرسانی real-time

### داشبورد وب
- ✅ نمایش وضعیت تمام دستگاه‌ها
- ✅ نمودارهای تحلیلی
- ✅ هشدارها و اعلان‌ها
- ✅ گزارش‌های زمانی

## سخت‌افزار مورد نیاز

### دستگاه ترددشمار
- **میکروکنترلر**: STM32F407VGT6
- **ماژول GSM/GPRS**: SIM800L
- **سنسورهای القایی**: 4 عدد (2 لاین × 2 حلقه)
- **سنسور دما/رطوبت**: DHT22 یا SHT30
- **SD Card**: برای ذخیره محلی
- **منبع تغذیه**:
  - پنل خورشیدی: 20W
  - باتری: 12V 7Ah
  - مدار شارژ

### سرور
- **CPU**: 4 Core یا بیشتر
- **RAM**: حداقل 8GB (برای 200 دستگاه)
- **Storage**: 500GB SSD
- **OS**: Ubuntu 20.04 LTS یا بالاتر

## نصب و راه‌اندازی

### 1. نصب Firmware روی STM32F407

#### پیش‌نیازها
```bash
# نصب ARM toolchain
sudo apt-get install gcc-arm-none-eabi

# نصب STM32CubeMX (برای تولید کد اولیه)
# دانلود از: https://www.st.com/en/development-tools/stm32cubemx.html

# نصب OpenOCD (برای پروگرام کردن)
sudo apt-get install openocd
```

#### کامپایل Firmware
```bash
cd firmware_stm32
make clean
make all
```

#### پروگرام کردن
```bash
# با ST-Link
openocd -f interface/stlink.cfg -f target/stm32f4x.cfg \
    -c "program build/firmware.elf verify reset exit"

# یا با J-Link
openocd -f interface/jlink.cfg -f target/stm32f4x.cfg \
    -c "program build/firmware.elf verify reset exit"
```

#### تنظیمات اولیه (از طریق Serial Console)
```
# اتصال به پورت سریال (115200 baud)
minicom -D /dev/ttyUSB0 -b 115200

# تنظیم ID دستگاه
DEVICE ID DEVICE001

# تنظیم نام محل
DEVICE NAME Tehran-Azadi-Axis1

# تنظیم APN
CONFIG SET apn mcinet

# تنظیم آدرس سرور
CONFIG SET server_ip 192.168.1.100
CONFIG SET server_port 8080

# تنظیم فاصله بین سنسورها (سانتی‌متر)
CONFIG SET loop_distance 400

# کالیبراسیون سنسورها
CALIBRATE

# ذخیره تنظیمات
CONFIG SAVE

# ریستارت
RESET
```

### 2. نصب سرور

#### نصب پیش‌نیازها
```bash
# به‌روزرسانی سیستم
sudo apt-get update && sudo apt-get upgrade -y

# نصب Python 3.10+
sudo apt-get install python3 python3-pip python3-venv -y

# نصب PostgreSQL
sudo apt-get install postgresql postgresql-contrib -y

# نصب Redis
sudo apt-get install redis-server -y
```

#### ایجاد دیتابیس
```bash
sudo -u postgres psql

CREATE DATABASE vehicle_traffic_db;
CREATE USER vtms WITH ENCRYPTED PASSWORD 'vtms_password';
GRANT ALL PRIVILEGES ON DATABASE vehicle_traffic_db TO vtms;
\q
```

#### نصب و راه‌اندازی Backend
```bash
cd server/backend

# ایجاد virtual environment
python3 -m venv venv
source venv/bin/activate

# نصب dependencies
pip install -r requirements.txt

# تنظیم متغیرهای محیطی
export FLASK_ENV=production
export DATABASE_URL=postgresql://vtms:vtms_password@localhost:5432/vehicle_traffic_db
export SECRET_KEY=$(python3 -c 'import secrets; print(secrets.token_hex(32))')

# راه‌اندازی سرور
python app.py
```

#### راه‌اندازی با Docker (اختیاری)
```bash
# ایجاد docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: vehicle_traffic_db
      POSTGRES_USER: vtms
      POSTGRES_PASSWORD: vtms_password
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  backend:
    build: .
    environment:
      DATABASE_URL: postgresql://vtms:vtms_password@postgres:5432/vehicle_traffic_db
      REDIS_URL: redis://redis:6379/0
      FLASK_ENV: production
    ports:
      - "5000:5000"
      - "8080:8080"
    depends_on:
      - postgres
      - redis

volumes:
  postgres_data:
EOF

# راه‌اندازی
docker-compose up -d
```

### 3. نصب داشبورد

#### روش ساده (Static HTML)
```bash
cd server/frontend/dashboard

# راه‌اندازی با Python HTTP Server
python3 -m http.server 8000

# دسترسی از مرورگر:
# http://localhost:8000
```

#### روش پیشرفته (با Nginx)
```bash
# نصب Nginx
sudo apt-get install nginx -y

# کپی فایل‌ها
sudo cp -r server/frontend/dashboard/* /var/www/html/

# تنظیم Nginx
sudo nano /etc/nginx/sites-available/vtms

# محتوای فایل:
server {
    listen 80;
    server_name your-domain.com;

    root /var/www/html;
    index index.html;

    location /api {
        proxy_pass http://localhost:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /socket.io {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}

# فعال‌سازی
sudo ln -s /etc/nginx/sites-available/vtms /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

## تنظیمات پیشرفته

### کالیبراسیون سنسورها

سنسورهای القایی باید بدون حضور خودرو کالیبره شوند:

```bash
# از طریق Serial Console
CALIBRATE

# یا برای سنسور خاص
TEST SENSOR 0
TEST SENSOR 1
TEST SENSOR 2
TEST SENSOR 3
```

### تنظیم محدوده‌های طبقه‌بندی

```bash
# تنظیم حدود طبقه‌بندی (سانتی‌متر)
CONFIG SET limit_x 200      # موتورسیکلت < 2m
CONFIG SET limit_a 600      # سواری < 6m
CONFIG SET limit_b 900      # ون < 9m
CONFIG SET limit_c 1200     # اتوبوس < 12m
CONFIG SET limit_d 1600     # کامیون < 16m
CONFIG SET limit_e 2000     # تریلی > 16m
```

### تنظیم محدودیت‌های سرعت

```bash
# محدودیت سرعت روز/شب برای خودروهای سبک و سنگین
CONFIG SET speed_limit_day_light 110
CONFIG SET speed_limit_night_light 100
CONFIG SET speed_limit_day_heavy 90
CONFIG SET speed_limit_night_heavy 80
```

## API Documentation

### دریافت لیست دستگاه‌ها
```http
GET /api/devices
Response: Array of device objects
```

### دریافت داده‌های ترافیک
```http
GET /api/devices/{device_id}/traffic?start_date=2025-12-01&end_date=2025-12-12
Response: Array of traffic data
```

### دریافت آمار دستگاه
```http
GET /api/devices/{device_id}/stats?hours=24
Response: Statistical summary
```

### دریافت هشدارها
```http
GET /api/alerts?active_only=true
Response: Array of alerts
```

### دریافت خلاصه داشبورد
```http
GET /api/dashboard/summary
Response: {
  "total_devices": 10,
  "online_devices": 8,
  "offline_devices": 2,
  "active_alerts": 3,
  "total_vehicles_today": 15420
}
```

## عیب‌یابی

### دستگاه به سرور متصل نمی‌شود

1. بررسی اتصال GPRS:
```bash
# از Serial Console
TEST GPRS
```

2. بررسی تنظیمات APN:
```bash
CONFIG GET apn
CONFIG GET server_ip
CONFIG GET server_port
```

3. بررسی سیگنال GSM:
```bash
STATUS
# بررسی فیلد signal_quality (باید > 10 باشد)
```

### سنسورها کار نمی‌کنند

1. بررسی سلامت سنسورها:
```bash
TEST SENSOR 0
TEST SENSOR 1
TEST SENSOR 2
TEST SENSOR 3
```

2. کالیبراسیون مجدد:
```bash
CALIBRATE
```

3. بررسی اتصالات سخت‌افزاری

### خطای دیتابیس

```bash
# بررسی وضعیت PostgreSQL
sudo systemctl status postgresql

# بررسی لاگ‌ها
sudo tail -f /var/log/postgresql/postgresql-15-main.log

# ریست دیتابیس (در صورت نیاز)
python app.py
# در Python shell:
from database.models import db
db.drop_all()
db.create_all()
```

## مشارکت

برای گزارش باگ یا پیشنهاد ویژگی جدید، لطفاً یک Issue ایجاد کنید.

## لایسنس

این پروژه تحت لایسنس MIT منتشر شده است.

## پشتیبانی

برای پشتیبانی و سوالات، به بخش Issues مراجعه کنید.

---

**نکته مهم**: قبل از استفاده در محیط production، حتماً:
1. رمزهای عبور را تغییر دهید
2. SSL/TLS را فعال کنید
3. Firewall را پیکربندی کنید
4. Backup منظم از دیتابیس بگیرید
