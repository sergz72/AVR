#include <nrf24.h>
#include <board.h>
#include <string.h>

unsigned char nrf24_configByte;
nrf24_dataRate nrf24_dataRateByte;
unsigned char txData[33];
unsigned char rxData[33];

// Fake address to test transceiver presence (5 bytes long)
const unsigned char *nRF24_TEST_ADDR = "nRF24";

unsigned char nrf24_readRegister(unsigned char registerNo, unsigned char *buffer, unsigned char dataBytes)
{
  txData[0] = registerNo;
  return nrf24_RW(txData, buffer, dataBytes+1);
}

unsigned char nrf24_command(unsigned char registerNo, unsigned char *status)
{
  return nrf24_RW(&registerNo, status, 1);
}

static unsigned char nrf24_initConfigRegister(unsigned char twoCRCBytes)
{
  unsigned char rc;
  unsigned char localTxData[2];
  unsigned char config;

  config = nrf24_configByte = 0x38U;

  if (twoCRCBytes)
    config |= 4U;

  localTxData[0] = nRF24_REG_CONFIG | nRF24_CMD_W_REGISTER;
  localTxData[1] = config;
  rc = nrf24_RW(localTxData, rxData, 2);
  if (rc)
    nrf24_configByte = config;
  return rc;
}

static unsigned char nrf24_setAddressWidth(unsigned char width)
{
  unsigned char localTxData[2];
  if (width < 3 || width > 5)
    return 0;
  localTxData[0] = nRF24_REG_SETUP_AW | nRF24_CMD_W_REGISTER;
  localTxData[1] = width - 2;
  return nrf24_RW(localTxData, rxData, 2);
}

unsigned char nrf24_Init(const nrf24_config *config)
{
  unsigned char rc;

  memset(txData, 0xFF, sizeof(txData));

  rc = nrf24_initConfigRegister(config->twoCRCBytes);
  if (!rc)
    return 0;
  // no AutoAck
  rc = nrf24_setAA(0);
  if (!rc)
    return 0;
  //only pipe 1
  rc = nrf24_rXAddrControl(2);
  if (!rc)
    return 0;
  rc = nrf24_setAddressWidth(config->addressWidth);
  if (!rc)
    return 0;
  // no retransmit
  rc = nrf24_setRetransmit(0);
  if (!rc)
    return 0;
  rc = nrf24_setChannel(config->channel);
  if (!rc)
    return 0;
  rc = nrf24_setDataRateAndTXPower(config->dataRate, config->txPower);
  if (!rc)
    return 0;
  rc = nrf24_clearIRQFlags();
  if (!rc)
    return 0;
  rc = nrf24_setRXAddress(nRF24_PIPE1, config->rxAddress, config->addressWidth);
  if (!rc)
    return 0;
  rc = nrf24_setTXAddress(config->txAddress, config->addressWidth);
  if (!rc)
    return 0;
  rc = nrf24_setRXPayloadLength(nRF24_PIPE0, 0);
  if (!rc)
    return 0;
  rc = nrf24_setRXPayloadLength(nRF24_PIPE1, config->rxPacketSize);
  if (!rc)
    return 0;
  rc = nrf24_setRXPayloadLength(nRF24_PIPE2, 0);
  if (!rc)
    return 0;
  rc = nrf24_setRXPayloadLength(nRF24_PIPE3, 0);
  if (!rc)
    return 0;
  rc = nrf24_setRXPayloadLength(nRF24_PIPE4, 0);
  if (!rc)
    return 0;
  rc = nrf24_setRXPayloadLength(nRF24_PIPE5, 0);
  if (!rc)
    return 0;
  rc = nrf24_setDynPD(0);
  if (!rc)
    return 0;
  rc = nrf24_setFeature(0);
  if (!rc)
    return 0;
  rc = nrf24_flushTX();
  if (!rc)
    return 0;
  return nrf24_flushRX();
}

unsigned char nrf24_powerControl(unsigned char powerUp)
{
  unsigned char localTxData[2];
  unsigned char config = nrf24_configByte;
  unsigned char rc;

  if (powerUp)
    config |= 2U;
  else
    config &= 0xFDU;

  localTxData[0] = nRF24_REG_CONFIG | nRF24_CMD_W_REGISTER;
  localTxData[1] = config;
  rc = nrf24_RW(localTxData, rxData, 2);
  if (rc)
  {
    nrf24_configByte = config;
    if (powerUp)
      delayms(2);
    else
      nRF24_CE_CLR;
  }
  return rc;
}

unsigned char nrf24_setAA(unsigned char enAA)
{
  unsigned char localTxData[2];
  localTxData[0] = nRF24_REG_EN_AA | nRF24_CMD_W_REGISTER;
  localTxData[1] = enAA & 0x3FU;
  return nrf24_RW(localTxData, rxData, 2);
}

unsigned char nrf24_RX(void)
{
  unsigned char localTxData[2];
  unsigned char config = nrf24_configByte;
  unsigned char rc;

  config |= 1U;

  localTxData[0] = nRF24_REG_CONFIG | nRF24_CMD_W_REGISTER;
  localTxData[1] = config;
  rc = nrf24_RW(localTxData, rxData, 2);
  if (rc)
  {
    nrf24_configByte = config;
    nRF24_CE_SET;
  }
  return rc;
}

unsigned char nrf24_TX(void)
{
  unsigned char localTxData[2];
  unsigned char config = nrf24_configByte;
  unsigned char rc;

  config &= 0xFEU;

  localTxData[0] = nRF24_REG_CONFIG | nRF24_CMD_W_REGISTER;
  localTxData[1] = config;
  rc = nrf24_RW(localTxData, rxData, 2);
  if (rc)
    nrf24_configByte = config;
  return rc;
}

unsigned char nrf24_rXAddrControl(unsigned char enRXAddr)
{
  unsigned char localTxData[2];
  localTxData[0] = nRF24_REG_EN_RXADDR | nRF24_CMD_W_REGISTER;
  localTxData[1] = enRXAddr & 0x3FU;
  return nrf24_RW(localTxData, rxData, 2);
}

unsigned char nrf24_setRetransmit(unsigned char retransmit)
{
  unsigned char localTxData[2];
  localTxData[0] = nRF24_REG_SETUP_RETR | nRF24_CMD_W_REGISTER;
  localTxData[1] = retransmit;
  return nrf24_RW(localTxData, rxData, 2);
}

unsigned char nrf24_setChannel(unsigned char channel)
{
  unsigned char localTxData[2];

  if (channel > 125)
    return 0;

  localTxData[0] = nRF24_REG_RF_CH | nRF24_CMD_W_REGISTER;
  localTxData[1] = channel;
  return nrf24_RW(localTxData, rxData, 2);
}

unsigned char nrf24_setDataRateAndTXPower(nrf24_dataRate dataRate, nrf24_txPower txPower)
{
  unsigned char localTxData[2];

  nrf24_dataRateByte = dataRate;
  localTxData[0] = nRF24_REG_RF_SETUP | nRF24_CMD_W_REGISTER;
  localTxData[1] = dataRate | txPower;
  return nrf24_RW(localTxData, rxData, 2);
}

unsigned char nrf24_setTXPower(nrf24_txPower txPower)
{
  unsigned char localTxData[2];
  localTxData[0] = nRF24_REG_RF_SETUP | nRF24_CMD_W_REGISTER;
  localTxData[1] = nrf24_dataRateByte | txPower;
  return nrf24_RW(localTxData, rxData, 2);
}

unsigned char nrf24_clearIRQFlags(void)
{
  unsigned char localTxData[2];
  localTxData[0] = nRF24_REG_STATUS | nRF24_CMD_W_REGISTER;
  localTxData[1] = 0x70U;
  return nrf24_RW(localTxData, rxData, 2);
}

unsigned char nrf24_setRXAddress(nrf24rxPipe pipe, const unsigned char *address, unsigned char addressWidth)
{
  unsigned char i;
  unsigned char localTxData[6];

  if ((pipe <= nRF24_PIPE1 && (addressWidth < 3 || addressWidth > 5)) || (pipe > nRF24_PIPE1 && addressWidth > 1))
    return 0;
  localTxData[0] = (nRF24_REG_RX_ADDR_P0 + pipe) | nRF24_CMD_W_REGISTER;
  for (i = 1; i <= addressWidth; i++)
    localTxData[i] = *address++;
  return nrf24_RW(localTxData, rxData, addressWidth + 1);
}

unsigned char nrf24_setRXPayloadLength(nrf24rxPipe pipe, unsigned char length)
{
  unsigned char localTxData[2];

  if (length > 32)
    return 0;

  localTxData[0] = (nRF24_REG_RX_PW_P0 + pipe) | nRF24_CMD_W_REGISTER;
  localTxData[1] = length;
  return nrf24_RW(localTxData, rxData, 2);
}

unsigned char nrf24_setTXAddress(const unsigned char *address, unsigned char addressWidth)
{
  unsigned char i;
  unsigned char localTxData[6];

  if (addressWidth < 3 || addressWidth > 5)
    return 0;
  localTxData[0] = nRF24_REG_TX_ADDR | nRF24_CMD_W_REGISTER;
  for (i = 1; i <= addressWidth; i++)
    localTxData[i] = *address++;
  return nrf24_RW(localTxData, rxData, addressWidth + 1);
}

unsigned char nrf24_setDynPD(unsigned char value)
{
  unsigned char localTxData[2];
  localTxData[0] = nRF24_REG_DYNPD | nRF24_CMD_W_REGISTER;
  localTxData[1] = value & 0x3FU;
  return nrf24_RW(localTxData, rxData, 2);
}

unsigned char nrf24_setFeature(unsigned char value)
{
  unsigned char localTxData[2];
  localTxData[0] = nRF24_REG_FEATURE | nRF24_CMD_W_REGISTER;
  localTxData[1] = value;
  return nrf24_RW(localTxData, rxData, 2);
}

unsigned char nrf24_flushTX(void)
{
  unsigned char status;
  return nrf24_command(nRF24_CMD_FLUSH_TX, &status);
}

unsigned char nrf24_flushRX(void)
{
  unsigned char status;
  return nrf24_command(nRF24_CMD_FLUSH_RX, &status);
}

unsigned char nrf24_NOP(unsigned char *status)
{
  return nrf24_command(nRF24_CMD_NOP, status);
}

unsigned char nrf24_getStatus(unsigned char *status)
{
  unsigned char rc = nrf24_readRegister(nRF24_REG_STATUS, rxData, 1);
  if (!rc)
    return 0;
  *status = rxData[1];
  return rc;
}

signed char nrf24_readRXFifo(unsigned char *buffer)
{
  unsigned char status;
  unsigned char rc = nrf24_getStatus(&status);
  if (!rc)
    return 0;

  status = (status & 0x0EU) >> 1U;
  if (status > 5)
    return -1; // no data
  rc = nrf24_readRegister(nRF24_REG_RX_PW_P0 + status, rxData, 1);
  if (!rc)
    return 0;
  status = rxData[1];
  if (!status)
    return -2; //zero length response
  rc = nrf24_readRegister(nRF24_CMD_R_RX_PAYLOAD, buffer, status);
  if (!rc)
    return 0;
  return status; // number of received bytes
}

static unsigned char nrf24_writeTXFifo(unsigned char *buffer, unsigned char length)
{
  if (length > 32)
    return 0;
  buffer[0] = nRF24_CMD_W_TX_PAYLOAD;
  return nrf24_RW(buffer, rxData, length + 1);
}

static void nrf24_transmitCleanup(void)
{
  nRF24_CE_CLR;
  nrf24_clearIRQFlags();
  nrf24_RX();
}

signed char nrf24_transmit(unsigned char *buffer, unsigned char length)
{
  unsigned char rc;
  unsigned char counter;
  unsigned char status;

  nRF24_CE_CLR;
  rc = nrf24_TX();
  if (!rc)
    return 0;
  rc = nrf24_writeTXFifo(buffer, length);
  if (!rc)
    return 0;
  nRF24_CE_SET;
  counter = 200U; // 20 ms timeout
  while (--counter)
  {
    delay(100);
    rc = nrf24_getStatus(&status);
    if (!rc)
    {
      nrf24_transmitCleanup();
      nrf24_flushTX();
      return 0;
    }
    if (status & 0x10U) //MAX_RT
    {
      nrf24_transmitCleanup();
      nrf24_flushTX();
      return -1;
    }
    if (status & 0x20U) //TX_DS
      break;
  }
  nrf24_transmitCleanup();
  if (!counter) { // timeout
    nrf24_flushTX();
    return -2;
  }

  return 1;
}

// Check if the nRF24L01 present
// return:
//   1 - nRF24L01 is online and responding
//   0 - received sequence differs from original
unsigned char nrf24_Check(void)
{
  unsigned char i;
  unsigned char *ptr = nRF24_TEST_ADDR;
  unsigned char rc = nrf24_setTXAddress(ptr, 5);

  if (!rc)
    return 0;

  rc = nrf24_readRegister(nRF24_REG_TX_ADDR, rxData, 5);
  if (!rc)
    return 0;

  // Compare buffers, return error on first mismatch
  for (i = 1; i <= 5; i++)
  {
    if (rxData[i] != *ptr++)
      return 0;
  }

  return 1;
}
