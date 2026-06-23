#ifndef I2C_TINY1614_H
#define I2C_TINY1614_H


void InitI2C(void);
int TWI_sendMessage (unsigned char address, const unsigned char *message, unsigned int length);
int TWI_transfer(unsigned char address, const unsigned char *wdata, unsigned int wlength, unsigned char *rdata, unsigned int rlength);


#endif
