#include "board.h"
#include <i2c_tiny1614.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>

static volatile const unsigned char *twi_wptr;
static volatile unsigned int twi_wrest;
static volatile unsigned char *twi_rptr;
static volatile unsigned int twi_rrest;
static volatile unsigned char twi_address;
static volatile unsigned char twi_sending;
static volatile unsigned char twi_error;

ISR (TWI0_TWIM_vect)
{
  if (TWI0.MSTATUS & TWI_RXACK_bm)
  {
    twi_error = 1;
    twi_sending = 0;
    TWI0.MCTRLB = TWI_ACKACT_NACK_gc | TWI_MCMD_STOP_gc;
  }
  else if (twi_wrest)
  {
    // Send Next Character
    twi_wrest--;
    TWI0.MSTATUS |= TWI_WIF_bm | TWI_RIF_bm;
    TWI0.MDATA = *twi_wptr++;
  }
  else if (twi_address)
  { // repeated start
    TWI0.MADDR = twi_address;
    TWI0.MCTRLB |= TWI_MCMD_REPSTART_gc;
    twi_address = 0;
  }
  else if (twi_rrest)
  {
    TWI0.MSTATUS = TWI_CLKHOLD_bm | TWI_WIF_bm | TWI_RIF_bm;
    // Receive Next Character
    twi_rrest--;
    *twi_rptr++ = TWI0.MDATA;
    if (twi_rrest)
       TWI0.MCTRLB = TWI_ACKACT_ACK_gc | TWI_MCMD_RECVTRANS_gc;
    else
    {
      TWI0.MCTRLB = TWI_ACKACT_NACK_gc | TWI_MCMD_STOP_gc;
      twi_sending = 0;
    }
  }
  else
  {
    // Generate STOP Condition
    TWI0.MCTRLB = TWI_ACKACT_NACK_gc | TWI_MCMD_STOP_gc;
    twi_sending = 0;
  }
}

int
TWI_sendMessage (unsigned char address, const unsigned char *message, unsigned int length)
{
  twi_wptr    = message;
  twi_wrest   = length;
  twi_rrest   = 0;
  twi_error   = 0;
  twi_address = 0;
  twi_sending = 1;

  // Send Slave Address(Start Sending)
  TWI0.MADDR = address;

  // Wait until finished
  while (twi_sending)
    sleep_cpu();
  
  return twi_error;
}

int
TWI_transfer(unsigned char address, const unsigned char *wdata, unsigned int wlength, unsigned char *rdata, unsigned int rlength)
{
  twi_wptr    = wdata;
  twi_wrest   = wlength;
  twi_rptr    = rdata;
  twi_rrest   = rlength;
  twi_address = address | 1;
  twi_error   = 0;
  twi_sending = 1;

  // Send Slave Address(Start Sending)
  TWI0.MADDR = address;

  // Wait until finished
  while (twi_sending)
    sleep_cpu();

  return twi_error;
}

/* TWI Baud Rate Calculation
 * CLK_PER is 1 MHz
 *
 * Requested Baud Rate: f_SCL = 100 KHz
 * register parameter: BAUD = (CLK_PER - f_SCL*(10+CLK_PER*t_RISE)) / (2*f_SCL)
 *  t_RISE = 300[ns] = 3.0e-7[s]
 */
#define F_RISE 3000000L
#define TWI_PARAM_BAUD (CLK_PER / (2 * F_SCL) - (5 + CLK_PER/F_RISE/2))

void
InitI2C (void)
{
  twi_sending = twi_error = 0;
  
  I2C_PORT.DIRSET = (1 << PIN_SDA) | (1 << PIN_SCL);
  I2C_PORT.SDAPINCTRL = 8; // pullup enable
  I2C_PORT.SCLPINCTRL = 8; // pullup enable
  
  //Standard 100kHz TWI, 4 Cycle Hold, 50ns SDA Hold Time
  TWI0.CTRLA = TWI_SDAHOLD_50NS_gc;
  TWI0.MBAUD = TWI_PARAM_BAUD;
  TWI0.MCTRLA = TWI_WIEN_bm | TWI_RIEN_bm | TWI_ENABLE_bm
//      | TWI_SMEN_bm
//      | TWI_QCEN_bm
      ;
  TWI0.MSTATUS = TWI_RIF_bm | TWI_WIF_bm | TWI_CLKHOLD_bm | TWI_RXACK_bm |
                 TWI_ARBLOST_bm | TWI_BUSERR_bm | TWI_BUSSTATE_IDLE_gc;
  TWI0.DBGCTRL = 1; // runs in debut mode
}
