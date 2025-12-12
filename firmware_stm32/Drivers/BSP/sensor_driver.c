/**
 * @file    sensor_driver.c
 * @brief   Inductive Loop Sensor Driver Implementation
 */

#include "sensor_driver.h"
#include <string.h>
#include <stdlib.h>

/* ==================== Private Variables ==================== */
static SensorManager_t sensor_mgr;
static TIM_HandleTypeDef *htim_sensor = NULL;

/* Input capture variables */
static uint32_t ic_value1 = 0;
static uint32_t ic_value2 = 0;
static uint8_t ic_buffer_count = 0;

/* Calibration */
static uint32_t calib_sum[NUM_INDUCTIVE_LOOPS] = {0};
static uint32_t calib_count[NUM_INDUCTIVE_LOOPS] = {0};

/* ==================== Private Function Prototypes ==================== */
static void SelectLoopHardware(uint8_t loop_id);
static void CalculateDeviation(uint8_t loop_id);

/* ==================== Public Functions ==================== */

/**
 * @brief Initialize sensor driver
 */
HAL_StatusTypeDef Sensor_Init(TIM_HandleTypeDef *htim2)
{
    if (htim2 == NULL) {
        return HAL_ERROR;
    }

    htim_sensor = htim2;

    // Initialize sensor manager
    memset(&sensor_mgr, 0, sizeof(SensorManager_t));

    // Enable all loops by default
    for (uint8_t i = 0; i < NUM_INDUCTIVE_LOOPS; i++) {
        sensor_mgr.sensors[i].enabled = true;
        sensor_mgr.sensors[i].calib_value = 50000; // Default calibration
    }

    // Configure GPIO for loop selection (multiplexer)
    GPIO_InitTypeDef GPIO_InitStruct = {0};

    // Enable clocks
    __HAL_RCC_GPIOD_CLK_ENABLE();

    // Configure SEL0 and SEL1 pins
    GPIO_InitStruct.Pin = LOOP_SEL0_PIN | LOOP_SEL1_PIN;
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init(GPIOD, &GPIO_InitStruct);

    // Select first loop
    sensor_mgr.current_loop = 0;
    SelectLoopHardware(0);

    return HAL_OK;
}

/**
 * @brief Start sensor measurements
 */
HAL_StatusTypeDef Sensor_Start(void)
{
    if (htim_sensor == NULL) {
        return HAL_ERROR;
    }

    // Start input capture
    HAL_TIM_IC_Start_IT(htim_sensor, TIM_CHANNEL_1);

    return HAL_OK;
}

/**
 * @brief Stop sensor measurements
 */
HAL_StatusTypeDef Sensor_Stop(void)
{
    if (htim_sensor == NULL) {
        return HAL_ERROR;
    }

    // Stop input capture
    HAL_TIM_IC_Stop_IT(htim_sensor, TIM_CHANNEL_1);

    return HAL_OK;
}

/**
 * @brief Process sensor data (called every 1ms)
 */
void Sensor_Process(void)
{
    uint8_t current = sensor_mgr.current_loop;

    // Calculate deviation for current sensor
    if (sensor_mgr.sensors[current].enabled) {
        CalculateDeviation(current);
    }

    // Switch to next enabled loop
    uint8_t next_loop = (current + 1) % NUM_INDUCTIVE_LOOPS;
    while (!sensor_mgr.sensors[next_loop].enabled && next_loop != current) {
        next_loop = (next_loop + 1) % NUM_INDUCTIVE_LOOPS;
    }

    if (next_loop != current) {
        sensor_mgr.current_loop = next_loop;
        SelectLoopHardware(next_loop);
    }

    // Reset input capture buffer
    ic_buffer_count = 0;
}

/**
 * @brief Get sensor deviation
 */
int32_t Sensor_GetDeviation(uint8_t loop_id)
{
    if (loop_id >= NUM_INDUCTIVE_LOOPS) {
        return 0;
    }

    return sensor_mgr.sensors[loop_id].deviation;
}

/**
 * @brief Check if loop is active
 */
bool Sensor_IsLoopActive(uint8_t loop_id)
{
    if (loop_id >= NUM_INDUCTIVE_LOOPS) {
        return false;
    }

    return sensor_mgr.sensors[loop_id].active;
}

/**
 * @brief Calibrate all sensors
 */
HAL_StatusTypeDef Sensor_Calibrate(void)
{
    // Clear calibration data
    memset(calib_sum, 0, sizeof(calib_sum));
    memset(calib_count, 0, sizeof(calib_count));

    sensor_mgr.calibration_mode = true;
    sensor_mgr.calib_samples = 0;

    // Collect 100 samples per loop
    uint32_t start_tick = HAL_GetTick();
    while (sensor_mgr.calib_samples < 100 && (HAL_GetTick() - start_tick) < 2000) {
        HAL_Delay(10);

        for (uint8_t i = 0; i < NUM_INDUCTIVE_LOOPS; i++) {
            if (sensor_mgr.sensors[i].enabled && sensor_mgr.sensors[i].freq_mean > 0) {
                calib_sum[i] += sensor_mgr.sensors[i].freq_mean;
                calib_count[i]++;
            }
        }

        sensor_mgr.calib_samples++;
    }

    // Calculate average calibration values
    for (uint8_t i = 0; i < NUM_INDUCTIVE_LOOPS; i++) {
        if (calib_count[i] > 0) {
            sensor_mgr.sensors[i].calib_value = calib_sum[i] / calib_count[i];
        }
    }

    sensor_mgr.calibration_mode = false;

    return HAL_OK;
}

/**
 * @brief Enable/disable loop
 */
void Sensor_EnableLoop(uint8_t loop_id, bool enable)
{
    if (loop_id < NUM_INDUCTIVE_LOOPS) {
        sensor_mgr.sensors[loop_id].enabled = enable;
    }
}

/**
 * @brief Get sensor status
 */
const SensorStatus_t* Sensor_GetStatus(uint8_t loop_id)
{
    if (loop_id >= NUM_INDUCTIVE_LOOPS) {
        return NULL;
    }

    return &sensor_mgr.sensors[loop_id];
}

/**
 * @brief Check sensor health
 */
bool Sensor_CheckHealth(uint8_t loop_id)
{
    if (loop_id >= NUM_INDUCTIVE_LOOPS) {
        return false;
    }

    const SensorStatus_t *sensor = &sensor_mgr.sensors[loop_id];

    // Check if sensor is responding
    if (sensor->enabled && sensor->freq_mean == 0) {
        return false;
    }

    // Check if too many errors
    if (sensor->error_count > 10) {
        return false;
    }

    // Check if deviation is realistic
    if (abs(sensor->deviation) > 5000 && !sensor->active) {
        return false;
    }

    return true;
}

/**
 * @brief Input capture callback
 */
void Sensor_IC_Callback(TIM_HandleTypeDef *htim)
{
    if (htim != htim_sensor) {
        return;
    }

    uint32_t capture_value = HAL_TIM_ReadCapturedValue(htim, TIM_CHANNEL_1);

    if (ic_buffer_count == 0) {
        ic_value1 = capture_value;
        ic_buffer_count = 1;
    } else if (ic_buffer_count == 1) {
        ic_value2 = capture_value;
        ic_buffer_count = 2;
    } else {
        // Buffer overflow - we have valid measurement
        ic_buffer_count = 3;

        uint8_t current = sensor_mgr.current_loop;

        // Calculate frequency period
        if (ic_value2 > ic_value1) {
            sensor_mgr.sensors[current].freq_mean = ic_value2 - ic_value1;
        } else {
            // Timer overflow case
            sensor_mgr.sensors[current].freq_mean = (0xFFFF - ic_value1) + ic_value2;
        }

        sensor_mgr.sensors[current].last_update = HAL_GetTick();
        sensor_mgr.sensors[current].error_count = 0;
    }
}

/**
 * @brief Get frequency
 */
uint32_t Sensor_GetFrequency(uint8_t loop_id)
{
    if (loop_id >= NUM_INDUCTIVE_LOOPS) {
        return 0;
    }

    return sensor_mgr.sensors[loop_id].freq_mean;
}

/* ==================== Private Functions ==================== */

/**
 * @brief Select loop via hardware multiplexer
 */
static void SelectLoopHardware(uint8_t loop_id)
{
    // Set multiplexer select pins (2-bit binary)
    HAL_GPIO_WritePin(LOOP_SEL0_PORT, LOOP_SEL0_PIN,
                     (loop_id & 0x01) ? GPIO_PIN_SET : GPIO_PIN_RESET);
    HAL_GPIO_WritePin(LOOP_SEL1_PORT, LOOP_SEL1_PIN,
                     (loop_id & 0x02) ? GPIO_PIN_SET : GPIO_PIN_RESET);

    // Small delay for multiplexer settling
    for (volatile int i = 0; i < 100; i++);
}

/**
 * @brief Calculate deviation from calibration
 */
static void CalculateDeviation(uint8_t loop_id)
{
    if (loop_id >= NUM_INDUCTIVE_LOOPS) {
        return;
    }

    SensorStatus_t *sensor = &sensor_mgr.sensors[loop_id];

    if (sensor->freq_mean == 0 || sensor->calib_value == 0) {
        sensor->deviation = 0;
        return;
    }

    // Calculate deviation as percentage * 100
    // dev = ((calib - freq) / calib) * 10000
    int32_t diff = (int32_t)sensor->calib_value - (int32_t)sensor->freq_mean;
    sensor->deviation = (diff * 10000) / (int32_t)sensor->calib_value;

    // Update active status based on threshold
    if (!sensor->active && sensor->deviation > MARGIN_TOP) {
        sensor->active = true;
    } else if (sensor->active && sensor->deviation < MARGIN_BOTTOM) {
        sensor->active = false;
    }
}
