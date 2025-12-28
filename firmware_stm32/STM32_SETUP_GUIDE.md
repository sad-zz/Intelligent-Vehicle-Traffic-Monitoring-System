# راهنمای کامل راه‌اندازی STM32F407 روی برد EWB-STM32F407V-LAN-V4.0

## مشخصات برد

برد **EWB-STM32F407V-LAN-V4.0** دارای امکانات زیر است:

| قطعه | مدل | توضیحات |
|------|-----|---------|
| CPU | STM32F407VGT6 | ARM Cortex-M4, 168MHz, 1MB Flash, 192KB RAM |
| USB-Serial | CP2104 | برای Serial Console و پروگرام |
| Ethernet | LAN8720A | برای ارتباط شبکه (اختیاری) |
| CAN Bus | SN65HVD230 | CAN transceiver |
| RS485 | SP3485 | RS485 transceiver |
| Flash | W25Q32 | 32Mbit SPI Flash |
| EEPROM | AT24C02 | 2Kbit I2C EEPROM |
| SD Card | MicroSD | برای ذخیره محلی |
| Debugger | SWD | 5-pin header |

---

## نقشه پین‌های مورد استفاده در پروژه

### 1. UART ها
```
UART1 (Serial Console):
- PA9  → UART1_TX (متصل به CP2104)
- PA10 → UART1_RX (متصل به CP2104)

UART2 (SIM800L):
- PA2  → UART2_TX
- PA3  → UART2_RX
```

### 2. سنسورهای القایی (Input Capture + Multiplexer)
```
TIM2_CH1 (Input Capture):
- PA0  → TIM2_CH1 (ورودی فرکانس از سنسورها)

Multiplexer Control:
- PD0  → LOOP_SEL0 (Bit 0 انتخاب سنسور)
- PD1  → LOOP_SEL1 (Bit 1 انتخاب سنسور)
```

### 3. سنسور دما و رطوبت
```
DHT22:
- PC0  → DHT22_DATA (GPIO با قابلیت Input/Output)
```

### 4. SIM800L Control
```
- PB2  → SIM800L_PWR    (کنترل برق)
- PB7  → SIM800L_PWRKEY (دکمه روشن/خاموش)
- PB6  → SIM800L_STATUS (وضعیت ماژول - Input)
```

### 5. SD Card (SDIO)
```
- PC8  → SDIO_D0
- PC9  → SDIO_D1
- PC10 → SDIO_D2
- PC11 → SDIO_D3
- PC12 → SDIO_CLK
- PD2  → SDIO_CMD
```

### 6. Status LED
```
- PE4  → STATUS_LED (LED موجود روی برد)
```

### 7. ADC (اندازه‌گیری باتری)
```
- PA4  → ADC1_IN4 (ولتاژ باتری - از طریق voltage divider)
- PA5  → ADC1_IN5 (ولتاژ خورشیدی - اختیاری)
```

### 8. SWD (Debug & Program)
```
- PA13 → SWDIO
- PA14 → SWCLK
```

### 9. Reset و Boot
```
- NRST → RESET Button
- BOOT0 → BOOT0 Jumper (برای ورود به DFU Mode)
```

---

## مرحله 1: نصب نرم‌افزارهای مورد نیاز

### 1.1 STM32CubeMX
```bash
# دانلود از سایت ST:
# https://www.st.com/en/development-tools/stm32cubemx.html

# Linux:
chmod +x SetupSTM32CubeMX-xxx.linux
./SetupSTM32CubeMX-xxx.linux

# Windows:
# اجرای فایل .exe
```

### 1.2 انتخاب IDE

#### گزینه 1: STM32CubeIDE (توصیه می‌شود)
```bash
# دانلود:
# https://www.st.com/en/development-tools/stm32cubeide.html

# مزایا:
- رایگان و Open Source
- پشتیبانی کامل از STM32
- دیباگر integrated
- بر پایه Eclipse
```

#### گزینه 2: Keil MDK
```bash
# دانلود:
# https://www.keil.com/download/product/

# نکته: نسخه رایگان محدودیت 32KB دارد
# برای پروژه‌های بزرگ‌تر نیاز به لایسنس دارید
```

---

## مرحله 2: ساخت پروژه با STM32CubeMX

### 2.1 ایجاد پروژه جدید

1. باز کردن STM32CubeMX
2. **File → New Project**
3. جستجوی **STM32F407VGT6**
4. انتخاب چیپ و **Start Project**

### 2.2 تنظیمات System Core

#### RCC (Reset and Clock Control)
```
1. Pinout & Configuration → System Core → RCC
2. High Speed Clock (HSE): Crystal/Ceramic Resonator
3. Low Speed Clock (LSE): Crystal/Ceramic Resonator (32.768 KHz)
```

#### SYS (System)
```
1. System Core → SYS
2. Debug: Serial Wire (برای SWD)
3. Timebase Source: SysTick
```

#### GPIO
تنظیم پین‌های زیر:

```
PA0:  TIM2_CH1 (Input Capture)
PA2:  USART2_TX
PA3:  USART2_RX
PA4:  ADC1_IN4 (Analog)
PA5:  ADC1_IN5 (Analog)
PA9:  USART1_TX
PA10: USART1_RX
PA13: SWDIO (Debug)
PA14: SWCLK (Debug)

PB2:  GPIO_Output (SIM800L_PWR)
PB6:  GPIO_Input (SIM800L_STATUS)
PB7:  GPIO_Output (SIM800L_PWRKEY)

PC0:  GPIO_Input/Output (DHT22)
PC8:  SDIO_D0
PC9:  SDIO_D1
PC10: SDIO_D2
PC11: SDIO_D3
PC12: SDIO_CLK
PC13: GPIO_Input (Button - WAKEUP)

PD0:  GPIO_Output (LOOP_SEL0)
PD1:  GPIO_Output (LOOP_SEL1)
PD2:  SDIO_CMD

PE4:  GPIO_Output (STATUS_LED)
```

**نحوه تنظیم:**
- روی هر پین کلیک کنید
- از منوی dropdown عملکرد را انتخاب کنید
- برای GPIO ها: `GPIO_Output` یا `GPIO_Input`

#### تنظیمات GPIO ها:

**برای PA0 (TIM2_CH1):**
- Mode: Input Capture direct mode
- Pull-up/Pull-down: No pull-up and no pull-down

**برای پین‌های Output:**
- Output Level: Low (یا High برای LED)
- Mode: Push Pull
- Speed: Medium
- Pull-up/Pull-down: No pull-up and no pull-down

**برای پین‌های Input:**
- Pull-up/Pull-down: Pull-up (برای button)

### 2.3 تنظیمات Peripherals

#### USART1 (Serial Console)
```
1. Connectivity → USART1
2. Mode: Asynchronous
3. Configuration:
   - Baud Rate: 115200 Bits/s
   - Word Length: 8 Bits
   - Parity: None
   - Stop Bits: 1
   - Flow Control: None

4. NVIC Settings: Enable USART1 global interrupt
5. DMA Settings (اختیاری):
   - Add DMA Request: USART1_RX (Circular mode)
   - Add DMA Request: USART1_TX
```

#### USART2 (SIM800L)
```
1. Connectivity → USART2
2. Mode: Asynchronous
3. Configuration:
   - Baud Rate: 115200 Bits/s
   - Word Length: 8 Bits
   - Parity: None
   - Stop Bits: 1

4. NVIC Settings: Enable USART2 global interrupt
5. DMA Settings:
   - Add DMA Request: USART2_RX (Circular mode)
   - Add DMA Request: USART2_TX
```

#### TIM2 (Input Capture)
```
1. Timers → TIM2
2. Mode:
   - Channel1: Input Capture direct mode

3. Configuration:
   - Prescaler: 167 (برای 1MHz clock)
   - Counter Period: 65535
   - Counter Mode: Up
   - Internal Clock Division: No Division
   - auto-reload preload: Enable

4. Input Capture Channel 1:
   - Polarity Selection: Rising Edge
   - IC Selection: Direct
   - Prescaler Division Ratio: No division

5. NVIC Settings: Enable TIM2 global interrupt
```

#### TIM4 (System Timer - 1ms)
```
1. Timers → TIM4
2. Mode: Internal Clock
3. Configuration:
   - Prescaler: 83 (برای 2MHz)
   - Counter Period: 1999 (برای 1ms @ 2MHz)
   - Counter Mode: Up

4. NVIC Settings: Enable TIM4 global interrupt
```

#### ADC1 (Battery Voltage)
```
1. Analog → ADC1
2. Mode: IN4 (PA4) و IN5 (PA5)
3. Configuration:
   - Clock Prescaler: PCLK2 divided by 4
   - Resolution: 12 bit
   - Data Alignment: Right
   - Scan Conversion Mode: Enabled
   - Continuous Conversion Mode: Enabled
   - Discontinuous Conversion Mode: Disabled
   - DMA Continuous Requests: Enabled

4. Number of Conversions: 2
   - Rank 1: Channel 4 (PA4) - Sampling time: 15 Cycles
   - Rank 2: Channel 5 (PA5) - Sampling time: 15 Cycles

5. DMA Settings:
   - Add: ADC1
   - Mode: Circular
   - Data Width: Half Word
```

#### SDIO (SD Card)
```
1. Connectivity → SDIO
2. Mode: SD 4 bits Wide bus
3. Configuration:
   - Clock Divide Factor: 0
   - Clock Power Save: Disabled
   - Bus Wide: 4-bit mode
   - Hardware Flow Control: Disabled

4. DMA Settings:
   - Add: SDIO_RX
   - Add: SDIO_TX
```

#### RTC (Real-Time Clock)
```
1. Timers → RTC
2. Activate: Enabled
3. Configuration:
   - Clock Source: LSE (32.768 KHz crystal)
   - Hour Format: 24 Hours
   - Asynchronous Predivider: 127
   - Synchronous Predivider: 255

4. Calendar: Set initial date/time
```

#### IWDG (Independent Watchdog)
```
1. Timers → IWDG
2. Activated: Enabled
3. Configuration:
   - Prescaler divider: 64
   - Down-counter reload value: 625
   - (Timeout ≈ 10 seconds)
```

#### I2C1 (EEPROM - اختیاری)
```
1. Connectivity → I2C1
2. Mode: I2C
3. Configuration:
   - I2C Speed Mode: Standard Mode
   - I2C Clock Speed: 100000 Hz
```

### 2.4 تنظیمات Clock

**Clock Configuration Tab:**

1. **Input frequency:**
   - HSE: 25 MHz (کریستال خارجی برد)

2. **PLL Configuration:**
   - PLL Source: HSE
   - PLLM: 25 (برای 1 MHz ورودی به PLL)
   - PLLN: 336 (برای 336 MHz VCO)
   - PLLP: 2 (برای 168 MHz system clock)
   - PLLQ: 7 (برای 48 MHz USB clock)

3. **System Clock Mux:**
   - System Clock Source: PLLCLK

4. **Bus Clocks:**
   - AHB Prescaler: /1 (168 MHz)
   - APB1 Prescaler: /4 (42 MHz - max 42 MHz)
   - APB2 Prescaler: /2 (84 MHz - max 84 MHz)

**نتیجه:**
- HCLK (System Clock): 168 MHz
- APB1 (Peripheral Clock): 42 MHz
- APB2 (Peripheral Clock): 84 MHz
- USB Clock: 48 MHz

### 2.5 تنظیمات DMA

در تب **DMA Settings** هر peripheral:

**USART1:**
- USART1_RX → DMA2 Stream 2, Channel 4, Priority: High, Mode: Circular
- USART1_TX → DMA2 Stream 7, Channel 4, Priority: Medium, Mode: Normal

**USART2:**
- USART2_RX → DMA1 Stream 5, Channel 4, Priority: High, Mode: Circular
- USART2_TX → DMA1 Stream 6, Channel 4, Priority: Medium, Mode: Normal

**ADC1:**
- ADC1 → DMA2 Stream 0, Channel 0, Priority: Low, Mode: Circular

### 2.6 تنظیمات NVIC

**NVIC Tab** → فعال کردن interrupt ها:

```
☑ TIM2 global interrupt (Priority: 5)
☑ TIM4 global interrupt (Priority: 10)
☑ USART1 global interrupt (Priority: 7)
☑ USART2 global interrupt (Priority: 6)
☑ SDIO global interrupt (Priority: 8)
☑ ADC global interrupt (Priority: 9)
☑ DMA2 stream0 global interrupt (Priority: 9)
☑ DMA2 stream2 global interrupt (Priority: 7)
☑ DMA2 stream7 global interrupt (Priority: 7)
☑ DMA1 stream5 global interrupt (Priority: 6)
☑ DMA1 stream6 global interrupt (Priority: 6)
```

**نکته:** Priority پایین‌تر = اولویت بالاتر (0 = بالاترین)

### 2.7 Project Settings

**Project Manager Tab:**

1. **Project:**
   - Project Name: `VehicleTrafficMonitor`
   - Project Location: انتخاب پوشه
   - Toolchain/IDE:
     - برای STM32CubeIDE: `STM32CubeIDE`
     - برای Keil: `MDK-ARM V5`

2. **Code Generator:**
   - STM32Cube MCU packages: Latest
   - ☑ Copy only the necessary library files
   - ☑ Generate peripheral initialization as pair of '.c/.h' files per peripheral
   - Generated files:
     - ☑ Generate initialization code in main.c
     - ☑ Backup previously generated files

3. **Advanced Settings:**
   - Driver Selector: HAL (برای همه peripherals)

### 2.8 تولید کد

**Generate Code:**
- کلیک روی **GENERATE CODE** (گوشه بالا سمت راست)
- منتظر بمانید تا کد تولید شود

---

## مرحله 3: باز کردن پروژه در IDE

### گزینه A: STM32CubeIDE

```bash
# در STM32CubeMX:
# پس از Generate Code، کلیک روی "Open Project"

# یا:
# File → Open Projects from File System
# انتخاب پوشه پروژه
```

### گزینه B: Keil MDK

```bash
# در پوشه پروژه:
# باز کردن فایل: MDK-ARM/VehicleTrafficMonitor.uvprojx

# نصب STM32F4 Device Pack:
# Pack Installer → Search: STM32F4 → Install
```

---

## مرحله 4: اضافه کردن کدهای پروژه

### 4.1 کپی فایل‌های Driver

از ریپازیتوری، فایل‌های زیر را به پروژه اضافه کنید:

```bash
# کپی به پوشه پروژه:
cp firmware_stm32/Core/Inc/config.h → Core/Inc/
cp firmware_stm32/Drivers/BSP/* → Drivers/BSP/
cp firmware_stm32/Middleware/* → Middleware/
```

**در Keil:**
- Project → Manage → Project Items
- اضافه کردن Groups: BSP، Middleware
- اضافه کردن فایل‌های .c به هر Group

**در STM32CubeIDE:**
- فایل‌ها را drag & drop کنید
- یا: File → Import → File System

### 4.2 اضافه کردن Include Paths

**در Keil:**
```
Options for Target → C/C++ → Include Paths:
../Drivers/BSP
../Middleware
```

**در STM32CubeIDE:**
```
Project → Properties → C/C++ Build → Settings → Include paths:
"${workspace_loc:/${ProjName}/Drivers/BSP}"
"${workspace_loc:/${ProjName}/Middleware}"
```

### 4.3 ویرایش main.c

در فایل `Core/Src/main.c`، بین `/* USER CODE BEGIN */` و `/* USER CODE END */`:

```c
/* USER CODE BEGIN Includes */
#include "config.h"
#include "sensor_driver.h"
#include "sim800l_driver.h"
#include "vehicle_detection.h"
/* USER CODE END Includes */

/* USER CODE BEGIN 0 */
// متغیرهای global
/* USER CODE END 0 */

int main(void)
{
  /* USER CODE BEGIN 1 */
  /* USER CODE END 1 */

  HAL_Init();
  SystemClock_Config();
  MX_GPIO_Init();
  MX_DMA_Init();
  MX_USART1_UART_Init();
  MX_USART2_UART_Init();
  MX_TIM2_Init();
  MX_TIM4_Init();
  MX_ADC1_Init();
  MX_SDIO_SD_Init();
  MX_RTC_Init();
  MX_IWDG_Init();

  /* USER CODE BEGIN 2 */

  // Initialize drivers
  Sensor_Init(&htim2);
  Sensor_Start();

  VehicleDetection_Init();

  SIM800L_Config_t sim_config = {
    .apn = DEFAULT_APN,
    .server_ip = DEFAULT_SERVER_IP,
    .server_port = DEFAULT_SERVER_PORT,
    .timeout_ms = 5000
  };
  SIM800L_Init(&huart2, &sim_config);
  SIM800L_PowerOn();

  // Start timers
  HAL_TIM_Base_Start_IT(&htim4);  // 1ms system timer
  HAL_ADC_Start_DMA(&hadc1, (uint32_t*)adc_buffer, 2);

  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */

    // Refresh watchdog
    HAL_IWDG_Refresh(&hiwdg);

    // Process vehicle detection
    VehicleDetection_Process();

    // Process SIM800L
    SIM800L_Process();

    // Sleep to save power
    HAL_PWR_EnterSLEEPMode(PWR_MAINREGULATOR_ON, PWR_SLEEPENTRY_WFI);
  }
  /* USER CODE END 3 */
}

/* USER CODE BEGIN 4 */

// Timer 4 interrupt (1ms)
void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim)
{
  if (htim == &htim4) {
    Sensor_Process();
  }
}

// Input Capture interrupt
void HAL_TIM_IC_CaptureCallback(TIM_HandleTypeDef *htim)
{
  if (htim == &htim2) {
    Sensor_IC_Callback(htim);
  }
}

// UART receive callback
void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{
  if (huart == &huart2) {
    // SIM800L data received
  }
}

/* USER CODE END 4 */
```

---

## مرحله 5: Build و Upload

### 5.1 Build پروژه

**در Keil:**
```
Project → Build Target (F7)
```

**در STM32CubeIDE:**
```
Project → Build All (Ctrl+B)
```

### 5.2 اتصال برد

1. اتصال کابل USB از کامپیوتر به **USB1** روی برد (USB-Serial)
2. اتصال ST-Link یا J-Link به **SWD connector** (5 پین)

**پین‌های SWD:**
```
1: VCC (3.3V)
2: SWDIO
3: GND
4: SWCLK
5: NRST
```

### 5.3 Upload Firmware

**با ST-Link (توصیه می‌شود):**

**در Keil:**
```
Options for Target → Debug → Use ST-Link Debugger
Flash → Download (F8)
```

**در STM32CubeIDE:**
```
Run → Debug (F11)
یا
Run → Run (Ctrl+F11)
```

**با OpenOCD (خط فرمان):**
```bash
openocd -f interface/stlink.cfg -f target/stm32f4x.cfg \
  -c "program build/VehicleTrafficMonitor.elf verify reset exit"
```

### 5.4 اتصال Serial Console

```bash
# Linux:
minicom -D /dev/ttyUSB0 -b 115200

# Windows:
# استفاده از PuTTY یا TeraTerm
# Port: COMX (بررسی از Device Manager)
# Baud: 115200
```

---

## مرحله 6: اتصال سخت‌افزار

### 6.1 اتصال ماژول SIM800L

| SIM800L | برد STM32 | توضیحات |
|---------|-----------|---------|
| VCC     | 3.3V-5V   | منبع تغذیه (حداقل 2A) |
| GND     | GND       | زمین |
| TXD     | PA3       | UART2_RX |
| RXD     | PA2       | UART2_TX |
| RST     | PB7       | Reset (اختیاری) |

**نکات مهم:**
- SIM800L نیاز به جریان بالا دارد (حداقل 2A)
- از منبع تغذیه جداگانه استفاده کنید
- خازن 1000uF روی VCC برای پایداری

### 6.2 اتصال سنسورهای القایی

**Multiplexer 4-to-1:**
- از یک CD4052 یا مشابه استفاده کنید
- خروجی multiplexer به PA0 (TIM2_CH1)
- کنترل: PD0 (SEL0), PD1 (SEL1)

```
Sensor 0 → MUX Input 0
Sensor 1 → MUX Input 1
Sensor 2 → MUX Input 2  →  MUX Output  →  PA0 (TIM2_CH1)
Sensor 3 → MUX Input 3
             ↑
        PD0, PD1 (Control)
```

### 6.3 اتصال DHT22

| DHT22 | برد STM32 |
|-------|-----------|
| VCC   | 3.3V      |
| GND   | GND       |
| DATA  | PC0       |

**Pull-up Resistor:** 10KΩ بین DATA و VCC

### 6.4 اتصال SD Card

SD Card از طریق سوکت روی برد متصل است - نیازی به سیم‌کشی ندارد.

---

## مرحله 7: تست و Debug

### 7.1 تست اولیه

پس از Upload، در Serial Console:

```
STATUS
```

خروجی باید اطلاعات سیستم را نمایش دهد.

### 7.2 کالیبراسیون سنسورها

```
CALIBRATE
```

منتظر بمانید تا کالیبراسیون تمام شود (≈10 ثانیه).

### 7.3 تست سنسورها

```
TEST SENSOR 0
TEST SENSOR 1
TEST SENSOR 2
TEST SENSOR 3
```

### 7.4 تست GPRS

```
TEST GPRS
```

باید پیام "GPRS OK" نمایش داده شود.

### 7.5 Debug با STM32CubeIDE

```
1. Set Breakpoint در خطوط مورد نظر
2. Run → Debug (F11)
3. استفاده از Variables window برای مشاهده متغیرها
4. Step Over (F6), Step Into (F5)
```

---

## مرحله 8: عیب‌یابی رایج

### مشکل 1: برد شناسایی نمی‌شود

**راه‌حل:**
```bash
# بررسی اتصال USB
lsusb | grep STM

# بررسی permissions
sudo chmod 666 /dev/ttyUSB0
```

### مشکل 2: Upload Error

**راه‌حل:**
- بررسی اتصال SWD
- BOOT0 را به GND وصل کنید
- Reset کنید و دوباره Upload

### مشکل 3: سنسورها کار نمی‌کنند

**راه‌حل:**
- بررسی اتصالات multiplexer
- اجرای `CALIBRATE`
- بررسی فرکانس ورودی با اسیلوسکوپ

### مشکل 4: GPRS متصل نمی‌شود

**راه‌حل:**
- بررسی سیم‌کارت
- بررسی APN: `CONFIG GET apn`
- بررسی سیگنال: `STATUS` → signal_quality > 10

---

## مرحله 9: بهینه‌سازی و Tips

### 9.1 کاهش مصرف برق

```c
// در main loop:
HAL_PWR_EnterSLEEPMode(PWR_MAINREGULATOR_ON, PWR_SLEEPENTRY_WFI);

// یا برای مصرف کمتر:
HAL_PWR_EnterSTOPMode(PWR_LOWPOWERREGULATOR_ON, PWR_STOPENTRY_WFI);
```

### 9.2 افزایش سرعت Build

**در Keil:**
```
Options → C/C++ → Optimization: Level 2 (-O2)
```

**در STM32CubeIDE:**
```
Properties → C/C++ Build → Settings → Optimization: -O2
```

### 9.3 استفاده از FreeRTOS (اختیاری)

برای مدیریت بهتر task ها:
```
STM32CubeMX → Middleware → FREERTOS → Enable
```

---

## مرحله 10: آماده‌سازی برای تولید

### 10.1 تست طولانی‌مدت

```bash
# اجرای دستگاه به مدت 24 ساعت
# بررسی:
# - Watchdog reset ها
# - Memory leaks
# - استحکام ارتباط GPRS
```

### 10.2 حفاظت کد

```c
// فعال کردن Read Protection:
// STM32CubeProgrammer → OB (Option Bytes) → RDP: Level 1
```

### 10.3 نسخه‌گذاری

در `config.h`:
```c
#define FIRMWARE_VERSION    "1.0.0"
#define BUILD_DATE          __DATE__
#define BUILD_TIME          __TIME__
```

---

## فایل‌های خروجی

پس از Build موفق:

**Keil:**
```
MDK-ARM/VehicleTrafficMonitor/VehicleTrafficMonitor.hex
MDK-ARM/VehicleTrafficMonitor/VehicleTrafficMonitor.bin
```

**STM32CubeIDE:**
```
Debug/VehicleTrafficMonitor.elf
Debug/VehicleTrafficMonitor.hex
Debug/VehicleTrafficMonitor.bin
```

این فایل‌ها آماده برای Upload به برد هستند.

---

## منابع مفید

1. **STM32F407 Reference Manual:** [RM0090](https://www.st.com/resource/en/reference_manual/dm00031020.pdf)
2. **STM32F407 Datasheet:** [DS8626](https://www.st.com/resource/en/datasheet/stm32f407vg.pdf)
3. **HAL Driver User Manual:** در CubeMX تحت Help → User Manual
4. **SIM800L AT Commands:** [SIM800_Series_AT_Command_Manual](https://www.simcom.com/product/SIM800.html)

---

**نکته نهایی:** همیشه نسخه backup از firmware خود نگه دارید!
