.equ RS_PORT=PORTA
.equ RS_CTRL=DDRA
.equ RS_BIT=PORTA5

.equ RW_PORT=PORTA
.equ RW_CTRL=DDRA
.equ RW_BIT=PORTA6

.equ E_PORT=PORTA
.equ E_CTRL=DDRA
.equ E_BIT=PORTA7

.equ LCD_DISPLAY_LINES=2

.macro lcd_data_set
  out PORTC, r17
  ldi r16, $FF
  out DDRC, r16
 .endm

.macro lcd_data_reset
  clr r16
  out DDRC, r16
  dec r16
  out PORTC, r16
.endm

.macro lcd_data_get
  in r16, DDRC
.endm
