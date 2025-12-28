# Firmware Build Guide - Vehicle Traffic Monitoring System

This guide explains how to build the firmware after generating code from the STM32CubeMX `.ioc` file.

## 📋 Overview

The project structure contains:
- **VehicleTrafficMonitor.ioc** - STM32CubeMX project file (ready to use)
- **Core/** - Application code (main.c, config.h)
- **Drivers/BSP/** - Custom sensor and SIM800L drivers
- **Middleware/** - Vehicle detection algorithms

## 🚀 Quick Start

### Step 1: Generate Code from STM32CubeMX

1. Open **STM32CubeMX**
2. Load the project file: `VehicleTrafficMonitor.ioc`
3. Go to **Project → Settings**:
   - **Toolchain/IDE**: Choose either:
     - `MDK-ARM V5` (for Keil uVision)
     - `STM32CubeIDE` (for STM32CubeIDE)
   - **Project Name**: `VehicleTrafficMonitor`
   - **Project Location**: Choose where to generate (e.g., `D:\STM32_Projects\VehicleTrafficMonitor`)

4. Click **GENERATE CODE**
5. Click **Open Project** (or open manually in your IDE)

### Step 2: Copy Custom Files to Generated Project

After code generation, you need to copy the custom driver and middleware files to the generated project.

#### For STM32CubeIDE:

```bash
# Navigate to your generated project directory
cd /path/to/generated/VehicleTrafficMonitor

# Create BSP directory in Drivers
mkdir -p Drivers/BSP

# Copy BSP drivers
cp /path/to/this/repo/firmware_stm32/Drivers/BSP/*.c Drivers/BSP/
cp /path/to/this/repo/firmware_stm32/Drivers/BSP/*.h Drivers/BSP/

# Create Middleware directory
mkdir -p Middleware

# Copy Middleware files
cp /path/to/this/repo/firmware_stm32/Middleware/*.h Middleware/

# Copy config.h to Core/Inc
cp /path/to/this/repo/firmware_stm32/Core/Inc/config.h Core/Inc/

# Copy main.c to Core/Src (REPLACE the generated one)
cp /path/to/this/repo/firmware_stm32/Core/Src/main.c Core/Src/
```

#### For Keil MDK:

```batch
REM Navigate to your generated project directory
cd D:\STM32_Projects\VehicleTrafficMonitor

REM Create BSP directory
mkdir Drivers\BSP

REM Copy BSP drivers
copy \path\to\repo\firmware_stm32\Drivers\BSP\*.* Drivers\BSP\

REM Create Middleware directory
mkdir Middleware

REM Copy Middleware files
copy \path\to\repo\firmware_stm32\Middleware\*.* Middleware\

REM Copy config.h
copy \path\to\repo\firmware_stm32\Core\Inc\config.h Core\Inc\

REM Copy main.c (REPLACE the generated one)
copy \path\to\repo\firmware_stm32\Core\Src\main.c Core\Src\
```

### Step 3: Add Files to Your IDE Project

#### STM32CubeIDE:

1. **Refresh the project**:
   - Right-click on project → **Refresh** (F5)

2. **Add include paths**:
   - Right-click on project → **Properties**
   - Navigate to: **C/C++ Build → Settings → MCU GCC Compiler → Include paths**
   - Click **Add** (green + icon) and add:
     ```
     ../Drivers/BSP
     ../Middleware
     ```
   - Click **Apply and Close**

3. **Add source files**:
   - The `.c` files in `Drivers/BSP` should appear automatically
   - If not, right-click on `Drivers/BSP` → **New → File** and browse to add them

4. **Verify paths in Project Explorer**:
   ```
   VehicleTrafficMonitor/
   ├── Core/
   │   ├── Inc/
   │   │   ├── config.h
   │   │   └── main.h
   │   └── Src/
   │       └── main.c
   ├── Drivers/
   │   ├── BSP/
   │   │   ├── sensor_driver.c
   │   │   ├── sensor_driver.h
   │   │   └── sim800l_driver.h
   │   ├── CMSIS/
   │   └── STM32F4xx_HAL_Driver/
   └── Middleware/
       └── vehicle_detection.h
   ```

#### Keil MDK:

1. **Add include paths**:
   - Go to **Project → Options for Target**
   - Select **C/C++** tab
   - In **Include Paths**, add:
     ```
     ..\Drivers\BSP
     ..\Middleware
     ```

2. **Add source files to build**:
   - In the **Project** pane, expand **Application/MDK-ARM**
   - Right-click on **Source Group 1** → **Add Existing Files to Group**
   - Browse to `Drivers\BSP\` and select:
     - `sensor_driver.c`
   - Click **Add** → **Close**

3. **Verify file structure** in Project pane

### Step 4: Build the Project

#### STM32CubeIDE:

1. Click **Project → Build All** (or press **Ctrl+B**)
2. Wait for compilation to complete
3. Check the **Console** for errors

Expected output:
```
Finished building target: VehicleTrafficMonitor.elf

arm-none-eabi-size  VehicleTrafficMonitor.elf
   text    data     bss     dec     hex filename
  45678    1024    8192   54894    d66e VehicleTrafficMonitor.elf
Finished building: default.size.stdout
```

#### Keil MDK:

1. Click **Project → Build Target** (or press **F7**)
2. Wait for compilation
3. Check **Build Output** window

Expected output:
```
Build target 'VehicleTrafficMonitor'
compiling main.c...
compiling sensor_driver.c...
linking...
Program Size: Code=45678 RO-data=1024 RW-data=512 ZI-data=7680
"VehicleTrafficMonitor.axf" - 0 Error(s), 0 Warning(s).
```

### Step 5: Flash to STM32F407 Board

#### Using ST-LINK (STM32CubeIDE):

1. Connect ST-LINK to your EWB-STM32F407-V4 board
2. Connect ST-LINK to PC via USB
3. Click **Run → Debug** (or press **F11**)
4. The firmware will be flashed automatically
5. Click **Resume** (F8) to run

#### Using ST-LINK (Keil):

1. Connect hardware as above
2. Click **Flash → Download** (or press **F8**)
3. Wait for "Programming Done" message
4. Click **Debug → Start/Stop Debug Session** (Ctrl+F5) to run

#### Using Serial Bootloader (Optional):

If you don't have ST-LINK, you can use the built-in UART bootloader:

```bash
# Install stm32flash tool
sudo apt-get install stm32flash  # Linux
# or download from: https://sourceforge.net/projects/stm32flash/

# Put STM32 in bootloader mode:
# 1. Set BOOT0 jumper to 1 (VDD)
# 2. Press RESET button
# 3. Connect USB-to-Serial adapter to UART1 (PA9/PA10)

# Flash the firmware
stm32flash -w VehicleTrafficMonitor.bin -v -g 0x0 /dev/ttyUSB0

# Set BOOT0 back to 0 (GND) and press RESET
```

## 🔧 Troubleshooting

### Error: "sensor_driver.h: No such file or directory"

**Solution**: You forgot to add include paths. Go back to **Step 3** and add:
- `../Drivers/BSP`
- `../Middleware`

### Error: "undefined reference to `Sensor_Init`"

**Solution**: The `sensor_driver.c` file is not being compiled. Add it to your project:
- **STM32CubeIDE**: Refresh project and rebuild
- **Keil**: Add the file to Source Group manually

### Error: "multiple definition of `main`"

**Solution**: Make sure you replaced the generated `main.c` with the custom one from this repository. Delete the old generated `main.c` first.

### Compilation is slow or hangs

**Solution**:
1. Disable optimization for Debug builds (already default)
2. Close unused projects in workspace
3. Increase IDE heap size:
   - **STM32CubeIDE**: Edit `STM32CubeIDE.ini`, increase `-Xmx` value
   - **Keil**: Tools → Options → Memory → increase stack size

### ST-LINK not detected

**Solution**:
1. Install latest ST-LINK drivers: [STSW-LINK009](https://www.st.com/en/development-tools/stsw-link009.html)
2. Check USB cable connection
3. Try a different USB port
4. Update ST-LINK firmware using STM32CubeProgrammer

## 📊 Verify Firmware is Running

After flashing, connect a serial terminal to UART1 (115200 baud, 8N1):

```bash
# Linux
sudo screen /dev/ttyUSB0 115200

# Windows - use PuTTY or TeraTerm
# Port: COM3 (check Device Manager)
# Baud: 115200
# Data bits: 8
# Parity: None
# Stop bits: 1
```

You should see:
```
========================================
  Vehicle Traffic Monitoring System
  STM32F407VGT6 - Firmware v1.0.0
  Device ID: DEVICE001
========================================

[INIT] Initializing sensor driver...
[OK] Sensor driver initialized
[INIT] Initializing SIM800L module...
[OK] SIM800L module initialized
[INIT] Initializing vehicle detection...
[OK] Vehicle detection initialized

[READY] System initialized successfully!
Type 'help' for available commands.
>
```

Type `help` to see available commands:
- `status` - Show system status
- `calibrate` - Calibrate sensors
- `send` - Send data now (manual)
- `reset` - Reset system

## 📁 Final Project Structure

After completing all steps, your generated project should look like this:

```
VehicleTrafficMonitor/
├── Core/
│   ├── Inc/
│   │   ├── config.h              ← Custom config
│   │   ├── main.h                ← Generated
│   │   ├── stm32f4xx_hal_conf.h  ← Generated
│   │   └── stm32f4xx_it.h        ← Generated
│   ├── Src/
│   │   ├── main.c                ← REPLACED with custom
│   │   ├── stm32f4xx_hal_msp.c   ← Generated
│   │   ├── stm32f4xx_it.c        ← Generated
│   │   └── system_stm32f4xx.c    ← Generated
│   └── Startup/
│       └── startup_stm32f407vgtx.s
├── Drivers/
│   ├── BSP/                       ← CUSTOM DRIVERS
│   │   ├── sensor_driver.c
│   │   ├── sensor_driver.h
│   │   └── sim800l_driver.h
│   ├── CMSIS/
│   └── STM32F4xx_HAL_Driver/
├── Middleware/                    ← CUSTOM MIDDLEWARE
│   └── vehicle_detection.h
├── MDK-ARM/                       ← If using Keil
│   ├── VehicleTrafficMonitor.uvprojx
│   └── ...
├── STM32CubeIDE/                  ← If using CubeIDE
│   ├── .cproject
│   ├── .project
│   └── ...
└── VehicleTrafficMonitor.ioc      ← Original .ioc file
```

## 🎯 Next Steps

Once the firmware is running:

1. **Hardware Setup**: Follow `HARDWARE_WIRING_GUIDE.md` to connect sensors and SIM800L
2. **Sensor Calibration**: Run `calibrate` command with no vehicles on sensors
3. **Server Setup**: Deploy the backend server (see `SERVER_HARDWARE_REQUIREMENTS.md`)
4. **Network Configuration**: Update SIM800L APN settings in code if needed
5. **Testing**: Monitor serial console for vehicle detections

## 📞 Support

If you encounter issues:
1. Check the **Troubleshooting** section above
2. Review `STM32_SETUP_GUIDE.md` for detailed pin configurations
3. Verify all hardware connections per `HARDWARE_WIRING_GUIDE.md`
4. Check that your board is the **EWB-STM32F407-V4** with 25MHz crystal

## ⚠️ Important Notes

- **DO NOT** modify files in `Drivers/STM32F4xx_HAL_Driver/` - these are ST's HAL library
- **DO NOT** edit code between `/* USER CODE BEGIN */` and `/* USER CODE END */` in generated files if you plan to regenerate from .ioc
- **ALWAYS** keep a backup of your custom code before regenerating from STM32CubeMX
- The custom `main.c` uses `USER CODE BEGIN/END` blocks to be compatible with code regeneration

Good luck with your Vehicle Traffic Monitoring System! 🚗📊
