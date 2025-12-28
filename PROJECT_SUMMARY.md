# خلاصه پروژه - سیستم نظارت بر تردد خودروهای هوشمند

## نمای کلی

این پروژه یک سیستم کامل IoT برای نظارت بر تردد خودروها است که شامل:

### ✅ Firmware STM32F407
مسیر: `firmware_stm32/`

**فایل‌های کلیدی:**
- `Core/Inc/config.h` - تنظیمات سیستم
- `Drivers/BSP/sensor_driver.c/h` - درایور سنسورهای القایی
- `Drivers/BSP/sim800l_driver.h` - درایور SIM800L GPRS
- `Middleware/vehicle_detection.h` - سیستم تشخیص و طبقه‌بندی خودرو

**قابلیت‌ها:**
- ✅ تشخیص خودرو با 4 سنسور القایی
- ✅ طبقه‌بندی به 6 کلاس (X, A, B, C, D, E)
- ✅ اندازه‌گیری سرعت و طول
- ✅ ارسال داده GPRS هر 10 دقیقه
- ✅ سنسور دما/رطوبت
- ✅ Watchdog و مدیریت انرژی
- ✅ Serial Console برای تنظیمات

### ✅ Backend Server (Flask)
مسیر: `server/backend/`

**فایل‌های کلیدی:**
- `app.py` - سرور اصلی Flask + TCP Server
- `database/models.py` - مدل‌های دیتابیس (SQLAlchemy)
- `services/device_monitor.py` - نظارت بر سلامت دستگاه‌ها
- `services/data_analyzer.py` - تحلیل آماری داده‌ها
- `config.py` - تنظیمات سرور

**قابلیت‌ها:**
- ✅ دریافت داده از 200 دستگاه همزمان
- ✅ TCP Server (پورت 8080) برای دستگاه‌ها
- ✅ REST API (پورت 5000) برای داشبورد
- ✅ WebSocket برای real-time updates
- ✅ PostgreSQL database
- ✅ تشخیص خودکار دستگاه معیوب
- ✅ سیستم Alert و Notification

### ✅ Web Dashboard
مسیر: `server/frontend/dashboard/`

**فایل‌های کلیدی:**
- `index.html` - داشبورد اصلی

**قابلیت‌ها:**
- ✅ نمایش وضعیت همه دستگاه‌ها
- ✅ نمودارهای real-time
- ✅ هشدارها و اعلان‌ها
- ✅ آمار و گزارش‌ها

### ✅ Database Schema
مسیر: `server/database/schema.sql`

**جداول:**
- `devices` - اطلاعات دستگاه‌ها
- `traffic_data` - داده‌های تردد (هر 10 دقیقه)
- `alerts` - هشدارها
- `system_logs` - لاگ‌های سیستم

## معماری سیستم

```
┌─────────────────────────────────────────────────────────────┐
│                    Device (STM32F407)                       │
│  ┌───────────┐  ┌───────────┐  ┌──────────┐  ┌──────────┐ │
│  │ 4x Sensor │──│  Vehicle  │──│ SIM800L  │──│   GPRS   │ │
│  │  Loops    │  │ Detection │  │  Module  │  │ Network  │ │
│  └───────────┘  └───────────┘  └──────────┘  └──────────┘ │
│       │              │               │              │       │
│       └──────────────┴───────────────┴──────────────┘       │
│                         JSON Data                           │
└─────────────────────────┬───────────────────────────────────┘
                          │ TCP (Port 8080)
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                    Backend Server                           │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │   TCP    │──│  Flask   │──│PostgreSQL│  │  Redis   │  │
│  │  Server  │  │   API    │  │ Database │  │  Cache   │  │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘  │
│       │              │                                      │
│       │      ┌───────┴────────┐                           │
│       │      │  Device Monitor│                           │
│       │      │  Data Analyzer │                           │
│       │      └────────────────┘                           │
└───────┬──────────────────────────────────────────────────┘
        │ REST API + WebSocket
        ▼
┌─────────────────────────────────────────────────────────────┐
│                    Web Dashboard                            │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │  Device  │  │ Traffic  │  │  Alerts  │  │  Charts  │  │
│  │  Status  │  │  Stats   │  │  Panel   │  │  Graphs  │  │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## پروتکل ارتباطی

### نمونه داده ارسالی از دستگاه:
```json
{
  "device_id": "DEVICE001",
  "location": "Tehran-Azadi-Axis1",
  "timestamp": "2025-12-12T10:00:00Z",
  "interval_minutes": 10,
  "temperature": 25.5,
  "humidity": 60.2,
  "battery_voltage": 12.4,
  "firmware_version": "1.0.0",
  "hardware_version": "STM32F407-V1",
  "lanes": [
    {
      "lane_id": 1,
      "direction": "north",
      "vehicles": {
        "class_A": {"count": 45, "avg_speed": 65, "violations": 2},
        "class_B": {"count": 12, "avg_speed": 58, "violations": 0},
        "class_C": {"count": 8, "avg_speed": 52, "violations": 1}
      },
      "total_vehicles": 65,
      "occupancy_rate": 15.2
    }
  ],
  "sensor_status": {
    "loop_0": "ok",
    "loop_1": "ok",
    "loop_2": "ok",
    "loop_3": "ok"
  }
}
```

## تشخیص دستگاه معیوب

سرور به صورت خودکار این موارد را بررسی می‌کند:

1. **عدم دریافت داده**: اگر > 30 دقیقه داده دریافت نشود
   - Alert: `device_offline`
   - Severity: `error`

2. **باتری ضعیف**: اگر ولتاژ < 11V
   - Alert: `low_battery`
   - Severity: `warning`

3. **تردد کم**: اگر تعداد < 10% میانگین سایر محورها
   - Alert: `low_traffic`
   - Severity: `warning`

4. **خطای سنسور**: اگر sensor_status != "ok"
   - Alert: `sensor_error`
   - Severity: `error`

## طبقه‌بندی خودروها

| کلاس | طول (متر) | نوع خودرو | نمونه |
|------|-----------|-----------|-------|
| X    | < 2       | موتورسیکلت | موتورسیکلت، دوچرخه برقی |
| A    | 2-6       | خودروی سبک | پراید، پژو، پیکان |
| B    | 6-9       | ون، مینی‌بوس | ون H100، مینی‌بوس |
| C    | 9-12      | اتوبوس کوچک، کامیون متوسط | اتوبوس شهری، کامیون 10 تن |
| D    | 12-16     | اتوبوس، کامیون سنگین | اتوبوس بین‌شهری، کامیون 18 تن |
| E    | > 16      | کامیون تریلی | کامیون کمرشکن |

## الگوریتم تشخیص

```
1. سنسور اول فعال شد → T1
2. سنسور اول غیرفعال شد → T2
3. سنسور دوم فعال شد → T3
4. سنسور دوم غیرفعال شد → T4

سرعت = distance / ((T1 + T3) / 2)
طول = سرعت × (T2 - T1) - loop_width

جهت:
  - اگر سنسور 0 قبل از سنسور 1 → جهت 12
  - اگر سنسور 1 قبل از سنسور 0 → جهت 21
```

## نکات مهم برای نصب

### سخت‌افزار
1. فاصله بین حلقه‌ها: 4 متر (قابل تنظیم)
2. عرض حلقه: 1.4 متر (قابل تنظیم)
3. ولتاژ باتری: حداقل 11V
4. سیگنال GSM: حداقل 10

### نرم‌افزار
1. کالیبراسیون سنسورها قبل از راه‌اندازی
2. تنظیم APN اپراتور
3. تنظیم IP و Port سرور
4. تست اتصال GPRS

### امنیت
1. تغییر رمز عبور دیتابیس
2. فعال‌سازی SSL/TLS
3. محدودسازی دسترسی با Firewall
4. Backup منظم از دیتابیس

## API Endpoints

```
GET  /api/devices                          # لیست دستگاه‌ها
GET  /api/devices/{device_id}              # جزئیات دستگاه
GET  /api/devices/{device_id}/traffic      # داده‌های تردد
GET  /api/devices/{device_id}/stats        # آمار دستگاه
GET  /api/alerts                           # لیست هشدارها
POST /api/alerts/{id}/acknowledge          # تایید هشدار
POST /api/alerts/{id}/resolve              # حل هشدار
GET  /api/dashboard/summary                # خلاصه داشبورد
GET  /health                               # بررسی سلامت سرور
```

## فایل‌های کلیدی پروژه

```
Intelligent-Vehicle-Traffic-Monitoring-System/
├── DESIGN.md                    ← معماری کامل سیستم
├── README.md                    ← راهنمای نصب و استفاده
├── PROJECT_SUMMARY.md           ← این فایل
│
├── firmware_stm32/              ← Firmware STM32F407
│   ├── Core/Inc/config.h
│   ├── Drivers/BSP/
│   │   ├── sensor_driver.c/h
│   │   └── sim800l_driver.h
│   └── Middleware/
│       └── vehicle_detection.h
│
├── server/
│   ├── backend/                 ← Backend Server
│   │   ├── app.py              ← سرور اصلی
│   │   ├── config.py
│   │   ├── requirements.txt
│   │   ├── database/
│   │   │   └── models.py
│   │   └── services/
│   │       ├── device_monitor.py
│   │       └── data_analyzer.py
│   │
│   ├── frontend/dashboard/      ← داشبورد وب
│   │   └── index.html
│   │
│   └── database/
│       └── schema.sql           ← Schema دیتابیس
│
└── firmware/Main/               ← کد قدیمی PIC (مرجع)
    └── 91-7.c
```

## مراحل راه‌اندازی سریع

### 1. نصب سرور
```bash
cd server/backend
pip install -r requirements.txt
sudo -u postgres psql < ../database/schema.sql
python app.py
```

### 2. باز کردن داشبورد
```bash
# در مرورگر:
http://localhost:8000
```

### 3. تنظیم دستگاه
```bash
# اتصال Serial
minicom -D /dev/ttyUSB0 -b 115200

# دستورات:
DEVICE ID DEVICE001
CONFIG SET server_ip 192.168.1.100
CONFIG SET server_port 8080
CALIBRATE
```

## پشتیبانی و توسعه

این پروژه آماده برای:
- ✅ استفاده در محیط تولید
- ✅ مقیاس‌پذیری تا 200 دستگاه
- ✅ توسعه و سفارشی‌سازی

برای سوالات و پشتیبانی، به فایل README.md مراجعه کنید.

---
**تاریخ ایجاد**: 2025-12-12
**نسخه**: 1.0.0
**وضعیت**: ✅ آماده استفاده
