/**
 * @file    sensor_driver.h
 * @brief   Inductive Loop Sensor Driver for Vehicle Detection
 * @details Manages 4 inductive loop sensors using frequency measurement
 *          via Input Capture on TIM2
 */

#ifndef __SENSOR_DRIVER_H
#define __SENSOR_DRIVER_H

#ifdef __cplusplus
extern "C" {
#endif

#include "stm32f4xx_hal.h"
#include "config.h"
#include <stdbool.h>

/* ==================== Type Definitions ==================== */

/**
 * @brief Sensor status structure
 */
typedef struct {
    uint32_t freq_mean;         // Mean frequency
    int32_t  deviation;         // Deviation from calibration
    uint32_t calib_value;       // Calibration reference value
    bool     active;            // Sensor currently active
    bool     enabled;           // Sensor enabled in config
    uint8_t  error_count;       // Consecutive error count
    uint32_t last_update;       // Last update timestamp
} SensorStatus_t;

/**
 * @brief Loop state for vehicle detection
 */
typedef enum {
    LOOP_STATE_IDLE = 0,
    LOOP_STATE_ACTIVE,
    LOOP_STATE_ERROR
} LoopState_t;

/**
 * @brief Sensor manager structure
 */
typedef struct {
    SensorStatus_t sensors[NUM_INDUCTIVE_LOOPS];
    uint8_t current_loop;       // Currently selected loop for measurement
    bool calibration_mode;      // In calibration mode
    uint32_t calib_samples;     // Calibration sample count
} SensorManager_t;

/* ==================== Function Prototypes ==================== */

/**
 * @brief Initialize sensor driver
 * @param htim2 Timer handle for input capture
 * @retval HAL status
 */
HAL_StatusTypeDef Sensor_Init(TIM_HandleTypeDef *htim2);

/**
 * @brief Start sensor measurements
 * @retval HAL status
 */
HAL_StatusTypeDef Sensor_Start(void);

/**
 * @brief Stop sensor measurements
 * @retval HAL status
 */
HAL_StatusTypeDef Sensor_Stop(void);

/**
 * @brief Process sensor data (called from timer interrupt)
 * @note This should be called every 1ms from main timer ISR
 */
void Sensor_Process(void);

/**
 * @brief Get sensor deviation for specific loop
 * @param loop_id Loop ID (0-3)
 * @retval Deviation value (-10000 to +10000)
 */
int32_t Sensor_GetDeviation(uint8_t loop_id);

/**
 * @brief Check if loop is currently active (vehicle present)
 * @param loop_id Loop ID (0-3)
 * @retval true if active, false otherwise
 */
bool Sensor_IsLoopActive(uint8_t loop_id);

/**
 * @brief Calibrate all sensors
 * @note This takes approximately 1 second
 * @retval HAL status
 */
HAL_StatusTypeDef Sensor_Calibrate(void);

/**
 * @brief Enable/disable specific loop
 * @param loop_id Loop ID (0-3)
 * @param enable true to enable, false to disable
 */
void Sensor_EnableLoop(uint8_t loop_id, bool enable);

/**
 * @brief Get sensor status
 * @param loop_id Loop ID (0-3)
 * @retval Pointer to sensor status structure
 */
const SensorStatus_t* Sensor_GetStatus(uint8_t loop_id);

/**
 * @brief Check sensor health
 * @param loop_id Loop ID (0-3)
 * @retval true if sensor is healthy, false if error
 */
bool Sensor_CheckHealth(uint8_t loop_id);

/**
 * @brief Input capture callback (called from HAL)
 * @param htim Timer handle
 */
void Sensor_IC_Callback(TIM_HandleTypeDef *htim);

/**
 * @brief Select loop for measurement
 * @param loop_id Loop ID (0-3)
 */
void Sensor_SelectLoop(uint8_t loop_id);

/**
 * @brief Get frequency measurement
 * @param loop_id Loop ID (0-3)
 * @retval Frequency value in Hz
 */
uint32_t Sensor_GetFrequency(uint8_t loop_id);

#ifdef __cplusplus
}
#endif

#endif /* __SENSOR_DRIVER_H */
