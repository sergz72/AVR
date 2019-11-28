#include "board.h"
#include <avr/sleep.h>
#include <st7066.h>
#include <avr/interrupt.h>
#include <avr/wdt.h>
#include "hal.h"
#include "clock.h"
#include "sensor.h"
#include "rf.h"
#include "adc.h"

extern volatile unsigned char update_clock;
extern volatile signed char packet_received;

int main(void)
{
  HALInit();
  
  st7066_init(2, ST7066_ENTRY_MODE_ADDRESS_INCREMENT);
  st7066_display_control(ST7066_DISPLAY_ON);

  clock_init();
  sensor_init();
  rf_init();
  adc_init();
    
  sleep_enable();
  set_sleep_mode(SLEEP_MODE_IDLE);
  
  sei();

  while (1) 
  {
    if (clock_proc())
    {
      sensor_proc();
      adc_proc();
    }      
    rf_proc();
    //if (!update_clock && packet_received <= 0)
    //  sleep_cpu();
    wdt_reset();
  }
}
