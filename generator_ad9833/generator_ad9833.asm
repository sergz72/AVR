;.equ TEST = 1

.include "m8def.inc"

.equ FOSC = 3686400

.ifdef TEST
.equ BAUDRATE  = 57600
.else
.equ BAUDRATE  = 230400
.endif

.equ  command_buffer = $60

.equ FSYNC=PORTB0
.equ SDATA=PORTB2
.equ SCLK=PORTB1

.CSEG

.org 0
  rjmp Start
.org URXCaddr
  ; RX complete interrupt vector
  ; Received byte - Command
  in   r16, UDR  ; retrieve data byte
  cpi  r16, 'I'  ; device identification
  brne No_I
  cpi  r28, command_buffer
  brne No_I
  ldi r16, 'G'
  rcall put_ch
  ldi r16, '9'
  rcall put_ch
  ldi r16, '8'
  rcall put_ch
  ldi r16, '3'
  rcall put_ch
  ldi r16, '3'
  rcall put_ch
  ldi r16, '1'
  rcall put_ch
  ldi r16, '.'
  rcall put_ch
  ldi r16, '0'
  rcall put_ch
  reti
no_I:
  cpi   r16, 'r'  ; read adc0 value
  brne  no_r
  cpi   r28, command_buffer
  brne  no_r
  clr   r16 ; channel 0
  rcall read_adc
  push  r16
  brne  no_stable
  ldi   r16, 'S' ; stable result
  rcall put_ch
  rjmp  write_result
no_stable:
  ldi   r16, 'N' ; not stable result
  rcall put_ch
write_result:
  mov   r16, r17
  rcall put_hex
  pop   r16
  rcall put_hex
  reti

no_r:

  cpi  r16, $D ; '\r'
  breq run_command
  st   Y+, r16
;  rcall put_ch
  reti
run_command:
;  rcall rn
  clr  r16
  st   Y+, r16
  ldi  r28, command_buffer
  ld   r16, Y+
  cpi  r16, 'w'  ; write to ad9833
  brne no_w
next_write:
  rcall read_byte
  mov   r18, r16
  rcall read_byte
  rcall write_9833
  ld    r16, Y
  tst   r16
  brne  next_write
  rjmp OK
no_w:

ERR:
  ldi   r28, command_buffer
  ldi   r16, 'E'
  rcall put_ch
  ldi   r16, 'r'
  rcall put_ch
  reti

OK:
  ldi   r28, command_buffer
  ldi   r16, 'O'
  rcall put_ch
  ldi   r16, 'k'
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

  clr r29 ; clear Y register
  ldi r28, command_buffer

  sei
Sleep_:
.ifndef TEST
  sleep
.endif
  rjmp Sleep_

ResetIO:
  ; Configute PORTC i/o pins as input pins
  clr r16
  out DDRC,  r16
  out DDRD,  r16
  out PORTC, r16
  out PORTD, r16
  ; PB0-PB2 - out pins
  ldi r16, 7
  out PORTB, r16
  out DDRB, r16
  ret

  ; Put character from r16 to serial port
put_ch:
  sbis UCSRA, UDRE	; check for space in tx fifo
  rjmp put_ch		; if not, keep looping
  out  UDR, r16		; enqueue data byte
  ret				; return to caller

;rn:
;  ldi   r16, '\r'
;  rcall put_ch
;  ldi   r16, '\n'
;  rcall put_ch
;  ret

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

read_half_byte:
  ld    r16, Y+
  subi  r16, '0'
  cpi   r16, 10
  brlt  no_hex
  subi  r16, 7
  cpi   r16, $10
  brlt  no_hex
  subi  r16, $20
no_hex:
  ret

read_byte:
  rcall read_half_byte
  swap  r16
  mov   r17, r16
  rcall read_half_byte
  or    r16, r17 
  ret

write_byte:
  ldi  r17, 8
next_w9833:
  rol  r16
  brcs write_1
  cbi  PORTB, SDATA
  rjmp write9833
write_1:
  sbi  PORTB, SDATA
write9833:
  cbi  PORTB, SCLK
  sbi  PORTB, SCLK
  dec  r17
  brne next_w9833
  ret

; r18:r16 - word to write
write_9833:
  push  r16
  mov   r16, r18
  cbi   PORTB, FSYNC
  rcall write_byte
  pop   r16
  rcall write_byte
  sbi   PORTB, FSYNC
  ret

read_adc:
  ; r16 - ADC channel no
  clr r0
  clr r1
  clr r4 ; counter
  sbr  r16, (1<<REFS0) | (1<<REFS1)
  out  ADMUX, r16
NextADC:
  ; Start ADC
  sbi  ADCSRA, ADSC
WaitADC:
  sbic ADCSRA, ADSC
  rjmp WaitADC
  in   r16, ADCL
  in   r17, ADCH
  movw r3:r2, r1:r0
  movw r1:r0, r17:r16
  sub  r2, r16
  sbc  r3, r17
  asr  r3
  lsr  r2
  asr  r3
  lsr  r2
  tst  r3
  brne NextCMP
  tst  r2
  brne NextCMP
  ret
NextCMP:
  neg  r3
  brne NextADC1
  neg  r2
  brne NextADC1
  ret
NextADC1:
  dec  r4
  brne NextADC
  dec  r4
  ret

