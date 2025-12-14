/**
 * @file    vehicle_detection.c
 * @brief   Vehicle Detection and Classification System Implementation
 * @details Analyzes sensor data to detect, classify and measure vehicles
 */

#include "vehicle_detection.h"
#include "sensor_driver.h"
#include <string.h>

/* Private variables */
static LaneDetection_t lane_data[NUM_LANES];
static IntervalStats_t interval_stats;
static VehicleInfo_t last_vehicle;
static uint16_t loop_distance = DEFAULT_LOOP_DISTANCE;
static uint16_t loop_width = DEFAULT_LOOP_WIDTH;
static uint16_t class_limits[6] = {LIMIT_X, LIMIT_A, LIMIT_B, LIMIT_C, LIMIT_D, LIMIT_E};
static uint8_t speed_limits[4] = {SPEED_LIMIT_DAY_LIGHT, SPEED_LIMIT_NIGHT_LIGHT,
                                   SPEED_LIMIT_DAY_HEAVY, SPEED_LIMIT_NIGHT_HEAVY};

/* Private function prototypes */
static void ProcessLane(uint8_t lane_id);
static VehicleClass_t ClassifyVehicle(uint16_t length);
static void UpdateStatistics(uint8_t lane_id, const VehicleInfo_t *vehicle);
static void ResetLane(uint8_t lane_id);

/**
 * @brief Initialize vehicle detection system
 */
HAL_StatusTypeDef VehicleDetection_Init(void)
{
    // Reset lane data
    memset(lane_data, 0, sizeof(lane_data));

    // Reset statistics
    memset(&interval_stats, 0, sizeof(interval_stats));
    interval_stats.interval_start = HAL_GetTick();

    // Reset last vehicle
    memset(&last_vehicle, 0, sizeof(last_vehicle));

    return HAL_OK;
}

/**
 * @brief Process sensor data for vehicle detection
 */
void VehicleDetection_Process(void)
{
    // Process both lanes
    ProcessLane(0);
    ProcessLane(1);
}

/**
 * @brief Process lane detection
 */
static void ProcessLane(uint8_t lane_id)
{
    if (lane_id >= NUM_LANES) {
        return;
    }

    LaneDetection_t *lane = &lane_data[lane_id];
    uint8_t loop1_id = lane_id * 2;      // First loop of lane
    uint8_t loop2_id = lane_id * 2 + 1;  // Second loop of lane

    int32_t loop1_deviation = Sensor_GetDeviation(loop1_id);
    int32_t loop2_deviation = Sensor_GetDeviation(loop2_id);

    bool loop1_active = (loop1_deviation > MARGIN_TOP);
    bool loop2_active = (loop2_deviation > MARGIN_TOP);

    uint32_t current_time = HAL_GetTick();

    switch (lane->state) {
        case LANE_STATE_IDLE:
            if (loop1_active) {
                lane->T1 = current_time;
                lane->state = LANE_STATE_FIRST_LOOP_ENTER;
                lane->direction = DIR_FORWARD;  // 1->2
            } else if (loop2_active) {
                lane->T1 = current_time;
                lane->state = LANE_STATE_FIRST_LOOP_ENTER;
                lane->direction = DIR_BACKWARD;  // 2->1
            }
            break;

        case LANE_STATE_FIRST_LOOP_ENTER:
            if (lane->direction == DIR_FORWARD && !loop1_active) {
                lane->T2 = current_time;
                lane->state = LANE_STATE_FIRST_LOOP_EXIT;
            } else if (lane->direction == DIR_BACKWARD && !loop2_active) {
                lane->T2 = current_time;
                lane->state = LANE_STATE_FIRST_LOOP_EXIT;
            }
            break;

        case LANE_STATE_FIRST_LOOP_EXIT:
            if (lane->direction == DIR_FORWARD && loop2_active) {
                lane->T3 = current_time;
                lane->state = LANE_STATE_SECOND_LOOP_ENTER;
            } else if (lane->direction == DIR_BACKWARD && loop1_active) {
                lane->T3 = current_time;
                lane->state = LANE_STATE_SECOND_LOOP_ENTER;
            }

            // Timeout check
            if ((current_time - lane->T2) > 5000) {
                ResetLane(lane_id);
            }
            break;

        case LANE_STATE_SECOND_LOOP_ENTER:
            if (lane->direction == DIR_FORWARD && !loop2_active) {
                lane->T4 = current_time;
                lane->state = LANE_STATE_COMPLETE;
            } else if (lane->direction == DIR_BACKWARD && !loop1_active) {
                lane->T4 = current_time;
                lane->state = LANE_STATE_COMPLETE;
            }
            break;

        case LANE_STATE_COMPLETE:
            {
                // Calculate vehicle parameters
                VehicleInfo_t vehicle;
                memset(&vehicle, 0, sizeof(vehicle));

                vehicle.lane_id = lane_id;
                vehicle.direction = lane->direction;
                vehicle.timestamp = lane->T1;

                // Calculate time intervals
                uint32_t occupancy1 = lane->T2 - lane->T1;  // Time on first loop
                uint32_t gap_time = lane->T3 - lane->T2;    // Time between loops
                uint32_t occupancy2 = lane->T4 - lane->T3;  // Time on second loop

                // Calculate average time between loops
                uint32_t avg_time = (lane->T3 + lane->T4) / 2 - (lane->T1 + lane->T2) / 2;

                // Calculate speed (km/h) = distance (cm) / time (ms) * 36
                // distance in cm, time in ms: speed = distance / time * 0.036
                if (avg_time > 0) {
                    vehicle.speed = (loop_distance * 36) / avg_time;  // km/h
                } else {
                    vehicle.speed = 0;
                }

                // Calculate vehicle length (cm) = speed * occupancy_time
                // length (cm) = speed (km/h) * occupancy_time (ms) / 36
                uint32_t avg_occupancy = (occupancy1 + occupancy2) / 2;
                if (vehicle.speed > 0) {
                    vehicle.length = (vehicle.speed * avg_occupancy) / 36;
                } else {
                    vehicle.length = 0;
                }

                // Classify vehicle based on length
                vehicle.class = ClassifyVehicle(vehicle.length);

                // Check for violations
                vehicle.speed_violation = (vehicle.speed > speed_limits[0]);  // Day light limit
                vehicle.wrong_direction = false;  // Would need directional configuration
                vehicle.short_headway = (lane->last_gap < 1000);  // Less than 1 second

                // Update statistics
                UpdateStatistics(lane_id, &vehicle);

                // Store as last vehicle
                memcpy(&last_vehicle, &vehicle, sizeof(vehicle));

                // Call user callback
                VehicleDetection_Callback(&vehicle);

                // Update gap timer
                lane->last_gap = current_time - lane->T4;

                // Reset lane
                ResetLane(lane_id);
            }
            break;
    }
}

/**
 * @brief Classify vehicle based on length
 */
static VehicleClass_t ClassifyVehicle(uint16_t length)
{
    if (length < class_limits[0]) {
        return VEHICLE_CLASS_X;  // Motorcycle
    } else if (length < class_limits[1]) {
        return VEHICLE_CLASS_A;  // Car
    } else if (length < class_limits[2]) {
        return VEHICLE_CLASS_B;  // Van
    } else if (length < class_limits[3]) {
        return VEHICLE_CLASS_C;  // Bus
    } else if (length < class_limits[4]) {
        return VEHICLE_CLASS_D;  // Heavy truck
    } else {
        return VEHICLE_CLASS_E;  // Trailer
    }
}

/**
 * @brief Update statistics
 */
static void UpdateStatistics(uint8_t lane_id, const VehicleInfo_t *vehicle)
{
    if (lane_id >= NUM_LANES || vehicle == NULL) {
        return;
    }

    LaneStats_t *lane_stats = &interval_stats.lane[lane_id];
    ClassStats_t *class_stats = NULL;

    // Select class statistics
    switch (vehicle->class) {
        case VEHICLE_CLASS_X:
            class_stats = &lane_stats->class_X;
            break;
        case VEHICLE_CLASS_A:
            class_stats = &lane_stats->class_A;
            break;
        case VEHICLE_CLASS_B:
            class_stats = &lane_stats->class_B;
            break;
        case VEHICLE_CLASS_C:
            class_stats = &lane_stats->class_C;
            break;
        case VEHICLE_CLASS_D:
            class_stats = &lane_stats->class_D;
            break;
        case VEHICLE_CLASS_E:
            class_stats = &lane_stats->class_E;
            break;
        default:
            return;
    }

    // Update class statistics
    class_stats->count++;
    class_stats->total_speed += vehicle->speed;
    class_stats->avg_speed = class_stats->total_speed / class_stats->count;

    if (vehicle->speed_violation) {
        class_stats->speed_violations++;
    }
    if (vehicle->wrong_direction) {
        class_stats->wrong_direction++;
    }
    if (vehicle->short_headway) {
        class_stats->short_headway++;
    }

    // Update lane total
    lane_stats->total_vehicles++;

    // Update interval total
    interval_stats.total_vehicles++;
}

/**
 * @brief Reset lane detection state
 */
static void ResetLane(uint8_t lane_id)
{
    if (lane_id >= NUM_LANES) {
        return;
    }

    lane_data[lane_id].state = LANE_STATE_IDLE;
    lane_data[lane_id].T1 = 0;
    lane_data[lane_id].T2 = 0;
    lane_data[lane_id].T3 = 0;
    lane_data[lane_id].T4 = 0;
}

/**
 * @brief Reset interval statistics
 */
void VehicleDetection_ResetInterval(void)
{
    interval_stats.interval_end = HAL_GetTick();

    // Clear statistics but keep interval timestamps
    uint32_t start = interval_stats.interval_start;
    uint32_t end = interval_stats.interval_end;

    memset(&interval_stats, 0, sizeof(interval_stats));

    interval_stats.interval_start = end;  // New interval starts when old one ends
}

/**
 * @brief Get current interval statistics
 */
const IntervalStats_t* VehicleDetection_GetIntervalStats(void)
{
    return &interval_stats;
}

/**
 * @brief Get last detected vehicle
 */
const VehicleInfo_t* VehicleDetection_GetLastVehicle(void)
{
    return &last_vehicle;
}

/**
 * @brief Set loop distance
 */
void VehicleDetection_SetLoopDistance(uint16_t distance)
{
    loop_distance = distance;
}

/**
 * @brief Set loop width
 */
void VehicleDetection_SetLoopWidth(uint16_t width)
{
    loop_width = width;
}

/**
 * @brief Set classification thresholds
 */
void VehicleDetection_SetClassLimits(const uint16_t limits[6])
{
    memcpy(class_limits, limits, sizeof(class_limits));
}

/**
 * @brief Set speed limits
 */
void VehicleDetection_SetSpeedLimits(uint8_t light_day, uint8_t light_night,
                                     uint8_t heavy_day, uint8_t heavy_night)
{
    speed_limits[0] = light_day;
    speed_limits[1] = light_night;
    speed_limits[2] = heavy_day;
    speed_limits[3] = heavy_night;
}

/**
 * @brief Get lane state
 */
LaneState_t VehicleDetection_GetLaneState(uint8_t lane_id)
{
    if (lane_id >= NUM_LANES) {
        return LANE_STATE_IDLE;
    }

    return lane_data[lane_id].state;
}

/**
 * @brief Calibrate vehicle detection
 */
HAL_StatusTypeDef VehicleDetection_Calibrate(void)
{
    // Reset all lane states
    for (uint8_t i = 0; i < NUM_LANES; i++) {
        ResetLane(i);
    }

    // Calibrate sensors
    return Sensor_Calibrate();
}

/**
 * @brief Vehicle callback - weak implementation
 * @note User should implement this in their application
 */
__weak void VehicleDetection_Callback(const VehicleInfo_t *vehicle)
{
    // Default implementation does nothing
    // User should override this in main.c
    (void)vehicle;
}
