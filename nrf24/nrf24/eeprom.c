#include "board.h"

#define EEPROM_PAGESIZE 32

#define NVM_EXEC()	asm("push r30"      "\n\t"	\
"push r31"      "\n\t"	\
"push r16"      "\n\t"	\
"push r18"      "\n\t"	\
"ldi r30, 0xCB" "\n\t"	\
"ldi r31, 0x01" "\n\t"	\
"ldi r16, 0xD8" "\n\t"	\
"ldi r18, 0x01" "\n\t"	\
"out 0x34, r16" "\n\t"	\
"st Z, r18"	    "\n\t"	\
"pop r18"       "\n\t"	\
"pop r16"       "\n\t"	\
"pop r31"       "\n\t"	\
"pop r30"       "\n\t"	\
)

static void EEPROM_WaitForNVM( void )
{
  do {
    /* Block execution while waiting for the NVM to be ready. */
  } while ((NVM.STATUS & NVM_NVMBUSY_bm) == NVM_NVMBUSY_bm);
}

unsigned char EEPROM_ReadByte( unsigned char pageAddr, unsigned char byteAddr )
{
  /* Wait until NVM is not busy. */
  EEPROM_WaitForNVM();

  /* Calculate address */
  unsigned int address = (unsigned int)(pageAddr*EEPROM_PAGESIZE)
  |(byteAddr & (EEPROM_PAGESIZE-1));

  /* Set address to read from. */
  NVM.ADDR0 = address & 0xFF;
  NVM.ADDR1 = (address >> 8) & 0x1F;
  NVM.ADDR2 = 0x00;

  /* Issue EEPROM Read command. */
  NVM.CMD = NVM_CMD_READ_EEPROM_gc;
  NVM_EXEC();

  return NVM.DATA0;
}
