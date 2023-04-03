.equ FOSC = 12000000

.equ RXD_PORT    = PORTB
.equ RXD_PINPORT = PINB
.equ RXD_PIN     = PINB1
.equ RXD_PCI     = PCINT1

.equ TXD_PORT = PORTB
.equ TXD_DDR  = DDRB
.equ TXD_PIN  = PINB0

.equ RELAY_PORT = PORTB
.equ RELAY_DDR  = DDRB
.equ RELAY_PIN  = PINB4

.equ half_delay_cycles = FOSC / 9600 / 2 ; 625

.equ T1CODE = 511 - FOSC / 4096 / 10

.def cnt2=r24
.def cnt3=r25
.def zero=r23
.def cnt1=r15

.org 0
 rjmp Start
.org PCI0addr
  rjmp PCI_Handler
.org OVF1addr
  rjmp OVF1_Handler
.org OVF0addr
  rjmp OVF0_Handler

PCI_Handler:
  sbic RXD_PINPORT, RXD_PIN
  reti
  rcall half_delay
  sbic  RXD_PINPORT, RXD_PIN
  reti
  ; disable PCIE
  out  GIMSK, zero
  rcall bit_delay
  clr   r16
  sbic  RXD_PINPORT, RXD_PIN
  sbr   r16, 1
  rcall bit_delay
  sbic  RXD_PINPORT, RXD_PIN
  sbr   r16, 2
  rcall bit_delay
  sbic  RXD_PINPORT, RXD_PIN
  sbr   r16, 4
  rcall bit_delay
  sbic  RXD_PINPORT, RXD_PIN
  sbr   r16, 8
  rcall bit_delay
  sbic  RXD_PINPORT, RXD_PIN
  sbr   r16, $10
  rcall bit_delay
  sbic  RXD_PINPORT, RXD_PIN
  sbr   r16, $20
  rcall bit_delay
  sbic  RXD_PINPORT, RXD_PIN
  sbr   r16, $40
  rcall bit_delay
  sbic  RXD_PINPORT, RXD_PIN
  sbr   r16, $80
  rcall bit_delay
  ; stop bit check
  sbis  RXD_PINPORT, RXD_PIN
  rjmp  enable_pcie
  cpi   r16, 'I'
  brne  not_I
  ldi   r16, 'L'
  rcall put_ch
  ldi   r16, 'M'
  rcall put_ch
  ldi   r16, 'E'
  rcall put_ch
  ldi   r16, 'T'
  rcall put_ch
  ldi   r16, 'E'
  rcall put_ch
  ldi   r16, 'R'
  rcall put_ch
  ldi   r16, '1'
  rcall put_ch
  ldi   r16, '.'
  rcall put_ch
  ldi   r16, '0'
  rcall put_ch
  rjmp  enable_pcie
not_I:
  cpi   r16, 'C'
  brne  not_C
  sbi   RELAY_PORT, RELAY_PIN
  ldi   r16, 'K'
  rcall put_ch
  rjmp  enable_pcie
not_C:
  cpi   r16, 'L'
  brne  not_L
  cbi   RELAY_PORT, RELAY_PIN
  ldi   r16, 'K'
  rcall put_ch
  rjmp  enable_pcie
not_L:
  cpi   r16, 'F'
  brne  not_F
  out   TCNT0, zero
  out   TCNT1, zero
  clr   cnt2
  clr   cnt3
  clr   cnt1
  out   TCNT1, zero
  ; reset Timer 1 prescaler
  ldi   r16, (1<<PSR1)
  out   GTCCR, r16
  ; start Timer 1, source - CK/4096
  ldi   r16, (1<<CS13)|(1<<CS12)|(1<<CS10)
  out   TCCR1, r16
  ; start T0, source - External clock source on T0 pin. Clock on rising edge.
  ldi   r16, (1<<CS00)|(1<<CS01)|(1<<CS02)
  out   TCCR0B, r16
  rcall idle_mode_enable
  reti
not_F:
  ldi   r16, 'E'
  rcall put_ch
  rjmp  enable_pcie
enable_pcie:
  ; enable PCIE
  ldi  r16, (1<<PCIE)
  out  GIMSK, r16
  reti

OVF0_Handler:
  adiw cnt3:cnt2, 1
  reti

OVF1_Handler:
  tst cnt1
  brne out_
  ldi r16, T1CODE
  out TCNT1, r16
  inc cnt1
  reti
out_:
  ; stop Timer 0
  out TCCR0B, zero
  ; stop Timer 1
  out TCCR1, zero
  in r16, TCNT0
  rcall put_decimal
  ldi r16, '0'
  rcall put_ch
  rcall power_down_mode_enable
  ; enable PCIE
  ldi  r16, (1<<PCIE)
  out  GIMSK, r16
  reti

Start:
  ; Initialize the stack pointer
  ldi r16, low(RAMEND)	;  SP <-- RAMEND
  out SPL, r16
.ifdef SPH
  ldi r16, high(RAMEND)
  out SPH, r16
.endif

  ; set TXD pin to "1"
  sbi TXD_PORT, TXD_PIN
  ; configure TXD pin as output
  sbi TXD_DDR,  TXD_PIN
  ; configure REAY control pin as output
  sbi RELAY_DDR,  RELAY_PIN

  ; enable pin change interrupt on RXD pin
  ldi  r16, (1<<RXD_PCI)
  out  PCMSK, r16
  ldi  r16, (1<<PCIE)
  out  GIMSK, r16

  ; enable Timer 0 and Timer 1 overflow interrupt
  ldi  r16, (1<<TOIE0)|(1<<TOIE1)
  out  TIMSK, r16

  ; disable analog comparator
  sbi ACSR, ACD

  ; shut down USI and ADC
  ldi r16, (1<<PRUSI)|(1<<PRADC)
  out PRR, r16

  clr zero

  rcall power_down_mode_enable

  sei

Sleep_:
  sleep
  rjmp Sleep_

power_down_mode_enable:
  ; Enable sleep command, power down mode, low level interrupt on INT0
  ldi r17, (1<<SE)|(1<<SM1)
  out MCUCR, r17
  ret
idle_mode_enable:
  ; Enable sleep command, idle mode, low level  interrupt on INT0
  ldi r17, (1<<SE)
  out MCUCR, r17
  ret

bit_delay:
  ; 3 cycles
  rcall half_delay
  ; 52 cycle delay
half_delay:
  ; 1 cycle
  ldi r17, 124
half_delay_:
  ; 1 cycle
  nop
  nop
  ; 1 cycle
  dec r17
  ; 2 cycles
  brne half_delay_
  ; 4 cycles
  ret

put_ch:
  cbi TXD_PORT, TXD_PIN
  rcall bit_delay
  ; bit 0
  sbrc r16, 0
  sbi TXD_PORT, TXD_PIN
  rcall bit_delay
  ; bit 1
  sbrs r16, 1
  cbi TXD_PORT, TXD_PIN
  sbrc r16, 1
  sbi TXD_PORT, TXD_PIN
  rcall bit_delay
  sbrs r16, 2
  cbi TXD_PORT, TXD_PIN
  sbrc r16, 2
  sbi TXD_PORT, TXD_PIN
  rcall bit_delay
  sbrs r16, 3
  cbi TXD_PORT, TXD_PIN
  sbrc r16, 3
  sbi TXD_PORT, TXD_PIN
  rcall bit_delay
  sbrs r16, 4
  cbi TXD_PORT, TXD_PIN
  sbrc r16, 4
  sbi TXD_PORT, TXD_PIN
  rcall bit_delay
  sbrs r16, 5
  cbi TXD_PORT, TXD_PIN
  sbrc r16, 5
  sbi TXD_PORT, TXD_PIN
  rcall bit_delay
  sbrs r16, 6
  cbi TXD_PORT, TXD_PIN
  sbrc r16, 6
  sbi TXD_PORT, TXD_PIN
  rcall bit_delay
  sbrs r16, 7
  cbi TXD_PORT, TXD_PIN
  sbrc r16, 7
  sbi TXD_PORT, TXD_PIN
  rcall bit_delay
  ; stop bit
  sbi TXD_PORT, TXD_PIN
  rcall bit_delay
  rcall bit_delay
  rcall bit_delay
  ret

;-----------------------------------------------------------------------------:
; 24bit/24bit Unsigned Division
;
; Register Variables
;  Call:  var1[2:0] = dividend (0x000000..0xffffff)
;         var2[2:0] = divisor (0x000001..0x7fffff)
;         mod[2:0]  = <don't care>
;         lc        = <don't care> (high register must be allocated)
;
;  Result:var1[2:0] = var1[2:0] / var2[2:0]
;         var2[2:0] = <not changed>
;         mod[2:0]  = var1[2:0] % var2[2:0]
;         lc        = 0
;
; Size  = 21 words
; Clock = 348..412 cycles (+ret)
; Stack = 0 bytes

.def var10=r16
.def var11=r24
.def var12=r25
.def var20=r17
.def var21=r23; zero
.def var22=r23; zero
.def mod0=r18
.def mod1=r19
.def mod2=r20
.def lc=r21

div24u:
		clr	mod0		;initialize variables
		clr	mod1		;  mod = 0;
		clr	mod2		;  lc = 24;
		ldi	lc,24		;/
					;---- calcurating loop
div24u_loop:
		lsl	var10		;var1 = var1 << 1;
		rol	var11		;
		rol	var12		;/
		rol	mod0		;mod = mod << 1 + carry;
		rol	mod1		;
		rol	mod2		;/
		cp	mod0,var20	;if (mod => var2) {
		cpc	mod1,var21	; mod -= var2; var1++;
		cpc	mod2,var22	; }
		brcs	div24u_next		;
		inc	var10		;
		sub	mod0,var20	;
		sbc	mod1,var21	;
		sbc	mod2,var22	;
div24u_next:
		dec	lc		;if (--lc > 0)
		brne	div24u_loop		; continue loop;
		ret

put_decimal:
  clr  r0
  ldi r17, 10
Next_dec:
  rcall div24u
  push r18
  inc  r0
  tst  cnt3
  brne Next_dec
  tst  cnt2
  brne Next_dec
  tst  r16
  brne Next_dec
Next_dec2:
  pop   r16
  subi  r16, -'0'
  rcall put_ch
  dec   r0
  brne Next_dec2
  ret
