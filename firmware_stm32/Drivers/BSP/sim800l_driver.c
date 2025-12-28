/**
 * @file    sim800l_driver.c
 * @brief   SIM800L GSM/GPRS Module Driver Implementation
 * @details AT command interface for TCP/IP communication
 */

#include "sim800l_driver.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

/* Private variables */
static UART_HandleTypeDef *sim800l_uart = NULL;
static SIM800L_Config_t sim800l_config;
static SIM800L_Status_t sim800l_status;

/* Private function prototypes */
static bool SIM800L_WaitResponse(const char *expected, uint32_t timeout_ms);
static void SIM800L_ClearBuffer(void);

/**
 * @brief Initialize SIM800L driver
 */
HAL_StatusTypeDef SIM800L_Init(UART_HandleTypeDef *huart, const SIM800L_Config_t *config)
{
    if (huart == NULL || config == NULL) {
        return HAL_ERROR;
    }

    sim800l_uart = huart;
    memcpy(&sim800l_config, config, sizeof(SIM800L_Config_t));

    // Initialize status
    memset(&sim800l_status, 0, sizeof(SIM800L_Status_t));
    sim800l_status.state = SIM800L_STATE_INIT;
    sim800l_status.signal_quality = 99; // Unknown

    // Power on module
    HAL_GPIO_WritePin(SIM800L_PWR_PORT, SIM800L_PWR_PIN, GPIO_PIN_SET);
    HAL_Delay(100);

    // Toggle PWRKEY to turn on
    HAL_GPIO_WritePin(SIM800L_PWRKEY_PORT, SIM800L_PWRKEY_PIN, GPIO_PIN_RESET);
    HAL_Delay(1000);
    HAL_GPIO_WritePin(SIM800L_PWRKEY_PORT, SIM800L_PWRKEY_PIN, GPIO_PIN_SET);
    HAL_Delay(2000);
    HAL_GPIO_WritePin(SIM800L_PWRKEY_PORT, SIM800L_PWRKEY_PIN, GPIO_PIN_RESET);

    // Wait for module to boot
    HAL_Delay(5000);

    // Test AT communication
    if (!SIM800L_SendCommand("AT", "OK", 1000)) {
        sim800l_status.state = SIM800L_STATE_ERROR;
        return HAL_ERROR;
    }

    // Disable echo
    SIM800L_SendCommand("ATE0", "OK", 1000);

    // Check SIM card
    if (!SIM800L_SendCommand("AT+CPIN?", "READY", 2000)) {
        sim800l_status.state = SIM800L_STATE_ERROR;
        return HAL_ERROR;
    }

    // Check network registration
    for (int i = 0; i < 30; i++) {
        if (SIM800L_SendCommand("AT+CREG?", "+CREG: 0,1", 1000) ||
            SIM800L_SendCommand("AT+CREG?", "+CREG: 0,5", 1000)) {
            sim800l_status.network_registered = true;
            break;
        }
        HAL_Delay(1000);
    }

    if (!sim800l_status.network_registered) {
        sim800l_status.state = SIM800L_STATE_ERROR;
        return HAL_ERROR;
    }

    // Get signal quality
    SIM800L_GetSignalQuality();

    sim800l_status.state = SIM800L_STATE_READY;
    return HAL_OK;
}

/**
 * @brief Power on SIM800L module
 */
HAL_StatusTypeDef SIM800L_PowerOn(void)
{
    HAL_GPIO_WritePin(SIM800L_PWR_PORT, SIM800L_PWR_PIN, GPIO_PIN_SET);
    HAL_Delay(100);

    HAL_GPIO_WritePin(SIM800L_PWRKEY_PORT, SIM800L_PWRKEY_PIN, GPIO_PIN_RESET);
    HAL_Delay(1000);
    HAL_GPIO_WritePin(SIM800L_PWRKEY_PORT, SIM800L_PWRKEY_PIN, GPIO_PIN_SET);
    HAL_Delay(2000);
    HAL_GPIO_WritePin(SIM800L_PWRKEY_PORT, SIM800L_PWRKEY_PIN, GPIO_PIN_RESET);

    HAL_Delay(5000);
    return HAL_OK;
}

/**
 * @brief Power off SIM800L module
 */
HAL_StatusTypeDef SIM800L_PowerOff(void)
{
    HAL_GPIO_WritePin(SIM800L_PWRKEY_PORT, SIM800L_PWRKEY_PIN, GPIO_PIN_RESET);
    HAL_Delay(1000);
    HAL_GPIO_WritePin(SIM800L_PWRKEY_PORT, SIM800L_PWRKEY_PIN, GPIO_PIN_SET);
    HAL_Delay(2500);
    HAL_GPIO_WritePin(SIM800L_PWRKEY_PORT, SIM800L_PWRKEY_PIN, GPIO_PIN_RESET);

    HAL_Delay(1000);
    HAL_GPIO_WritePin(SIM800L_PWR_PORT, SIM800L_PWR_PIN, GPIO_PIN_RESET);

    sim800l_status.state = SIM800L_STATE_OFF;
    return HAL_OK;
}

/**
 * @brief Reset SIM800L module
 */
HAL_StatusTypeDef SIM800L_Reset(void)
{
    SIM800L_PowerOff();
    HAL_Delay(1000);
    return SIM800L_PowerOn();
}

/**
 * @brief Initialize GPRS connection
 */
HAL_StatusTypeDef SIM800L_InitGPRS(void)
{
    char cmd[64];

    sim800l_status.state = SIM800L_STATE_GPRS_CONNECT;

    // Set connection type to GPRS
    if (!SIM800L_SendCommand("AT+SAPBR=3,1,\"CONTYPE\",\"GPRS\"", "OK", 2000)) {
        return HAL_ERROR;
    }

    // Set APN
    snprintf(cmd, sizeof(cmd), "AT+SAPBR=3,1,\"APN\",\"%s\"", sim800l_config.apn);
    if (!SIM800L_SendCommand(cmd, "OK", 2000)) {
        return HAL_ERROR;
    }

    // Set APN user if provided
    if (strlen(sim800l_config.apn_user) > 0) {
        snprintf(cmd, sizeof(cmd), "AT+SAPBR=3,1,\"USER\",\"%s\"", sim800l_config.apn_user);
        SIM800L_SendCommand(cmd, "OK", 2000);
    }

    // Set APN password if provided
    if (strlen(sim800l_config.apn_pass) > 0) {
        snprintf(cmd, sizeof(cmd), "AT+SAPBR=3,1,\"PWD\",\"%s\"", sim800l_config.apn_pass);
        SIM800L_SendCommand(cmd, "OK", 2000);
    }

    // Open GPRS context
    if (!SIM800L_SendCommand("AT+SAPBR=1,1", "OK", 10000)) {
        return HAL_ERROR;
    }

    // Query GPRS context
    if (!SIM800L_SendCommand("AT+SAPBR=2,1", "OK", 2000)) {
        return HAL_ERROR;
    }

    sim800l_status.state = SIM800L_STATE_GPRS_READY;
    return HAL_OK;
}

/**
 * @brief Connect to TCP server
 */
HAL_StatusTypeDef SIM800L_ConnectTCP(void)
{
    char cmd[128];

    sim800l_status.state = SIM800L_STATE_TCP_CONNECT;

    // Close any existing connection
    SIM800L_SendCommand("AT+CIPCLOSE", "OK", 2000);
    HAL_Delay(500);

    // Set single connection mode
    if (!SIM800L_SendCommand("AT+CIPMUX=0", "OK", 2000)) {
        return HAL_ERROR;
    }

    // Start TCP connection
    snprintf(cmd, sizeof(cmd), "AT+CIPSTART=\"TCP\",\"%s\",%d",
             sim800l_config.server_ip, sim800l_config.server_port);

    if (!SIM800L_SendCommand(cmd, "CONNECT OK", 10000)) {
        sim800l_status.state = SIM800L_STATE_ERROR;
        return HAL_ERROR;
    }

    sim800l_status.state = SIM800L_STATE_TCP_CONNECTED;
    return HAL_OK;
}

/**
 * @brief Disconnect TCP connection
 */
HAL_StatusTypeDef SIM800L_DisconnectTCP(void)
{
    SIM800L_SendCommand("AT+CIPCLOSE", "OK", 2000);
    sim800l_status.state = SIM800L_STATE_GPRS_READY;
    return HAL_OK;
}

/**
 * @brief Send data via TCP
 */
HAL_StatusTypeDef SIM800L_SendData(const uint8_t *data, uint16_t length)
{
    char cmd[32];

    if (sim800l_status.state != SIM800L_STATE_TCP_CONNECTED) {
        return HAL_ERROR;
    }

    // Prepare to send
    snprintf(cmd, sizeof(cmd), "AT+CIPSEND=%d", length);
    if (!SIM800L_SendCommand(cmd, ">", 5000)) {
        return HAL_ERROR;
    }

    // Send data
    HAL_UART_Transmit(sim800l_uart, (uint8_t*)data, length, 5000);

    // Wait for send confirmation
    if (!SIM800L_WaitResponse("SEND OK", 10000)) {
        return HAL_ERROR;
    }

    return HAL_OK;
}

/**
 * @brief Receive data via TCP
 */
HAL_StatusTypeDef SIM800L_ReceiveData(uint8_t *buffer, uint16_t max_length, uint16_t *received)
{
    // Simplified implementation - would need proper buffer management
    *received = 0;
    return HAL_OK;
}

/**
 * @brief Send JSON data to server
 */
HAL_StatusTypeDef SIM800L_SendJSON(const char *json_data)
{
    HAL_StatusTypeDef status;

    // Initialize GPRS if not already done
    if (sim800l_status.state < SIM800L_STATE_GPRS_READY) {
        if (SIM800L_InitGPRS() != HAL_OK) {
            return HAL_ERROR;
        }
    }

    // Connect to TCP server
    if (sim800l_status.state != SIM800L_STATE_TCP_CONNECTED) {
        if (SIM800L_ConnectTCP() != HAL_OK) {
            return HAL_ERROR;
        }
    }

    // Send JSON data
    status = SIM800L_SendData((const uint8_t*)json_data, strlen(json_data));

    // Close connection to save power
    SIM800L_DisconnectTCP();

    return status;
}

/**
 * @brief Send AT command
 */
bool SIM800L_SendCommand(const char *command, const char *expected_response, uint32_t timeout_ms)
{
    char cmd_buffer[256];

    if (sim800l_uart == NULL) {
        return false;
    }

    // Clear receive buffer
    SIM800L_ClearBuffer();

    // Send command
    snprintf(cmd_buffer, sizeof(cmd_buffer), "%s\r\n", command);
    HAL_UART_Transmit(sim800l_uart, (uint8_t*)cmd_buffer, strlen(cmd_buffer), 1000);

    // Wait for response
    return SIM800L_WaitResponse(expected_response, timeout_ms);
}

/**
 * @brief Wait for response
 */
static bool SIM800L_WaitResponse(const char *expected, uint32_t timeout_ms)
{
    uint32_t start_time = HAL_GetTick();
    uint16_t index = 0;
    uint8_t rx_byte;

    sim800l_status.response_len = 0;
    memset(sim800l_status.response, 0, sizeof(sim800l_status.response));

    while ((HAL_GetTick() - start_time) < timeout_ms) {
        if (HAL_UART_Receive(sim800l_uart, &rx_byte, 1, 10) == HAL_OK) {
            if (index < sizeof(sim800l_status.response) - 1) {
                sim800l_status.response[index++] = rx_byte;
                sim800l_status.response_len = index;

                // Check if expected response is in buffer
                if (expected != NULL && strstr(sim800l_status.response, expected) != NULL) {
                    return true;
                }
            }
        }
    }

    // If no expected response specified, check for OK
    if (expected == NULL && strstr(sim800l_status.response, "OK") != NULL) {
        return true;
    }

    return false;
}

/**
 * @brief Clear receive buffer
 */
static void SIM800L_ClearBuffer(void)
{
    uint8_t dummy;
    while (HAL_UART_Receive(sim800l_uart, &dummy, 1, 10) == HAL_OK) {
        // Flush buffer
    }
}

/**
 * @brief Check if SIM800L is ready
 */
bool SIM800L_IsReady(void)
{
    return (sim800l_status.state >= SIM800L_STATE_READY);
}

/**
 * @brief Check if TCP is connected
 */
bool SIM800L_IsConnected(void)
{
    return (sim800l_status.state == SIM800L_STATE_TCP_CONNECTED);
}

/**
 * @brief Get current state
 */
SIM800L_State_t SIM800L_GetState(void)
{
    return sim800l_status.state;
}

/**
 * @brief Get status structure
 */
const SIM800L_Status_t* SIM800L_GetStatus(void)
{
    return &sim800l_status;
}

/**
 * @brief Get signal quality
 */
uint8_t SIM800L_GetSignalQuality(void)
{
    char *ptr;

    if (SIM800L_SendCommand("AT+CSQ", "OK", 2000)) {
        // Parse response: +CSQ: <rssi>,<ber>
        ptr = strstr(sim800l_status.response, "+CSQ: ");
        if (ptr != NULL) {
            sim800l_status.signal_quality = atoi(ptr + 6);
        }
    }

    return sim800l_status.signal_quality;
}

/**
 * @brief Process incoming data
 */
void SIM800L_ProcessByte(uint8_t data)
{
    // Called from UART IRQ - store in buffer
    if (sim800l_status.response_len < sizeof(sim800l_status.response) - 1) {
        sim800l_status.response[sim800l_status.response_len++] = data;
    }
}

/**
 * @brief Process module
 */
void SIM800L_Process(void)
{
    sim800l_status.last_activity = HAL_GetTick();
}

/**
 * @brief Configure module parameters
 */
HAL_StatusTypeDef SIM800L_Configure(const SIM800L_Config_t *config)
{
    if (config == NULL) {
        return HAL_ERROR;
    }

    memcpy(&sim800l_config, config, sizeof(SIM800L_Config_t));
    return HAL_OK;
}

/**
 * @brief Enable sleep mode
 */
HAL_StatusTypeDef SIM800L_EnableSleep(void)
{
    return SIM800L_SendCommand("AT+CSCLK=1", "OK", 2000) ? HAL_OK : HAL_ERROR;
}

/**
 * @brief Disable sleep mode
 */
HAL_StatusTypeDef SIM800L_DisableSleep(void)
{
    return SIM800L_SendCommand("AT+CSCLK=0", "OK", 2000) ? HAL_OK : HAL_ERROR;
}
