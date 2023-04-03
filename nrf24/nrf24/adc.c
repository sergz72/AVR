#include "board.h"
#include "adc.h"

unsigned int battery_voltage;

void adc_init(void)
{
  battery_voltage = 0;
}

void adc_proc(void)
{
  
}  