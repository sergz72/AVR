#include "board.h"
#include "controller.h"
#include "ui.h"
#include <avr/interrupt.h>

int main()
{
  SystemInit();

  sei();
  
  controller_init();
  UI_Init();

  while (1)
  {
      delayms(TIMER_DELAY);
      //LED_PORT.OUTTGL = 1 << LED_PIN;

    signed char keyboard_status = get_keyboard_status();
    unsigned int v = get_voltage();
    int current = update_current(v);
    Process_Timer_Event(keyboard_status, v, get_current());
  }
}
