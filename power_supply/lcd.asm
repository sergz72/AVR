.include "lcdconf.inc"

LcdInit:
  cbi E_PORT, E_BIT
  sbi E_CTRL, E_BIT
  sbi RW_CTRL, RW_BIT
  sbi RS_CTRL, RS_BIT
	ldi r17, $30 + ((LCD_DISPLAY_LINES-1)<<3)
  rcall lcd_command
	ldi r17, 6
  rcall lcd_command
	rcall lcd_display_on
	rcall lcd_display_clear
  ret

lcd_display_clear:
  ldi r17, 1
  rcall lcd_command
; Wait 2 ms
  ldi r16, low(FOSC / 2000)
  ldi r17, high(FOSC / 2000)
clear_loop:
  tst r16
  breq clear_loop2
  dec r16
  rjmp clear_loop
clear_loop2:
  tst r17
  breq clear_loop_exit
  dec r16
  dec r17
  rjmp clear_loop
clear_loop_exit:
  ret

lcd_display_on:
lcd_cursor_off:
  ldi r17, $0C
  rcall lcd_command
  ret

lcd_cursor_on:
  ldi r17, $0F
  rcall lcd_command
  ret

lcd_display_off:
  ldi r17, $08
  rcall lcd_command
  ret

; R17 - command
lcd_command:
  rcall lcd_wait
  cbi RS_PORT, RS_BIT
	cbi RW_PORT, RW_BIT
  rcall lcd_data_set_proc
	sbi E_PORT, E_BIT
	rcall lcd_delay_250
	cbi E_PORT, E_BIT
	rcall lcd_delay_250
	rcall lcd_data_reset_proc
  ret

lcd_data_set_proc:
  lcd_data_set
	ret

lcd_data_reset_proc:
  lcd_data_reset
	ret

lcd_data_get_proc:
  lcd_data_get
	ret

lcd_delay_250:
  ldi r16, FOSC / 200000
lcd_delay_next:
	dec r16
	brge lcd_delay_next
  ret

lcd_wait:
  rcall lcd_read_cmd_reg
	sbrs  r16, 7
	ret
	rjmp lcd_wait

lcd_read_cmd_reg:
  cbi RS_PORT, RS_BIT
	sbi RW_PORT, RW_BIT
	sbi E_PORT, E_BIT
	rcall lcd_delay_250
  rcall lcd_data_get_proc
	mov r0, r16
	cbi E_PORT, E_BIT
	rcall lcd_delay_250
	mov r16, r0
  ret

; R17 - DDRAM address
lcd_set_address:
  mov r1, r17
  ori r17, $80
  rcall lcd_command
	mov r17, r1
  ret
  
; R18 DDRAM data
lcd_ddram_write:
  rcall lcd_wait
  sbi RS_PORT, RS_BIT
	cbi RW_PORT, RW_BIT
	mov r0, r17
	mov r17, r18
  rcall lcd_data_set_proc
	sbi E_PORT, E_BIT
	rcall lcd_delay_250
	cbi E_PORT, E_BIT
	rcall lcd_delay_250
	cbi E_PORT, E_BIT
	rcall lcd_data_reset_proc
	mov r17, r0
	inc r17
  ret


