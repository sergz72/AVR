#ifndef __NRF24_H
#define __NRF24_H

// nRF24L0 instruction definitions
#define nRF24_CMD_W_REGISTER       0x20U // Register write
#define nRF24_CMD_R_RX_PAYLOAD     0x61U // Read RX payload
#define nRF24_CMD_W_TX_PAYLOAD     0xA0U // Write TX payload
#define nRF24_CMD_FLUSH_TX         0xE1U // Flush TX FIFO
#define nRF24_CMD_FLUSH_RX         0xE2U // Flush RX FIFO
#define nRF24_CMD_REUSE_TX_PL      0xE3U // Reuse TX payload
#define nRF24_CMD_R_RX_PL_WID      0x60U // Read RX payload width
#define nRF24_CMD_W_ACK_PAYLOAD    0x60U // Read RX payload width
#define nRF24_CMD_NOP              0xFFU // No operation (used for reading status register)

// nRF24L0 register definitions
#define nRF24_REG_CONFIG           0x00U // Configuration register
#define nRF24_REG_EN_AA            0x01U // Enable "Auto acknowledgment"
#define nRF24_REG_EN_RXADDR        0x02U // Enable RX addresses
#define nRF24_REG_SETUP_AW         0x03U // Setup of address widths
#define nRF24_REG_SETUP_RETR       0x04U // Setup of automatic retransmit
#define nRF24_REG_RF_CH            0x05U // RF channel
#define nRF24_REG_RF_SETUP         0x06U // RF setup register
#define nRF24_REG_STATUS           0x07U // Status register
#define nRF24_REG_OBSERVE_TX       0x08U // Transmit observe register
#define nRF24_REG_RPD              0x09U // Received power detector
#define nRF24_REG_RX_ADDR_P0       0x0AU // Receive address data pipe 0
#define nRF24_REG_RX_ADDR_P1       0x0BU // Receive address data pipe 1
#define nRF24_REG_RX_ADDR_P2       0x0CU // Receive address data pipe 2
#define nRF24_REG_RX_ADDR_P3       0x0DU // Receive address data pipe 3
#define nRF24_REG_RX_ADDR_P4       0x0EU // Receive address data pipe 4
#define nRF24_REG_RX_ADDR_P5       0x0FU // Receive address data pipe 5
#define nRF24_REG_TX_ADDR          0x10U // Transmit address
#define nRF24_REG_RX_PW_P0         0x11U // Number of bytes in RX payload in data pipe 0
#define nRF24_REG_RX_PW_P1         0x12U // Number of bytes in RX payload in data pipe 1
#define nRF24_REG_RX_PW_P2         0x13U // Number of bytes in RX payload in data pipe 2
#define nRF24_REG_RX_PW_P3         0x14U // Number of bytes in RX payload in data pipe 3
#define nRF24_REG_RX_PW_P4         0x15U // Number of bytes in RX payload in data pipe 4
#define nRF24_REG_RX_PW_P5         0x16U // Number of bytes in RX payload in data pipe 5
#define nRF24_REG_FIFO_STATUS      0x17U // FIFO status register
#define nRF24_REG_DYNPD            0x1CU // Enable dynamic payload length
#define nRF24_REG_FEATURE          0x1DU // Feature register

// Data rate
typedef enum {
  nRF24_DR_250K = 0x20, // 250kbps data rate
  nRF24_DR_1M   = 0x00, // 1Mbps data rate
  nRF24_DR_2M   = 0x08  // 2Mbps data rate
} nrf24_dataRate;

// RF output power in TX mode
typedef enum {
  nRF24_TXPWR_M18dBm = 0x00, // -18dBm
  nRF24_TXPWR_M12dBm = 0x02, // -12dBm
  nRF24_TXPWR_M6dBm  = 0x04, //  -6dBm
  nRF24_TXPWR_0dBm   = 0x06  //   0dBm
} nrf24_txPower;

// Enumeration of RX pipe addresses
typedef enum {
  nRF24_PIPE0  = 0x00, // pipe0
  nRF24_PIPE1  = 0x01, // pipe1
  nRF24_PIPE2  = 0x02, // pipe2
  nRF24_PIPE3  = 0x03, // pipe3
  nRF24_PIPE4  = 0x04, // pipe4
  nRF24_PIPE5  = 0x05  // pipe5
} nrf24rxPipe;

typedef struct
{
  unsigned char twoCRCBytes;
  unsigned char addressWidth;
  const unsigned char *rxAddress;
  const unsigned char *txAddress;
  unsigned char channel;
  unsigned char rxPacketSize;
  nrf24_dataRate dataRate;
  nrf24_txPower txPower;
} nrf24_config;

unsigned char nrf24_RW(unsigned char *txdata, unsigned char *rxdata, unsigned char size);
unsigned char nrf24_command(unsigned char command, unsigned char *status);
unsigned char nrf24_Check(void);
unsigned char nrf24_Init(const nrf24_config *config);
unsigned char nrf24_command(unsigned char registerNo, unsigned char *status);
unsigned char nrf24_readRegister(unsigned char registerNo, unsigned char *buffer, unsigned char dataBytes);
unsigned char nrf24_powerControl(unsigned char powerUp);
unsigned char nrf24_setAA(unsigned char enAA);
unsigned char nrf24_RX(void);
unsigned char nrf24_TX(void);
unsigned char nrf24_rXAddrControl(unsigned char enRXAddr);
unsigned char nrf24_setRetransmit(unsigned char retransmit);
unsigned char nrf24_setChannel(unsigned char channel);
unsigned char nrf24_setDataRateAndTXPower(nrf24_dataRate dataRate, nrf24_txPower txPower);
unsigned char nrf24_setTXPower(nrf24_txPower txPower);
unsigned char nrf24_clearIRQFlags(void);
unsigned char nrf24_setRXAddress(nrf24rxPipe pipe, const unsigned char *address, unsigned char addressWidth);
unsigned char nrf24_setTXAddress(const unsigned char *address, unsigned char addressWidth);
unsigned char nrf24_setDynPD(unsigned char value);
unsigned char nrf24_setFeature(unsigned char value);
unsigned char nrf24_flushTX(void);
unsigned char nrf24_flushRX(void);
unsigned char nrf24_NOP(unsigned char *status);
unsigned char nrf24_getStatus(unsigned char *status);
signed char nrf24_readRXFifo(unsigned char *buffer);
signed char nrf24_transmit(unsigned char *buffer, unsigned char length);
unsigned char nrf24_setRXPayloadLength(nrf24rxPipe pipe, unsigned char length);

#define nRF24_RX_ON(device_num)   nRF24_CE_SET(device_num)
#define nRF24_RX_OFF(device_num)  nRF24_CE_CLR(device_num)

#endif
