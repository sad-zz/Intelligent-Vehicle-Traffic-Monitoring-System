/**
 * @file    config.h
 * @brief   System Configuration for Vehicle Traffic Monitoring System
 * @author  Generated for STM32F407
 * @date    2025-12-12
 */

#ifndef __CONFIG_H
#define __CONFIG_H

#ifdef __cplusplus
extern "C" {
#endif

/* ==================== System Configuration ==================== */
#define FIRMWARE_VERSION        "1.0.0"
#define HARDWARE_VERSION        "STM32F407-V1"
#define SYSTEM_MODEL            "VTMS-4LANE"

/* Device Configuration (Stored in Flash/EEPROM) */
#define DEFAULT_DEVICE_ID       "DEVICE001"
#define DEFAULT_LOCATION_NAME   "Tehran-Highway-A1"

/* ==================== Timing Configuration ==================== */
#define SYSTEM_TICK_FREQ        1000        // 1ms tick
#define DATA_SEND_INTERVAL      600000      // 10 minutes in ms
#define SENSOR_SAMPLE_RATE      1000        // 1ms (1kHz)
#define TEMP_SAMPLE_INTERVAL    60000       // 1 minute

/* ==================== Sensor Configuration ==================== */
#define NUM_INDUCTIVE_LOOPS     4           // 4 loops (2 per lane)
#define NUM_LANES               2           // 2 lanes

/* Loop IDs */
#define LOOP_0                  0           // Lane 1 - First loop
#define LOOP_1                  1           // Lane 1 - Second loop
#define LOOP_2                  2           // Lane 2 - First loop
#define LOOP_3                  3           // Lane 2 - Second loop

/* Loop Physical Parameters (in cm) */
#define DEFAULT_LOOP_DISTANCE   400         // Distance between loops (400cm = 4m)
#define DEFAULT_LOOP_WIDTH      140         // Loop width (140cm = 1.4m)

/* Sensor Thresholds */
#define MARGIN_TOP              50          // Activation threshold
#define MARGIN_BOTTOM           30          // Deactivation threshold

/* Vehicle Classification Limits (in cm) */
#define LIMIT_X                 200         // Motorcycle < 2m
#define LIMIT_A                 600         // Car < 6m
#define LIMIT_B                 900         // Van < 9m
#define LIMIT_C                 1200        // Bus/Medium truck < 12m
#define LIMIT_D                 1600        // Heavy truck < 16m
#define LIMIT_E                 2000        // Trailer > 16m

/* Speed Thresholds (km/h) */
#define SPEED_LIMIT_DAY_LIGHT   110         // Light vehicles day
#define SPEED_LIMIT_NIGHT_LIGHT 100         // Light vehicles night
#define SPEED_LIMIT_DAY_HEAVY   90          // Heavy vehicles day
#define SPEED_LIMIT_NIGHT_HEAVY 80          // Heavy vehicles night

/* Gap Delay (ms) */
#define GAP_DELAY_THRESHOLD     2000        // 2 seconds

/* ==================== Communication Configuration ==================== */

/* UART1 - Debug/Console */
#define UART1_BAUDRATE          115200
#define UART1_TX_BUFFER_SIZE    512
#define UART1_RX_BUFFER_SIZE    256

/* UART2 - SIM800L */
#define UART2_BAUDRATE          115200
#define UART2_TX_BUFFER_SIZE    1024
#define UART2_RX_BUFFER_SIZE    1024
#define SIM800L_RESPONSE_TIMEOUT 5000       // 5 seconds

/* Server Configuration */
#define DEFAULT_SERVER_IP       "192.168.1.100"
#define DEFAULT_SERVER_PORT     8080
#define DEFAULT_APN             "mcinet"    // MTN Irancell APN
#define DEFAULT_APN_USER        ""
#define DEFAULT_APN_PASS        ""

/* ==================== Power Management ==================== */
#define BATTERY_LOW_THRESHOLD   11.0        // Volts
#define BATTERY_CRITICAL        10.0        // Volts
#define SOLAR_MIN_VOLTAGE       12.0        // Volts

/* Power Modes */
#define POWER_MODE_NORMAL       0
#define POWER_MODE_LOW_POWER    1
#define POWER_MODE_EMERGENCY    2

/* ==================== Watchdog Configuration ==================== */
#define IWDG_TIMEOUT_MS         10000       // 10 seconds
#define IWDG_PRESCALER          IWDG_PRESCALER_64
#define IWDG_RELOAD_VALUE       625         // For ~10s with LSI=32kHz

/* ==================== Memory Configuration ==================== */
#define SD_CARD_ENABLED         1
#define FLASH_CONFIG_ADDRESS    0x080E0000  // Last sector for config
#define INTERVAL_DATA_SIZE      512         // Bytes per interval record

/* ==================== GPIO Pin Definitions ==================== */

/* Inductive Loop Sensor Multiplexer Control */
#define LOOP_SEL0_PORT          GPIOD
#define LOOP_SEL0_PIN           GPIO_PIN_0
#define LOOP_SEL1_PORT          GPIOD
#define LOOP_SEL1_PIN           GPIO_PIN_1

/* SIM800L Control */
#define SIM800L_PWR_PORT        GPIOB
#define SIM800L_PWR_PIN         GPIO_PIN_2
#define SIM800L_PWRKEY_PORT     GPIOB
#define SIM800L_PWRKEY_PIN      GPIO_PIN_7
#define SIM800L_STATUS_PORT     GPIOB
#define SIM800L_STATUS_PIN      GPIO_PIN_6

/* DHT22 Temperature & Humidity Sensor */
#define DHT22_PORT              GPIOC
#define DHT22_PIN               GPIO_PIN_0

/* SD Card SPI */
#define SD_CS_PORT              GPIOF
#define SD_CS_PIN               GPIO_PIN_1

/* Status LED */
#define STATUS_LED_PORT         GPIOE
#define STATUS_LED_PIN          GPIO_PIN_4

/* Error LED */
#define ERROR_LED_PORT          GPIOB
#define ERROR_LED_PIN           GPIO_PIN_5

/* Charge Control */
#define CHARGE_CTRL_PORT        GPIOB
#define CHARGE_CTRL_PIN         GPIO_PIN_8

/* ==================== Error Codes ==================== */
#define ERR_NONE                0x0000
#define ERR_MMC                 0x0001
#define ERR_LOOP1               0x0002
#define ERR_LOOP2               0x0004
#define ERR_LOOP3               0x0008
#define ERR_LOOP4               0x0010
#define ERR_POWER               0x0020
#define ERR_SOLAR               0x0040
#define ERR_BATTERY_LOW         0x0080
#define ERR_LANE1_DIRECTION     0x0100
#define ERR_LANE2_DIRECTION     0x0200
#define ERR_SIM800L             0x0400
#define ERR_TEMPERATURE         0x0800

/* ==================== Debug Configuration ==================== */
#define DEBUG_ENABLED           1
#define DEBUG_VERBOSE           0

#ifdef __cplusplus
}
#endif

#endif /* __CONFIG_H */
