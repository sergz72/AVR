#ifndef _BOARD_H
#define _BOARD_H

#define OSC20M_FREQUENCY 16000000L
#define CLK_PER 1000000L

#define F_SCL           100000L
#define TWI_BUFFER_SIZE 16
#define I2C_PORT        PORTB
#define PIN_SDA         1
#define PIN_SCL         0
#define SDAPINCTRL     PIN1CTRL
#define SCLPINCTRL     PIN0CTRL

#define LED_BATTERY_PORT   PORTA
#define LED_BATTERY_PIN    3
#define LED_BATTERY_ON     LED_BATTERY_PORT.OUTSET = 1 << LED_BATTERY_PIN
#define LED_BATTERY_OFF    LED_BATTERY_PORT.OUTCLR = 1 << LED_BATTERY_PIN
#define LED_BATTERY_TOGGLE LED_BATTERY_PORT.OUTTGL = 1 << LED_BATTERY_PIN

#define LED_TIMER_PORT   PORTA
#define LED_TIMER_PIN    2
#define LED_TIMER_ON     LED_TIMER_PORT.OUTSET = 1 << LED_TIMER_PIN
#define LED_TIMER_OFF    LED_TIMER_PORT.OUTCLR = 1 << LED_TIMER_PIN
#define LED_TIMER_TOGGLE LED_TIMER_PORT.OUTTGL = 1 << LED_TIMER_PIN

#define INT_PORT      PORTA
#define INT_PIN       1
#define INT_PINCTRL   PIN1CTRL
#define INT_PORT_vect PORTA_PORT_vect

#define RTC_INT_MS 125

//#define USART_ENABLED
//#define DEBUG_ENABLED

#define USART_PORT         PORTB
#define USART_TX_PIN       2
#define USART_RX_PIN       3
#define USART_RXPINCTRL    PIN3CTRL
#define USART_BAUD         9600L
#define COMMMAND_LINE_SIZE 50

#define PWM_FREQUENCY 100000L
#define PWM_PORT      PORTA
#define PWM_PIN       4
#define PWM_CMP_CALC(f) (OSC20M_FREQUENCY / PWM_FREQUENCY)
#define PWM_DUTY      145

#define DAC1_VALUE 40

#define VBAT_3V0 512
#define VBAT_3V2 480

void SystemInit(void);
unsigned short get_vbat(void);
void enable_pwm(void);
void disable_pwm(void);
void pwm_set_duty(unsigned short value);
void dac_set(unsigned char value);

#ifdef USART_ENABLED
void usart_putchar(char c);
#endif

extern volatile unsigned char timer_interrupt, rtc_interrupt;

#endif
