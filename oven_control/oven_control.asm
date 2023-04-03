;.equ TEST = 1

.include "m8def.inc"

.equ FOSC = 3686400

.ifdef TEST
.equ BAUDRATE  = 57600
.else
.equ BAUDRATE  = 115200
.endif

.equ ON_PIN=PORTC5

.CSEG

.org 0
  rjmp Start
.org URXCaddr
  ; RX complete interrupt vector
  ; Received byte - Command
  in   r16, UDR  ; retrieve data byte
  cpi  r16, 'I'  ; device identification
  brne No_I
  ldi r16, 'O'
  rcall put_ch
  ldi r16, 'V'
  rcall put_ch
  ldi r16, 'E'
  rcall put_ch
  ldi r16, 'N'
  rcall put_ch
  ldi r16, 'C'
  rcall put_ch
  ldi r16, 'T'
  rcall put_ch
  ldi r16, 'L'
  rcall put_ch
  ldi r16, '1'
  rcall put_ch
  ldi r16, '.'
  rcall put_ch
  ldi r16, '0'
  rcall put_ch
  reti
no_I:
  cpi   r16, 'r'  ; read adc1 value
  brne  no_r
  ldi   r16, 1 ; channel 1
  rcall DO_ADC
  push  r16
  mov   r16, r17
  rcall put_hex
  pop   r16
  rcall put_hex
  reti
no_r:
  cpi   r16, 'e'  ; enable heater
  brne  no_e
  sbi   PORTC, ON_PIN
  rjmp  OK
no_e:
  cpi   r16, 'd'  ; disable heater
  brne  no_d
  cbi   PORTC, ON_PIN
OK:
  ldi   r16, 'O'
  rcall put_ch
  ldi   r16, 'k'
  rcall put_ch
  reti

no_d:
ERR:
  ldi   r16, 'E'
  rcall put_ch
  ldi   r16, 'r'
  rcall put_ch
  reti

Start:
  ; Initialize the stack pointer
  ldi R24, low(RAMEND)	;  SP <-- RAMEND
  ldi R25, high(RAMEND)
  out SPL, R24
  out SPH, R25

  rcall ResetIO

  ; Set up the UART
.equ UBR = (FOSC / 16 / BAUDRATE) - 1
  ldi R24, high(UBR)
  out UBRRH, R24
  ldi R24, low(UBR)
  out UBRRL, R24

  ldi R24, (1<<RXEN) | (1<<TXEN) | (1<<RXCIE); Enable RX and TX
  out UCSRB, R24
  ldi R24, (1<<URSEL) | (3<<UCSZ0) ; 8 data, 1 stop
  out UCSRC, R24

  ; Configure ADC
  ; Reference - 2.56V
  ldi r16, (1<<REFS0) | (1<<REFS1)
  out ADMUX, r16
  ; Enable ADC, set prescaler - 32 (ADC clk should be 50-200 khz)
  ldi r16, (1<<ADEN) | (1<<ADPS2) | (1<<ADPS0)
  out ADCSRA, r16

  ; Enable sleep command, idle mode, INT0 on rising edge
  ldi r16, (1<<SE)
  out MCUCR, r16

  sei
Sleep_:
.ifndef TEST
  sleep
.endif
  rjmp Sleep_

ResetIO:
  ; Configute PORTC i/o pins as input pins
  clr r16
  out DDRB,  r16
  out DDRD,  r16
  out PORTB, r16
  out PORTC, r16
  out PORTD, r16
  ; PC5 - out pin
  ldi r16, $20
  out DDRC, r16
  ret

  ; Put character from r16 to serial port
put_ch:
  sbis UCSRA, UDRE	; check for space in tx fifo
  rjmp put_ch		; if not, keep looping
  out  UDR, r16		; enqueue data byte
  ret				; return to caller

to_hex:
  andi  r16, $0f
  cpi   r16, 10
  brlt  no_hex_sym
  subi  r16, -'0'-7
  ret
no_hex_sym:
  subi  r16, -'0'
  ret

put_hex:
  push  r16
  swap  r16
  rcall to_hex
  rcall put_ch
  pop   r16
  rcall to_hex
  rcall put_ch
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
