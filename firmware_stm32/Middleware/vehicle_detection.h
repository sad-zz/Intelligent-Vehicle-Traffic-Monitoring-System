/**
 * @file    vehicle_detection.h
 * @brief   Vehicle Detection and Classification System
 * @details Analyzes sensor data to detect, classify and measure vehicles
 */

#ifndef __VEHICLE_DETECTION_H
#define __VEHICLE_DETECTION_H

#ifdef __cplusplus
extern "C" {
#endif

#include "stm32f4xx_hal.h"
#include "config.h"
#include <stdbool.h>

/* ==================== Type Definitions ==================== */

/**
 * @brief Vehicle class enumeration
 */
typedef enum {
    VEHICLE_CLASS_X = 'X',  // Motorcycle (< 2m)
    VEHICLE_CLASS_A = 'A',  // Car (2-6m)
    VEHICLE_CLASS_B = 'B',  // Van (6-9m)
    VEHICLE_CLASS_C = 'C',  // Bus/Medium truck (9-12m)
    VEHICLE_CLASS_D = 'D',  // Heavy truck (12-16m)
    VEHICLE_CLASS_E = 'E',  // Trailer (> 16m)
    VEHICLE_CLASS_UNKNOWN = '?'
} VehicleClass_t;

/**
 * @brief Vehicle direction
 */
typedef enum {
    DIR_FORWARD = 12,       // Direction 1->2
    DIR_BACKWARD = 21,      // Direction 2->1
    DIR_UNKNOWN = 0
} VehicleDirection_t;

/**
 * @brief Vehicle information structure
 */
typedef struct {
    VehicleClass_t class;
    VehicleDirection_t direction;
    uint16_t speed;             // km/h
    uint16_t length;            // cm
    uint32_t timestamp;         // Detection time (ms)
    uint8_t lane_id;            // Lane number (0 or 1)
    bool speed_violation;
    bool wrong_direction;
    bool short_headway;
} VehicleInfo_t;

/**
 * @brief Lane detection state
 */
typedef enum {
    LANE_STATE_IDLE = 0,
    LANE_STATE_FIRST_LOOP_ENTER,
    LANE_STATE_FIRST_LOOP_EXIT,
    LANE_STATE_SECOND_LOOP_ENTER,
    LANE_STATE_SECOND_LOOP_EXIT,
    LANE_STATE_COMPLETE
} LaneState_t;

/**
 * @brief Lane detection data
 */
typedef struct {
    LaneState_t state;
    VehicleDirection_t direction;
    uint32_t T1;                // First loop activation time
    uint32_t T2;                // First loop deactivation time
    uint32_t T3;                // Second loop activation time
    uint32_t T4;                // Second loop deactivation time
    uint32_t last_gap;          // Time since last vehicle (ms)
    bool timer_enabled;
    uint32_t timer_value;
} LaneDetection_t;

/**
 * @brief Interval statistics for one vehicle class in one lane
 */
typedef struct {
    uint16_t count;             // Vehicle count
    uint32_t total_speed;       // Sum of speeds for average
    uint16_t avg_speed;         // Average speed (km/h)
    uint16_t speed_violations;  // Count of speed violations
    uint16_t wrong_direction;   // Count of wrong direction
    uint16_t short_headway;     // Count of short headway
} ClassStats_t;

/**
 * @brief Lane interval statistics
 */
typedef struct {
    ClassStats_t class_X;
    ClassStats_t class_A;
    ClassStats_t class_B;
    ClassStats_t class_C;
    ClassStats_t class_D;
    ClassStats_t class_E;
    uint16_t total_vehicles;
    uint32_t occupancy_time;    // Total time with vehicle present (ms)
    float occupancy_rate;       // Percentage
} LaneStats_t;

/**
 * @brief Complete interval statistics
 */
typedef struct {
    uint32_t interval_start;    // Timestamp
    uint32_t interval_end;
    LaneStats_t lane[NUM_LANES];
    uint16_t total_vehicles;
} IntervalStats_t;

/* ==================== Function Prototypes ==================== */

/**
 * @brief Initialize vehicle detection system
 * @retval HAL status
 */
HAL_StatusTypeDef VehicleDetection_Init(void);

/**
 * @brief Process sensor data for vehicle detection
 * @note Call this from main loop (1ms rate)
 */
void VehicleDetection_Process(void);

/**
 * @brief Reset interval statistics
 */
void VehicleDetection_ResetInterval(void);

/**
 * @brief Get current interval statistics
 * @retval Pointer to interval statistics
 */
const IntervalStats_t* VehicleDetection_GetIntervalStats(void);

/**
 * @brief Get last detected vehicle
 * @retval Pointer to vehicle info (NULL if none)
 */
const VehicleInfo_t* VehicleDetection_GetLastVehicle(void);

/**
 * @brief Set loop distance (distance between loops in lane)
 * @param distance Distance in cm
 */
void VehicleDetection_SetLoopDistance(uint16_t distance);

/**
 * @brief Set loop width
 * @param width Width in cm
 */
void VehicleDetection_SetLoopWidth(uint16_t width);

/**
 * @brief Set classification thresholds
 * @param limits Array of 6 values for class boundaries
 */
void VehicleDetection_SetClassLimits(const uint16_t limits[6]);

/**
 * @brief Set speed limits
 * @param light_day Day speed limit for light vehicles (km/h)
 * @param light_night Night speed limit for light vehicles (km/h)
 * @param heavy_day Day speed limit for heavy vehicles (km/h)
 * @param heavy_night Night speed limit for heavy vehicles (km/h)
 */
void VehicleDetection_SetSpeedLimits(uint8_t light_day, uint8_t light_night,
                                     uint8_t heavy_day, uint8_t heavy_night);

/**
 * @brief Get lane state
 * @param lane_id Lane ID (0 or 1)
 * @retval Lane state
 */
LaneState_t VehicleDetection_GetLaneState(uint8_t lane_id);

/**
 * @brief Calibrate vehicle detection
 * @retval HAL status
 */
HAL_StatusTypeDef VehicleDetection_Calibrate(void);

/**
 * @brief Vehicle callback (called when new vehicle detected)
 * @note Implement this function in your application
 * @param vehicle Detected vehicle information
 */
extern void VehicleDetection_Callback(const VehicleInfo_t *vehicle);

#ifdef __cplusplus
}
#endif

#endif /* __VEHICLE_DETECTION_H */
