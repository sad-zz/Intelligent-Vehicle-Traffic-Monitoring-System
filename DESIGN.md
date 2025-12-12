# طراحی سیستم نظارت بر تردد خودروهای هوشمند

## نمای کلی سیستم

### سخت‌افزار دستگاه
- **میکروکنترلر**: STM32F407VGT6
  - CPU: ARM Cortex-M4 @ 168MHz
  - Flash: 1MB
  - RAM: 192KB
  - مصرف کم با حالت‌های Sleep/Stop
  - Independent Watchdog (IWDG)

- **ماژول ارتباطی**: SIM800L (GPRS/GSM)
  - ارتباط از طریق UART
  - پشتیبانی از TCP/IP
  - مصرف برق کم در حالت Sleep

- **سنسورها**:
  - 4x سنسور القایی/مغناطیسی (برای تشخیص خودرو)
  - 1x DHT22 (دما و رطوبت)
  - یا SHT30/BME280 (دقت بالاتر)

- **ذخیره‌سازی**:
  - SD Card (SPI) برای ذخیره محلی
  - EEPROM داخلی برای تنظیمات

- **منبع تغذیه**:
  - پنل خورشیدی + باتری
  - مدار شارژ
  - نظارت بر ولتاژ باتری

### معماری نرم‌افزار

#### سمت دستگاه (Firmware - STM32F407)

```
firmware/
├── Core/
│   ├── Inc/
│   │   ├── main.h
│   │   ├── config.h
│   │   └── stm32f4xx_it.h
│   └── Src/
│       ├── main.c
│       ├── system_stm32f4xx.c
│       └── stm32f4xx_it.c
├── Drivers/
│   ├── BSP/
│   │   ├── sensor_driver.c/h      # درایور سنسورهای القایی
│   │   ├── sim800l_driver.c/h     # درایور SIM800L
│   │   ├── dht22_driver.c/h       # درایور DHT22
│   │   └── sd_card_driver.c/h     # درایور SD Card
│   └── HAL/                        # STM32 HAL Drivers
├── Middleware/
│   ├── vehicle_detection.c/h      # الگوریتم تشخیص خودرو
│   ├── vehicle_classification.c/h # طبقه‌بندی خودرو
│   ├── data_logger.c/h            # ذخیره داده
│   ├── gprs_protocol.c/h          # پروتکل ارتباط GPRS
│   └── power_management.c/h       # مدیریت انرژی
└── Application/
    ├── command_interface.c/h      # رابط دستورات (Serial Console)
    ├── watchdog_manager.c/h       # مدیریت Watchdog
    └── system_monitor.c/h         # نظارت بر سلامت سیستم
```

#### سمت سرور (Backend)

```
server/
├── backend/
│   ├── app.py                     # Flask/FastAPI Application
│   ├── database/
│   │   ├── models.py              # مدل‌های دیتابیس
│   │   └── db_manager.py          # مدیریت پایگاه داده
│   ├── api/
│   │   ├── device_api.py          # API دریافت از دستگاه‌ها
│   │   ├── dashboard_api.py       # API داشبورد
│   │   └── health_monitor.py     # API سلامت دستگاه‌ها
│   └── services/
│       ├── data_analyzer.py       # تحلیل داده‌ها
│       ├── device_monitor.py      # نظارت بر دستگاه‌ها
│       └── alert_service.py       # سیستم هشدار
├── frontend/
│   ├── dashboard/                 # React/Vue.js Dashboard
│   │   ├── components/
│   │   │   ├── TrafficChart.jsx
│   │   │   ├── DeviceStatus.jsx
│   │   │   ├── TemperatureChart.jsx
│   │   │   └── AlertPanel.jsx
│   │   └── pages/
│   │       ├── MainDashboard.jsx
│   │       ├── DeviceManagement.jsx
│   │       └── Reports.jsx
│   └── public/
└── database/
    └── schema.sql                 # Schema پایگاه داده
```

## پروتکل ارتباطی

### فرمت بسته داده (هر 10 دقیقه)

```json
{
  "device_id": "DEV001",
  "location": "Tehran-Azadi-Axis1",
  "timestamp": "2025-12-12T10:00:00Z",
  "interval_minutes": 10,
  "temperature": 25.5,
  "humidity": 60.2,
  "battery_voltage": 12.4,
  "lanes": [
    {
      "lane_id": 1,
      "direction": "north",
      "vehicles": {
        "class_A": {"count": 45, "avg_speed": 65, "violations": 2},
        "class_B": {"count": 12, "avg_speed": 58, "violations": 0},
        "class_C": {"count": 8, "avg_speed": 52, "violations": 1},
        "class_D": {"count": 3, "avg_speed": 48, "violations": 0},
        "class_E": {"count": 1, "avg_speed": 45, "violations": 0}
      },
      "total_vehicles": 69,
      "occupancy_rate": 15.2
    },
    {
      "lane_id": 2,
      "direction": "south",
      "vehicles": { ... },
      "total_vehicles": 58,
      "occupancy_rate": 12.8
    }
  ],
  "errors": [],
  "sensor_status": {
    "loop_0": "ok",
    "loop_1": "ok",
    "loop_2": "ok",
    "loop_3": "ok"
  }
}
```

### دستورات Serial Console

```
CONFIG SET <param> <value>     # تنظیم پارامتر
CONFIG GET <param>             # دریافت پارامتر
STATUS                         # وضعیت سیستم
CALIBRATE                      # کالیبراسیون سنسورها
RESET                          # ریست دستگاه
TEST SENSOR <id>               # تست سنسور
TEST GPRS                      # تست اتصال GPRS
SEND NOW                       # ارسال فوری داده
LOG SHOW <count>               # نمایش لاگ‌ها
DEVICE ID <new_id>             # تنظیم ID دستگاه
DEVICE NAME <new_name>         # تنظیم نام دستگاه
```

## طبقه‌بندی خودروها

| کلاس | طول (متر) | نوع خودرو |
|------|-----------|-----------|
| X    | < 2       | موتورسیکلت |
| A    | 2-6       | خودروی سبک |
| B    | 6-9       | ون، مینی‌بوس |
| C    | 9-12      | اتوبوس کوچک، کامیون متوسط |
| D    | 12-16     | اتوبوس، کامیون سنگین |
| E    | > 16      | کامیون تریلی |

## الگوریتم تشخیص خودرو

1. **تشخیص ورود خودرو**: تغییر فرکانس سنسور > آستانه بالا
2. **اندازه‌گیری زمان**:
   - T1: زمان فعال شدن سنسور اول
   - T2: زمان غیرفعال شدن سنسور اول
   - T3: زمان فعال شدن سنسور دوم
   - T4: زمان غیرفعال شدن سنسور دوم
3. **محاسبه سرعت**: `V = distance / ((T1+T3)/2)`
4. **محاسبه طول**: `L = V × (T2-T1) - loop_width`
5. **تشخیص جهت**: بر اساس توالی فعال‌سازی سنسورها
6. **طبقه‌بندی**: بر اساس جدول بالا

## تشخیص دستگاه معیوب

سرور به صورت خودکار دستگاه‌های معیوب را تشخیص می‌دهد:

1. **عدم دریافت داده**: اگر > 30 دقیقه داده دریافت نشود
2. **تعداد کم خودرو**: اگر تعداد < 10% میانگین سایر محورها
3. **خطای سنسور**: اگر sensor_status حاوی خطا باشد
4. **باتری ضعیف**: اگر ولتاژ < 11V
5. **دمای غیرعادی**: اگر دما خارج از محدوده قابل قبول

## مدیریت انرژی

1. **حالت عادی**: CPU در حالت Run، همه سنسورها فعال
2. **حالت Sleep**: CPU در حالت Sleep بین اندازه‌گیری‌ها
3. **حالت Low Power**: GPRS خاموش بین ارسال‌ها
4. **حالت Emergency**: اگر باتری < 20%، فقط نمونه‌برداری هر 30 دقیقه

## Watchdog

- **IWDG**: Independent Watchdog با timeout 10 ثانیه
- بازنشانی در حلقه اصلی
- اگر سیستم hang شود، خودکار ریست می‌شود

## امنیت

1. احراز هویت دستگاه با Device ID + Key
2. رمزنگاری داده‌ها (اختیاری - TLS)
3. محدودیت دسترسی به Serial Console
4. لاگ تمام دستورات

## مقیاس‌پذیری

- پشتیبانی از تا 200 دستگاه
- دیتابیس: PostgreSQL با partitioning بر اساس تاریخ
- Cache: Redis برای داده‌های real-time
- Message Queue: RabbitMQ برای پردازش ناهمزمان
