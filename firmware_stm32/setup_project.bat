@echo off
REM ###########################################################################
REM Vehicle Traffic Monitoring System - Project Setup Script (Windows)
REM
REM This script copies custom driver and middleware files to your generated
REM STM32CubeMX project directory.
REM
REM Usage:
REM   setup_project.bat C:\Path\To\Generated\VehicleTrafficMonitor
REM
REM Example:
REM   setup_project.bat D:\STM32_Projects\VehicleTrafficMonitor
REM ###########################################################################

setlocal enabledelayedexpansion

REM Get the directory where this script is located
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

REM Print header
echo.
echo ==========================================
echo  Vehicle Traffic Monitoring System
echo  Project Setup Script (Windows)
echo ==========================================
echo.

REM Check if target directory is provided
if "%~1"=="" (
    echo Error: No target directory specified
    echo.
    echo Usage: %~nx0 ^<target_project_directory^>
    echo.
    echo Example:
    echo   %~nx0 D:\STM32_Projects\VehicleTrafficMonitor
    echo   %~nx0 C:\Users\YourName\Documents\STM32\VehicleTrafficMonitor
    echo.
    pause
    exit /b 1
)

set "TARGET_DIR=%~1"

REM Check if target directory exists
if not exist "%TARGET_DIR%" (
    echo Error: Target directory does not exist: %TARGET_DIR%
    echo.
    echo Please generate code from STM32CubeMX first!
    echo.
    pause
    exit /b 1
)

REM Check if target looks like a valid STM32 project
if not exist "%TARGET_DIR%\Core" (
    echo Error: Target directory doesn't appear to be a valid STM32 project
    echo Expected to find 'Core' subdirectory.
    echo.
    pause
    exit /b 1
)

if not exist "%TARGET_DIR%\Drivers" (
    echo Error: Target directory doesn't appear to be a valid STM32 project
    echo Expected to find 'Drivers' subdirectory.
    echo.
    pause
    exit /b 1
)

echo Source directory: %SCRIPT_DIR%
echo Target directory: %TARGET_DIR%
echo.

REM Confirmation prompt
set /p "CONFIRM=Continue with setup? (Y/N): "
if /i not "%CONFIRM%"=="Y" (
    echo Setup cancelled.
    pause
    exit /b 0
)

echo.
echo Setting up project...
echo.

REM Counter for successful operations
set "SUCCESS_COUNT=0"
set "TOTAL_OPERATIONS=0"

REM 1. Create BSP directory
echo [1/7] Creating Drivers\BSP directory...
if not exist "%TARGET_DIR%\Drivers\BSP" mkdir "%TARGET_DIR%\Drivers\BSP"
if exist "%TARGET_DIR%\Drivers\BSP" (
    echo [OK] Created Drivers\BSP
    set /a SUCCESS_COUNT+=1
) else (
    echo [ERROR] Failed to create Drivers\BSP
)
set /a TOTAL_OPERATIONS+=1
echo.

REM 2. Copy BSP driver source files (.c)
echo [2/7] Copying BSP driver files (.c^)...
for %%f in ("%SCRIPT_DIR%\Drivers\BSP\*.c") do (
    copy /Y "%%f" "%TARGET_DIR%\Drivers\BSP\" >nul 2>&1
    if !errorlevel! equ 0 (
        echo [OK] Copied %%~nxf
        set /a SUCCESS_COUNT+=1
    ) else (
        echo [ERROR] Failed to copy %%~nxf
    )
    set /a TOTAL_OPERATIONS+=1
)
echo.

REM 3. Copy BSP driver header files (.h)
echo [3/7] Copying BSP driver files (.h^)...
for %%f in ("%SCRIPT_DIR%\Drivers\BSP\*.h") do (
    copy /Y "%%f" "%TARGET_DIR%\Drivers\BSP\" >nul 2>&1
    if !errorlevel! equ 0 (
        echo [OK] Copied %%~nxf
        set /a SUCCESS_COUNT+=1
    ) else (
        echo [ERROR] Failed to copy %%~nxf
    )
    set /a TOTAL_OPERATIONS+=1
)
echo.

REM 4. Create Middleware directory
echo [4/7] Creating Middleware directory...
if not exist "%TARGET_DIR%\Middleware" mkdir "%TARGET_DIR%\Middleware"
if exist "%TARGET_DIR%\Middleware" (
    echo [OK] Created Middleware
    set /a SUCCESS_COUNT+=1
) else (
    echo [ERROR] Failed to create Middleware
)
set /a TOTAL_OPERATIONS+=1
echo.

REM 5. Copy Middleware files
echo [5/7] Copying Middleware files...
for %%f in ("%SCRIPT_DIR%\Middleware\*.h") do (
    copy /Y "%%f" "%TARGET_DIR%\Middleware\" >nul 2>&1
    if !errorlevel! equ 0 (
        echo [OK] Copied %%~nxf
        set /a SUCCESS_COUNT+=1
    ) else (
        echo [ERROR] Failed to copy %%~nxf
    )
    set /a TOTAL_OPERATIONS+=1
)
echo.

REM 6. Copy config.h to Core\Inc
echo [6/7] Copying config.h...
copy /Y "%SCRIPT_DIR%\Core\Inc\config.h" "%TARGET_DIR%\Core\Inc\" >nul 2>&1
if !errorlevel! equ 0 (
    echo [OK] Copied config.h
    set /a SUCCESS_COUNT+=1
) else (
    echo [ERROR] Failed to copy config.h
)
set /a TOTAL_OPERATIONS+=1
echo.

REM 7. Copy main.c to Core\Src (with backup)
echo [7/7] Copying main.c...
if exist "%TARGET_DIR%\Core\Src\main.c" (
    REM Backup existing main.c
    set "TIMESTAMP=%date:~-4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
    set "TIMESTAMP=!TIMESTAMP: =0!"
    copy "%TARGET_DIR%\Core\Src\main.c" "%TARGET_DIR%\Core\Src\main.c.backup_!TIMESTAMP!" >nul 2>&1
    echo [WARN] Backed up existing main.c to: main.c.backup_!TIMESTAMP!
)

copy /Y "%SCRIPT_DIR%\Core\Src\main.c" "%TARGET_DIR%\Core\Src\" >nul 2>&1
if !errorlevel! equ 0 (
    echo [OK] Copied main.c
    set /a SUCCESS_COUNT+=1
) else (
    echo [ERROR] Failed to copy main.c
)
set /a TOTAL_OPERATIONS+=1
echo.

REM Print summary
echo ==========================================
echo  Setup Summary
echo ==========================================
echo Successful operations: %SUCCESS_COUNT% / %TOTAL_OPERATIONS%
echo.

if %SUCCESS_COUNT% equ %TOTAL_OPERATIONS% (
    echo [SUCCESS] Setup completed successfully!
    echo.
    echo Next steps:
    echo   1. Open your project in STM32CubeIDE or Keil
    echo   2. Add include paths:
    echo      - ..\Drivers\BSP
    echo      - ..\Middleware
    echo   3. Refresh/rebuild the project
    echo   4. Flash to your STM32F407 board
    echo.
    echo See FIRMWARE_BUILD_GUIDE.md for detailed instructions.
    echo.
) else (
    echo [WARNING] Setup completed with warnings
    echo.
    echo Some files may not have been copied successfully.
    echo Please check the output above and copy missing files manually.
    echo.
)

pause
exit /b 0
