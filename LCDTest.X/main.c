#include "board.h"
#include <avr/sleep.h>
#include <st7066.h>

FUSES = {
	.WDTCFG = 0x00, // WDTCFG {PERIOD=OFF, WINDOW=OFF}
	.BODCFG = 0x55, // BODCFG {SLEEP=ENABLED, ACTIVE=ENABLED, SAMPFREQ=125HZ, LVL=BODLEVEL2} 2.6v
	.OSCCFG = 0x02, // OSCCFG {FREQSEL=20MHZ, OSCLOCK=CLEAR}
	.TCD0CFG = 0x00, // TCD0CFG {CMPA=CLEAR, CMPB=CLEAR, CMPC=CLEAR, CMPD=CLEAR, CMPAEN=CLEAR, CMPBEN=CLEAR, CMPCEN=CLEAR, CMPDEN=CLEAR}
	.SYSCFG0 = 0xF6, // SYSCFG0 {EESAVE=CLEAR, RSTPINCFG=UPDI, CRCSRC=NOCRC}
	.SYSCFG1 = 0x07, // SYSCFG1 {SUT=64MS}
	.APPEND = 0x00, // APPEND {APPEND=User range:  0x0 - 0xFF}
	.BOOTEND = 0x00, // BOOTEND {BOOTEND=User range:  0x0 - 0xFF}
};

LOCKBITS = 0xC5; // {LB=NOLOCK}

int main(void)
{
    HALInit();
    
    
    st7066_init(2, ST7066_ENTRY_MODE_ADDRESS_INCREMENT);
    st7066_display_control(ST7066_DISPLAY_ON);
    st7066_clear_display(1);
    st7066_set_ddram_address(0);
    st7066_write_data('H');
    st7066_write_data('e');
    st7066_write_data('l');
    st7066_write_data('l');
    st7066_write_data('o');
    st7066_set_ddram_address(0x40);
    st7066_write_data('W');
    st7066_write_data('o');
    st7066_write_data('r');
    st7066_write_data('l');
    st7066_write_data('d');
    
    while (1)
    {
        /*delayms(500);
        ST7066_RS_SET;
        delayms(500);
        ST7066_RS_CLR;*/
        sleep_cpu();
    }
}
