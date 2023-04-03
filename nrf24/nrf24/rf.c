#include "board.h"
#include "rf.h"
#include "eeprom.h"
#include <st7066.h>
#include <nrf24.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>

extern unsigned char seconds, minutes, hours, update_hours, update_minutes;
extern int temperature;
extern char humidity;
extern unsigned int battery_voltage;

/* packet format
in(13 bytes):  timestamp (64 bit) ext_temperature(16 bit) hours minutes seconds
out(13 bytes): timestamp (64 bit) temperature(16 bit) battery_voltage(16bit) humidity
*/

volatile signed char packet_received;

static const unsigned char TXADDR[] = { 0, 0, 0 };
static const unsigned char RXADDR[] = { 0, 0, 1 };

static const nrf24_config config = {
  1,
  3,
  RXADDR,
  TXADDR,
  0,
  16,
  nRF24_DR_250K,
  nRF24_TXPWR_M6dBm
};

static unsigned char aes_encodeKey[16];
static unsigned char aes_decodeKey[16];
static unsigned char timestamp[8];
static int prevTemperature = -998;

/*static signed char timestamp_compare(unsigned char *buffer)
{
  unsigned char i;
  unsigned char c1, c2;
  
  i = 8;
  buffer += 8;
  do
  {
    i--;
    //buffer = (unsigned char*)((unsigned int)buffer - 1);
    buffer--;
    c1 = timestamp[i];
    c2 = *buffer;
    if (c1 > c2)
      return -1;
    else if (c1 < c2)
      return 1;
  } while (i);
  
  return 0;
}*/

#define AES_error_flag_check	    (AES.STATUS & AES_ERROR_bm)

static unsigned char aes_encode(unsigned char *buffer)
{
  unsigned char i;
  unsigned char *p = buffer;
  
  /* Remove pending AES interrupts. */
  AES.STATUS = (AES_ERROR_bm | AES_SRIF_bm);

  AES.CTRL = 0; //reset counters
  
  /* Load key and data to AES Key memory. */
  for (i = 0; i < 16; i++)
  {
    AES.KEY = aes_encodeKey[i];
    AES.STATE = *p++;
  }

  AES.CTRL = AES_START_bm;
  
  do{
    /* Wait until AES is finished or an error occurs. */
  } while((AES.STATUS & (AES_SRIF_bm|AES_ERROR_bm) ) == 0);

  if (AES_error_flag_check)
    return 0;
  
  for(i = 0; i < 16; i++)
    *buffer++ = AES.STATE;

  return 1;
}

static unsigned char aes_decode(unsigned char *buffer)
{
  unsigned char i;
  unsigned char *p = buffer;
  
  /* Remove pending AES interrupts. */
  AES.STATUS = (AES_ERROR_bm | AES_SRIF_bm);

  AES.CTRL = 0; //reset counters
  
  /* Load key and data to AES Key memory. */
  for (i = 0; i < 16; i++)
  {
    AES.KEY = aes_decodeKey[i];
    AES.STATE = *p++;
  }

  AES.CTRL = AES_START_bm | AES_DECRYPT_bm;
  
  do{
    /* Wait until AES is finished or an error occurs. */
  } while((AES.STATUS & (AES_SRIF_bm|AES_ERROR_bm) ) == 0);

  if (AES_error_flag_check)
    return 0;
  
  for(i = 0; i < 16; i++)
    *buffer++ = AES.STATE;

  return 1;
}

void rf_init(void)
{
  unsigned char i;
  
  for (i = 0; i < 8; i++)
    timestamp[i] = 0;

  //reset counters
  AES.CTRL = 0;
  
  for (i = 0; i < 16; i++)
    aes_encodeKey[i] = EEPROM_ReadByte(0, i);
  
  //dummy encode
  aes_encode(aes_decodeKey);

  AES.CTRL = 0; //reset counters
  for (i = 0; i < 16; i++)
    aes_decodeKey[i] = AES.KEY;

  st7066_set_ddram_address(0x48);
  st7066_write_data('O');
  st7066_write_data('u');
  st7066_write_data('t');

  if (!nrf24_Check() || !nrf24_Init(&config) || !nrf24_powerControl(1) || !nrf24_RX())
  {
    st7066_write_data(' ');
    st7066_write_data('E');
    st7066_write_data('r');
    st7066_write_data('r');
    st7066_write_data(' ');
    packet_received = -1;
  }    
  else
    packet_received = 0;
}

void rf_proc(void)
{
  unsigned char nRF24_payload[33];
  signed char rc;
  int extTemperature;

  //if (packet_received > 0)
  //{
    //packet_received = 0;
    rc = nrf24_readRXFifo(nRF24_payload);
    if (rc > 0)
    {
      if (rc != 16)
      {
        nrf24_flushRX();
        return;
      }
      //decode
      rc = aes_decode(&nRF24_payload[1]);
      //checking decode correctness
      if (rc && nRF24_payload[14] == 0x55 && nRF24_payload[15] == 0xAA && nRF24_payload[16] == 0x33)// &&
//          timestamp_compare(&nRF24_payload[1]) > 0)
      {
        // timestamp update
        for (rc = 0; rc < 8; rc++)
          timestamp[rc] = nRF24_payload[rc + 1];
        extTemperature = nRF24_payload[10];
        extTemperature <<= 8;
        extTemperature |= nRF24_payload[9];
        hours = nRF24_payload[11];
        minutes = nRF24_payload[12];
        seconds = nRF24_payload[13];
        update_hours = update_minutes = 1;
        if (extTemperature != prevTemperature)
        {
          prevTemperature = extTemperature;
          st7066_set_ddram_address(0x4B);
          if (extTemperature < 0)
          {
            st7066_write_data('-');
            extTemperature = -extTemperature;
          }
          else
            st7066_write_data(' ');
          rc = extTemperature / 100;
          st7066_write_data(rc ? '0' + rc : ' ');
          rc = (extTemperature / 10) % 10;
          st7066_write_data('0' + rc);
          st7066_write_data('.');
          rc = extTemperature % 10;
          st7066_write_data('0' + rc);
        }
        //encode
        nRF24_payload[9] = temperature & 0xFF;
        nRF24_payload[10] = temperature >> 8;
        nRF24_payload[11] = battery_voltage & 0xFF;
        nRF24_payload[12] = battery_voltage >> 8;
        nRF24_payload[13] = humidity;
        rc = aes_encode(&nRF24_payload[1]);
        if (rc)
          nrf24_transmit(nRF24_payload, 16);
      }
    }
    else
      nrf24_flushRX();
  //}
}

//ISR(PORTD_INT0_vect)
//{
//  if (packet_received == 0)
//    packet_received = 1;
//}
