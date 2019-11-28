  ldi r16, 19
  ldi r17, 25
  clt
  rcall ir_receive
  brcc _ok1
  rjmp ir_receive_failure
_ok1:
  ldi r16, 7
  ldi r17, 11
  rcall ir_receive
  brcc _ok2
  rjmp ir_receive_failure
_ok2:
  ldi r16, 3
  ldi r17, 7
  rcall ir_receive
  brcc _ok3
  rjmp ir_receive_failure
_ok3:
  rcall ir_receive
  brcc _ok4
  rjmp ir_receive_failure
_ok4:
  rcall ir_receive
  brcc _ok5
  rjmp ir_receive_failure
_ok5:
  rcall ir_receive
  brcc _ok6
  rjmp ir_receive_failure
_ok6:
  rcall ir_receive
  brcc _ok7
  rjmp ir_receive_failure
_ok7:
  ldi r16, 7
  ldi r17, 11
  rcall ir_receive
  brcc _ok8
  rjmp ir_receive_failure
_ok8:
  ldi r16, 3
  ldi r17, 7
  rcall ir_receive
  brcs ir_receive_failure
  ldi r16, 7
  ldi r17, 11
  rcall ir_receive
  brcs ir_receive_failure
  ldi r16, 10
  ldi r17, 15
  rcall ir_receive
  brcs ir_receive_failure
  ldi r16, 7
  ldi r17, 11
  rcall ir_receive
  brcs ir_receive_failure
  ldi   r18, $80
  rcall ir_receive_byte
  brcs ir_receive_failure
  mov  r0, r1
  ldi   r18, $80
  rcall ir_receive_byte
  brcs ir_receive_failure
  mov  r2, r1
  ldi   r18, $80
  rcall ir_receive_byte
  brcs ir_receive_failure
  mov  r16, r1
  ldi   r18, $20
  rcall ir_receive_byte
  brcs ir_receive_failure
; packet received
  cli
  clr  receive_counter
  ldi  r17, low(RECEIVE_BLOCK_INTERVAL)
  mov  receive_blocked_counter_l, r17
  ldi  r17, high(RECEIVE_BLOCK_INTERVAL)
  mov  receive_blocked_counter_h, r17
  sei
  ldi  ZL, low(2*button_codes)
  ldi  ZH, high(2*button_codes)
  lpm  r17, Z+
  adiw ZH:ZL, 1
next_cmp:
  lpm  r18, Z+
  cp   r18, r0
  brne no_1
  lpm  r18, Z+
  cp   r18, r2
  brne no_2
  lpm  r18, Z+
  cp   r18, r16
  brne no_3
  lpm  r18, Z+
  cp   r18, r1
  brne no_4
  lpm  r16, Z+
  lpm  r17, Z+
  movw ZH:ZL, R17:r16
  icall
  rjmp Sleep_
no_1:
  adiw ZH:ZL, 1
no_2:
  adiw ZH:ZL, 1
no_3:
  adiw ZH:ZL, 1
no_4:
  adiw ZH:ZL, 2
  dec r17
  brne next_cmp
  rjmp Sleep_

ir_receive_failure:
  ldi  r16, -20
  mov  receive_counter, r16
  rjmp Sleep_

ir_receive:
  push r18
  brts wait_0
  set
wait_1:
  mov  r18, receive_counter
  cpi  r18, 30
  brlo _ok
_err:
  sec
  pop r18
  ret
_ok:
  sbis PIND, PIND2
  rjmp wait_1
check_timing:
  mov r0, r18
  ldi r18, 1
  mov receive_counter, r18
  cp  r0, r16
  brlo _err
  cp  r0, r17
  brsh _err
  clc
  pop r18
  ret
wait_0:
  clt
wait_01:
  mov  r18, receive_counter
  cpi  r18, 30
  brsh _err
  sbic PIND, PIND2
  rjmp wait_01
  rjmp check_timing

ir_receive_byte:
  push r16
  push r0
  push r18
  clr r1
receive_next:
  lsr  r1
  ldi r16, 3
  ldi r17, 11
  rcall ir_receive
  brcs byte_receive_failure
  mov  r16, r0
  cpi  r16, 6
  brlo bit_0
  pop  r16
  or   r1, r16
  push r16
receive_next1:
  lsr  r18
  brne receive_next
  clc
  pop r18
  pop r0
  pop r16
  ret
bit_0:
  ldi r16, 3
  ldi r17, 7
  rcall ir_receive
  brcc receive_next1
byte_receive_failure:
  sec
  pop r18
  pop r0
  pop r16
  ret
