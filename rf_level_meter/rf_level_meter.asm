.include "m8def.inc"

.equ FOSC   = 1000000 ; 1 MHZ internal RC

;.def u_min  = r0
;.def u_step = r1
.def pred_v_lo = r2
.def pred_v_hi = r3

.CSEG

.org 0
  rjmp Start

.org OVF0addr
  wdr
  rcall StartTimers
  sbis  PINC, PORTC4
  rjmp  check_battery_level
  clr   r16
  rcall DO_ADC
  cp    r17, pred_v_hi
  breq  next_cmp
  brsh  _show_input
_dec_19:
  movw  r17:r16, pred_v_hi:pred_v_lo
  subi  r16, 19
;  subi  r16, 2
  sbci  r17, 0
  rjmp  _show_input
next_cmp:
  cp    r16, pred_v_lo
  brlo  _dec_19
_show_input:
  movw  pred_v_hi:pred_v_lo, r17:r16
  subi  r16, 162
  sbci  r17, 0
  brpl  show_input_level
  clr   r16
  rcall set_leds
  reti
show_input_level:
  ldi   r18, 38
  clr   r19
  rcall div16u
  rcall set_leds
  reti

check_battery_level:
  ldi   r16, 1
  rcall DO_ADC
  ; Calcutating voltage level in mV
;  movw  r21:r20, r17:r16
;  ldi   r22, 5
;  clr   r23
;  rcall mul16x16_16
  ; r17:r16 - voltage level in mV
  subi  r16, low(2650/5)
  sbci  r17, high(2650/5)
  brpl  show_battery_level
  clr   r16
  rcall set_leds
  reti
show_battery_level:
  ldi   r18, 20
  clr   r19
  rcall div16u
  rcall set_leds
  reti

Start:
  ; Initialize the stack pointer
  ldi R24, low(RAMEND)	;  SP <-- RAMEND
  ldi R25, high(RAMEND)
  out SPL, R24
  out SPH, R25

  rcall ResetIO

;  rcall read_eeprom_data

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

  rcall StartTimers

  ; Enable Timer 0 interrupt
  ldi r16, 1<<TOIE0
  out TIMSK, r16

  ; Configure WDT
  ldi r16, (1<<WDCE)|(1<<WDE)|(1<<WDP2)
  out WDTCR, r16
  ldi r16, (1<<WDCE)|(1<<WDE)|(1<<WDP2)
  out WDTCR, r16

  clr pred_v_lo
  clr pred_v_hi

  ; Enable interrupts
  sei
Sleep_:
  sleep
  rjmp Sleep_

ResetIO:
  ; Configute all i/o pins as input pins
  clr r16
  out DDRB,  r16
  out DDRC,  r16
  out DDRD,  r16
  dec r16
  out PORTD, r16 ; enable pull-ups
  out PORTB, r16
  out DDRD,  r16 ; port D - output
  ldi r16,   $FC
  out PORTC, r16
  ldi r16,   $C7
  out DDRB,  r16
  ret

.equ T0CODE = 256 - FOSC / 1024 / 70 ; one interrupt per 0.01 sec
StartTimers:
  ldi r16, T0CODE
  out TCNT0, r16
  ; Timer 0 - clkI/O/1024 (From prescaler)
  ldi r16, (1<<CS02)|(1<<CS00)
  ; Start timer 0
  out  TCCR0, r16
  ret

set_leds:
  clr r18
  clr r19
_snext:
  sec
  tst r16
  breq _set
  rol r18
  rol r19
  dec r16
  rjmp _snext
  ret
_set:
  mov r17, r16
  bst r18, 0
  bld r16, 2
  bst r18, 1
  bld r16, 1
  bst r18, 2
  bld r16, 0
  bst r18, 3
  bld r17, 7
  bst r18, 4
  bld r17, 6
  bst r18, 5
  bld r17, 5
  bst r18, 6
  bld r16, 7
  bst r18, 7
  bld r16, 6
  bst r19, 0
  bld r17, 4
  bst r19, 1
  bld r17, 3
  bst r19, 2
  bld r17, 2
  bst r19, 3
  bld r17, 1
  bst r19, 4
  bld r17, 0
  com r16
  com r17
  out PORTB, r16
  out PORTD, r17
  ret

;read_eeprom_data:
;  clr r18
;  ldi r17, 1
;  rcall EERead
;  mov u_min, r16
;  inc r17
;  rcall EERead
;  mov u_step, r16
;  ret

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

;.def	EEdrd	=r16		;result data byte
;.def	EEard	=r17		;address low to read from
;.def	EEardh=r18		;address high to read from

;***** Code

;EERead:
;	sbic	EECR,EEWE	;if EEWE not clear
;	rjmp	EERead		;    wait more

; the two following lines must be replaced with the line above if 1200 is used
;	out 	EEARH,EEardh	;output address high for 8515
;	out	EEARL,EEard	;output address low for 8515


;	sbi	EECR,EERE	;set EEPROM Read strobe
				;This instruction takes 4 clock cycles since
				;it halts the CPU for two clock cycles
;	in	EEdrd,EEDR	;get data
;	ret

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

;mul16x16_16:
;	mul	r22, r20		; al * bl
;	movw	r17:r16, r1:r0
;	mul	r23, r20		; ah * bl
;	add	r17, r0
;	mul	r21, r22		; bh * al
;	add	r17, r0
;	ret

;.ESEG
;.db $00, $00, $00
