.include "m8535def.inc"

.equ FOSC   = 1000000 ; 1 MHZ internal RC

.def status_reg=r9
.def u_lo=r10
.def u_hi=r11
.def i_lo=r12
.def i_hi=r13
.def lcd_cursor_pos=r8

.equ max_u=5100 ; 5.1v
.equ min_u=1450 ; 1.45v

.equ max_i=1020 ; 1.024 A
.equ min_i=4    ; 4 mA

.equ OUTPUT_ENABLED=1
.equ ON=0
.equ I_SET=2
.equ U_SET=3

.CSEG

.org 0
  rjmp Start

.org INT0addr
  rjmp INT0Handler

.org OVF1addr
  cli
  rcall StartTimers

  sbrc  status_reg, U_SET
  rcall lcd_cursor_off
  sbrc  status_reg, I_SET
  rcall lcd_cursor_off

  sbrs  status_reg, OUTPUT_ENABLED
  rjmp  display_i
	ldi   r17, 2
	rcall lcd_set_address
  ldi   r16, 1
  rcall DO_ADC
  movw  r21:r20, r17:r16
  ldi   r22, 5
  clr   r23
  rcall mul16x16_16
  rcall put_decimal
  ldi   r18, ' '
	rcall lcd_ddram_write

display_i:
	ldi   r17, 10
	rcall lcd_set_address
  clr   r16
  rcall DO_ADC
  rcall put_decimal
  ldi   r18, ' '
	rcall lcd_ddram_write

  sbrc  status_reg, U_SET
  rjmp  restore_cursor
  sbrc  status_reg, I_SET
  rjmp  restore_cursor

  sei
  reti

restore_cursor:
  mov   r17, lcd_cursor_pos
  rcall lcd_set_address
  rcall lcd_cursor_on
  sei
  reti

INT0Handler:
  cli

  ldi   r16, $F7
next_scan:
  out   PORTD, r16
  nop
  nop
  sbis  PINB, PB4
  rcall process_key1
  sbis  PIND, PD0
  rcall process_key2
  sbis  PIND, PD1
  rcall process_key3
  sec
  rol   r16
  brcs  next_scan

  ldi  r16, 7
  out  PORTD, r16

.equ WAIT_CODE = 256 - FOSC / 1024 / 10 ; delay 0.1 sec
  ldi r16, WAIT_CODE
  rcall wait_

wait_1:
  sbis  PIND, PD2
  rjmp  wait_1

  ldi r16, WAIT_CODE
  rcall wait_

  ldi  r16, (1<<INTF0)
  out  GIFR, r16
  
  rcall StartTimers

  sei
  reti

process_key1:
  clr  r30
  rjmp process_key

process_key2:
  ldi  r30, 5
  rjmp process_key

process_key3:
  ldi  r30, 10
process_key:
  push r16
  ldi  r17, $ff
next_p:
  inc  r17
  rol  r16
  brcs next_p
  ldi  r31, high(2*key_codes)
  add  r30, r17
  ldi  r17, low(2*key_codes)
  clr  r16
  add  r30, r17
  adc  r31, r16
  lpm  r18, Z
  cpi  r18, 'O' ; ON/OFF key
  brne no_O
  tst  status_reg
  brne _OFF
  ldi  r16, 1<<ON
  mov  status_reg, r16
  rcall lcd_display_on
  rcall StartTimers
  pop   r16
  ret
_OFF:
  clr  status_reg
  sbi  PORTA, PA2
  rcall lcd_display_off
  clr   r16
  out  TCCR1B, r16 ; stop timer1
  pop   r16
  ret
no_O:
  tst   status_reg
  brne  process_key_
  pop   r16
  ret
process_key_:
  cpi   r18, 'E' ; output enable
  brne  no_E
  sbrs  status_reg, OUTPUT_ENABLED
  rjmp  ENABLE_
  sbi   PORTA, PA2
  rcall display_u_reg
EN_:
  ldi   r16, 1<<OUTPUT_ENABLED
  eor   status_reg, r16
  pop   r16
  ret
ENABLE_:
  cbi   PORTA, PA2
  rjmp  EN_

no_E:
  cpi   r18, 'U'
  brne  no_U
  ldi  r17, $49
  rcall lcd_set_address
  ldi  r18, 'U'
	rcall lcd_ddram_write
  rcall clr_input
  ldi   r16, 1<<U_SET
  or    status_reg, r16
  ldi   r16, ~(1<<I_SET)
  and    status_reg, r16
  pop   r16
  ret
no_U:
  cpi   r18, 'I'
  brne  no_I
  ldi  r17, $49
  rcall lcd_set_address
  ldi  r18, 'I'
	rcall lcd_ddram_write
  rcall clr_input
  ldi   r16, 1<<I_SET
  or   status_reg, r16
  ldi   r16, ~(1<<U_SET)
  and    status_reg, r16
  pop   r16
  ret
no_I:
  cpi   r18, 'N'
  brne  no_N
  sbrc  status_reg, I_SET
  rjmp  I_SET_
  sbrc  status_reg, U_SET
  rjmp  U_SET_
  pop   r16
  ret
I_SET_:
  rcall get_value
  movw  i_hi:i_lo, r17:r16
  rcall set_i
  rcall display_i_max
SET_:
  ldi   r16, ~((1<<I_SET)|(1<<U_SET))
  and   status_reg, r16
  rcall lcd_cursor_off
  ldi  r17, $49
  rcall lcd_set_address
  ldi  r18, ' '
	rcall lcd_ddram_write
	rcall lcd_ddram_write
	rcall lcd_ddram_write
	rcall lcd_ddram_write
	rcall lcd_ddram_write
	rcall lcd_ddram_write
	rcall lcd_ddram_write
  pop   r16
  ret
U_SET_:
  rcall get_value
  movw  u_hi:u_lo, r17:r16
  rcall set_u
  sbrs  status_reg, OUTPUT_ENABLED
  rcall display_u_reg
  rjmp  SET_
no_N:
  sbrc  status_reg, I_SET
  rjmp  ENTRY
  sbrc  status_reg, U_SET
  rjmp  ENTRY
  pop  r16
  ret
ENTRY:
  ldi   r30, $60-$4B
  add   r30, lcd_cursor_pos
  cpi   r30, $64
  brge  skip_entry
  clr   r31
  st    Z, r18
 	rcall lcd_ddram_write
  inc   lcd_cursor_pos
skip_entry:
  pop  r16
  ret

clr_input:
  ldi  r18, '='
	rcall lcd_ddram_write
  ldi  r18, ' '
	rcall lcd_ddram_write
	rcall lcd_ddram_write
	rcall lcd_ddram_write
	rcall lcd_ddram_write
	rcall lcd_ddram_write
  ldi   r17, $4B
  mov   lcd_cursor_pos, r17
  rcall lcd_set_address
  rcall lcd_cursor_on
  ret

get_value:
  ldi   r30, $60-$4B
  add   r30, lcd_cursor_pos
  clr   r31
  st    Z, r31
  ldi   r30, $60
  clr   r16
  clr   r17
get_next:
  ld    r18, Z+
  tst   r18
  breq  get_done
  clr   r21
  ldi   r20, 10
  movw  r23:r22, r17:r16
;*	r17:r16 = r23:r22 * r21:r20
  rcall mul16x16_16
  subi  r18, '0'
  add   r16, r18
  adc   r17, r31
  rjmp  get_next
get_done:
  ret

Start:
  ; Initialize the stack pointer
  ldi R24, low(RAMEND)	;  SP <-- RAMEND
  ldi R25, high(RAMEND)
  out SPL, R24
  out SPH, R25

  rcall ResetIO

  ldi   r16, 1<<ON
  mov   status_reg, r16

  rcall read_eeprom_data
  rcall set_u
  rcall set_i

  ; Configure ADC
  ; Reference - Internal 2.56V Voltage Reference
  ldi r16, (1<<REFS0) | (1<<REFS1)
  out ADMUX, r16
  ; Enable ADC, set prescaler - 8 (ADC clk should be 50-200 khz)
  ldi r16, (1<<ADEN) | (1<<ADPS1) | (1<<ADPS0)
  out ADCSRA, r16

  ; Enable sleep command, idle mode
  ldi r16, (1<<SE)
  out MCUCR, r16

.equ WAIT_CODE2 = 256 - FOSC / 1024 / 4 ; delay 0.25 sec
  ldi r16, WAIT_CODE2
  rcall wait_

  rcall InitDisplay

  rcall display_u_reg
  rcall display_i_max

  rcall StartTimers

  ldi  r16, (1<<INTF0)
  out  GIFR, r16

  ldi  r16, $F8
  out  DDRD, r16
  ldi  r16, 7
  out  PORTD, r16

; Enable INT0
  ldi r16, (1<<INT0)
  out GICR, r16

  ; Enable Timer 1 interrupt
  ldi r16, 1<<TOIE1
  out TIMSK, r16

  ; Enable interrupts
  sei
Sleep_:
  sleep
  rjmp Sleep_

wait_:
  out TCNT0, r16
  ; Timer 0 - clkI/O/1024 (From prescaler)
  ldi r16, (1<<CS02)|(1<<CS00)
  ; Start timer 0
  out  TCCR0, r16

wait_loop:
  in   r16, TIFR
  sbrs r16, TOV0
  rjmp wait_loop
  out  TIFR, r16
   
  clr  r16
  ; Stop timer 1
  out  TCCR0, r16
  ret

ResetIO:
  ; Configute all i/o pins as input pins
  clr r16
  out DDRA,  r16
  out DDRB,  r16
  out DDRC,  r16
  out DDRD,  r16
  dec r16
  out PORTD, r16 ; enable pull-ups on port D (keyboard)
  out PORTB, r16
  out PORTC, r16
  ldi r16, $FC
  out PORTA, r16
  ; PORTB0,1,2,3 - out pins
  ldi r16, $0F
  out DDRB, r16
  cbi PORTB, PB0 ; set clk pin to "0"
  ; PORTA2 - out pin
  ldi r16, 4
  out DDRA, r16
  ret

InitDisplay:
  rcall LcdInit
	clr r17
	rcall lcd_set_address
	ldi r18, 'U'
	rcall lcd_ddram_write
	clr r17
	rcall lcd_set_address
	ldi r18, 'U'
	rcall lcd_ddram_write
	ldi r18, '='
	rcall lcd_ddram_write
	ldi r17, 8
	rcall lcd_set_address
	ldi r18, 'I'
	rcall lcd_ddram_write
	ldi r18, '='
	rcall lcd_ddram_write
	ldi r17, $40
	rcall lcd_set_address
	ldi r18, 'I'
	rcall lcd_ddram_write
	ldi r18, 'm'
	rcall lcd_ddram_write
	ldi r18, '='
	rcall lcd_ddram_write
  ret

.equ T1CODE = 65536 - FOSC / 1024 / 5 ; one interrupt per 0.2 sec
StartTimers:
  ldi r16, high(T1CODE)
  out TCNT1H, r16
  ldi r16, low(T1CODE)
  out TCNT1L, r16
  ; Timer 1 - clkI/O/1024 (From prescaler)
  ldi r16, (1<<CS12)|(1<<CS10)
  ; Start timer 1
  out  TCCR1B, r16
  ret

set_u:
  ldi  r16, high(max_u)
  cp   u_hi, r16
  breq next_cmp_510
  brsh set_510
  ldi  r16, high(min_u)
  cp   u_hi, r16
  breq next_145
  brlo set_145
set_u_:
  rcall write_u_to_eeprom
  rcall convert_to_vcode
  sbi  PORTB, PB0
  cbi  PORTB, PB2
  rcall write_5160
  sbi  PORTB, PB2
  nop
  sbi  PORTB, PB0
  cbi  PORTB, PB0
  ret
next_cmp_510:
  ldi  r16, low(max_u)
  cp   u_lo, r16
  breq set_u_
  brsh set_510
  rjmp set_u_
set_510:
  ldi  r16, high(max_u)
  mov  u_hi, r16
  ldi  r16, low(max_u)
  mov  u_lo, r16
  rjmp set_u_
next_145:
  ldi  r16, low(min_u)
  cp   u_hi, r16
  brlo set_145
  rjmp set_u_
set_145:
  ldi  r16, high(min_u)
  mov  u_hi, r16
  ldi  r16, low(min_u)
  mov  u_lo, r16
  rjmp set_u_

set_i:
  ldi  r16, high(max_i)
  cp   i_hi, r16
  breq next_cmp_1024
  brsh set_1024
  ldi  r16, high(min_i)
  cp   i_hi, r16
  breq next_4
  brlo set_4
set_i_:
  rcall write_i_to_eeprom
  rcall convert_to_icode
  sbi  PORTB, PB0
  cbi  PORTB, PB3
  rcall write_5160
  sbi  PORTB, PB3
  nop
  sbi  PORTB, PB0
  cbi  PORTB, PB0
  ret
next_cmp_1024:
  ldi  r16, low(max_i)
  cp   i_hi, r16
  breq set_i_
  brsh set_1024
  rjmp set_i_
set_1024:
  ldi  r16, high(max_i)
  mov  i_hi, r16
  ldi  r16, low(max_i)
  mov  i_lo, r16
  rjmp set_i_
next_4:
  ldi  r16, low(min_i)
  cp   i_lo, r16
  brlo set_4
  rjmp set_i_
set_4:
  ldi  r16, high(min_i)
  mov  i_hi, r16
  ldi  r16, low(min_i)
  mov  i_lo, r16
  rjmp set_i_


; converting using table
convert_to_vcode:
  ldi  r16, $ff
  ldi  r31, high(2*voltage_codes)
  ldi  r30, low(2*voltage_codes)
next_val:
  inc  r16
  lpm  r17, Z+
  lpm  r18, Z+
  cp   r18, u_hi
  breq next_cp
  brsh next_val
  ret
next_cp:
  cp   r17, u_lo
  breq cp_done
  brsh next_val
cp_done:
  dec  r16
  ret

convert_to_icode:
  movw r17:r16, i_hi:i_lo
  asr  r17
  ror  r16
  asr  r17
  ror  r16
  ret

write_5160:
  ldi  r17, 8
next_write_5160:
  cbi  PORTB, PB0
  rol  r16
  brcc write_0
  sbi  PORTB, PB1
  nop
next_w_5160:
  sbi  PORTB, PB0
  dec  r17
  brne next_write_5160
  cbi  PORTB, PB0
  ret
write_0:
  cbi  PORTB, PB1
  rjmp next_w_5160

write_u_to_eeprom:
  clr r18
  ldi r17, 1
  mov r16, u_lo
  rcall EEWrite
  inc r17  
  mov r16, u_hi
  rcall EEWrite
  ret

write_i_to_eeprom:
  clr r18
  ldi r17, 3
  mov r16, i_lo
  rcall EEWrite
  inc r17  
  mov r16, i_hi
  rcall EEWrite
  ret

read_eeprom_data:
  clr r18
  ldi r17, 1
  rcall EERead
  mov u_lo, r16
  inc r17
  rcall EERead
  mov u_hi, r16
  inc r17
  rcall EERead
  mov i_lo, r16
  inc r17
  rcall EERead
  mov i_hi, r16
  ret

DO_ADC:
  ; r16 - ADC channel no
  sbr  r16, (1<<REFS0) | (1<<REFS1)
  out  ADMUX, r16
NextADC:
  ; Start ADC
  sbi  ADCSRA, ADSC
Wait:
  sbic ADCSRA, ADSC
  rjmp Wait
  in   r16, ADCL
  in   r17, ADCH
  ret

display_u_reg:
	ldi   r17, 2
	rcall lcd_set_address
  movw  r17:r16,u_hi:u_lo
  rcall put_decimal
  ret

display_i_max:
	ldi   r17, $43
	rcall lcd_set_address
  movw  r17:r16,i_hi:i_lo
  rcall put_decimal
  ret

;******************************************************************************
;*
;* FUNCTION
;*	mul16x16_16
;* DECRIPTION
;*	Multiply of two 16bits numbers with 16bits result.
;* USAGE
;*	r17:r16 = r23:r22 * r21:r20
;* STATISTICS
;*	Cycles :	9 + ret
;*	Words :		6 + ret
;*	Register usage: r0, r1 and r16 to r23 (8 registers)
;* NOTE
;*	Full orthogonality i.e. any register pair can be used as long as
;*	the result and the two operands does not share register pairs.
;*	The routine is non-destructive to the operands.
;*
;******************************************************************************

mul16x16_16:
	mul	r22, r20		; al * bl
	movw	r17:r16, r1:r0
	mul	r23, r20		; ah * bl
	add	r17, r0
	mul	r21, r22		; bh * al
	add	r17, r0
	ret

put_decimal:
  clr  r19
  ldi  r18, 10
  ldi  r23, 4
Next_dec:
  rcall div16u
	subi r21, -'0'
  push r21
	cpi  r23, 2
	brne no_1
	ldi  r20, '.'
	push r20
no_1:
	dec  r23
  brne Next_dec
  ldi   r23, 5
Next_dec2:
  pop   r18
  rcall lcd_ddram_write
  dec   r23
  brne  Next_dec2
  ret

;***************************************************************************
;*
;* "div16u" - 16/16 Bit Unsigned Division
;*
;* This subroutine divides the two 16-bit numbers 
;* "dd8uH:dd8uL" (dividend) and "dv16uH:dv16uL" (divisor). 
;* The result is placed in "dres16uH:dres16uL" and the remainder in
;* "drem16uH:drem16uL".
;*  
;* Number of words	:19
;* Number of cycles	:235/251 (Min/Max)
;* Low registers used	:2 (drem16uL,drem16uH)
;* High registers used  :5 (dres16uL/dd16uL,dres16uH/dd16uH,dv16uL,dv16uH,
;*			    dcnt16u)
;*
;***************************************************************************

;***** Subroutine Register Variables

.def	drem16uL=r21
.def	drem16uH=r22
.def	dres16uL=r16
.def	dres16uH=r17
.def	dd16uL	=r16
.def	dd16uH	=r17
.def	dv16uL	=r18
.def	dv16uH	=r19
.def	dcnt16u	=r20

;***** Code

div16u:	clr	drem16uL	;clear remainder Low byte
	sub	drem16uH,drem16uH;clear remainder High byte and carry
	ldi	dcnt16u,17	;init loop counter
d16u_1:	rol	dd16uL		;shift left dividend
	rol	dd16uH
	dec	dcnt16u		;decrement counter
	brne	d16u_2		;if done
	ret			;    return
d16u_2:	rol	drem16uL	;shift dividend into remainder
	rol	drem16uH
	sub	drem16uL,dv16uL	;remainder = remainder - divisor
	sbc	drem16uH,dv16uH	;
	brcc	d16u_3		;if result negative
	add	drem16uL,dv16uL	;    restore remainder
	adc	drem16uH,dv16uH
	clc			;    clear carry to be shifted into result
	rjmp	d16u_1		;else
d16u_3:	sec			;    set carry to be shifted into result
	rjmp	d16u_1

;***************************************************************************
;* 
;* EEWrite
;*
;* This subroutine waits until the EEPROM is ready to be programmed, then
;* programs the EEPROM with register variable "EEdwr" at address "EEawr:EEawr"
;*
;* Number of words: 7 + return
;* Number of cycles: 11 + return (if EEPROM is ready)
;* Low Registers used	:None
;* High Registers used:	;3 (EEdwr,EEawr,EEawrh)
;*
;***************************************************************************

;***** Subroutine register variables

.def	EEdwr	=r16		;data byte to write to EEPROM
.def	EEawr	=r17		;address low byte to write to
.def	EEawrh=r18		;address high byte to write to

;***** Code

EEWrite:
	sbic	EECR,EEWE	;if EEWE not clear
	rjmp	EEWrite		;    wait more

	out 	EEARH,EEawrh	;output address high for 8515
	out	EEARL,EEawr	;output address low for 8515
		

	out	EEDR,EEdwr	;output data
	sbi 	EECR,EEMWE	;set master write enable
	sbi	EECR,EEWE	;set EEPROM Write strobe
				;This instruction takes 4 clock cycles since
				;it halts the CPU for two clock cycles
	ret

;***************************************************************************
;* 
;* EERead
;*
;* This subroutine waits until the EEPROM is ready to be programmed, then
;* reads the register variable "EEdrd" from address "EEardh:EEard"
;*
;* Number of words: 6 + return
;* Number of cycles: 9 + return (if EEPROM is ready)
;* Low Registers used	:1 (EEdrd)
;* High Registers used:	:2 (EEard,EEardh)
;*
;***************************************************************************

;***** Subroutine register variables

.def	EEdrd	=r16		;result data byte
.def	EEard	=r17		;address low to read from
.def	EEardh=r18		;address high to read from

;***** Code

EERead:
	sbic	EECR,EEWE	;if EEWE not clear
	rjmp	EERead		;    wait more

; the two following lines must be replaced with the line above if 1200 is used
	out 	EEARH,EEardh	;output address high for 8515
	out	EEARL,EEard	;output address low for 8515


	sbi	EECR,EERE	;set EEPROM Read strobe
				;This instruction takes 4 clock cycles since
				;it halts the CPU for two clock cycles
	in	EEdrd,EEDR	;get data
	ret

.include "lcd.asm"

key_codes:
.db '1', '2', '3', '0', 'O', '4', '5', '6', 'U', 'E', '7', '8', '9', 'I', 'N'

voltage_codes:
.dw 8610,8444,8285,8131,7983,7841,7703,7570,7442,7318,7198,7082,6970,6861,6755,6653
.dw 6553,6457,6363,6273,6184,6098,6015,5933,5854,5777,5702,5629,5558,5488,5421,5355
.dw 5290,5227,5166,5105,5047,4989,4933,4879,4825,4772,4721,4671,4622,4574,4526,4480
.dw 4435,4391,4347,4305,4263,4222,4182,4142,4103,4065,4028,3991,3955,3920,3885,3851
.dw 3818,3785,3753,3721,3690,3659,3629,3599,3570,3541,3512,3485,3457,3430,3403,3377
.dw 3351,3326,3301,3276,3252,3228,3205,3181,3159,3136,3114,3092,3070,3049,3028,3007
.dw 2987,2966,2947,2927,2908,2888,2870,2851,2832,2814,2796,2779,2761,2744,2727,2710
.dw 2693,2677,2661,2645,2629,2613,2598,2583,2567,2552,2538,2523,2509,2494,2480,2466
.dw 2453,2439,2426,2412,2399,2386,2373,2360,2348,2335,2323,2311,2299,2287,2275,2263
.dw 2251,2240,2228,2217,2206,2195,2184,2173,2163,2152,2141,2131,2121,2111,2101,2090
.dw 2081,2071,2061,2051,2042,2032,2023,2014,2005,1995,1986,1977,1969,1960,1951,1942
.dw 1934,1925,1917,1909,1900,1892,1884,1876,1868,1860,1852,1844,1837,1829,1822,1814
.dw 1807,1799,1792,1784,1777,1770,1763,1756,1749,1742,1735,1728,1721,1715,1708,1701
.dw 1695,1688,1682,1675,1669,1663,1657,1650,1644,1638,1632,1626,1620,1614,1608,1602
.dw 1596,1590,1585,1579,1573,1568,1562,1557,1551,1546,1540,1535,1529,1524,1519,1514
.dw 1508,1503,1498,1493,1488,1483,1478,1473,1468,1463,1458,1454,1449,1444,1439,1434
