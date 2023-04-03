#ifndef EEPROM_H_
#define EEPROM_H_

#define EEPROM_PAGESIZE 32

unsigned char EEPROM_ReadByte(unsigned char pageAddr, unsigned char byteAddr);


#endif /* EEPROM_H_ */