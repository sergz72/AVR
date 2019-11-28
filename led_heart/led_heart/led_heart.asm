.equ FOSC   = 4000000

.equ PWM_MAX = FOSC / 8 / 256 / 50

.equ MODE_MAX=6

.equ LEDA_MASK = 3 ; PA0, PA1
.equ LEDB_MASK = $FF ; PB0-PB7
.equ LEDD_MASK = $77 ; PD0,PD1,PD2,PD4,PD5,PD6

.equ BUTTON_PINPORT = PIND
.equ BUTTON_PIN  = PIND3

.def led0_counter=r0
.def led1_counter=r1
.def led2_counter=r2
.def led3_counter=r3
.def led4_counter=r4
.def led5_counter=r5
.def led6_counter=r6
.def led7_counter=r7
.def led8_counter=r8
.def led9_counter=r9
.def led10_counter=r10
.def led11_counter=r11
.def led12_counter=r12
.def led13_counter=r13
.def led14_counter=r14
.def led15_counter=r15
.def mode_changed=r19
.def delay_counter=r20
.def tmpSREG = r21
.def blocking_interval=r22
.def zero=r23
.def mode=r24
.def PWM_counter=r25

.org 0
  rjmp Start
.org INT1addr
  rjmp INT1_Handler
.org OVF0addr
  rjmp PWM_handler

INT1_Handler:
  in  tmpSREG, SREG
  ; disable INT1
  out  GIMSK, zero
  rcall idle_mode_enable
  rcall start_timer0
  ldi  blocking_interval, 100
  out  SREG, tmpSREG
  reti

PWM_Handler:
  in  tmpSREG, SREG
  tst blocking_interval
  breq not_blocked ; if blocking_interval == 0
  dec blocking_interval
  brne blocked
  sbic BUTTON_PINPORT, BUTTON_PIN
  rjmp not_blocked
  ser mode_changed
  inc mode
  cpi mode, MODE_MAX+1
  brlo mode_ok
  clr mode
mode_ok:
  clr PWM_counter
not_blocked:
  sbis BUTTON_PINPORT, BUTTON_PIN
  rjmp blocked
  ; enable INT1
  ldi  r16, (1<<INT1)
  out  GIMSK, r16
  tst mode
  brne blocked
  rcall power_down_mode_enable
  rcall LED_Off
  rcall stop_timer0
mode_off:
  out  SREG, tmpSREG
  reti
blocked:
  tst mode
  breq mode_off
  tst PWM_counter
  breq PWM_0
  inc  PWM_counter
  cpi  PWM_counter, PWM_MAX
  brlo PWM_next_
  clr  PWM_counter
PWM_next_:
  rjmp PWM_next
PWM_0:
  cpse delay_counter, zero
  dec  delay_counter
  inc  PWM_counter
  rcall LED_Off
  ldi  XL, low(led_state)
  ldi  XH, high(led_state)
  ld   r16, X+
  mov  led0_counter,r16
  tst  r16
  breq led0_off
  cbi  PORTB, PORTB4
led0_off:
  ld   r16, X+
  mov  led1_counter,r16
  tst  r16
  breq led1_off
  cbi  PORTB, PORTB5
led1_off:
  ld   r16, X+
  mov  led2_counter,r16
  tst  r16
  breq led2_off
  cbi  PORTB, PORTB6
led2_off:
  ld   r16, X+
  mov  led3_counter,r16
  tst  r16
  breq led3_off
  cbi  PORTB, PORTB7
led3_off:
  ld   r16, X+
  mov  led4_counter,r16
  tst  r16
  breq led4_off
  cbi  PORTD, PORTD0
led4_off:
  ld   r16, X+
  mov  led5_counter,r16
  tst  r16
  breq led5_off
  cbi  PORTD, PORTD1
led5_off:
  ld   r16, X+
  mov  led6_counter,r16
  tst  r16
  breq led6_off
  cbi  PORTA, PORTA1
led6_off:
  ld   r16, X+
  mov  led7_counter,r16
  tst  r16
  breq led7_off
  cbi  PORTA, PORTA0
led7_off:
  ld   r16, X+
  mov  led8_counter,r16
  tst  r16
  breq led8_off
  cbi  PORTD, PORTD2
led8_off:
  ld   r16, X+
  mov  led9_counter,r16
  tst  r16
  breq led9_off
  cbi  PORTD, PORTD4
led9_off:
  ld   r16, X+
  mov  led10_counter,r16
  tst  r16
  breq led10_off
  cbi  PORTD, PORTD5
led10_off:
  ld   r16, X+
  mov  led11_counter,r16
  tst  r16
  breq led11_off
  cbi  PORTD, PORTD6
led11_off:
  ld   r16, X+
  mov  led12_counter,r16
  tst  r16
  breq led12_off
  cbi  PORTB, PORTB0
led12_off:
  ld   r16, X+
  mov  led13_counter,r16
  tst  r16
  breq led13_off
  cbi  PORTB, PORTB1
led13_off:
  ld   r16, X+
  mov  led14_counter,r16
  tst  r16
  breq led14_off
  cbi  PORTB, PORTB2
led14_off:
  ld   r16, X+
  mov  led15_counter,r16
  tst  r16
  breq led15_off
  cbi  PORTB, PORTB3
led15_off:
  out  SREG, tmpSREG
  reti
PWM_next:
  tst  led0_counter
  breq led1_check
  dec  led0_counter
  brne led1_check
  ; led 0 off
  sbi  PORTB, PORTB4
led1_check:
  tst  led1_counter
  breq led2_check
  dec  led1_counter
  brne led2_check
  ; led 1 off
  sbi  PORTB, PORTB5
led2_check:
  tst  led2_counter
  breq led3_check
  dec  led2_counter
  brne led3_check
  ; led 2 off
  sbi  PORTB, PORTB6
led3_check:
  tst  led3_counter
  breq led4_check
  dec  led3_counter
  brne led4_check
  ; led 3 off
  sbi  PORTB, PORTB7
led4_check:
  tst  led4_counter
  breq led5_check
  dec  led4_counter
  brne led5_check
  ; led 4 off
  sbi  PORTD, PORTD0
led5_check:
  tst  led5_counter
  breq led6_check
  dec  led5_counter
  brne led6_check
  ; led 5 off
  sbi  PORTD, PORTD1
led6_check:
  tst  led6_counter
  breq led7_check
  dec  led6_counter
  brne led7_check
  ; led 6 off
  sbi  PORTA, PORTA1
led7_check:
  tst  led7_counter
  breq led8_check
  dec  led7_counter
  brne led8_check
  ; led 7 off
  sbi  PORTA, PORTA0
led8_check:
  tst  led8_counter
  breq led9_check
  dec  led8_counter
  brne led9_check
  ; led 8 off
  sbi  PORTD, PORTD2
led9_check:
  tst  led9_counter
  breq led10_check
  dec  led9_counter
  brne led10_check
  ; led 9 off
  sbi  PORTD, PORTD4
led10_check:
  tst  led10_counter
  breq led11_check
  dec  led10_counter
  brne led11_check
  ; led 10 off
  sbi  PORTD, PORTD5
led11_check:
  tst  led11_counter
  breq led12_check
  dec  led11_counter
  brne led12_check
  ; led 11 off
  sbi  PORTD, PORTD6
led12_check:
  tst  led12_counter
  breq led13_check
  dec  led12_counter
  brne led13_check
  ; led 12 off
  sbi  PORTB, PORTB0
led13_check:
  tst  led13_counter
  breq led14_check
  dec  led13_counter
  brne led14_check
  ; led 13 off
  sbi  PORTB, PORTB1
led14_check:
  tst  led14_counter
  breq led15_check
  dec  led14_counter
  brne led15_check
  ; led 14 off
  sbi  PORTB, PORTB2
led15_check:
  tst  led15_counter
  breq led_check_done
  dec  led15_counter
  brne led_check_done
  ; led 15 off
  sbi  PORTB, PORTB3
led_check_done:
  out  SREG, tmpSREG
  reti

Start:
  ; Initialize the stack pointer
  ldi r16, RAMEND	;  SP <-- RAMEND
  out SPL, r16

  ; LED Off
  rcall Led_Off
  ldi r16, LEDA_MASK
  out DDRA, r16
  ldi r16, LEDB_MASK
  out DDRB, r16
  ldi r16, LEDD_MASK
  out DDRD, r16

  ; Enable Timer 0 interrupt
  ldi r16, (1<<TOIE0)
  out TIMSK, r16

  ; enable INT1
  ldi  r16, (1<<INT1)
  out  GIMSK, r16

  ; disable analog comparator
  sbi ACSR, ACD

  clr mode
  clr zero
  clr delay_counter

  rcall power_down_mode_enable

  sei

main_loop:
  clr mode_changed
  ldi ZL, low(program_table)
  ldi ZH, high(program_table)
  add ZL, mode
  adc ZH, zero
  icall
  rjmp main_loop

start_timer0:
  ; Timer 0 - clkI/O/8 (From prescaler)
  out TCNT0, zero
  ldi r16, (1<<CS01)
  out TCCR0B, r16
  ret

stop_timer0:
  ; Timer 0 - stopped
  out TCCR0B, zero
  ret

delay:
  cpse mode_changed, zero
  ret
  sleep
  tst delay_counter
  brne delay
  ret

power_down_mode_enable:
  ; Enable sleep command, power down mode, low level interrupt on INT1
  ldi r16, (1<<SE)|(1<<SM1)
  out MCUCR, r16
  ret
idle_mode_enable:
  ; Enable sleep command, idle mode, low level  interrupt on INT1
  ldi r16, (1<<SE)
  out MCUCR, r16
  ret

LED_Off:
  ; LED Off
  ldi r16, LEDA_MASK
  out PORTA, r16
  ldi r16, LEDB_MASK
  out PORTB, r16
  ldi r16, LEDD_MASK|(1<<3); INT1
  out PORTD, r16
  ret

program_table:
  rjmp mode0_program
  rjmp mode1_program
  rjmp mode2_program
  rjmp mode3_program
  rjmp mode4_program
  rjmp mode5_program
  rjmp mode6_program

mode0_program:
  sleep
  ret

mode1_program:
  ldi YL, low(led_state)
  ldi YH, high(led_state)
  ldi r17, PWM_MAX
  ldi r18, 16
st_1:
  st  Y+, r17
  dec r18
  brne st_1
  ldi delay_counter, 100
  rcall delay
  ret

mode2_program:
  clr r17
st_2n:
  ldi YL, low(led_state)
  ldi YH, high(led_state)
  ldi r18, 16
st_2:
  st  Y+, r17
  dec r18
  brne st_2
  ldi delay_counter, 1
  rcall delay
  inc r17
  cpi r17, PWM_MAX+1
  brlo st_2n
st_22n:
  ldi YL, low(led_state)
  ldi YH, high(led_state)
  dec r17
  ldi r18, 16
st_22:
  st  Y+, r17
  dec r18
  brne st_22
  ldi delay_counter, 1
  rcall delay
  tst r17
  brne st_22n
  ret

mode3_program:
  ldi r17, 1
  clr r18
st_3:
  rcall led_set
  ldi delay_counter, 4
  rcall delay
  clc
  lsl r17
  rol r18
  tst r17
  brne st_3
  tst r18
  brne st_3
  ret

mode4_program:
  ldi r17, 1
  mov r18, r17
st_4:
  rcall led_set
  ldi delay_counter, 4
  rcall delay
  clc
  lsl r17
  rol r18
  tst r17
  brne st_4
  ret

mode5_program:
  ldi r17, $55
  mov r18, r17
  rcall led_set
  ldi delay_counter, 30
  rcall delay
  ldi r17, $AA
  mov r18, r17
  rcall led_set
  ldi delay_counter, 30
  rcall delay
  ret

mode6_program:
  ldi r17, 1
  clr r18
  rcall led_set
  ldi delay_counter, 4
  rcall delay
  ldi r17, 3
  ldi r18, $80
  rcall led_set
  ldi delay_counter, 4
  rcall delay
  ldi r17, 7
  ldi r18, $C0
  rcall led_set
  ldi delay_counter, 4
  rcall delay
  ldi r17, $F
  ldi r18, $E0
  rcall led_set
  ldi delay_counter, 4
  rcall delay
  ldi r17, $1F
  ldi r18, $F0
  rcall led_set
  ldi delay_counter, 4
  rcall delay
  ldi r17, $3F
  ldi r18, $F8
  rcall led_set
  ldi delay_counter, 4
  rcall delay
  ldi r17, $7F
  ldi r18, $FC
  rcall led_set
  ldi delay_counter, 4
  rcall delay
  ldi r17, $FF
  ldi r18, $FE
  rcall led_set
  ldi delay_counter, 4
  rcall delay
  ldi r17, $FF
  mov r18, r17
  rcall led_set
  ldi delay_counter, 4
  rcall delay
  ldi r17, $FE
  ldi r18, $FF
  rcall led_set
  ldi delay_counter, 4
  rcall delay
  ldi r17, $FC
  ldi r18, $7F
  rcall led_set
  ldi delay_counter, 4
  rcall delay
  ldi r17, $F8
  ldi r18, $3F
  rcall led_set
  ldi delay_counter, 4
  rcall delay
  ldi r17, $F0
  ldi r18, $1F
  rcall led_set
  ldi delay_counter, 4
  rcall delay
  ldi r17, $E0
  ldi r18, $0F
  rcall led_set
  ldi delay_counter, 4
  rcall delay
  ldi r17, $C0
  ldi r18, $07
  rcall led_set
  ldi delay_counter, 4
  rcall delay
  ldi r17, $80
  ldi r18, $03
  rcall led_set
  ldi delay_counter, 4
  rcall delay
  clr r17
  ldi r18, 1
  rcall led_set
  ldi delay_counter, 4
  rcall delay
  ret

led_set:
  push r17
  push r18
  ldi YL, low(led_state)
  ldi YH, high(led_state)
  rcall led_set__
  pop r18
  mov r17, r18
  push r18
  rcall led_set__
  pop r18
  pop r17
  ret

led_set__:
  clr r18
led_set_:
  lsr r17
  push r17
  brcc set_0
  ldi  r17, PWM_MAX
set_:
  st  Y+, r17
  pop r17
  inc r18
  cpi r18, 8
  brlo led_set_
  ret
set_0:
  clr r17
  rjmp set_

.dseg

led_state:
  .byte 16

