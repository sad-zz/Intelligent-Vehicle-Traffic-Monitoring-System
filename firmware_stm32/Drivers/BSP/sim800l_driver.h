/**
 * @file    sim800l_driver.h
 * @brief   SIM800L GSM/GPRS Module Driver
 * @details AT command interface for TCP/IP communication
 */

#ifndef __SIM800L_DRIVER_H
#define __SIM800L_DRIVER_H

#ifdef __cplusplus
extern "C" {
#endif

#include "stm32f4xx_hal.h"
#include "config.h"
#include <stdbool.h>

/* ==================== Type Definitions ==================== */

/**
 * @brief SIM800L connection state
 */
typedef enum {
    SIM800L_STATE_OFF = 0,
    SIM800L_STATE_INIT,
    SIM800L_STATE_READY,
    SIM800L_STATE_GPRS_CONNECT,
    SIM800L_STATE_GPRS_READY,
    SIM800L_STATE_TCP_CONNECT,
    SIM800L_STATE_TCP_CONNECTED,
    SIM800L_STATE_ERROR
} SIM800L_State_t;

/**
 * @brief SIM800L configuration
 */
typedef struct {
    char apn[32];
    char apn_user[32];
    char apn_pass[32];
    char server_ip[16];
    uint16_t server_port;
    uint32_t timeout_ms;
} SIM800L_Config_t;

/**
 * @brief SIM800L status
 */
typedef struct {
    SIM800L_State_t state;
    bool network_registered;
    uint8_t signal_quality;     // 0-31, 99=unknown
    uint16_t error_count;
    uint32_t last_activity;
    char response[256];
    uint16_t response_len;
} SIM800L_Status_t;

/* ==================== Function Prototypes ==================== */

/**
 * @brief Initialize SIM800L driver
 * @param huart UART handle for communication
 * @param config Configuration structure
 * @retval HAL status
 */
HAL_StatusTypeDef SIM800L_Init(UART_HandleTypeDef *huart, const SIM800L_Config_t *config);

/**
 * @brief Power on SIM800L module
 * @retval HAL status
 */
HAL_StatusTypeDef SIM800L_PowerOn(void);

/**
 * @brief Power off SIM800L module
 * @retval HAL status
 */
HAL_StatusTypeDef SIM800L_PowerOff(void);

/**
 * @brief Reset SIM800L module
 * @retval HAL status
 */
HAL_StatusTypeDef SIM800L_Reset(void);

/**
 * @brief Initialize GPRS connection
 * @retval HAL status
 */
HAL_StatusTypeDef SIM800L_InitGPRS(void);

/**
 * @brief Connect to TCP server
 * @retval HAL status
 */
HAL_StatusTypeDef SIM800L_ConnectTCP(void);

/**
 * @brief Disconnect TCP connection
 * @retval HAL status
 */
HAL_StatusTypeDef SIM800L_DisconnectTCP(void);

/**
 * @brief Send data via TCP
 * @param data Data buffer to send
 * @param length Data length
 * @retval HAL status
 */
HAL_StatusTypeDef SIM800L_SendData(const uint8_t *data, uint16_t length);

/**
 * @brief Receive data via TCP
 * @param buffer Buffer to store received data
 * @param max_length Maximum buffer length
 * @param received Actual received length
 * @retval HAL status
 */
HAL_StatusTypeDef SIM800L_ReceiveData(uint8_t *buffer, uint16_t max_length, uint16_t *received);

/**
 * @brief Send AT command
 * @param command AT command string
 * @param expected_response Expected response string (NULL for any OK)
 * @param timeout_ms Timeout in milliseconds
 * @retval true if successful, false otherwise
 */
bool SIM800L_SendCommand(const char *command, const char *expected_response, uint32_t timeout_ms);

/**
 * @brief Check if SIM800L is ready
 * @retval true if ready, false otherwise
 */
bool SIM800L_IsReady(void);

/**
 * @brief Check if TCP is connected
 * @retval true if connected, false otherwise
 */
bool SIM800L_IsConnected(void);

/**
 * @brief Get current state
 * @retval Current state
 */
SIM800L_State_t SIM800L_GetState(void);

/**
 * @brief Get status structure
 * @retval Pointer to status structure
 */
const SIM800L_Status_t* SIM800L_GetStatus(void);

/**
 * @brief Get signal quality
 * @retval Signal quality (0-31, 99=unknown)
 */
uint8_t SIM800L_GetSignalQuality(void);

/**
 * @brief Process incoming data (call from UART IRQ)
 * @param data Received byte
 */
void SIM800L_ProcessByte(uint8_t data);

/**
 * @brief Process module (call periodically from main loop)
 */
void SIM800L_Process(void);

/**
 * @brief Send JSON data to server
 * @param json_data JSON string
 * @retval HAL status
 */
HAL_StatusTypeDef SIM800L_SendJSON(const char *json_data);

/**
 * @brief Configure module parameters
 * @param config New configuration
 * @retval HAL status
 */
HAL_StatusTypeDef SIM800L_Configure(const SIM800L_Config_t *config);

/**
 * @brief Enable sleep mode for power saving
 * @retval HAL status
 */
HAL_StatusTypeDef SIM800L_EnableSleep(void);

/**
 * @brief Disable sleep mode
 * @retval HAL status
 */
HAL_StatusTypeDef SIM800L_DisableSleep(void);

#ifdef __cplusplus
}
#endif

#endif /* __SIM800L_DRIVER_H */
