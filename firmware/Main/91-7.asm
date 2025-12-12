
_rtc_read:

;ds1305_lib.h,2 :: 		void rtc_read()
;ds1305_lib.h,4 :: 		shorttostr(current_time.year,tmp3);
	PUSH	W10
	PUSH	W11
	MOV	#lo_addr(_tmp3), W11
	MOV	#lo_addr(_current_time+6), W0
	MOV.B	[W0], W10
	CALL	_ShortToStr
;ds1305_lib.h,5 :: 		datetimesec[2]=tmp3[2];
	MOV	#lo_addr(_datetimesec+2), W1
	MOV	#lo_addr(_tmp3+2), W0
	MOV.B	[W0], [W1]
;ds1305_lib.h,6 :: 		datetimesec[3]=tmp3[3];
	MOV	#lo_addr(_datetimesec+3), W1
	MOV	#lo_addr(_tmp3+3), W0
	MOV.B	[W0], [W1]
;ds1305_lib.h,7 :: 		shorttostr(current_time.month,tmp3);
	MOV	#lo_addr(_tmp3), W11
	MOV	#lo_addr(_current_time+5), W0
	MOV.B	[W0], W10
	CALL	_ShortToStr
;ds1305_lib.h,8 :: 		datetimesec[5]=tmp3[2];
	MOV	#lo_addr(_datetimesec+5), W1
	MOV	#lo_addr(_tmp3+2), W0
	MOV.B	[W0], [W1]
;ds1305_lib.h,9 :: 		datetimesec[6]=tmp3[3];
	MOV	#lo_addr(_datetimesec+6), W1
	MOV	#lo_addr(_tmp3+3), W0
	MOV.B	[W0], [W1]
;ds1305_lib.h,10 :: 		shorttostr(current_time.day,tmp3);
	MOV	#lo_addr(_tmp3), W11
	MOV	#lo_addr(_current_time+4), W0
	MOV.B	[W0], W10
	CALL	_ShortToStr
;ds1305_lib.h,11 :: 		datetimesec[8]=tmp3[2];
	MOV	#lo_addr(_datetimesec+8), W1
	MOV	#lo_addr(_tmp3+2), W0
	MOV.B	[W0], [W1]
;ds1305_lib.h,12 :: 		datetimesec[9]=tmp3[3];
	MOV	#lo_addr(_datetimesec+9), W1
	MOV	#lo_addr(_tmp3+3), W0
	MOV.B	[W0], [W1]
;ds1305_lib.h,13 :: 		shorttostr(current_time.hour,tmp3);
	MOV	#lo_addr(_tmp3), W11
	MOV	#lo_addr(_current_time+3), W0
	MOV.B	[W0], W10
	CALL	_ShortToStr
;ds1305_lib.h,14 :: 		datetimesec[11]=tmp3[2];
	MOV	#lo_addr(_datetimesec+11), W1
	MOV	#lo_addr(_tmp3+2), W0
	MOV.B	[W0], [W1]
;ds1305_lib.h,15 :: 		datetimesec[12]=tmp3[3];
	MOV	#lo_addr(_datetimesec+12), W1
	MOV	#lo_addr(_tmp3+3), W0
	MOV.B	[W0], [W1]
;ds1305_lib.h,16 :: 		shorttostr(current_time.minute,tmp3);
	MOV	#lo_addr(_tmp3), W11
	MOV	#lo_addr(_current_time+2), W0
	MOV.B	[W0], W10
	CALL	_ShortToStr
;ds1305_lib.h,17 :: 		datetimesec[14]=tmp3[2];
	MOV	#lo_addr(_datetimesec+14), W1
	MOV	#lo_addr(_tmp3+2), W0
	MOV.B	[W0], [W1]
;ds1305_lib.h,18 :: 		datetimesec[15]=tmp3[3];
	MOV	#lo_addr(_datetimesec+15), W1
	MOV	#lo_addr(_tmp3+3), W0
	MOV.B	[W0], [W1]
;ds1305_lib.h,19 :: 		shorttostr(current_time.second,tmp3);
	MOV	#lo_addr(_tmp3), W11
	MOV	#lo_addr(_current_time+1), W0
	MOV.B	[W0], W10
	CALL	_ShortToStr
;ds1305_lib.h,20 :: 		datetimesec[17]=tmp3[2];
	MOV	#lo_addr(_datetimesec+17), W1
	MOV	#lo_addr(_tmp3+2), W0
	MOV.B	[W0], [W1]
;ds1305_lib.h,21 :: 		datetimesec[18]=tmp3[3];
	MOV	#lo_addr(_datetimesec+18), W1
	MOV	#lo_addr(_tmp3+3), W0
	MOV.B	[W0], [W1]
;ds1305_lib.h,22 :: 		datetimesec[20]=(char)((milisec/100)+48);
	MOV	#100, W2
	MOV	_milisec, W0
	REPEAT	#17
	DIV.S	W0, W2
	MOV	W0, W3
	MOV.B	#48, W1
	MOV	#lo_addr(_datetimesec+20), W0
	ADD.B	W3, W1, [W0]
	MOV	#lo_addr(_datetimesec+20), W1
	MOV	#lo_addr(_datetimesec+20), W0
	MOV.B	[W0], [W1]
;ds1305_lib.h,23 :: 		for(rtc_read_cnt=0;rtc_read_cnt<strlen(datetimesec);rtc_read_cnt++) if(datetimesec[rtc_read_cnt]==' ') datetimesec[rtc_read_cnt]='0';
	MOV	#lo_addr(_rtc_read_cnt), W1
	CLR	W0
	MOV.B	W0, [W1]
L_rtc_read0:
	MOV	#lo_addr(_datetimesec), W10
	CALL	_strlen
	MOV	#lo_addr(_rtc_read_cnt), W1
	SE	[W1], W1
	CP	W1, W0
	BRA LT	L__rtc_read1045
	GOTO	L_rtc_read1
L__rtc_read1045:
	MOV	#lo_addr(_rtc_read_cnt), W0
	SE	[W0], W1
	MOV	#lo_addr(_datetimesec), W0
	ADD	W0, W1, W0
	MOV.B	[W0], W1
	MOV.B	#32, W0
	CP.B	W1, W0
	BRA Z	L__rtc_read1046
	GOTO	L_rtc_read3
L__rtc_read1046:
	MOV	#lo_addr(_rtc_read_cnt), W0
	SE	[W0], W1
	MOV	#lo_addr(_datetimesec), W0
	ADD	W0, W1, W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
L_rtc_read3:
	MOV.B	#1, W1
	MOV	#lo_addr(_rtc_read_cnt), W0
	ADD.B	W1, [W0], [W0]
	GOTO	L_rtc_read0
L_rtc_read1:
;ds1305_lib.h,24 :: 		}
L_end_rtc_read:
	POP	W11
	POP	W10
	RETURN
; end of _rtc_read

_rtc_init:

;ds1305_lib.h,25 :: 		void rtc_init()
;ds1305_lib.h,27 :: 		current_time.second=0;
	MOV	#lo_addr(_current_time+1), W1
	CLR	W0
	MOV.B	W0, [W1]
;ds1305_lib.h,28 :: 		current_time.minute=0;
	MOV	#lo_addr(_current_time+2), W1
	CLR	W0
	MOV.B	W0, [W1]
;ds1305_lib.h,29 :: 		current_time.hour=0;
	MOV	#lo_addr(_current_time+3), W1
	CLR	W0
	MOV.B	W0, [W1]
;ds1305_lib.h,30 :: 		current_time.day=1;
	MOV	#lo_addr(_current_time+4), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;ds1305_lib.h,31 :: 		current_time.month=1;
	MOV	#lo_addr(_current_time+5), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;ds1305_lib.h,32 :: 		current_time.year=0;
	MOV	#lo_addr(_current_time+6), W1
	CLR	W0
	MOV.B	W0, [W1]
;ds1305_lib.h,39 :: 		}
L_end_rtc_init:
	RETURN
; end of _rtc_init

_rtc_write:

;ds1305_lib.h,40 :: 		void rtc_write(char input)
;ds1305_lib.h,47 :: 		rtc=1;
	BSET	LATF0_bit, BitPos(LATF0_bit+0)
;ds1305_lib.h,48 :: 		if(input==1)
	CP.B	W10, #1
	BRA Z	L__rtc_write1049
	GOTO	L_rtc_write4
L__rtc_write1049:
;ds1305_lib.h,50 :: 		current_time.second=(uart1_data[15]-48)+(uart1_data[14]-48)*10;
	MOV	#lo_addr(_uart1_data+15), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W2
	MOV	#lo_addr(_uart1_data+14), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.UU	W1, W0, W0
	ADD	W2, W0, W1
	MOV	#lo_addr(_current_time+1), W0
	MOV.B	W1, [W0]
;ds1305_lib.h,51 :: 		current_time.minute=(uart1_data[13]-48)+(uart1_data[12]-48)*10;
	MOV	#lo_addr(_uart1_data+13), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W2
	MOV	#lo_addr(_uart1_data+12), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.UU	W1, W0, W0
	ADD	W2, W0, W1
	MOV	#lo_addr(_current_time+2), W0
	MOV.B	W1, [W0]
;ds1305_lib.h,52 :: 		current_time.hour=(uart1_data[11]-48)+(uart1_data[10]-48)*10;
	MOV	#lo_addr(_uart1_data+11), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W2
	MOV	#lo_addr(_uart1_data+10), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.UU	W1, W0, W0
	ADD	W2, W0, W1
	MOV	#lo_addr(_current_time+3), W0
	MOV.B	W1, [W0]
;ds1305_lib.h,53 :: 		current_time.day=(uart1_data[9]-48)+(uart1_data[8]-48)*10;
	MOV	#lo_addr(_uart1_data+9), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W2
	MOV	#lo_addr(_uart1_data+8), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.UU	W1, W0, W0
	ADD	W2, W0, W1
	MOV	#lo_addr(_current_time+4), W0
	MOV.B	W1, [W0]
;ds1305_lib.h,54 :: 		current_time.month=(uart1_data[7]-48)+(uart1_data[6]-48)*10;
	MOV	#lo_addr(_uart1_data+7), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W2
	MOV	#lo_addr(_uart1_data+6), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.UU	W1, W0, W0
	ADD	W2, W0, W1
	MOV	#lo_addr(_current_time+5), W0
	MOV.B	W1, [W0]
;ds1305_lib.h,55 :: 		current_time.year=(uart1_data[5]-48)+(uart1_data[4]-48)*10;
	MOV	#lo_addr(_uart1_data+5), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W2
	MOV	#lo_addr(_uart1_data+4), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.UU	W1, W0, W0
	ADD	W2, W0, W1
	MOV	#lo_addr(_current_time+6), W0
	MOV.B	W1, [W0]
;ds1305_lib.h,56 :: 		}
	GOTO	L_rtc_write5
L_rtc_write4:
;ds1305_lib.h,59 :: 		current_time.second=(uart2_data[15]-48)+(uart2_data[14]-48)*10;
	MOV	#lo_addr(_uart2_data+15), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W2
	MOV	#lo_addr(_uart2_data+14), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.UU	W1, W0, W0
	ADD	W2, W0, W1
	MOV	#lo_addr(_current_time+1), W0
	MOV.B	W1, [W0]
;ds1305_lib.h,60 :: 		current_time.minute=(uart2_data[13]-48)+(uart2_data[12]-48)*10;
	MOV	#lo_addr(_uart2_data+13), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W2
	MOV	#lo_addr(_uart2_data+12), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.UU	W1, W0, W0
	ADD	W2, W0, W1
	MOV	#lo_addr(_current_time+2), W0
	MOV.B	W1, [W0]
;ds1305_lib.h,61 :: 		current_time.hour=(uart2_data[11]-48)+(uart2_data[10]-48)*10;
	MOV	#lo_addr(_uart2_data+11), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W2
	MOV	#lo_addr(_uart2_data+10), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.UU	W1, W0, W0
	ADD	W2, W0, W1
	MOV	#lo_addr(_current_time+3), W0
	MOV.B	W1, [W0]
;ds1305_lib.h,62 :: 		current_time.day=(uart2_data[9]-48)+(uart2_data[8]-48)*10;
	MOV	#lo_addr(_uart2_data+9), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W2
	MOV	#lo_addr(_uart2_data+8), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.UU	W1, W0, W0
	ADD	W2, W0, W1
	MOV	#lo_addr(_current_time+4), W0
	MOV.B	W1, [W0]
;ds1305_lib.h,63 :: 		current_time.month=(uart2_data[7]-48)+(uart2_data[6]-48)*10;
	MOV	#lo_addr(_uart2_data+7), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W2
	MOV	#lo_addr(_uart2_data+6), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.UU	W1, W0, W0
	ADD	W2, W0, W1
	MOV	#lo_addr(_current_time+5), W0
	MOV.B	W1, [W0]
;ds1305_lib.h,64 :: 		current_time.year=(uart2_data[5]-48)+(uart2_data[4]-48)*10;
	MOV	#lo_addr(_uart2_data+5), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W2
	MOV	#lo_addr(_uart2_data+4), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.UU	W1, W0, W0
	ADD	W2, W0, W1
	MOV	#lo_addr(_current_time+6), W0
	MOV.B	W1, [W0]
;ds1305_lib.h,65 :: 		}
L_rtc_write5:
;ds1305_lib.h,88 :: 		rtc=0;
	BCLR	LATF0_bit, BitPos(LATF0_bit+0)
;ds1305_lib.h,90 :: 		}
L_end_rtc_write:
	RETURN
; end of _rtc_write

_send_atc:

;gprs.h,1 :: 		void send_atc(const char *s)
;gprs.h,3 :: 		while(*s)
L_send_atc6:
	MOV	#___Lib_System_DefaultPage, W0
	MOV	WREG, 52
	MOV.B	[W10], W0
	CP0.B	W0
	BRA NZ	L__send_atc1051
	GOTO	L_send_atc7
L__send_atc1051:
;gprs.h,5 :: 		if(*s!=10 && *s!=13 && *s!=' ')
	MOV	#___Lib_System_DefaultPage, W0
	MOV	WREG, 52
	MOV.B	[W10], W0
	CP.B	W0, #10
	BRA NZ	L__send_atc1052
	GOTO	L__send_atc838
L__send_atc1052:
	MOV	#___Lib_System_DefaultPage, W0
	MOV	WREG, 52
	MOV.B	[W10], W0
	CP.B	W0, #13
	BRA NZ	L__send_atc1053
	GOTO	L__send_atc837
L__send_atc1053:
	MOV	#___Lib_System_DefaultPage, W0
	MOV	WREG, 52
	MOV.B	[W10], W1
	MOV.B	#32, W0
	CP.B	W1, W0
	BRA NZ	L__send_atc1054
	GOTO	L__send_atc836
L__send_atc1054:
L__send_atc835:
;gprs.h,7 :: 		if(debug_gsm) UART1_Write(*s);
	MOV	#lo_addr(_debug_gsm), W0
	CP0.B	[W0]
	BRA NZ	L__send_atc1055
	GOTO	L_send_atc11
L__send_atc1055:
	MOV	#___Lib_System_DefaultPage, W0
	MOV	WREG, 52
	PUSH	W10
	ZE	[W10], W10
	CALL	_UART1_Write
	POP	W10
L_send_atc11:
;gprs.h,8 :: 		UART2_Write(*s);
	MOV	#___Lib_System_DefaultPage, W0
	MOV	WREG, 52
	PUSH	W10
	ZE	[W10], W10
	CALL	_UART2_Write
	POP	W10
;gprs.h,9 :: 		delay_us(15);
	MOV	#73, W7
L_send_atc12:
	DEC	W7
	BRA NZ	L_send_atc12
	NOP
	NOP
;gprs.h,5 :: 		if(*s!=10 && *s!=13 && *s!=' ')
L__send_atc838:
L__send_atc837:
L__send_atc836:
;gprs.h,11 :: 		s++;
	ADD	W10, #1, W0
	MOV	W0, W10
;gprs.h,14 :: 		}
	GOTO	L_send_atc6
L_send_atc7:
;gprs.h,15 :: 		}
L_end_send_atc:
	RETURN
; end of _send_atc

_send_out:

;gprs.h,16 :: 		void send_out(const char *s)
;gprs.h,18 :: 		while(*s)
L_send_out14:
	MOV	#___Lib_System_DefaultPage, W0
	MOV	WREG, 52
	MOV.B	[W10], W0
	CP0.B	W0
	BRA NZ	L__send_out1057
	GOTO	L_send_out15
L__send_out1057:
;gprs.h,20 :: 		if(*s!=10 && *s!=13)
	MOV	#___Lib_System_DefaultPage, W0
	MOV	WREG, 52
	MOV.B	[W10], W0
	CP.B	W0, #10
	BRA NZ	L__send_out1058
	GOTO	L__send_out841
L__send_out1058:
	MOV	#___Lib_System_DefaultPage, W0
	MOV	WREG, 52
	MOV.B	[W10], W0
	CP.B	W0, #13
	BRA NZ	L__send_out1059
	GOTO	L__send_out840
L__send_out1059:
L__send_out839:
;gprs.h,23 :: 		UART1_Write(*s);
	MOV	#___Lib_System_DefaultPage, W0
	MOV	WREG, 52
	PUSH	W10
	ZE	[W10], W10
	CALL	_UART1_Write
	POP	W10
;gprs.h,26 :: 		delay_us(15);
	MOV	#73, W7
L_send_out19:
	DEC	W7
	BRA NZ	L_send_out19
	NOP
	NOP
;gprs.h,20 :: 		if(*s!=10 && *s!=13)
L__send_out841:
L__send_out840:
;gprs.h,28 :: 		s++;
	ADD	W10, #1, W0
	MOV	W0, W10
;gprs.h,31 :: 		}
	GOTO	L_send_out14
L_send_out15:
;gprs.h,32 :: 		}
L_end_send_out:
	RETURN
; end of _send_out

_set_gprs_timer:

;gprs.h,33 :: 		void set_gprs_timer(unsigned short timer)
;gprs.h,35 :: 		gprs_timer=0;
	MOV	#lo_addr(_gprs_timer), W1
	CLR	W0
	MOV.B	W0, [W1]
;gprs.h,36 :: 		gprs_end_timer=timer+1;
	MOV	#lo_addr(_gprs_end_timer), W0
	ADD.B	W10, #1, [W0]
;gprs.h,37 :: 		gprs_timer_en=1;
	MOV	#lo_addr(_gprs_timer_en), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;gprs.h,38 :: 		}
L_end_set_gprs_timer:
	RETURN
; end of _set_gprs_timer

_sim900_restart:

;gprs.h,39 :: 		void sim900_restart()
;gprs.h,41 :: 		sim_reset=1;
	MOV	#lo_addr(_sim_reset), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;gprs.h,42 :: 		}
L_end_sim900_restart:
	RETURN
; end of _sim900_restart

_spifat_init:

;mmc.h,1 :: 		void spifat_init()
;mmc.h,3 :: 		SPI1_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64,_SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_IDLE_2_ACTIVE);
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	CLR	W13
	MOV	#28, W12
	CLR	W11
	MOV	#32, W10
	MOV	#256, W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CALL	_SPI1_Init_Advanced
	SUB	#8, W15
;mmc.h,4 :: 		if(0==Mmc_Init())
	CALL	_Mmc_Init
	CP	W0, #0
	BRA Z	L__spifat_init1063
	GOTO	L_spifat_init21
L__spifat_init1063:
;mmc.h,6 :: 		memory_error=0;
	MOV	#lo_addr(_memory_error), W1
	CLR	W0
	MOV.B	W0, [W1]
;mmc.h,7 :: 		}
	GOTO	L_spifat_init22
L_spifat_init21:
;mmc.h,10 :: 		delay_ms(1);
	MOV	#4914, W7
L_spifat_init23:
	DEC	W7
	BRA NZ	L_spifat_init23
	NOP
	NOP
;mmc.h,11 :: 		if(0==Mmc_Init())
	CALL	_Mmc_Init
	CP	W0, #0
	BRA Z	L__spifat_init1064
	GOTO	L_spifat_init25
L__spifat_init1064:
;mmc.h,13 :: 		memory_error=0;
	MOV	#lo_addr(_memory_error), W1
	CLR	W0
	MOV.B	W0, [W1]
;mmc.h,14 :: 		}
	GOTO	L_spifat_init26
L_spifat_init25:
;mmc.h,17 :: 		memory_error=1;
	MOV	#lo_addr(_memory_error), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;mmc.h,18 :: 		}
L_spifat_init26:
;mmc.h,19 :: 		SPI1_read(0);
	CLR	W10
	CALL	_SPI1_Read
;mmc.h,20 :: 		SPI1_read(0);
	CLR	W10
	CALL	_SPI1_Read
;mmc.h,21 :: 		}
L_spifat_init22:
;mmc.h,23 :: 		SPI1_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_4,_SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE); //SPI1_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_4, _SPI_PRESCALE_PRI_64,_SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);
	MOV	#2, W13
	MOV	#28, W12
	CLR	W11
	MOV	#32, W10
	CLR	W0
	PUSH	W0
	MOV	#64, W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CALL	_SPI1_Init_Advanced
	SUB	#8, W15
;mmc.h,24 :: 		SPI1_Write(0xFF);
	MOV	#255, W10
	CALL	_SPI1_Write
;mmc.h,25 :: 		}
L_end_spifat_init:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _spifat_init

_reset_interval_data:

;interval.h,1 :: 		void reset_interval_data()
;interval.h,3 :: 		for(jj=0;jj<262;jj++) interval_data[jj]='0';
	CLR	W0
	MOV	W0, _jj
L_reset_interval_data27:
	MOV	_jj, W1
	MOV	#262, W0
	CP	W1, W0
	BRA LT	L__reset_interval_data1066
	GOTO	L_reset_interval_data28
L__reset_interval_data1066:
	MOV	#lo_addr(_interval_data), W1
	MOV	#lo_addr(_jj), W0
	ADD	W1, [W0], W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
	MOV	#1, W1
	MOV	#lo_addr(_jj), W0
	ADD	W1, [W0], [W0]
	GOTO	L_reset_interval_data27
L_reset_interval_data28:
;interval.h,4 :: 		for(jj=0;jj<8;jj++) interval_data[jj]=system_id[jj];
	CLR	W0
	MOV	W0, _jj
L_reset_interval_data30:
	MOV	_jj, W0
	CP	W0, #8
	BRA LT	L__reset_interval_data1067
	GOTO	L_reset_interval_data31
L__reset_interval_data1067:
	MOV	#lo_addr(_interval_data), W1
	MOV	#lo_addr(_jj), W0
	ADD	W1, [W0], W2
	MOV	#lo_addr(_system_id), W1
	MOV	#lo_addr(_jj), W0
	ADD	W1, [W0], W1
	MOV	#___Lib_System_DefaultPage, W0
	MOV	WREG, 52
	MOV.B	[W1], W0
	MOV.B	W0, [W2]
	MOV	#1, W1
	MOV	#lo_addr(_jj), W0
	ADD	W1, [W0], [W0]
	GOTO	L_reset_interval_data30
L_reset_interval_data31:
;interval.h,5 :: 		interval_data[262]=13;
	MOV	#lo_addr(_interval_data+262), W1
	MOV.B	#13, W0
	MOV.B	W0, [W1]
;interval.h,6 :: 		interval_data[263]=10;
	MOV	#lo_addr(_interval_data+263), W1
	MOV.B	#10, W0
	MOV.B	W0, [W1]
;interval.h,7 :: 		interval_data[264]=0;
	MOV	#lo_addr(_interval_data+264), W1
	CLR	W0
	MOV.B	W0, [W1]
;interval.h,8 :: 		}
L_end_reset_interval_data:
	RETURN
; end of _reset_interval_data

_reset_interval:

;interval.h,9 :: 		void reset_interval()
;interval.h,11 :: 		current_interval.l1acount=0;
	CLR	W0
	MOV	W0, _current_interval
;interval.h,12 :: 		current_interval.l1avavg=0;
	MOV	#lo_addr(_current_interval+2), W1
	CLR	W0
	MOV.B	W0, [W1]
;interval.h,13 :: 		current_interval.l1aspeed=0;
	CLR	W0
	MOV	W0, _current_interval+4
;interval.h,14 :: 		current_interval.l1agrab=0;
	CLR	W0
	MOV	W0, _current_interval+6
;interval.h,15 :: 		current_interval.l1aheadway=0;
	CLR	W0
	MOV	W0, _current_interval+8
;interval.h,17 :: 		current_interval.l1bcount=0;
	CLR	W0
	MOV	W0, _current_interval+10
;interval.h,18 :: 		current_interval.l1bvavg=0;
	MOV	#lo_addr(_current_interval+12), W1
	CLR	W0
	MOV.B	W0, [W1]
;interval.h,19 :: 		current_interval.l1bspeed=0;
	CLR	W0
	MOV	W0, _current_interval+14
;interval.h,20 :: 		current_interval.l1bgrab=0;
	CLR	W0
	MOV	W0, _current_interval+16
;interval.h,21 :: 		current_interval.l1bheadway=0;
	CLR	W0
	MOV	W0, _current_interval+18
;interval.h,23 :: 		current_interval.l1ccount=0;
	CLR	W0
	MOV	W0, _current_interval+20
;interval.h,24 :: 		current_interval.l1cvavg=0;
	MOV	#lo_addr(_current_interval+22), W1
	CLR	W0
	MOV.B	W0, [W1]
;interval.h,25 :: 		current_interval.l1cspeed=0;
	CLR	W0
	MOV	W0, _current_interval+24
;interval.h,26 :: 		current_interval.l1cgrab=0;
	CLR	W0
	MOV	W0, _current_interval+26
;interval.h,27 :: 		current_interval.l1cheadway=0;
	CLR	W0
	MOV	W0, _current_interval+28
;interval.h,29 :: 		current_interval.l1dcount=0;
	CLR	W0
	MOV	W0, _current_interval+30
;interval.h,30 :: 		current_interval.l1dvavg=0;
	MOV	#lo_addr(_current_interval+32), W1
	CLR	W0
	MOV.B	W0, [W1]
;interval.h,31 :: 		current_interval.l1dspeed=0;
	CLR	W0
	MOV	W0, _current_interval+34
;interval.h,32 :: 		current_interval.l1dgrab=0;
	CLR	W0
	MOV	W0, _current_interval+36
;interval.h,33 :: 		current_interval.l1dheadway=0;
	CLR	W0
	MOV	W0, _current_interval+38
;interval.h,35 :: 		current_interval.l1ecount=0;
	CLR	W0
	MOV	W0, _current_interval+40
;interval.h,36 :: 		current_interval.l1evavg=0;
	MOV	#lo_addr(_current_interval+42), W1
	CLR	W0
	MOV.B	W0, [W1]
;interval.h,37 :: 		current_interval.l1espeed=0;
	CLR	W0
	MOV	W0, _current_interval+44
;interval.h,38 :: 		current_interval.l1egrab=0;
	CLR	W0
	MOV	W0, _current_interval+46
;interval.h,39 :: 		current_interval.l1eheadway=0;
	CLR	W0
	MOV	W0, _current_interval+48
;interval.h,41 :: 		current_interval.l1xcount=0;
	CLR	W0
	MOV	W0, _current_interval+50
;interval.h,42 :: 		current_interval.l1xvavg=0;
	MOV	#lo_addr(_current_interval+52), W1
	CLR	W0
	MOV.B	W0, [W1]
;interval.h,43 :: 		current_interval.l1xspeed=0;
	CLR	W0
	MOV	W0, _current_interval+54
;interval.h,44 :: 		current_interval.l1xgrab=0;
	CLR	W0
	MOV	W0, _current_interval+56
;interval.h,45 :: 		current_interval.l1xheadway=0;
	CLR	W0
	MOV	W0, _current_interval+58
;interval.h,47 :: 		current_interval.l2acount=0;
	CLR	W0
	MOV	W0, _current_interval+62
;interval.h,48 :: 		current_interval.l2avavg=0;
	MOV	#lo_addr(_current_interval+64), W1
	CLR	W0
	MOV.B	W0, [W1]
;interval.h,49 :: 		current_interval.l2aspeed=0;
	CLR	W0
	MOV	W0, _current_interval+66
;interval.h,50 :: 		current_interval.l2agrab=0;
	CLR	W0
	MOV	W0, _current_interval+68
;interval.h,51 :: 		current_interval.l2aheadway=0;
	CLR	W0
	MOV	W0, _current_interval+70
;interval.h,53 :: 		current_interval.l2bcount=0;
	CLR	W0
	MOV	W0, _current_interval+72
;interval.h,54 :: 		current_interval.l2bvavg=0;
	MOV	#lo_addr(_current_interval+74), W1
	CLR	W0
	MOV.B	W0, [W1]
;interval.h,55 :: 		current_interval.l2bspeed=0;
	CLR	W0
	MOV	W0, _current_interval+76
;interval.h,56 :: 		current_interval.l2bgrab=0;
	CLR	W0
	MOV	W0, _current_interval+78
;interval.h,57 :: 		current_interval.l2bheadway=0;
	CLR	W0
	MOV	W0, _current_interval+80
;interval.h,59 :: 		current_interval.l2ccount=0;
	CLR	W0
	MOV	W0, _current_interval+82
;interval.h,60 :: 		current_interval.l2cvavg=0;
	MOV	#lo_addr(_current_interval+84), W1
	CLR	W0
	MOV.B	W0, [W1]
;interval.h,61 :: 		current_interval.l2cvavgnew=0;
	MOV	#lo_addr(_current_interval+85), W1
	CLR	W0
	MOV.B	W0, [W1]
;interval.h,62 :: 		current_interval.l2cspeed=0;
	CLR	W0
	MOV	W0, _current_interval+86
;interval.h,63 :: 		current_interval.l2cgrab=0;
	CLR	W0
	MOV	W0, _current_interval+88
;interval.h,64 :: 		current_interval.l2cheadway=0;
	CLR	W0
	MOV	W0, _current_interval+90
;interval.h,66 :: 		current_interval.l2dcount=0;
	CLR	W0
	MOV	W0, _current_interval+92
;interval.h,67 :: 		current_interval.l2dvavg=0;
	MOV	#lo_addr(_current_interval+94), W1
	CLR	W0
	MOV.B	W0, [W1]
;interval.h,68 :: 		current_interval.l2dspeed=0;
	CLR	W0
	MOV	W0, _current_interval+96
;interval.h,69 :: 		current_interval.l2dgrab=0;
	CLR	W0
	MOV	W0, _current_interval+98
;interval.h,70 :: 		current_interval.l2dheadway=0;
	CLR	W0
	MOV	W0, _current_interval+100
;interval.h,72 :: 		current_interval.l2ecount=0;
	CLR	W0
	MOV	W0, _current_interval+102
;interval.h,73 :: 		current_interval.l2evavg=0;
	MOV	#lo_addr(_current_interval+104), W1
	CLR	W0
	MOV.B	W0, [W1]
;interval.h,74 :: 		current_interval.l2espeed=0;
	CLR	W0
	MOV	W0, _current_interval+106
;interval.h,75 :: 		current_interval.l2egrab=0;
	CLR	W0
	MOV	W0, _current_interval+108
;interval.h,76 :: 		current_interval.l2eheadway=0;
	CLR	W0
	MOV	W0, _current_interval+110
;interval.h,78 :: 		current_interval.l2xcount=0;
	CLR	W0
	MOV	W0, _current_interval+112
;interval.h,79 :: 		current_interval.l2xvavg=0;
	MOV	#lo_addr(_current_interval+114), W1
	CLR	W0
	MOV.B	W0, [W1]
;interval.h,80 :: 		current_interval.l2xspeed=0;
	CLR	W0
	MOV	W0, _current_interval+116
;interval.h,81 :: 		current_interval.l2xgrab=0;
	CLR	W0
	MOV	W0, _current_interval+118
;interval.h,82 :: 		current_interval.l2xheadway=0;
	CLR	W0
	MOV	W0, _current_interval+120
;interval.h,85 :: 		totalv1a=0;
	CLR	W0
	CLR	W1
	MOV	W0, _totalv1a
	MOV	W1, _totalv1a+2
;interval.h,86 :: 		totalv1b=0;
	CLR	W0
	CLR	W1
	MOV	W0, _totalv1b
	MOV	W1, _totalv1b+2
;interval.h,87 :: 		totalv1c=0;
	CLR	W0
	CLR	W1
	MOV	W0, _totalv1c
	MOV	W1, _totalv1c+2
;interval.h,88 :: 		totalv1d=0;
	CLR	W0
	CLR	W1
	MOV	W0, _totalv1d
	MOV	W1, _totalv1d+2
;interval.h,89 :: 		totalv1e=0;
	CLR	W0
	CLR	W1
	MOV	W0, _totalv1e
	MOV	W1, _totalv1e+2
;interval.h,90 :: 		totalv1x=0;
	CLR	W0
	CLR	W1
	MOV	W0, _totalv1x
	MOV	W1, _totalv1x+2
;interval.h,91 :: 		totalv2a=0;
	CLR	W0
	CLR	W1
	MOV	W0, _totalv2a
	MOV	W1, _totalv2a+2
;interval.h,92 :: 		totalv2b=0;
	CLR	W0
	CLR	W1
	MOV	W0, _totalv2b
	MOV	W1, _totalv2b+2
;interval.h,93 :: 		totalv2c=0;
	CLR	W0
	CLR	W1
	MOV	W0, _totalv2c
	MOV	W1, _totalv2c+2
;interval.h,95 :: 		totalv2d=0;
	CLR	W0
	CLR	W1
	MOV	W0, _totalv2d
	MOV	W1, _totalv2d+2
;interval.h,96 :: 		totalv2e=0;
	CLR	W0
	CLR	W1
	MOV	W0, _totalv2e
	MOV	W1, _totalv2e+2
;interval.h,97 :: 		totalv2x=0;
	CLR	W0
	CLR	W1
	MOV	W0, _totalv2x
	MOV	W1, _totalv2x+2
;interval.h,99 :: 		l1occ=0;
	CLR	W0
	CLR	W1
	MOV	W0, _l1occ
	MOV	W1, _l1occ+2
;interval.h,100 :: 		l2occ=0;
	CLR	W0
	CLR	W1
	MOV	W0, _l2occ
	MOV	W1, _l2occ+2
;interval.h,102 :: 		}
L_end_reset_interval:
	RETURN
; end of _reset_interval

_cal_interval:

;interval.h,103 :: 		void cal_interval()
;interval.h,105 :: 		reset_interval_data();
	PUSH	W10
	PUSH	W11
	CALL	_reset_interval_data
;interval.h,107 :: 		if(current_interval.l1acount>0) current_interval.l1avavg=(unsigned short)(totalv1a/current_interval.l1acount);
	MOV	_current_interval, W0
	CP	W0, #0
	BRA GT	L__cal_interval1070
	GOTO	L_cal_interval33
L__cal_interval1070:
	MOV	_current_interval, W2
	ASR	W2, #15, W3
	MOV	_totalv1a, W0
	MOV	_totalv1a+2, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_current_interval+2), W2
	MOV.B	W0, [W2]
	GOTO	L_cal_interval34
L_cal_interval33:
;interval.h,108 :: 		else  current_interval.l1avavg=0;
	MOV	#lo_addr(_current_interval+2), W1
	CLR	W0
	MOV.B	W0, [W1]
L_cal_interval34:
;interval.h,110 :: 		if(current_interval.l1bcount>0) current_interval.l1bvavg=(unsigned short)(totalv1b/current_interval.l1bcount);
	MOV	_current_interval+10, W0
	CP	W0, #0
	BRA GT	L__cal_interval1071
	GOTO	L_cal_interval35
L__cal_interval1071:
	MOV	_current_interval+10, W2
	ASR	W2, #15, W3
	MOV	_totalv1b, W0
	MOV	_totalv1b+2, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_current_interval+12), W2
	MOV.B	W0, [W2]
	GOTO	L_cal_interval36
L_cal_interval35:
;interval.h,111 :: 		else  current_interval.l1bvavg=0;
	MOV	#lo_addr(_current_interval+12), W1
	CLR	W0
	MOV.B	W0, [W1]
L_cal_interval36:
;interval.h,113 :: 		if(current_interval.l1ccount>0) current_interval.l1cvavg=(unsigned short)(totalv1c/current_interval.l1ccount);
	MOV	_current_interval+20, W0
	CP	W0, #0
	BRA GT	L__cal_interval1072
	GOTO	L_cal_interval37
L__cal_interval1072:
	MOV	_current_interval+20, W2
	ASR	W2, #15, W3
	MOV	_totalv1c, W0
	MOV	_totalv1c+2, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_current_interval+22), W2
	MOV.B	W0, [W2]
	GOTO	L_cal_interval38
L_cal_interval37:
;interval.h,114 :: 		else  current_interval.l1cvavg=0;
	MOV	#lo_addr(_current_interval+22), W1
	CLR	W0
	MOV.B	W0, [W1]
L_cal_interval38:
;interval.h,116 :: 		if(current_interval.l1dcount>0) current_interval.l1dvavg=(unsigned short)(totalv1d/current_interval.l1dcount);
	MOV	_current_interval+30, W0
	CP	W0, #0
	BRA GT	L__cal_interval1073
	GOTO	L_cal_interval39
L__cal_interval1073:
	MOV	_current_interval+30, W2
	ASR	W2, #15, W3
	MOV	_totalv1d, W0
	MOV	_totalv1d+2, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_current_interval+32), W2
	MOV.B	W0, [W2]
	GOTO	L_cal_interval40
L_cal_interval39:
;interval.h,117 :: 		else  current_interval.l1dvavg=0;
	MOV	#lo_addr(_current_interval+32), W1
	CLR	W0
	MOV.B	W0, [W1]
L_cal_interval40:
;interval.h,119 :: 		if(current_interval.l1ecount>0) current_interval.l1evavg=(unsigned short)(totalv1e/current_interval.l1ecount);
	MOV	_current_interval+40, W0
	CP	W0, #0
	BRA GT	L__cal_interval1074
	GOTO	L_cal_interval41
L__cal_interval1074:
	MOV	_current_interval+40, W2
	ASR	W2, #15, W3
	MOV	_totalv1e, W0
	MOV	_totalv1e+2, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_current_interval+42), W2
	MOV.B	W0, [W2]
	GOTO	L_cal_interval42
L_cal_interval41:
;interval.h,120 :: 		else  current_interval.l1evavg=0;
	MOV	#lo_addr(_current_interval+42), W1
	CLR	W0
	MOV.B	W0, [W1]
L_cal_interval42:
;interval.h,122 :: 		if(current_interval.l1xcount>0) current_interval.l1xvavg=(unsigned short)(totalv1x/current_interval.l1xcount);
	MOV	_current_interval+50, W0
	CP	W0, #0
	BRA GT	L__cal_interval1075
	GOTO	L_cal_interval43
L__cal_interval1075:
	MOV	_current_interval+50, W2
	ASR	W2, #15, W3
	MOV	_totalv1x, W0
	MOV	_totalv1x+2, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_current_interval+52), W2
	MOV.B	W0, [W2]
	GOTO	L_cal_interval44
L_cal_interval43:
;interval.h,123 :: 		else  current_interval.l1xvavg=0;
	MOV	#lo_addr(_current_interval+52), W1
	CLR	W0
	MOV.B	W0, [W1]
L_cal_interval44:
;interval.h,125 :: 		if(current_interval.l2acount>0) current_interval.l2avavg=(unsigned short)(totalv2a/current_interval.l2acount);
	MOV	_current_interval+62, W0
	CP	W0, #0
	BRA GT	L__cal_interval1076
	GOTO	L_cal_interval45
L__cal_interval1076:
	MOV	_current_interval+62, W2
	ASR	W2, #15, W3
	MOV	_totalv2a, W0
	MOV	_totalv2a+2, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_current_interval+64), W2
	MOV.B	W0, [W2]
	GOTO	L_cal_interval46
L_cal_interval45:
;interval.h,126 :: 		else  current_interval.l2avavg=0;
	MOV	#lo_addr(_current_interval+64), W1
	CLR	W0
	MOV.B	W0, [W1]
L_cal_interval46:
;interval.h,128 :: 		if(current_interval.l2bcount>0) current_interval.l2bvavg=(unsigned short)(totalv2b/current_interval.l2bcount);
	MOV	_current_interval+72, W0
	CP	W0, #0
	BRA GT	L__cal_interval1077
	GOTO	L_cal_interval47
L__cal_interval1077:
	MOV	_current_interval+72, W2
	ASR	W2, #15, W3
	MOV	_totalv2b, W0
	MOV	_totalv2b+2, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_current_interval+74), W2
	MOV.B	W0, [W2]
	GOTO	L_cal_interval48
L_cal_interval47:
;interval.h,129 :: 		else  current_interval.l2bvavg=0;
	MOV	#lo_addr(_current_interval+74), W1
	CLR	W0
	MOV.B	W0, [W1]
L_cal_interval48:
;interval.h,131 :: 		if(current_interval.l2ccount>0) current_interval.l2cvavg=(unsigned short)(totalv2c/(unsigned long)(current_interval.l2ccount));
	MOV	_current_interval+82, W0
	CP	W0, #0
	BRA GT	L__cal_interval1078
	GOTO	L_cal_interval49
L__cal_interval1078:
	MOV	_current_interval+82, W2
	ASR	W2, #15, W3
	MOV	_totalv2c, W0
	MOV	_totalv2c+2, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_current_interval+84), W2
	MOV.B	W0, [W2]
	GOTO	L_cal_interval50
L_cal_interval49:
;interval.h,132 :: 		else  current_interval.l2cvavg=0;
	MOV	#lo_addr(_current_interval+84), W1
	CLR	W0
	MOV.B	W0, [W1]
L_cal_interval50:
;interval.h,134 :: 		if(current_interval.l2dcount>0) current_interval.l2dvavg=(unsigned short)(totalv2d/current_interval.l2dcount);
	MOV	_current_interval+92, W0
	CP	W0, #0
	BRA GT	L__cal_interval1079
	GOTO	L_cal_interval51
L__cal_interval1079:
	MOV	_current_interval+92, W2
	ASR	W2, #15, W3
	MOV	_totalv2d, W0
	MOV	_totalv2d+2, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_current_interval+94), W2
	MOV.B	W0, [W2]
	GOTO	L_cal_interval52
L_cal_interval51:
;interval.h,135 :: 		else  current_interval.l2dvavg=0;
	MOV	#lo_addr(_current_interval+94), W1
	CLR	W0
	MOV.B	W0, [W1]
L_cal_interval52:
;interval.h,137 :: 		if(current_interval.l2ecount>0) current_interval.l2evavg=(unsigned short)(totalv2e/current_interval.l2ecount);
	MOV	_current_interval+102, W0
	CP	W0, #0
	BRA GT	L__cal_interval1080
	GOTO	L_cal_interval53
L__cal_interval1080:
	MOV	_current_interval+102, W2
	ASR	W2, #15, W3
	MOV	_totalv2e, W0
	MOV	_totalv2e+2, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_current_interval+104), W2
	MOV.B	W0, [W2]
	GOTO	L_cal_interval54
L_cal_interval53:
;interval.h,138 :: 		else  current_interval.l2evavg=0;
	MOV	#lo_addr(_current_interval+104), W1
	CLR	W0
	MOV.B	W0, [W1]
L_cal_interval54:
;interval.h,140 :: 		if(current_interval.l2xcount>0) current_interval.l2xvavg=(unsigned short)(totalv2x/current_interval.l2xcount);
	MOV	_current_interval+112, W0
	CP	W0, #0
	BRA GT	L__cal_interval1081
	GOTO	L_cal_interval55
L__cal_interval1081:
	MOV	_current_interval+112, W2
	ASR	W2, #15, W3
	MOV	_totalv2x, W0
	MOV	_totalv2x+2, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_current_interval+114), W2
	MOV.B	W0, [W2]
	GOTO	L_cal_interval56
L_cal_interval55:
;interval.h,141 :: 		else  current_interval.l2xvavg=0;
	MOV	#lo_addr(_current_interval+114), W1
	CLR	W0
	MOV.B	W0, [W1]
L_cal_interval56:
;interval.h,143 :: 		bytetostr(current_time.year,tmp3);
	MOV	#lo_addr(_tmp3), W11
	MOV	#lo_addr(_current_time+6), W0
	MOV.B	[W0], W10
	CALL	_ByteToStr
;interval.h,144 :: 		interval_data[8]=tmp3[1];
	MOV	#lo_addr(_interval_data+8), W1
	MOV	#lo_addr(_tmp3+1), W0
	MOV.B	[W0], [W1]
;interval.h,145 :: 		interval_data[9]=tmp3[2];
	MOV	#lo_addr(_interval_data+9), W1
	MOV	#lo_addr(_tmp3+2), W0
	MOV.B	[W0], [W1]
;interval.h,146 :: 		bytetostr(current_time.month,tmp3);
	MOV	#lo_addr(_tmp3), W11
	MOV	#lo_addr(_current_time+5), W0
	MOV.B	[W0], W10
	CALL	_ByteToStr
;interval.h,147 :: 		interval_data[10]=tmp3[1];
	MOV	#lo_addr(_interval_data+10), W1
	MOV	#lo_addr(_tmp3+1), W0
	MOV.B	[W0], [W1]
;interval.h,148 :: 		interval_data[11]=tmp3[2];
	MOV	#lo_addr(_interval_data+11), W1
	MOV	#lo_addr(_tmp3+2), W0
	MOV.B	[W0], [W1]
;interval.h,149 :: 		bytetostr(current_time.day,tmp3);
	MOV	#lo_addr(_tmp3), W11
	MOV	#lo_addr(_current_time+4), W0
	MOV.B	[W0], W10
	CALL	_ByteToStr
;interval.h,150 :: 		interval_data[12]=tmp3[1];
	MOV	#lo_addr(_interval_data+12), W1
	MOV	#lo_addr(_tmp3+1), W0
	MOV.B	[W0], [W1]
;interval.h,151 :: 		interval_data[13]=tmp3[2];
	MOV	#lo_addr(_interval_data+13), W1
	MOV	#lo_addr(_tmp3+2), W0
	MOV.B	[W0], [W1]
;interval.h,152 :: 		bytetostr(current_time.hour,tmp3);
	MOV	#lo_addr(_tmp3), W11
	MOV	#lo_addr(_current_time+3), W0
	MOV.B	[W0], W10
	CALL	_ByteToStr
;interval.h,153 :: 		interval_data[14]=tmp3[1];
	MOV	#lo_addr(_interval_data+14), W1
	MOV	#lo_addr(_tmp3+1), W0
	MOV.B	[W0], [W1]
;interval.h,154 :: 		interval_data[15]=tmp3[2];
	MOV	#lo_addr(_interval_data+15), W1
	MOV	#lo_addr(_tmp3+2), W0
	MOV.B	[W0], [W1]
;interval.h,155 :: 		bytetostr(current_time.minute,tmp3);
	MOV	#lo_addr(_tmp3), W11
	MOV	#lo_addr(_current_time+2), W0
	MOV.B	[W0], W10
	CALL	_ByteToStr
;interval.h,156 :: 		interval_data[16]=tmp3[1];
	MOV	#lo_addr(_interval_data+16), W1
	MOV	#lo_addr(_tmp3+1), W0
	MOV.B	[W0], [W1]
;interval.h,157 :: 		interval_data[17]=tmp3[2];
	MOV	#lo_addr(_interval_data+17), W1
	MOV	#lo_addr(_tmp3+2), W0
	MOV.B	[W0], [W1]
;interval.h,159 :: 		inttostr(current_interval.l1acount,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval, W10
	CALL	_IntToStr
;interval.h,160 :: 		interval_data[18]=tmp4[2];
	MOV	#lo_addr(_interval_data+18), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,161 :: 		interval_data[19]=tmp4[3];
	MOV	#lo_addr(_interval_data+19), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,162 :: 		interval_data[20]=tmp4[4];
	MOV	#lo_addr(_interval_data+20), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,163 :: 		interval_data[21]=tmp4[5];
	MOV	#lo_addr(_interval_data+21), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,165 :: 		bytetostr(current_interval.l1avavg,tmp3);
	MOV	#lo_addr(_tmp3), W11
	MOV	#lo_addr(_current_interval+2), W0
	MOV.B	[W0], W10
	CALL	_ByteToStr
;interval.h,166 :: 		interval_data[22]=tmp3[0];
	MOV	#lo_addr(_interval_data+22), W1
	MOV	#lo_addr(_tmp3), W0
	MOV.B	[W0], [W1]
;interval.h,167 :: 		interval_data[23]=tmp3[1];
	MOV	#lo_addr(_interval_data+23), W1
	MOV	#lo_addr(_tmp3+1), W0
	MOV.B	[W0], [W1]
;interval.h,168 :: 		interval_data[24]=tmp3[2];
	MOV	#lo_addr(_interval_data+24), W1
	MOV	#lo_addr(_tmp3+2), W0
	MOV.B	[W0], [W1]
;interval.h,170 :: 		inttostr(current_interval.l1aspeed,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+4, W10
	CALL	_IntToStr
;interval.h,171 :: 		interval_data[25]=tmp4[2];
	MOV	#lo_addr(_interval_data+25), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,172 :: 		interval_data[26]=tmp4[3];
	MOV	#lo_addr(_interval_data+26), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,173 :: 		interval_data[27]=tmp4[4];
	MOV	#lo_addr(_interval_data+27), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,174 :: 		interval_data[28]=tmp4[5];
	MOV	#lo_addr(_interval_data+28), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,176 :: 		inttostr(current_interval.l1agrab,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+6, W10
	CALL	_IntToStr
;interval.h,177 :: 		interval_data[29]=tmp4[2];
	MOV	#lo_addr(_interval_data+29), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,178 :: 		interval_data[30]=tmp4[3];
	MOV	#lo_addr(_interval_data+30), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,179 :: 		interval_data[31]=tmp4[4];
	MOV	#lo_addr(_interval_data+31), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,180 :: 		interval_data[32]=tmp4[5];
	MOV	#lo_addr(_interval_data+32), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,182 :: 		inttostr(current_interval.l1aheadway,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+8, W10
	CALL	_IntToStr
;interval.h,183 :: 		interval_data[33]=tmp4[2];
	MOV	#lo_addr(_interval_data+33), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,184 :: 		interval_data[34]=tmp4[3];
	MOV	#lo_addr(_interval_data+34), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,185 :: 		interval_data[35]=tmp4[4];
	MOV	#lo_addr(_interval_data+35), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,186 :: 		interval_data[36]=tmp4[5];
	MOV	#lo_addr(_interval_data+36), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,188 :: 		inttostr(current_interval.l1bcount,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+10, W10
	CALL	_IntToStr
;interval.h,189 :: 		interval_data[37]=tmp4[2];
	MOV	#lo_addr(_interval_data+37), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,190 :: 		interval_data[38]=tmp4[3];
	MOV	#lo_addr(_interval_data+38), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,191 :: 		interval_data[39]=tmp4[4];
	MOV	#lo_addr(_interval_data+39), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,192 :: 		interval_data[40]=tmp4[5];
	MOV	#lo_addr(_interval_data+40), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,194 :: 		bytetostr(current_interval.l1bvavg,tmp3);
	MOV	#lo_addr(_tmp3), W11
	MOV	#lo_addr(_current_interval+12), W0
	MOV.B	[W0], W10
	CALL	_ByteToStr
;interval.h,195 :: 		interval_data[41]=tmp3[0];
	MOV	#lo_addr(_interval_data+41), W1
	MOV	#lo_addr(_tmp3), W0
	MOV.B	[W0], [W1]
;interval.h,196 :: 		interval_data[42]=tmp3[1];
	MOV	#lo_addr(_interval_data+42), W1
	MOV	#lo_addr(_tmp3+1), W0
	MOV.B	[W0], [W1]
;interval.h,197 :: 		interval_data[43]=tmp3[2];
	MOV	#lo_addr(_interval_data+43), W1
	MOV	#lo_addr(_tmp3+2), W0
	MOV.B	[W0], [W1]
;interval.h,199 :: 		inttostr(current_interval.l1bspeed,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+14, W10
	CALL	_IntToStr
;interval.h,200 :: 		interval_data[44]=tmp4[2];
	MOV	#lo_addr(_interval_data+44), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,201 :: 		interval_data[45]=tmp4[3];
	MOV	#lo_addr(_interval_data+45), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,202 :: 		interval_data[46]=tmp4[4];
	MOV	#lo_addr(_interval_data+46), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,203 :: 		interval_data[47]=tmp4[5];
	MOV	#lo_addr(_interval_data+47), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,205 :: 		inttostr(current_interval.l1bgrab,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+16, W10
	CALL	_IntToStr
;interval.h,206 :: 		interval_data[48]=tmp4[2];
	MOV	#lo_addr(_interval_data+48), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,207 :: 		interval_data[49]=tmp4[3];
	MOV	#lo_addr(_interval_data+49), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,208 :: 		interval_data[50]=tmp4[4];
	MOV	#lo_addr(_interval_data+50), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,209 :: 		interval_data[51]=tmp4[5];
	MOV	#lo_addr(_interval_data+51), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,211 :: 		inttostr(current_interval.l1bheadway,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+18, W10
	CALL	_IntToStr
;interval.h,212 :: 		interval_data[52]=tmp4[2];
	MOV	#lo_addr(_interval_data+52), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,213 :: 		interval_data[53]=tmp4[3];
	MOV	#lo_addr(_interval_data+53), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,214 :: 		interval_data[54]=tmp4[4];
	MOV	#lo_addr(_interval_data+54), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,215 :: 		interval_data[55]=tmp4[5];
	MOV	#lo_addr(_interval_data+55), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,217 :: 		inttostr(current_interval.l1ccount,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+20, W10
	CALL	_IntToStr
;interval.h,218 :: 		interval_data[56]=tmp4[2];
	MOV	#lo_addr(_interval_data+56), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,219 :: 		interval_data[57]=tmp4[3];
	MOV	#lo_addr(_interval_data+57), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,220 :: 		interval_data[58]=tmp4[4];
	MOV	#lo_addr(_interval_data+58), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,221 :: 		interval_data[59]=tmp4[5];
	MOV	#lo_addr(_interval_data+59), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,223 :: 		bytetostr(current_interval.l1cvavg,tmp3);
	MOV	#lo_addr(_tmp3), W11
	MOV	#lo_addr(_current_interval+22), W0
	MOV.B	[W0], W10
	CALL	_ByteToStr
;interval.h,224 :: 		interval_data[60]=tmp3[0];
	MOV	#lo_addr(_interval_data+60), W1
	MOV	#lo_addr(_tmp3), W0
	MOV.B	[W0], [W1]
;interval.h,225 :: 		interval_data[61]=tmp3[1];
	MOV	#lo_addr(_interval_data+61), W1
	MOV	#lo_addr(_tmp3+1), W0
	MOV.B	[W0], [W1]
;interval.h,226 :: 		interval_data[62]=tmp3[2];
	MOV	#lo_addr(_interval_data+62), W1
	MOV	#lo_addr(_tmp3+2), W0
	MOV.B	[W0], [W1]
;interval.h,228 :: 		inttostr(current_interval.l1cspeed,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+24, W10
	CALL	_IntToStr
;interval.h,229 :: 		interval_data[63]=tmp4[2];
	MOV	#lo_addr(_interval_data+63), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,230 :: 		interval_data[64]=tmp4[3];
	MOV	#lo_addr(_interval_data+64), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,231 :: 		interval_data[65]=tmp4[4];
	MOV	#lo_addr(_interval_data+65), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,232 :: 		interval_data[66]=tmp4[5];
	MOV	#lo_addr(_interval_data+66), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,234 :: 		inttostr(current_interval.l1cgrab,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+26, W10
	CALL	_IntToStr
;interval.h,235 :: 		interval_data[67]=tmp4[2];
	MOV	#lo_addr(_interval_data+67), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,236 :: 		interval_data[68]=tmp4[3];
	MOV	#lo_addr(_interval_data+68), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,237 :: 		interval_data[69]=tmp4[4];
	MOV	#lo_addr(_interval_data+69), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,238 :: 		interval_data[70]=tmp4[5];
	MOV	#lo_addr(_interval_data+70), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,240 :: 		inttostr(current_interval.l1cheadway,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+28, W10
	CALL	_IntToStr
;interval.h,241 :: 		interval_data[71]=tmp4[2];
	MOV	#lo_addr(_interval_data+71), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,242 :: 		interval_data[72]=tmp4[3];
	MOV	#lo_addr(_interval_data+72), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,243 :: 		interval_data[73]=tmp4[4];
	MOV	#lo_addr(_interval_data+73), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,244 :: 		interval_data[74]=tmp4[5];
	MOV	#lo_addr(_interval_data+74), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,246 :: 		inttostr(current_interval.l1dcount,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+30, W10
	CALL	_IntToStr
;interval.h,247 :: 		interval_data[75]=tmp4[2];
	MOV	#lo_addr(_interval_data+75), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,248 :: 		interval_data[76]=tmp4[3];
	MOV	#lo_addr(_interval_data+76), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,249 :: 		interval_data[77]=tmp4[4];
	MOV	#lo_addr(_interval_data+77), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,250 :: 		interval_data[78]=tmp4[5];
	MOV	#lo_addr(_interval_data+78), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,252 :: 		bytetostr(current_interval.l1dvavg,tmp3);
	MOV	#lo_addr(_tmp3), W11
	MOV	#lo_addr(_current_interval+32), W0
	MOV.B	[W0], W10
	CALL	_ByteToStr
;interval.h,253 :: 		interval_data[79]=tmp3[0];
	MOV	#lo_addr(_interval_data+79), W1
	MOV	#lo_addr(_tmp3), W0
	MOV.B	[W0], [W1]
;interval.h,254 :: 		interval_data[80]=tmp3[1];
	MOV	#lo_addr(_interval_data+80), W1
	MOV	#lo_addr(_tmp3+1), W0
	MOV.B	[W0], [W1]
;interval.h,255 :: 		interval_data[81]=tmp3[2];
	MOV	#lo_addr(_interval_data+81), W1
	MOV	#lo_addr(_tmp3+2), W0
	MOV.B	[W0], [W1]
;interval.h,257 :: 		inttostr(current_interval.l1dspeed,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+34, W10
	CALL	_IntToStr
;interval.h,258 :: 		interval_data[82]=tmp4[2];
	MOV	#lo_addr(_interval_data+82), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,259 :: 		interval_data[83]=tmp4[3];
	MOV	#lo_addr(_interval_data+83), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,260 :: 		interval_data[84]=tmp4[4];
	MOV	#lo_addr(_interval_data+84), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,261 :: 		interval_data[85]=tmp4[5];
	MOV	#lo_addr(_interval_data+85), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,263 :: 		inttostr(current_interval.l1dgrab,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+36, W10
	CALL	_IntToStr
;interval.h,264 :: 		interval_data[86]=tmp4[2];
	MOV	#lo_addr(_interval_data+86), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,265 :: 		interval_data[87]=tmp4[3];
	MOV	#lo_addr(_interval_data+87), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,266 :: 		interval_data[88]=tmp4[4];
	MOV	#lo_addr(_interval_data+88), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,267 :: 		interval_data[89]=tmp4[5];
	MOV	#lo_addr(_interval_data+89), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,269 :: 		inttostr(current_interval.l1dheadway,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+38, W10
	CALL	_IntToStr
;interval.h,270 :: 		interval_data[90]=tmp4[2];
	MOV	#lo_addr(_interval_data+90), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,271 :: 		interval_data[91]=tmp4[3];
	MOV	#lo_addr(_interval_data+91), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,272 :: 		interval_data[92]=tmp4[4];
	MOV	#lo_addr(_interval_data+92), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,273 :: 		interval_data[93]=tmp4[5];
	MOV	#lo_addr(_interval_data+93), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,275 :: 		inttostr(current_interval.l1ecount,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+40, W10
	CALL	_IntToStr
;interval.h,276 :: 		interval_data[94]=tmp4[2];
	MOV	#lo_addr(_interval_data+94), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,277 :: 		interval_data[95]=tmp4[3];
	MOV	#lo_addr(_interval_data+95), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,278 :: 		interval_data[96]=tmp4[4];
	MOV	#lo_addr(_interval_data+96), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,279 :: 		interval_data[97]=tmp4[5];
	MOV	#lo_addr(_interval_data+97), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,281 :: 		bytetostr(current_interval.l1evavg,tmp3);
	MOV	#lo_addr(_tmp3), W11
	MOV	#lo_addr(_current_interval+42), W0
	MOV.B	[W0], W10
	CALL	_ByteToStr
;interval.h,282 :: 		interval_data[98]=tmp3[0];
	MOV	#lo_addr(_interval_data+98), W1
	MOV	#lo_addr(_tmp3), W0
	MOV.B	[W0], [W1]
;interval.h,283 :: 		interval_data[99]=tmp3[1];
	MOV	#lo_addr(_interval_data+99), W1
	MOV	#lo_addr(_tmp3+1), W0
	MOV.B	[W0], [W1]
;interval.h,284 :: 		interval_data[100]=tmp3[2];
	MOV	#lo_addr(_interval_data+100), W1
	MOV	#lo_addr(_tmp3+2), W0
	MOV.B	[W0], [W1]
;interval.h,286 :: 		inttostr(current_interval.l1espeed,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+44, W10
	CALL	_IntToStr
;interval.h,287 :: 		interval_data[101]=tmp4[2];
	MOV	#lo_addr(_interval_data+101), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,288 :: 		interval_data[102]=tmp4[3];
	MOV	#lo_addr(_interval_data+102), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,289 :: 		interval_data[103]=tmp4[4];
	MOV	#lo_addr(_interval_data+103), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,290 :: 		interval_data[104]=tmp4[5];
	MOV	#lo_addr(_interval_data+104), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,292 :: 		inttostr(current_interval.l1egrab,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+46, W10
	CALL	_IntToStr
;interval.h,293 :: 		interval_data[105]=tmp4[2];
	MOV	#lo_addr(_interval_data+105), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,294 :: 		interval_data[106]=tmp4[3];
	MOV	#lo_addr(_interval_data+106), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,295 :: 		interval_data[107]=tmp4[4];
	MOV	#lo_addr(_interval_data+107), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,296 :: 		interval_data[108]=tmp4[5];
	MOV	#lo_addr(_interval_data+108), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,298 :: 		inttostr(current_interval.l1eheadway,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+48, W10
	CALL	_IntToStr
;interval.h,299 :: 		interval_data[109]=tmp4[2];
	MOV	#lo_addr(_interval_data+109), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,300 :: 		interval_data[110]=tmp4[3];
	MOV	#lo_addr(_interval_data+110), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,301 :: 		interval_data[111]=tmp4[4];
	MOV	#lo_addr(_interval_data+111), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,302 :: 		interval_data[112]=tmp4[5];
	MOV	#lo_addr(_interval_data+112), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,304 :: 		inttostr(current_interval.l1xcount,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+50, W10
	CALL	_IntToStr
;interval.h,305 :: 		interval_data[113]=tmp4[2];
	MOV	#lo_addr(_interval_data+113), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,306 :: 		interval_data[114]=tmp4[3];
	MOV	#lo_addr(_interval_data+114), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,307 :: 		interval_data[115]=tmp4[4];
	MOV	#lo_addr(_interval_data+115), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,308 :: 		interval_data[116]=tmp4[5];
	MOV	#lo_addr(_interval_data+116), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,310 :: 		bytetostr(current_interval.l1xvavg,tmp3);
	MOV	#lo_addr(_tmp3), W11
	MOV	#lo_addr(_current_interval+52), W0
	MOV.B	[W0], W10
	CALL	_ByteToStr
;interval.h,311 :: 		interval_data[117]=tmp3[0];
	MOV	#lo_addr(_interval_data+117), W1
	MOV	#lo_addr(_tmp3), W0
	MOV.B	[W0], [W1]
;interval.h,312 :: 		interval_data[118]=tmp3[1];
	MOV	#lo_addr(_interval_data+118), W1
	MOV	#lo_addr(_tmp3+1), W0
	MOV.B	[W0], [W1]
;interval.h,313 :: 		interval_data[119]=tmp3[2];
	MOV	#lo_addr(_interval_data+119), W1
	MOV	#lo_addr(_tmp3+2), W0
	MOV.B	[W0], [W1]
;interval.h,315 :: 		inttostr(current_interval.l1xspeed,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+54, W10
	CALL	_IntToStr
;interval.h,316 :: 		interval_data[120]=tmp4[2];
	MOV	#lo_addr(_interval_data+120), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,317 :: 		interval_data[121]=tmp4[3];
	MOV	#lo_addr(_interval_data+121), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,318 :: 		interval_data[122]=tmp4[4];
	MOV	#lo_addr(_interval_data+122), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,319 :: 		interval_data[123]=tmp4[5];
	MOV	#lo_addr(_interval_data+123), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,321 :: 		inttostr(current_interval.l1xgrab,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+56, W10
	CALL	_IntToStr
;interval.h,322 :: 		interval_data[124]=tmp4[2];
	MOV	#lo_addr(_interval_data+124), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,323 :: 		interval_data[125]=tmp4[3];
	MOV	#lo_addr(_interval_data+125), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,324 :: 		interval_data[126]=tmp4[4];
	MOV	#lo_addr(_interval_data+126), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,325 :: 		interval_data[127]=tmp4[5];
	MOV	#lo_addr(_interval_data+127), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,327 :: 		inttostr(current_interval.l1xheadway,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+58, W10
	CALL	_IntToStr
;interval.h,328 :: 		interval_data[128]=tmp4[2];
	MOV	#lo_addr(_interval_data+128), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,329 :: 		interval_data[129]=tmp4[3];
	MOV	#lo_addr(_interval_data+129), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,330 :: 		interval_data[130]=tmp4[4];
	MOV	#lo_addr(_interval_data+130), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,331 :: 		interval_data[131]=tmp4[5];
	MOV	#lo_addr(_interval_data+131), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,333 :: 		inttostr((int)(l1occ/(INTERVALPERIOD*2*600)),debug_txt);
	MOV	#6000, W2
	MOV	#0, W3
	MOV	_l1occ, W0
	MOV	_l1occ+2, W1
	SETM	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_debug_txt), W11
	MOV	W0, W10
	CALL	_IntToStr
;interval.h,334 :: 		interval_data[132]=debug_txt[3];
	MOV	#lo_addr(_interval_data+132), W1
	MOV	#lo_addr(_debug_txt+3), W0
	MOV.B	[W0], [W1]
;interval.h,335 :: 		interval_data[133]=debug_txt[4];
	MOV	#lo_addr(_interval_data+133), W1
	MOV	#lo_addr(_debug_txt+4), W0
	MOV.B	[W0], [W1]
;interval.h,336 :: 		interval_data[134]=debug_txt[5];
	MOV	#lo_addr(_interval_data+134), W1
	MOV	#lo_addr(_debug_txt+5), W0
	MOV.B	[W0], [W1]
;interval.h,343 :: 		inttostr(current_interval.l2acount,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+62, W10
	CALL	_IntToStr
;interval.h,344 :: 		interval_data[135]=tmp4[2];
	MOV	#lo_addr(_interval_data+135), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,345 :: 		interval_data[136]=tmp4[3];
	MOV	#lo_addr(_interval_data+136), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,346 :: 		interval_data[137]=tmp4[4];
	MOV	#lo_addr(_interval_data+137), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,347 :: 		interval_data[138]=tmp4[5];
	MOV	#lo_addr(_interval_data+138), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,349 :: 		bytetostr(current_interval.l2avavg,tmp3);
	MOV	#lo_addr(_tmp3), W11
	MOV	#lo_addr(_current_interval+64), W0
	MOV.B	[W0], W10
	CALL	_ByteToStr
;interval.h,350 :: 		interval_data[139]=tmp3[0];
	MOV	#lo_addr(_interval_data+139), W1
	MOV	#lo_addr(_tmp3), W0
	MOV.B	[W0], [W1]
;interval.h,351 :: 		interval_data[140]=tmp3[1];
	MOV	#lo_addr(_interval_data+140), W1
	MOV	#lo_addr(_tmp3+1), W0
	MOV.B	[W0], [W1]
;interval.h,352 :: 		interval_data[141]=tmp3[2];
	MOV	#lo_addr(_interval_data+141), W1
	MOV	#lo_addr(_tmp3+2), W0
	MOV.B	[W0], [W1]
;interval.h,354 :: 		inttostr(current_interval.l2aspeed,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+66, W10
	CALL	_IntToStr
;interval.h,355 :: 		interval_data[142]=tmp4[2];
	MOV	#lo_addr(_interval_data+142), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,356 :: 		interval_data[143]=tmp4[3];
	MOV	#lo_addr(_interval_data+143), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,357 :: 		interval_data[144]=tmp4[4];
	MOV	#lo_addr(_interval_data+144), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,358 :: 		interval_data[145]=tmp4[5];
	MOV	#lo_addr(_interval_data+145), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,360 :: 		inttostr(current_interval.l2agrab,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+68, W10
	CALL	_IntToStr
;interval.h,361 :: 		interval_data[146]=tmp4[2];
	MOV	#lo_addr(_interval_data+146), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,362 :: 		interval_data[147]=tmp4[3];
	MOV	#lo_addr(_interval_data+147), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,363 :: 		interval_data[148]=tmp4[4];
	MOV	#lo_addr(_interval_data+148), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,364 :: 		interval_data[149]=tmp4[5];
	MOV	#lo_addr(_interval_data+149), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,366 :: 		inttostr(current_interval.l2aheadway,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+70, W10
	CALL	_IntToStr
;interval.h,367 :: 		interval_data[150]=tmp4[2];
	MOV	#lo_addr(_interval_data+150), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,368 :: 		interval_data[151]=tmp4[3];
	MOV	#lo_addr(_interval_data+151), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,369 :: 		interval_data[152]=tmp4[4];
	MOV	#lo_addr(_interval_data+152), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,370 :: 		interval_data[153]=tmp4[5];
	MOV	#lo_addr(_interval_data+153), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,372 :: 		inttostr(current_interval.l2bcount,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+72, W10
	CALL	_IntToStr
;interval.h,373 :: 		interval_data[154]=tmp4[2];
	MOV	#lo_addr(_interval_data+154), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,374 :: 		interval_data[155]=tmp4[3];
	MOV	#lo_addr(_interval_data+155), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,375 :: 		interval_data[156]=tmp4[4];
	MOV	#lo_addr(_interval_data+156), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,376 :: 		interval_data[157]=tmp4[5];
	MOV	#lo_addr(_interval_data+157), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,378 :: 		bytetostr(current_interval.l2bvavg,tmp3);
	MOV	#lo_addr(_tmp3), W11
	MOV	#lo_addr(_current_interval+74), W0
	MOV.B	[W0], W10
	CALL	_ByteToStr
;interval.h,379 :: 		interval_data[158]=tmp3[0];
	MOV	#lo_addr(_interval_data+158), W1
	MOV	#lo_addr(_tmp3), W0
	MOV.B	[W0], [W1]
;interval.h,380 :: 		interval_data[159]=tmp3[1];
	MOV	#lo_addr(_interval_data+159), W1
	MOV	#lo_addr(_tmp3+1), W0
	MOV.B	[W0], [W1]
;interval.h,381 :: 		interval_data[160]=tmp3[2];
	MOV	#lo_addr(_interval_data+160), W1
	MOV	#lo_addr(_tmp3+2), W0
	MOV.B	[W0], [W1]
;interval.h,383 :: 		inttostr(current_interval.l2bspeed,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+76, W10
	CALL	_IntToStr
;interval.h,384 :: 		interval_data[161]=tmp4[2];
	MOV	#lo_addr(_interval_data+161), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,385 :: 		interval_data[162]=tmp4[3];
	MOV	#lo_addr(_interval_data+162), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,386 :: 		interval_data[163]=tmp4[4];
	MOV	#lo_addr(_interval_data+163), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,387 :: 		interval_data[164]=tmp4[5];
	MOV	#lo_addr(_interval_data+164), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,389 :: 		inttostr(current_interval.l2bgrab,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+78, W10
	CALL	_IntToStr
;interval.h,390 :: 		interval_data[165]=tmp4[2];
	MOV	#lo_addr(_interval_data+165), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,391 :: 		interval_data[166]=tmp4[3];
	MOV	#lo_addr(_interval_data+166), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,392 :: 		interval_data[167]=tmp4[4];
	MOV	#lo_addr(_interval_data+167), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,393 :: 		interval_data[168]=tmp4[5];
	MOV	#lo_addr(_interval_data+168), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,395 :: 		inttostr(current_interval.l2bheadway,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+80, W10
	CALL	_IntToStr
;interval.h,396 :: 		interval_data[169]=tmp4[2];
	MOV	#lo_addr(_interval_data+169), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,397 :: 		interval_data[170]=tmp4[3];
	MOV	#lo_addr(_interval_data+170), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,398 :: 		interval_data[171]=tmp4[4];
	MOV	#lo_addr(_interval_data+171), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,399 :: 		interval_data[172]=tmp4[5];
	MOV	#lo_addr(_interval_data+172), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,401 :: 		inttostr(current_interval.l2ccount,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+82, W10
	CALL	_IntToStr
;interval.h,402 :: 		interval_data[173]=tmp4[2];
	MOV	#lo_addr(_interval_data+173), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,403 :: 		interval_data[174]=tmp4[3];
	MOV	#lo_addr(_interval_data+174), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,404 :: 		interval_data[175]=tmp4[4];
	MOV	#lo_addr(_interval_data+175), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,405 :: 		interval_data[176]=tmp4[5];
	MOV	#lo_addr(_interval_data+176), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,407 :: 		bytetostr(current_interval.l2cvavg,tmp3);
	MOV	#lo_addr(_tmp3), W11
	MOV	#lo_addr(_current_interval+84), W0
	MOV.B	[W0], W10
	CALL	_ByteToStr
;interval.h,408 :: 		interval_data[177]=tmp3[0];
	MOV	#lo_addr(_interval_data+177), W1
	MOV	#lo_addr(_tmp3), W0
	MOV.B	[W0], [W1]
;interval.h,409 :: 		interval_data[178]=tmp3[1];
	MOV	#lo_addr(_interval_data+178), W1
	MOV	#lo_addr(_tmp3+1), W0
	MOV.B	[W0], [W1]
;interval.h,410 :: 		interval_data[179]=tmp3[2];
	MOV	#lo_addr(_interval_data+179), W1
	MOV	#lo_addr(_tmp3+2), W0
	MOV.B	[W0], [W1]
;interval.h,412 :: 		inttostr(current_interval.l2cspeed,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+86, W10
	CALL	_IntToStr
;interval.h,413 :: 		interval_data[180]=tmp4[2];
	MOV	#lo_addr(_interval_data+180), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,414 :: 		interval_data[181]=tmp4[3];
	MOV	#lo_addr(_interval_data+181), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,415 :: 		interval_data[182]=tmp4[4];
	MOV	#lo_addr(_interval_data+182), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,416 :: 		interval_data[183]=tmp4[5];
	MOV	#lo_addr(_interval_data+183), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,418 :: 		inttostr(current_interval.l2cgrab,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+88, W10
	CALL	_IntToStr
;interval.h,419 :: 		interval_data[184]=tmp4[2];
	MOV	#lo_addr(_interval_data+184), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,420 :: 		interval_data[185]=tmp4[3];
	MOV	#lo_addr(_interval_data+185), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,421 :: 		interval_data[186]=tmp4[4];
	MOV	#lo_addr(_interval_data+186), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,422 :: 		interval_data[187]=tmp4[5];
	MOV	#lo_addr(_interval_data+187), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,424 :: 		inttostr(current_interval.l2cheadway,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+90, W10
	CALL	_IntToStr
;interval.h,425 :: 		interval_data[188]=tmp4[2];
	MOV	#lo_addr(_interval_data+188), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,426 :: 		interval_data[189]=tmp4[3];
	MOV	#lo_addr(_interval_data+189), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,427 :: 		interval_data[190]=tmp4[4];
	MOV	#lo_addr(_interval_data+190), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,428 :: 		interval_data[191]=tmp4[5];
	MOV	#lo_addr(_interval_data+191), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,430 :: 		inttostr(current_interval.l2dcount,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+92, W10
	CALL	_IntToStr
;interval.h,431 :: 		interval_data[192]=tmp4[2];
	MOV	#lo_addr(_interval_data+192), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,432 :: 		interval_data[193]=tmp4[3];
	MOV	#lo_addr(_interval_data+193), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,433 :: 		interval_data[194]=tmp4[4];
	MOV	#lo_addr(_interval_data+194), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,434 :: 		interval_data[195]=tmp4[5];
	MOV	#lo_addr(_interval_data+195), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,436 :: 		bytetostr(current_interval.l2dvavg,tmp3);
	MOV	#lo_addr(_tmp3), W11
	MOV	#lo_addr(_current_interval+94), W0
	MOV.B	[W0], W10
	CALL	_ByteToStr
;interval.h,437 :: 		interval_data[196]=tmp3[0];
	MOV	#lo_addr(_interval_data+196), W1
	MOV	#lo_addr(_tmp3), W0
	MOV.B	[W0], [W1]
;interval.h,438 :: 		interval_data[197]=tmp3[1];
	MOV	#lo_addr(_interval_data+197), W1
	MOV	#lo_addr(_tmp3+1), W0
	MOV.B	[W0], [W1]
;interval.h,439 :: 		interval_data[198]=tmp3[2];
	MOV	#lo_addr(_interval_data+198), W1
	MOV	#lo_addr(_tmp3+2), W0
	MOV.B	[W0], [W1]
;interval.h,441 :: 		inttostr(current_interval.l2dspeed,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+96, W10
	CALL	_IntToStr
;interval.h,442 :: 		interval_data[199]=tmp4[2];
	MOV	#lo_addr(_interval_data+199), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,443 :: 		interval_data[200]=tmp4[3];
	MOV	#lo_addr(_interval_data+200), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,444 :: 		interval_data[201]=tmp4[4];
	MOV	#lo_addr(_interval_data+201), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,445 :: 		interval_data[202]=tmp4[5];
	MOV	#lo_addr(_interval_data+202), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,447 :: 		inttostr(current_interval.l2dgrab,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+98, W10
	CALL	_IntToStr
;interval.h,448 :: 		interval_data[203]=tmp4[2];
	MOV	#lo_addr(_interval_data+203), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,449 :: 		interval_data[204]=tmp4[3];
	MOV	#lo_addr(_interval_data+204), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,450 :: 		interval_data[205]=tmp4[4];
	MOV	#lo_addr(_interval_data+205), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,451 :: 		interval_data[206]=tmp4[5];
	MOV	#lo_addr(_interval_data+206), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,453 :: 		inttostr(current_interval.l2dheadway,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+100, W10
	CALL	_IntToStr
;interval.h,454 :: 		interval_data[207]=tmp4[2];
	MOV	#lo_addr(_interval_data+207), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,455 :: 		interval_data[208]=tmp4[3];
	MOV	#lo_addr(_interval_data+208), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,456 :: 		interval_data[209]=tmp4[4];
	MOV	#lo_addr(_interval_data+209), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,457 :: 		interval_data[210]=tmp4[5];
	MOV	#lo_addr(_interval_data+210), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,459 :: 		inttostr(current_interval.l2ecount,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+102, W10
	CALL	_IntToStr
;interval.h,460 :: 		interval_data[211]=tmp4[2];
	MOV	#lo_addr(_interval_data+211), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,461 :: 		interval_data[212]=tmp4[3];
	MOV	#lo_addr(_interval_data+212), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,462 :: 		interval_data[213]=tmp4[4];
	MOV	#lo_addr(_interval_data+213), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,463 :: 		interval_data[214]=tmp4[5];
	MOV	#lo_addr(_interval_data+214), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,465 :: 		bytetostr(current_interval.l2evavg,tmp3);
	MOV	#lo_addr(_tmp3), W11
	MOV	#lo_addr(_current_interval+104), W0
	MOV.B	[W0], W10
	CALL	_ByteToStr
;interval.h,466 :: 		interval_data[215]=tmp3[0];
	MOV	#lo_addr(_interval_data+215), W1
	MOV	#lo_addr(_tmp3), W0
	MOV.B	[W0], [W1]
;interval.h,467 :: 		interval_data[216]=tmp3[1];
	MOV	#lo_addr(_interval_data+216), W1
	MOV	#lo_addr(_tmp3+1), W0
	MOV.B	[W0], [W1]
;interval.h,468 :: 		interval_data[217]=tmp3[2];
	MOV	#lo_addr(_interval_data+217), W1
	MOV	#lo_addr(_tmp3+2), W0
	MOV.B	[W0], [W1]
;interval.h,470 :: 		inttostr(current_interval.l2espeed,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+106, W10
	CALL	_IntToStr
;interval.h,471 :: 		interval_data[218]=tmp4[2];
	MOV	#lo_addr(_interval_data+218), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,472 :: 		interval_data[219]=tmp4[3];
	MOV	#lo_addr(_interval_data+219), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,473 :: 		interval_data[220]=tmp4[4];
	MOV	#lo_addr(_interval_data+220), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,474 :: 		interval_data[221]=tmp4[5];
	MOV	#lo_addr(_interval_data+221), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,476 :: 		inttostr(current_interval.l2egrab,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+108, W10
	CALL	_IntToStr
;interval.h,477 :: 		interval_data[222]=tmp4[2];
	MOV	#lo_addr(_interval_data+222), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,478 :: 		interval_data[223]=tmp4[3];
	MOV	#lo_addr(_interval_data+223), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,479 :: 		interval_data[224]=tmp4[4];
	MOV	#lo_addr(_interval_data+224), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,480 :: 		interval_data[225]=tmp4[5];
	MOV	#lo_addr(_interval_data+225), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,482 :: 		inttostr(current_interval.l2eheadway,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+110, W10
	CALL	_IntToStr
;interval.h,483 :: 		interval_data[226]=tmp4[2];
	MOV	#lo_addr(_interval_data+226), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,484 :: 		interval_data[227]=tmp4[3];
	MOV	#lo_addr(_interval_data+227), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,485 :: 		interval_data[228]=tmp4[4];
	MOV	#lo_addr(_interval_data+228), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,486 :: 		interval_data[229]=tmp4[5];
	MOV	#lo_addr(_interval_data+229), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,488 :: 		inttostr(current_interval.l2xcount,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+112, W10
	CALL	_IntToStr
;interval.h,489 :: 		interval_data[230]=tmp4[2];
	MOV	#lo_addr(_interval_data+230), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,490 :: 		interval_data[231]=tmp4[3];
	MOV	#lo_addr(_interval_data+231), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,491 :: 		interval_data[232]=tmp4[4];
	MOV	#lo_addr(_interval_data+232), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,492 :: 		interval_data[233]=tmp4[5];
	MOV	#lo_addr(_interval_data+233), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,494 :: 		bytetostr(current_interval.l2xvavg,tmp3);
	MOV	#lo_addr(_tmp3), W11
	MOV	#lo_addr(_current_interval+114), W0
	MOV.B	[W0], W10
	CALL	_ByteToStr
;interval.h,495 :: 		interval_data[234]=tmp3[0];
	MOV	#lo_addr(_interval_data+234), W1
	MOV	#lo_addr(_tmp3), W0
	MOV.B	[W0], [W1]
;interval.h,496 :: 		interval_data[235]=tmp3[1];
	MOV	#lo_addr(_interval_data+235), W1
	MOV	#lo_addr(_tmp3+1), W0
	MOV.B	[W0], [W1]
;interval.h,497 :: 		interval_data[236]=tmp3[2];
	MOV	#lo_addr(_interval_data+236), W1
	MOV	#lo_addr(_tmp3+2), W0
	MOV.B	[W0], [W1]
;interval.h,499 :: 		inttostr(current_interval.l2xspeed,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+116, W10
	CALL	_IntToStr
;interval.h,500 :: 		interval_data[237]=tmp4[2];
	MOV	#lo_addr(_interval_data+237), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,501 :: 		interval_data[238]=tmp4[3];
	MOV	#lo_addr(_interval_data+238), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,502 :: 		interval_data[239]=tmp4[4];
	MOV	#lo_addr(_interval_data+239), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,503 :: 		interval_data[240]=tmp4[5];
	MOV	#lo_addr(_interval_data+240), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,505 :: 		inttostr(current_interval.l2xgrab,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+118, W10
	CALL	_IntToStr
;interval.h,506 :: 		interval_data[241]=tmp4[2];
	MOV	#lo_addr(_interval_data+241), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,507 :: 		interval_data[242]=tmp4[3];
	MOV	#lo_addr(_interval_data+242), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,508 :: 		interval_data[243]=tmp4[4];
	MOV	#lo_addr(_interval_data+243), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,509 :: 		interval_data[244]=tmp4[5];
	MOV	#lo_addr(_interval_data+244), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,511 :: 		inttostr(current_interval.l2xheadway,tmp4);
	MOV	#lo_addr(_tmp4), W11
	MOV	_current_interval+120, W10
	CALL	_IntToStr
;interval.h,512 :: 		interval_data[245]=tmp4[2];
	MOV	#lo_addr(_interval_data+245), W1
	MOV	#lo_addr(_tmp4+2), W0
	MOV.B	[W0], [W1]
;interval.h,513 :: 		interval_data[246]=tmp4[3];
	MOV	#lo_addr(_interval_data+246), W1
	MOV	#lo_addr(_tmp4+3), W0
	MOV.B	[W0], [W1]
;interval.h,514 :: 		interval_data[247]=tmp4[4];
	MOV	#lo_addr(_interval_data+247), W1
	MOV	#lo_addr(_tmp4+4), W0
	MOV.B	[W0], [W1]
;interval.h,515 :: 		interval_data[248]=tmp4[5];
	MOV	#lo_addr(_interval_data+248), W1
	MOV	#lo_addr(_tmp4+5), W0
	MOV.B	[W0], [W1]
;interval.h,518 :: 		inttostr((int)(l2occ/(INTERVALPERIOD*2*600)),debug_txt);
	MOV	#6000, W2
	MOV	#0, W3
	MOV	_l2occ, W0
	MOV	_l2occ+2, W1
	SETM	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_debug_txt), W11
	MOV	W0, W10
	CALL	_IntToStr
;interval.h,519 :: 		interval_data[249]=debug_txt[3];
	MOV	#lo_addr(_interval_data+249), W1
	MOV	#lo_addr(_debug_txt+3), W0
	MOV.B	[W0], [W1]
;interval.h,520 :: 		interval_data[250]=debug_txt[4];
	MOV	#lo_addr(_interval_data+250), W1
	MOV	#lo_addr(_debug_txt+4), W0
	MOV.B	[W0], [W1]
;interval.h,521 :: 		interval_data[251]=debug_txt[5];
	MOV	#lo_addr(_interval_data+251), W1
	MOV	#lo_addr(_debug_txt+5), W0
	MOV.B	[W0], [W1]
;interval.h,524 :: 		inttostr((int)(vbat*0.388509+7),debug_txt);
	MOV	_vbat, W0
	MOV	_vbat+2, W1
	SETM	W2
	CALL	__Long2Float
	MOV	#60071, W2
	MOV	#16070, W3
	CALL	__Mul_FP
	MOV	#0, W2
	MOV	#16608, W3
	CALL	__AddSub_FP
	CALL	__Float2Longint
	MOV	#lo_addr(_debug_txt), W11
	MOV	W0, W10
	CALL	_IntToStr
;interval.h,525 :: 		interval_data[252]=debug_txt[3];
	MOV	#lo_addr(_interval_data+252), W1
	MOV	#lo_addr(_debug_txt+3), W0
	MOV.B	[W0], [W1]
;interval.h,526 :: 		interval_data[253]=debug_txt[4];
	MOV	#lo_addr(_interval_data+253), W1
	MOV	#lo_addr(_debug_txt+4), W0
	MOV.B	[W0], [W1]
;interval.h,527 :: 		interval_data[254]=debug_txt[5];
	MOV	#lo_addr(_interval_data+254), W1
	MOV	#lo_addr(_debug_txt+5), W0
	MOV.B	[W0], [W1]
;interval.h,529 :: 		if(solar<50)
	MOV	#50, W1
	MOV	#0, W2
	MOV	#lo_addr(_solar), W0
	CP	W1, [W0++]
	CPB	W2, [W0--]
	BRA GT	L__cal_interval1082
	GOTO	L_cal_interval57
L__cal_interval1082:
;interval.h,530 :: 		inttostr(0,debug_txt);
	MOV	#lo_addr(_debug_txt), W11
	CLR	W10
	CALL	_IntToStr
	GOTO	L_cal_interval58
L_cal_interval57:
;interval.h,532 :: 		inttostr((int)(solar*0.388509),debug_txt);
	MOV	_solar, W0
	MOV	_solar+2, W1
	SETM	W2
	CALL	__Long2Float
	MOV	#60071, W2
	MOV	#16070, W3
	CALL	__Mul_FP
	CALL	__Float2Longint
	MOV	#lo_addr(_debug_txt), W11
	MOV	W0, W10
	CALL	_IntToStr
L_cal_interval58:
;interval.h,533 :: 		interval_data[255]=debug_txt[3];
	MOV	#lo_addr(_interval_data+255), W1
	MOV	#lo_addr(_debug_txt+3), W0
	MOV.B	[W0], [W1]
;interval.h,534 :: 		interval_data[256]=debug_txt[4];
	MOV	#lo_addr(_interval_data+256), W1
	MOV	#lo_addr(_debug_txt+4), W0
	MOV.B	[W0], [W1]
;interval.h,535 :: 		interval_data[257]=debug_txt[5];
	MOV	#lo_addr(_interval_data+257), W1
	MOV	#lo_addr(_debug_txt+5), W0
	MOV.B	[W0], [W1]
;interval.h,538 :: 		inttostr(error_byte,debug_txt);
	MOV	#lo_addr(_debug_txt), W11
	MOV	_error_byte, W10
	CALL	_IntToStr
;interval.h,539 :: 		interval_data[258]=debug_txt[2];
	MOV	#lo_addr(_interval_data+258), W1
	MOV	#lo_addr(_debug_txt+2), W0
	MOV.B	[W0], [W1]
;interval.h,540 :: 		interval_data[259]=debug_txt[3];
	MOV	#lo_addr(_interval_data+259), W1
	MOV	#lo_addr(_debug_txt+3), W0
	MOV.B	[W0], [W1]
;interval.h,541 :: 		interval_data[260]=debug_txt[4];
	MOV	#lo_addr(_interval_data+260), W1
	MOV	#lo_addr(_debug_txt+4), W0
	MOV.B	[W0], [W1]
;interval.h,542 :: 		interval_data[261]=debug_txt[5];
	MOV	#lo_addr(_interval_data+261), W1
	MOV	#lo_addr(_debug_txt+5), W0
	MOV.B	[W0], [W1]
;interval.h,546 :: 		reset_interval();
	CALL	_reset_interval
;interval.h,548 :: 		for(cal_interval_cnt=0;cal_interval_cnt<262;cal_interval_cnt++) if(interval_data[cal_interval_cnt]==' ') interval_data[cal_interval_cnt]='0';
	CLR	W0
	MOV	W0, _cal_interval_cnt
L_cal_interval59:
	MOV	_cal_interval_cnt, W1
	MOV	#262, W0
	CP	W1, W0
	BRA LTU	L__cal_interval1083
	GOTO	L_cal_interval60
L__cal_interval1083:
	MOV	#lo_addr(_interval_data), W1
	MOV	#lo_addr(_cal_interval_cnt), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV.B	#32, W0
	CP.B	W1, W0
	BRA Z	L__cal_interval1084
	GOTO	L_cal_interval62
L__cal_interval1084:
	MOV	#lo_addr(_interval_data), W1
	MOV	#lo_addr(_cal_interval_cnt), W0
	ADD	W1, [W0], W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
L_cal_interval62:
	MOV	#1, W1
	MOV	#lo_addr(_cal_interval_cnt), W0
	ADD	W1, [W0], [W0]
	GOTO	L_cal_interval59
L_cal_interval60:
;interval.h,549 :: 		}
L_end_cal_interval:
	POP	W11
	POP	W10
	RETURN
; end of _cal_interval

_tris_init:

;capture_int_lib.h,1 :: 		void tris_init()
;capture_int_lib.h,3 :: 		TRISB.RB3=0;
	BCLR	TRISB, #3
;capture_int_lib.h,4 :: 		TRISB.RB5=0;
	BCLR	TRISB, #5
;capture_int_lib.h,5 :: 		mmc_error=0;
	BCLR	LATB5_bit, BitPos(LATB5_bit+0)
;capture_int_lib.h,6 :: 		TRISB.RB6=1;
	BSET	TRISB, #6
;capture_int_lib.h,7 :: 		TRISB.RB7=0;
	BCLR	TRISB, #7
;capture_int_lib.h,8 :: 		LATB.RB7=0;
	BCLR	LATB, #7
;capture_int_lib.h,9 :: 		TRISB.RB8=0;
	BCLR	TRISB, #8
;capture_int_lib.h,12 :: 		TRISB.RB0=1;
	BSET	TRISB, #0
;capture_int_lib.h,13 :: 		TRISB.RB1=1;
	BSET	TRISB, #1
;capture_int_lib.h,14 :: 		TRISB.RB4=1;
	BSET	TRISB, #4
;capture_int_lib.h,15 :: 		TRISF.RF0=0;
	BCLR	TRISF, #0
;capture_int_lib.h,16 :: 		TRISF.RF1=0;
	BCLR	TRISF, #1
;capture_int_lib.h,17 :: 		TRISF.RF2=1;
	BSET	TRISF, #2
;capture_int_lib.h,18 :: 		TRISF.RF3=0;
	BCLR	TRISF, #3
;capture_int_lib.h,19 :: 		TRISF.RF4=1;
	BSET	TRISF, #4
;capture_int_lib.h,20 :: 		TRISF.RF5=0;
	BCLR	TRISF, #5
;capture_int_lib.h,21 :: 		TRISF.RF6=0;
	BCLR	TRISF, #6
;capture_int_lib.h,22 :: 		TRISE.RE0=0;
	BCLR	TRISE, #0
;capture_int_lib.h,23 :: 		TRISE.RE1=0;
	BCLR	TRISE, #1
;capture_int_lib.h,24 :: 		TRISE.RE2=0;
	BCLR	TRISE, #2
;capture_int_lib.h,25 :: 		TRISE.RE3=0;
	BCLR	TRISE, #3
;capture_int_lib.h,26 :: 		TRISE.RE4=0;
	BCLR	TRISE, #4
;capture_int_lib.h,27 :: 		TRISE.RE5=0;
	BCLR	TRISE, #5
;capture_int_lib.h,28 :: 		TRISE.RE8=1;
	BSET	TRISE, #8
;capture_int_lib.h,29 :: 		TRISC.RC13=0;
	BCLR	TRISC, #13
;capture_int_lib.h,30 :: 		TRISC.RC14=1;
	BSET	TRISC, #14
;capture_int_lib.h,31 :: 		TRISD=0;
	CLR	TRISD
;capture_int_lib.h,32 :: 		LATD=0;
	CLR	LATD
;capture_int_lib.h,33 :: 		TRISB.RB2=0;
	BCLR	TRISB, #2
;capture_int_lib.h,36 :: 		}
L_end_tris_init:
	RETURN
; end of _tris_init

_tmrcp_init:

;capture_int_lib.h,37 :: 		void tmrcp_init()
;capture_int_lib.h,39 :: 		current_loop=0;
	MOV	#lo_addr(_current_loop), W1
	CLR	W0
	MOV.B	W0, [W1]
;capture_int_lib.h,40 :: 		docal=0;
	MOV	#lo_addr(_docal), W1
	CLR	W0
	MOV.B	W0, [W1]
;capture_int_lib.h,41 :: 		TMR2=0x0000;
	CLR	TMR2
;capture_int_lib.h,42 :: 		T2CON=0x0000;
	CLR	T2CON
;capture_int_lib.h,43 :: 		T4CON=0x0000;
	CLR	T4CON
;capture_int_lib.h,44 :: 		PR4=14744;
	MOV	#14744, W0
	MOV	WREG, PR4
;capture_int_lib.h,45 :: 		T4IF_bit=0;
	BCLR	T4IF_bit, BitPos(T4IF_bit+0)
;capture_int_lib.h,46 :: 		T4IE_bit=1;
	BSET	T4IE_bit, BitPos(T4IE_bit+0)
;capture_int_lib.h,47 :: 		if(AUTCAL) IC7CON=0x00E5;
	MOV	#lo_addr(_AUTCAL), W0
	CP0	[W0]
	BRA NZ	L__tmrcp_init1087
	GOTO	L_tmrcp_init63
L__tmrcp_init1087:
	MOV	#229, W0
	MOV	WREG, IC7CON
	GOTO	L_tmrcp_init64
L_tmrcp_init63:
;capture_int_lib.h,48 :: 		else IC7CON=0x00E4;
	MOV	#228, W0
	MOV	WREG, IC7CON
L_tmrcp_init64:
;capture_int_lib.h,49 :: 		T4CON.TON=1;
	BSET	T4CON, #15
;capture_int_lib.h,50 :: 		T2CON.TON=1;
	BSET	T2CON, #15
;capture_int_lib.h,51 :: 		T4CON.TSIDL=0;
	BCLR	T4CON, #13
;capture_int_lib.h,52 :: 		T2CON.TSIDL=0;
	BCLR	T2CON, #13
;capture_int_lib.h,53 :: 		}
L_end_tmrcp_init:
	RETURN
; end of _tmrcp_init

_uart_init:

;uart_int_lib.h,1 :: 		void uart_init()
;uart_int_lib.h,3 :: 		UART1_init(115200);                          //   Setting UART Data
	PUSH	W10
	PUSH	W11
	MOV	#49664, W10
	MOV	#1, W11
	CALL	_UART1_Init
;uart_int_lib.h,4 :: 		U1MODE.ALTIO=1;
	BSET	U1MODE, #10
;uart_int_lib.h,5 :: 		U1MODE.USIDL=0;
	BCLR	U1MODE, #13
;uart_int_lib.h,6 :: 		U2MODE.USIDL=0;
	BCLR	U2MODE, #13
;uart_int_lib.h,7 :: 		U1RXIF_bit=0;
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;uart_int_lib.h,8 :: 		UART2_init(115200);
	MOV	#49664, W10
	MOV	#1, W11
	CALL	_UART2_Init
;uart_int_lib.h,9 :: 		clear_uart1();
	CALL	_clear_uart1
;uart_int_lib.h,10 :: 		U1RXIE_bit=1;
	BSET	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;uart_int_lib.h,12 :: 		clear_uart2();
	CALL	_clear_uart2
;uart_int_lib.h,13 :: 		U2RXIF_bit=0;
	BCLR	U2RXIF_bit, BitPos(U2RXIF_bit+0)
;uart_int_lib.h,14 :: 		U2RXIE_bit=1;
	BSET	U2RXIE_bit, BitPos(U2RXIE_bit+0)
;uart_int_lib.h,15 :: 		uart2_data_received=0;
	MOV	#lo_addr(_uart2_data_received), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart_int_lib.h,16 :: 		uart2_data_received2=0;
	MOV	#lo_addr(_uart2_data_received2), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart_int_lib.h,18 :: 		U1STAbits.OERR=0;
	BCLR	U1STAbits, #1
;uart_int_lib.h,19 :: 		U2STAbits.OERR=0;
	BCLR	U2STAbits, #1
;uart_int_lib.h,20 :: 		u2func=0;
	CLR	W0
	MOV	W0, _u2func
;uart_int_lib.h,21 :: 		function_code=0;
	CLR	W0
	MOV	W0, _function_code
;uart_int_lib.h,22 :: 		send_out("Started, Step:");
	MOV	#lo_addr(?lstr_1_91_457), W10
	CALL	_send_out
;uart_int_lib.h,23 :: 		wordtostr((RCON-8192),tmp7);
	MOV	RCON, W1
	MOV	#8192, W0
	SUB	W1, W0, W0
	MOV	#lo_addr(_tmp7), W11
	MOV	W0, W10
	CALL	_WordToStr
;uart_int_lib.h,24 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,25 :: 		send_out("  MMC Error:");
	MOV	#lo_addr(?lstr_2_91_457), W10
	CALL	_send_out
;uart_int_lib.h,26 :: 		RCON=0x0000;
	CLR	RCON
;uart_int_lib.h,27 :: 		}
L_end_uart_init:
	POP	W11
	POP	W10
	RETURN
; end of _uart_init

_UART1INT:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;uart_int_lib.h,28 :: 		void UART1INT() iv IVT_ADDR_U1RXINTERRUPT
;uart_int_lib.h,30 :: 		while(U1STAbits.URXDA)
	PUSH	W10
L_UART1INT65:
	BTSS	U1STAbits, #0
	GOTO	L_UART1INT66
;uart_int_lib.h,32 :: 		udata=UART1_Read();
	CALL	_UART1_Read
	MOV	#lo_addr(_udata), W1
	MOV.B	W0, [W1]
;uart_int_lib.h,33 :: 		UART1_Write(udata);
	ZE	W0, W10
	CALL	_UART1_Write
;uart_int_lib.h,34 :: 		if(udata==8 && uart1_data_pointer>0)
	MOV	#lo_addr(_udata), W0
	MOV.B	[W0], W0
	CP.B	W0, #8
	BRA Z	L__UART1INT1090
	GOTO	L__UART1INT844
L__UART1INT1090:
	MOV	#lo_addr(_uart1_data_pointer), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA GT	L__UART1INT1091
	GOTO	L__UART1INT843
L__UART1INT1091:
L__UART1INT842:
;uart_int_lib.h,36 :: 		uart1_data_pointer--;
	MOV.B	#1, W1
	MOV	#lo_addr(_uart1_data_pointer), W0
	SUBR.B	W1, [W0], [W0]
;uart_int_lib.h,37 :: 		}
	GOTO	L_UART1INT70
;uart_int_lib.h,34 :: 		if(udata==8 && uart1_data_pointer>0)
L__UART1INT844:
L__UART1INT843:
;uart_int_lib.h,38 :: 		else if(udata==13)
	MOV	#lo_addr(_udata), W0
	MOV.B	[W0], W0
	CP.B	W0, #13
	BRA Z	L__UART1INT1092
	GOTO	L_UART1INT71
L__UART1INT1092:
;uart_int_lib.h,40 :: 		uart1_data_received=1;
	MOV	#lo_addr(_uart1_data_received), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;uart_int_lib.h,41 :: 		}
	GOTO	L_UART1INT72
L_UART1INT71:
;uart_int_lib.h,42 :: 		else if(udata!=10)
	MOV	#lo_addr(_udata), W0
	MOV.B	[W0], W0
	CP.B	W0, #10
	BRA NZ	L__UART1INT1093
	GOTO	L_UART1INT73
L__UART1INT1093:
;uart_int_lib.h,44 :: 		uart1_data[uart1_data_pointer]=udata;
	MOV	#lo_addr(_uart1_data_pointer), W0
	SE	[W0], W1
	MOV	#lo_addr(_uart1_data), W0
	ADD	W0, W1, W1
	MOV	#lo_addr(_udata), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,45 :: 		uart1_data_pointer++;
	MOV.B	#1, W1
	MOV	#lo_addr(_uart1_data_pointer), W0
	ADD.B	W1, [W0], [W0]
;uart_int_lib.h,46 :: 		}
L_UART1INT73:
L_UART1INT72:
L_UART1INT70:
;uart_int_lib.h,47 :: 		}
	GOTO	L_UART1INT65
L_UART1INT66:
;uart_int_lib.h,48 :: 		if(uart1_data_pointer==48) clear_uart1();
	MOV	#lo_addr(_uart1_data_pointer), W0
	MOV.B	[W0], W1
	MOV.B	#48, W0
	CP.B	W1, W0
	BRA Z	L__UART1INT1094
	GOTO	L_UART1INT74
L__UART1INT1094:
	CALL	_clear_uart1
L_UART1INT74:
;uart_int_lib.h,50 :: 		U1RXIF_bit=0;
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;uart_int_lib.h,51 :: 		}
L_end_UART1INT:
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _UART1INT

_UART2INT:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;uart_int_lib.h,53 :: 		void UART2INT() iv IVT_ADDR_U2RXINTERRUPT
;uart_int_lib.h,55 :: 		while(U2STAbits.URXDA)
	PUSH	W10
L_UART2INT75:
	BTSS	U2STAbits, #0
	GOTO	L_UART2INT76
;uart_int_lib.h,57 :: 		udata2=UART2_Read();
	CALL	_UART2_Read
	MOV	#lo_addr(_udata2), W1
	MOV.B	W0, [W1]
;uart_int_lib.h,58 :: 		if(debug_gsm) UART1_Write(udata2);
	MOV	#lo_addr(_debug_gsm), W0
	CP0.B	[W0]
	BRA NZ	L__UART2INT1096
	GOTO	L_UART2INT77
L__UART2INT1096:
	MOV	#lo_addr(_udata2), W0
	ZE	[W0], W10
	CALL	_UART1_Write
L_UART2INT77:
;uart_int_lib.h,59 :: 		if(!dis_int)
	MOV	#lo_addr(_dis_int), W0
	CP0.B	[W0]
	BRA Z	L__UART2INT1097
	GOTO	L_UART2INT78
L__UART2INT1097:
;uart_int_lib.h,61 :: 		if(udata2!=10)
	MOV	#lo_addr(_udata2), W0
	MOV.B	[W0], W0
	CP.B	W0, #10
	BRA NZ	L__UART2INT1098
	GOTO	L_UART2INT79
L__UART2INT1098:
;uart_int_lib.h,63 :: 		if(udata2!=13)
	MOV	#lo_addr(_udata2), W0
	MOV.B	[W0], W0
	CP.B	W0, #13
	BRA NZ	L__UART2INT1099
	GOTO	L_UART2INT80
L__UART2INT1099:
;uart_int_lib.h,65 :: 		uart2_data[uart2_data_pointer]=udata2;
	MOV	#lo_addr(_uart2_data_pointer), W0
	SE	[W0], W1
	MOV	#lo_addr(_uart2_data), W0
	ADD	W0, W1, W1
	MOV	#lo_addr(_udata2), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,66 :: 		uart2_data_pointer++;
	MOV.B	#1, W1
	MOV	#lo_addr(_uart2_data_pointer), W0
	ADD.B	W1, [W0], [W0]
;uart_int_lib.h,67 :: 		if(udata2=='>') sending_ready=1;
	MOV	#lo_addr(_udata2), W0
	MOV.B	[W0], W1
	MOV.B	#62, W0
	CP.B	W1, W0
	BRA Z	L__UART2INT1100
	GOTO	L_UART2INT81
L__UART2INT1100:
	MOV	#lo_addr(_sending_ready), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
L_UART2INT81:
;uart_int_lib.h,68 :: 		}
	GOTO	L_UART2INT82
L_UART2INT80:
;uart_int_lib.h,69 :: 		else if(uart2_data_pointer>0)
	MOV	#lo_addr(_uart2_data_pointer), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA GT	L__UART2INT1101
	GOTO	L_UART2INT83
L__UART2INT1101:
;uart_int_lib.h,80 :: 		uart2_data_received=1;
	MOV	#lo_addr(_uart2_data_received), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;uart_int_lib.h,81 :: 		}
L_UART2INT83:
L_UART2INT82:
;uart_int_lib.h,82 :: 		}
L_UART2INT79:
;uart_int_lib.h,83 :: 		if(uart2_data_pointer==47) uart2_data_pointer=0;
	MOV	#lo_addr(_uart2_data_pointer), W0
	MOV.B	[W0], W1
	MOV.B	#47, W0
	CP.B	W1, W0
	BRA Z	L__UART2INT1102
	GOTO	L_UART2INT84
L__UART2INT1102:
	MOV	#lo_addr(_uart2_data_pointer), W1
	CLR	W0
	MOV.B	W0, [W1]
L_UART2INT84:
;uart_int_lib.h,84 :: 		}
L_UART2INT78:
;uart_int_lib.h,85 :: 		}
	GOTO	L_UART2INT75
L_UART2INT76:
;uart_int_lib.h,86 :: 		U2RXIF_bit=0;
	BCLR	U2RXIF_bit, BitPos(U2RXIF_bit+0)
;uart_int_lib.h,87 :: 		}
L_end_UART2INT:
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _UART2INT

_distance_write:

;uart_int_lib.h,89 :: 		void distance_write()
;uart_int_lib.h,91 :: 		loop_distance=(uart1_data[6]-48)+(uart1_data[5]-48)*10+(uart1_data[4]-48)*100;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#lo_addr(_uart1_data+6), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W2
	MOV	#lo_addr(_uart1_data+5), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+4), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#100, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W0
	MOV	W0, _loop_distance
;uart_int_lib.h,92 :: 		eeprom_write(0x7FFC18,loop_distance);
	MOV	W0, W12
	MOV	#64536, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,93 :: 		delay_ms(5);
	MOV	#24573, W7
L_distance_write85:
	DEC	W7
	BRA NZ	L_distance_write85
	NOP
;uart_int_lib.h,94 :: 		NVMADR=0xFF00;
	MOV	#65280, W0
	MOV	WREG, NVMADR
;uart_int_lib.h,95 :: 		NVMADRU=0x007F;
	MOV	#127, W0
	MOV	WREG, NVMADRU
;uart_int_lib.h,96 :: 		}
L_end_distance_write:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _distance_write

_looplen_write:

;uart_int_lib.h,97 :: 		void looplen_write()
;uart_int_lib.h,99 :: 		loop_width=(uart1_data[6]-48)+(uart1_data[5]-48)*10+(uart1_data[4]-48)*100;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#lo_addr(_uart1_data+6), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W2
	MOV	#lo_addr(_uart1_data+5), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+4), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#100, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W0
	MOV	W0, _loop_width
;uart_int_lib.h,100 :: 		eeprom_write(0x7FFC1C,loop_width);
	MOV	W0, W12
	MOV	#64540, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,101 :: 		delay_ms(5);
	MOV	#24573, W7
L_looplen_write87:
	DEC	W7
	BRA NZ	L_looplen_write87
	NOP
;uart_int_lib.h,102 :: 		NVMADR=0xFF00;
	MOV	#65280, W0
	MOV	WREG, NVMADR
;uart_int_lib.h,103 :: 		NVMADRU=0x007F;
	MOV	#127, W0
	MOV	WREG, NVMADRU
;uart_int_lib.h,104 :: 		}
L_end_looplen_write:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _looplen_write

_margin_write:

;uart_int_lib.h,105 :: 		void margin_write()
;uart_int_lib.h,107 :: 		MARGINTOP=(uart1_data[5]-48)+(uart1_data[4]-48)*10;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#lo_addr(_uart1_data+5), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W2
	MOV	#lo_addr(_uart1_data+4), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W0
	MOV	W0, _MARGINTOP
;uart_int_lib.h,108 :: 		eeprom_write(0x7FFC00,MARGINTOP);
	MOV	W0, W12
	MOV	#64512, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,109 :: 		delay_ms(5);
	MOV	#24573, W7
L_margin_write89:
	DEC	W7
	BRA NZ	L_margin_write89
	NOP
;uart_int_lib.h,110 :: 		MARGINBOT=(uart1_data[7]-48)+(uart1_data[6]-48)*10;
	MOV	#lo_addr(_uart1_data+7), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W2
	MOV	#lo_addr(_uart1_data+6), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W0
	MOV	W0, _MARGINBOT
;uart_int_lib.h,111 :: 		eeprom_write(0x7FFC04,MARGINBOT);
	MOV	W0, W12
	MOV	#64516, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,112 :: 		delay_ms(5);
	MOV	#24573, W7
L_margin_write91:
	DEC	W7
	BRA NZ	L_margin_write91
	NOP
;uart_int_lib.h,113 :: 		NVMADR=0xFF00;
	MOV	#65280, W0
	MOV	WREG, NVMADR
;uart_int_lib.h,114 :: 		NVMADRU=0x007F;
	MOV	#127, W0
	MOV	WREG, NVMADRU
;uart_int_lib.h,115 :: 		}
L_end_margin_write:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _margin_write

_process_interface:

;uart_int_lib.h,116 :: 		void process_interface()
;uart_int_lib.h,119 :: 		UART1_Write(13); UART1_Write(10);
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#13, W10
	CALL	_UART1_Write
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,120 :: 		switch (function_code)
	GOTO	L_process_interface93
;uart_int_lib.h,122 :: 		case 0:
L_process_interface95:
;uart_int_lib.h,123 :: 		send_out(system_id);
	MOV	#lo_addr(_system_id), W10
	CALL	_send_out
;uart_int_lib.h,125 :: 		UART1_Write(',');
	MOV	#44, W10
	CALL	_UART1_Write
;uart_int_lib.h,126 :: 		UART1_Write_Text(datetimesec);
	MOV	#lo_addr(_datetimesec), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,127 :: 		UART1_Write(',');
	MOV	#44, W10
	CALL	_UART1_Write
;uart_int_lib.h,128 :: 		send_out(system_model);
	MOV	#lo_addr(?lstr_3_91_457), W10
	CALL	_send_out
;uart_int_lib.h,129 :: 		UART1_Write(',');
	MOV	#44, W10
	CALL	_UART1_Write
;uart_int_lib.h,130 :: 		send_out(version);
	MOV	#lo_addr(?lstr_4_91_457), W10
	CALL	_send_out
;uart_int_lib.h,131 :: 		UART1_Write(',');
	MOV	#44, W10
	CALL	_UART1_Write
;uart_int_lib.h,132 :: 		send_out("READY");
	MOV	#lo_addr(?lstr_5_91_457), W10
	CALL	_send_out
;uart_int_lib.h,133 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,134 :: 		case 2:
L_process_interface96:
;uart_int_lib.h,137 :: 		loop[0]=uart1_data[4]-48;
	MOV	#lo_addr(_uart1_data+4), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	MOV	W0, _loop
;uart_int_lib.h,138 :: 		eeprom_write(0x7FFC08,loop[0]);
	MOV	W0, W12
	MOV	#64520, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,139 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface97:
	DEC	W7
	BRA NZ	L_process_interface97
	NOP
;uart_int_lib.h,140 :: 		loop[1]=uart1_data[5]-48;
	MOV	#lo_addr(_uart1_data+5), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	MOV	W0, _loop+2
;uart_int_lib.h,141 :: 		eeprom_write(0x7FFC0C,loop[1]);
	MOV	W0, W12
	MOV	#64524, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,142 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface99:
	DEC	W7
	BRA NZ	L_process_interface99
	NOP
;uart_int_lib.h,143 :: 		loop[2]=uart1_data[6]-48;
	MOV	#lo_addr(_uart1_data+6), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	MOV	W0, _loop+4
;uart_int_lib.h,144 :: 		eeprom_write(0x7FFC10,loop[2]);
	MOV	W0, W12
	MOV	#64528, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,145 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface101:
	DEC	W7
	BRA NZ	L_process_interface101
	NOP
;uart_int_lib.h,146 :: 		loop[3]=uart1_data[7]-48;
	MOV	#lo_addr(_uart1_data+7), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	MOV	W0, _loop+6
;uart_int_lib.h,147 :: 		eeprom_write(0x7FFC14,loop[3]);
	MOV	W0, W12
	MOV	#64532, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,148 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface103:
	DEC	W7
	BRA NZ	L_process_interface103
	NOP
;uart_int_lib.h,150 :: 		NVMADR=0xFF00;
	MOV	#65280, W0
	MOV	WREG, NVMADR
;uart_int_lib.h,151 :: 		NVMADRU=0x007F;
	MOV	#127, W0
	MOV	WREG, NVMADRU
;uart_int_lib.h,153 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,154 :: 		case 197:
L_process_interface105:
;uart_int_lib.h,156 :: 		current_sector= 31*24*60*(unsigned long)((uart1_data[6]-48)*10+(uart1_data[7]-48));
	MOV	#lo_addr(_uart1_data+6), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_uart1_data+7), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	ADD	W2, W0, W0
	ASR	W0, #15, W1
	MOV	#44640, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	W0, _current_sector
	MOV	W1, _current_sector+2
;uart_int_lib.h,157 :: 		current_sector+= 24*60*(unsigned long)((uart1_data[8]-48)*10+(uart1_data[9]-48));
	MOV	#lo_addr(_uart1_data+8), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_uart1_data+9), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	ADD	W2, W0, W0
	ASR	W0, #15, W1
	MOV	#1440, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	#lo_addr(_current_sector), W2
	ADD	W0, [W2], [W2++]
	ADDC	W1, [W2], [W2--]
;uart_int_lib.h,158 :: 		current_sector+= 60*(unsigned long)((uart1_data[10]-48)*10+(uart1_data[11]-48));
	MOV	#lo_addr(_uart1_data+10), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_uart1_data+11), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	ADD	W2, W0, W0
	ASR	W0, #15, W1
	MOV	#60, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	#lo_addr(_current_sector), W2
	ADD	W0, [W2], [W2++]
	ADDC	W1, [W2], [W2--]
;uart_int_lib.h,159 :: 		current_sector+= (unsigned long)((uart1_data[12]-48)*10+(uart1_data[13]-48));
	MOV	#lo_addr(_uart1_data+12), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_uart1_data+13), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	ADD	W2, W0, W0
	MOV	W0, W3
	ASR	W3, #15, W4
	MOV	#lo_addr(_current_sector), W2
	ADD	W3, [W2++], W0
	ADDC	W4, [W2--], W1
	MOV	W0, _current_sector
	MOV	W1, _current_sector+2
;uart_int_lib.h,160 :: 		Mmc_Read_Sector(current_sector, interval_data);
	MOV	#lo_addr(_interval_data), W12
	MOV.D	W0, W10
	CALL	_Mmc_Read_Sector
;uart_int_lib.h,162 :: 		interval_data[9]!=uart1_data[5] ||
	MOV	#lo_addr(_interval_data+8), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_uart1_data+4), W0
	CP.B	W1, [W0]
	BRA Z	L__process_interface1107
	GOTO	L__process_interface856
L__process_interface1107:
	MOV	#lo_addr(_interval_data+9), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_uart1_data+5), W0
	CP.B	W1, [W0]
	BRA Z	L__process_interface1108
	GOTO	L__process_interface855
L__process_interface1108:
;uart_int_lib.h,163 :: 		interval_data[10]!=uart1_data[6] ||
	MOV	#lo_addr(_interval_data+10), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_uart1_data+6), W0
	CP.B	W1, [W0]
	BRA Z	L__process_interface1109
	GOTO	L__process_interface854
L__process_interface1109:
;uart_int_lib.h,164 :: 		interval_data[11]!=uart1_data[7] ||
	MOV	#lo_addr(_interval_data+11), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_uart1_data+7), W0
	CP.B	W1, [W0]
	BRA Z	L__process_interface1110
	GOTO	L__process_interface853
L__process_interface1110:
;uart_int_lib.h,165 :: 		interval_data[12]!=uart1_data[8] ||
	MOV	#lo_addr(_interval_data+12), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_uart1_data+8), W0
	CP.B	W1, [W0]
	BRA Z	L__process_interface1111
	GOTO	L__process_interface852
L__process_interface1111:
;uart_int_lib.h,166 :: 		interval_data[13]!=uart1_data[9] ||
	MOV	#lo_addr(_interval_data+13), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_uart1_data+9), W0
	CP.B	W1, [W0]
	BRA Z	L__process_interface1112
	GOTO	L__process_interface851
L__process_interface1112:
;uart_int_lib.h,167 :: 		interval_data[14]!=uart1_data[10] ||
	MOV	#lo_addr(_interval_data+14), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_uart1_data+10), W0
	CP.B	W1, [W0]
	BRA Z	L__process_interface1113
	GOTO	L__process_interface850
L__process_interface1113:
;uart_int_lib.h,168 :: 		interval_data[15]!=uart1_data[11] ||
	MOV	#lo_addr(_interval_data+15), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_uart1_data+11), W0
	CP.B	W1, [W0]
	BRA Z	L__process_interface1114
	GOTO	L__process_interface849
L__process_interface1114:
;uart_int_lib.h,169 :: 		interval_data[16]!=uart1_data[12] ||
	MOV	#lo_addr(_interval_data+16), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_uart1_data+12), W0
	CP.B	W1, [W0]
	BRA Z	L__process_interface1115
	GOTO	L__process_interface848
L__process_interface1115:
;uart_int_lib.h,170 :: 		interval_data[17]!=uart1_data[13])
	MOV	#lo_addr(_interval_data+17), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_uart1_data+13), W0
	CP.B	W1, [W0]
	BRA Z	L__process_interface1116
	GOTO	L__process_interface847
L__process_interface1116:
	GOTO	L_process_interface108
;uart_int_lib.h,162 :: 		interval_data[9]!=uart1_data[5] ||
L__process_interface856:
L__process_interface855:
;uart_int_lib.h,163 :: 		interval_data[10]!=uart1_data[6] ||
L__process_interface854:
;uart_int_lib.h,164 :: 		interval_data[11]!=uart1_data[7] ||
L__process_interface853:
;uart_int_lib.h,165 :: 		interval_data[12]!=uart1_data[8] ||
L__process_interface852:
;uart_int_lib.h,166 :: 		interval_data[13]!=uart1_data[9] ||
L__process_interface851:
;uart_int_lib.h,167 :: 		interval_data[14]!=uart1_data[10] ||
L__process_interface850:
;uart_int_lib.h,168 :: 		interval_data[15]!=uart1_data[11] ||
L__process_interface849:
;uart_int_lib.h,169 :: 		interval_data[16]!=uart1_data[12] ||
L__process_interface848:
;uart_int_lib.h,170 :: 		interval_data[17]!=uart1_data[13])
L__process_interface847:
;uart_int_lib.h,172 :: 		reset_interval_data();
	CALL	_reset_interval_data
;uart_int_lib.h,173 :: 		interval_data[8]=uart1_data[4];
	MOV	#lo_addr(_interval_data+8), W1
	MOV	#lo_addr(_uart1_data+4), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,174 :: 		interval_data[9]=uart1_data[5];
	MOV	#lo_addr(_interval_data+9), W1
	MOV	#lo_addr(_uart1_data+5), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,175 :: 		interval_data[10]=uart1_data[6];
	MOV	#lo_addr(_interval_data+10), W1
	MOV	#lo_addr(_uart1_data+6), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,176 :: 		interval_data[11]=uart1_data[7];
	MOV	#lo_addr(_interval_data+11), W1
	MOV	#lo_addr(_uart1_data+7), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,177 :: 		interval_data[12]=uart1_data[8];
	MOV	#lo_addr(_interval_data+12), W1
	MOV	#lo_addr(_uart1_data+8), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,178 :: 		interval_data[13]=uart1_data[9];
	MOV	#lo_addr(_interval_data+13), W1
	MOV	#lo_addr(_uart1_data+9), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,179 :: 		interval_data[14]=uart1_data[10];
	MOV	#lo_addr(_interval_data+14), W1
	MOV	#lo_addr(_uart1_data+10), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,180 :: 		interval_data[15]=uart1_data[11];
	MOV	#lo_addr(_interval_data+15), W1
	MOV	#lo_addr(_uart1_data+11), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,181 :: 		interval_data[16]=uart1_data[12];
	MOV	#lo_addr(_interval_data+16), W1
	MOV	#lo_addr(_uart1_data+12), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,182 :: 		interval_data[17]=uart1_data[13];
	MOV	#lo_addr(_interval_data+17), W1
	MOV	#lo_addr(_uart1_data+13), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,183 :: 		}
L_process_interface108:
;uart_int_lib.h,184 :: 		for(cal_interval_cnt=0;cal_interval_cnt<264;cal_interval_cnt++)
	CLR	W0
	MOV	W0, _cal_interval_cnt
L_process_interface109:
	MOV	_cal_interval_cnt, W1
	MOV	#264, W0
	CP	W1, W0
	BRA LTU	L__process_interface1117
	GOTO	L_process_interface110
L__process_interface1117:
;uart_int_lib.h,186 :: 		UART1_Write(interval_data[cal_interval_cnt]);
	MOV	#lo_addr(_interval_data), W1
	MOV	#lo_addr(_cal_interval_cnt), W0
	ADD	W1, [W0], W0
	ZE	[W0], W10
	CALL	_UART1_Write
;uart_int_lib.h,184 :: 		for(cal_interval_cnt=0;cal_interval_cnt<264;cal_interval_cnt++)
	MOV	#1, W1
	MOV	#lo_addr(_cal_interval_cnt), W0
	ADD	W1, [W0], [W0]
;uart_int_lib.h,187 :: 		}
	GOTO	L_process_interface109
L_process_interface110:
;uart_int_lib.h,189 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,190 :: 		case 3:
L_process_interface112:
;uart_int_lib.h,193 :: 		AUTCAL=uart1_data[4]-48;
	MOV	#lo_addr(_uart1_data+4), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	MOV	W0, _AUTCAL
;uart_int_lib.h,194 :: 		eeprom_write(0x7FFCCC,AUTCAL);
	MOV	W0, W12
	MOV	#64716, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,195 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface113:
	DEC	W7
	BRA NZ	L_process_interface113
	NOP
;uart_int_lib.h,196 :: 		NVMADR=0xFF00;
	MOV	#65280, W0
	MOV	WREG, NVMADR
;uart_int_lib.h,197 :: 		NVMADRU=0x007F;
	MOV	#127, W0
	MOV	WREG, NVMADRU
;uart_int_lib.h,200 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,201 :: 		case 4:
L_process_interface115:
;uart_int_lib.h,204 :: 		distance_write();
	CALL	_distance_write
;uart_int_lib.h,207 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,208 :: 		case 5:
L_process_interface116:
;uart_int_lib.h,211 :: 		looplen_write();
	CALL	_looplen_write
;uart_int_lib.h,214 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,215 :: 		case 6:
L_process_interface117:
;uart_int_lib.h,218 :: 		onloop0=1;
	BSET	LATE0_bit, BitPos(LATE0_bit+0)
;uart_int_lib.h,219 :: 		onloop1=1;
	BSET	LATE1_bit, BitPos(LATE1_bit+0)
;uart_int_lib.h,220 :: 		onloop2=1;
	BSET	LATE2_bit, BitPos(LATE2_bit+0)
;uart_int_lib.h,221 :: 		onloop3=1;
	BSET	LATE3_bit, BitPos(LATE3_bit+0)
;uart_int_lib.h,222 :: 		cal();
	CALL	_cal
;uart_int_lib.h,223 :: 		onloop0=0;
	BCLR	LATE0_bit, BitPos(LATE0_bit+0)
;uart_int_lib.h,224 :: 		onloop1=0;
	BCLR	LATE1_bit, BitPos(LATE1_bit+0)
;uart_int_lib.h,225 :: 		onloop2=0;
	BCLR	LATE2_bit, BitPos(LATE2_bit+0)
;uart_int_lib.h,226 :: 		onloop3=0;
	BCLR	LATE3_bit, BitPos(LATE3_bit+0)
;uart_int_lib.h,228 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,229 :: 		case 7:
L_process_interface118:
;uart_int_lib.h,230 :: 		longtostr((long)(235930/caldata[0]),debug_txt);
	MOV	_caldata, W2
	MOV	_caldata+2, W3
	MOV	#39322, W0
	MOV	#3, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_debug_txt), W12
	MOV.D	W0, W10
	CALL	_LongToStr
;uart_int_lib.h,231 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,232 :: 		UART1_Write(',');
	MOV	#44, W10
	CALL	_UART1_Write
;uart_int_lib.h,233 :: 		longtostr((long)(235930/caldata[1]),debug_txt);
	MOV	_caldata+4, W2
	MOV	_caldata+6, W3
	MOV	#39322, W0
	MOV	#3, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_debug_txt), W12
	MOV.D	W0, W10
	CALL	_LongToStr
;uart_int_lib.h,234 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,235 :: 		UART1_Write(',');
	MOV	#44, W10
	CALL	_UART1_Write
;uart_int_lib.h,236 :: 		longtostr((long)(235930/caldata[2]),debug_txt);
	MOV	_caldata+8, W2
	MOV	_caldata+10, W3
	MOV	#39322, W0
	MOV	#3, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_debug_txt), W12
	MOV.D	W0, W10
	CALL	_LongToStr
;uart_int_lib.h,237 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,238 :: 		UART1_Write(',');
	MOV	#44, W10
	CALL	_UART1_Write
;uart_int_lib.h,239 :: 		longtostr((long)(235930/caldata[3]),debug_txt);
	MOV	_caldata+12, W2
	MOV	_caldata+14, W3
	MOV	#39322, W0
	MOV	#3, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_debug_txt), W12
	MOV.D	W0, W10
	CALL	_LongToStr
;uart_int_lib.h,240 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,241 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,242 :: 		case 8:
L_process_interface119:
;uart_int_lib.h,245 :: 		debug=!debug;
	MOV	#lo_addr(_debug), W0
	MOV.B	[W0], W0
	CP0.B	W0
	CLR.B	W1
	BRA NZ	L__process_interface1118
	INC.B	W1
L__process_interface1118:
	MOV	#lo_addr(_debug), W0
	MOV.B	W1, [W0]
;uart_int_lib.h,246 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,248 :: 		case 10:
L_process_interface120:
;uart_int_lib.h,251 :: 		margin_write();
	CALL	_margin_write
;uart_int_lib.h,254 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,255 :: 		case 11:
L_process_interface121:
;uart_int_lib.h,258 :: 		HMM=(uart1_data[4]-48)*10+(uart1_data[5]-48);
	MOV	#lo_addr(_uart1_data+4), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_uart1_data+5), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	ADD	W2, W0, W0
	MOV	W0, _HMM
;uart_int_lib.h,259 :: 		if(HMM<10) HMM = 10;
	CP	W0, #10
	BRA LT	L__process_interface1119
	GOTO	L_process_interface122
L__process_interface1119:
	MOV	#10, W0
	MOV	W0, _HMM
L_process_interface122:
;uart_int_lib.h,260 :: 		eeprom_write(0x7FFCC8,HMM);
	MOV	_HMM, W12
	MOV	#64712, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,261 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface123:
	DEC	W7
	BRA NZ	L_process_interface123
	NOP
;uart_int_lib.h,264 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,265 :: 		case 12:
L_process_interface125:
;uart_int_lib.h,268 :: 		rtc_write(1);
	MOV.B	#1, W10
	CALL	_rtc_write
;uart_int_lib.h,271 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,272 :: 		case 13:
L_process_interface126:
;uart_int_lib.h,275 :: 		Reset();
	RESET
;uart_int_lib.h,276 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,278 :: 		case 17:
L_process_interface127:
;uart_int_lib.h,280 :: 		sim900_restart();
	CALL	_sim900_restart
;uart_int_lib.h,281 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,282 :: 		case 18:
L_process_interface128:
;uart_int_lib.h,284 :: 		UART2_Write('A');
	MOV	#65, W10
	CALL	_UART2_Write
;uart_int_lib.h,285 :: 		delay_ms(50);
	MOV	#4, W8
	MOV	#49125, W7
L_process_interface129:
	DEC	W7
	BRA NZ	L_process_interface129
	DEC	W8
	BRA NZ	L_process_interface129
	NOP
;uart_int_lib.h,286 :: 		send_atc("T+CSQ");
	MOV	#lo_addr(?lstr_6_91_457), W10
	CALL	_send_atc
;uart_int_lib.h,288 :: 		clear_UART2();
	CALL	_clear_uart2
;uart_int_lib.h,289 :: 		debug_gsm=1;
	MOV	#lo_addr(_debug_gsm), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;uart_int_lib.h,290 :: 		UART2_Write(13);
	MOV	#13, W10
	CALL	_UART2_Write
;uart_int_lib.h,291 :: 		delay_ms(100);
	MOV	#8, W8
	MOV	#32716, W7
L_process_interface131:
	DEC	W7
	BRA NZ	L_process_interface131
	DEC	W8
	BRA NZ	L_process_interface131
;uart_int_lib.h,292 :: 		debug_gsm=0;
	MOV	#lo_addr(_debug_gsm), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart_int_lib.h,296 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,297 :: 		case 19:
L_process_interface133:
;uart_int_lib.h,300 :: 		DSPEED1=(uart1_data[4]-48)*100+(uart1_data[5]-48)*10+(uart1_data[6]-48);
	MOV	#lo_addr(_uart1_data+4), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#100, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_uart1_data+5), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+6), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#lo_addr(_DSPEED1), W0
	ADD	W2, W1, [W0]
;uart_int_lib.h,301 :: 		NSPEED1=(uart1_data[7]-48)*100+(uart1_data[8]-48)*10+(uart1_data[9]-48);
	MOV	#lo_addr(_uart1_data+7), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#100, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_uart1_data+8), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+9), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#lo_addr(_NSPEED1), W0
	ADD	W2, W1, [W0]
;uart_int_lib.h,302 :: 		DSPEED2=(uart1_data[10]-48)*100+(uart1_data[11]-48)*10+(uart1_data[12]-48);
	MOV	#lo_addr(_uart1_data+10), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#100, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_uart1_data+11), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+12), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#lo_addr(_DSPEED2), W0
	ADD	W2, W1, [W0]
;uart_int_lib.h,303 :: 		NSPEED2=(uart1_data[13]-48)*100+(uart1_data[14]-48)*10+(uart1_data[15]-48);
	MOV	#lo_addr(_uart1_data+13), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#100, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_uart1_data+14), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+15), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#lo_addr(_NSPEED2), W0
	ADD	W2, W1, [W0]
;uart_int_lib.h,305 :: 		eeprom_write(0x7FFCC0,DSPEED1);
	MOV	_DSPEED1, W12
	MOV	#64704, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,306 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface134:
	DEC	W7
	BRA NZ	L_process_interface134
	NOP
;uart_int_lib.h,307 :: 		eeprom_write(0x7FFCC4,NSPEED1);
	MOV	_NSPEED1, W12
	MOV	#64708, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,308 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface136:
	DEC	W7
	BRA NZ	L_process_interface136
	NOP
;uart_int_lib.h,309 :: 		eeprom_write(0x7FFCD0,DSPEED2);
	MOV	_DSPEED2, W12
	MOV	#64720, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,310 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface138:
	DEC	W7
	BRA NZ	L_process_interface138
	NOP
;uart_int_lib.h,311 :: 		eeprom_write(0x7FFCD4,NSPEED2);
	MOV	_NSPEED2, W12
	MOV	#64724, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,312 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface140:
	DEC	W7
	BRA NZ	L_process_interface140
	NOP
;uart_int_lib.h,314 :: 		NVMADR=0xFF00;
	MOV	#65280, W0
	MOV	WREG, NVMADR
;uart_int_lib.h,315 :: 		NVMADRU=0x007F;
	MOV	#127, W0
	MOV	WREG, NVMADRU
;uart_int_lib.h,317 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,318 :: 		case 21:
L_process_interface142:
;uart_int_lib.h,321 :: 		power_type=uart1_data[4]-48;
	MOV	#lo_addr(_uart1_data+4), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	MOV	W0, _power_type
;uart_int_lib.h,322 :: 		eeprom_write(0x7FFC58,power_type);
	MOV	W0, W12
	MOV	#64600, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,323 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface143:
	DEC	W7
	BRA NZ	L_process_interface143
	NOP
;uart_int_lib.h,325 :: 		NVMADR=0xFF00;
	MOV	#65280, W0
	MOV	WREG, NVMADR
;uart_int_lib.h,326 :: 		NVMADRU=0x007F;
	MOV	#127, W0
	MOV	WREG, NVMADRU
;uart_int_lib.h,328 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,329 :: 		case 22:
L_process_interface145:
;uart_int_lib.h,332 :: 		sms_number_1[0]=uart1_data[4];
	MOV	#lo_addr(_sms_number_1), W1
	MOV	#lo_addr(_uart1_data+4), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,333 :: 		sms_number_1[1]=uart1_data[5];
	MOV	#lo_addr(_sms_number_1+1), W1
	MOV	#lo_addr(_uart1_data+5), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,334 :: 		sms_number_1[2]=uart1_data[6];
	MOV	#lo_addr(_sms_number_1+2), W1
	MOV	#lo_addr(_uart1_data+6), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,335 :: 		sms_number_1[3]=uart1_data[7];
	MOV	#lo_addr(_sms_number_1+3), W1
	MOV	#lo_addr(_uart1_data+7), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,336 :: 		sms_number_1[4]=uart1_data[8];
	MOV	#lo_addr(_sms_number_1+4), W1
	MOV	#lo_addr(_uart1_data+8), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,337 :: 		sms_number_1[5]=uart1_data[9];
	MOV	#lo_addr(_sms_number_1+5), W1
	MOV	#lo_addr(_uart1_data+9), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,338 :: 		sms_number_1[6]=uart1_data[10];
	MOV	#lo_addr(_sms_number_1+6), W1
	MOV	#lo_addr(_uart1_data+10), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,339 :: 		sms_number_1[7]=uart1_data[11];
	MOV	#lo_addr(_sms_number_1+7), W1
	MOV	#lo_addr(_uart1_data+11), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,340 :: 		sms_number_1[8]=uart1_data[12];
	MOV	#lo_addr(_sms_number_1+8), W1
	MOV	#lo_addr(_uart1_data+12), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,341 :: 		sms_number_1[9]=uart1_data[13];
	MOV	#lo_addr(_sms_number_1+9), W1
	MOV	#lo_addr(_uart1_data+13), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,342 :: 		sms_number_1[10]=uart1_data[14];
	MOV	#lo_addr(_sms_number_1+10), W1
	MOV	#lo_addr(_uart1_data+14), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,343 :: 		eeprom_write(0x7FFC60,(int)(sms_number_1[0]*256+sms_number_1[1]));
	MOV	#lo_addr(_sms_number_1), W0
	ZE	[W0], W0
	SL	W0, #8, W1
	MOV	#lo_addr(_sms_number_1+1), W0
	ZE	[W0], W0
	ADD	W1, W0, W0
	MOV	W0, W12
	MOV	#64608, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,344 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface146:
	DEC	W7
	BRA NZ	L_process_interface146
	NOP
;uart_int_lib.h,345 :: 		eeprom_write(0x7FFC64,(int)(sms_number_1[2]*256+sms_number_1[3]));
	MOV	#lo_addr(_sms_number_1+2), W0
	ZE	[W0], W0
	SL	W0, #8, W1
	MOV	#lo_addr(_sms_number_1+3), W0
	ZE	[W0], W0
	ADD	W1, W0, W0
	MOV	W0, W12
	MOV	#64612, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,346 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface148:
	DEC	W7
	BRA NZ	L_process_interface148
	NOP
;uart_int_lib.h,347 :: 		eeprom_write(0x7FFC68,(int)(sms_number_1[4]*256+sms_number_1[5]));
	MOV	#lo_addr(_sms_number_1+4), W0
	ZE	[W0], W0
	SL	W0, #8, W1
	MOV	#lo_addr(_sms_number_1+5), W0
	ZE	[W0], W0
	ADD	W1, W0, W0
	MOV	W0, W12
	MOV	#64616, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,348 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface150:
	DEC	W7
	BRA NZ	L_process_interface150
	NOP
;uart_int_lib.h,349 :: 		eeprom_write(0x7FFC6C,(int)(sms_number_1[6]*256+sms_number_1[7]));
	MOV	#lo_addr(_sms_number_1+6), W0
	ZE	[W0], W0
	SL	W0, #8, W1
	MOV	#lo_addr(_sms_number_1+7), W0
	ZE	[W0], W0
	ADD	W1, W0, W0
	MOV	W0, W12
	MOV	#64620, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,350 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface152:
	DEC	W7
	BRA NZ	L_process_interface152
	NOP
;uart_int_lib.h,351 :: 		eeprom_write(0x7FFC70,(int)(sms_number_1[8]*256+sms_number_1[9]));
	MOV	#lo_addr(_sms_number_1+8), W0
	ZE	[W0], W0
	SL	W0, #8, W1
	MOV	#lo_addr(_sms_number_1+9), W0
	ZE	[W0], W0
	ADD	W1, W0, W0
	MOV	W0, W12
	MOV	#64624, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,352 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface154:
	DEC	W7
	BRA NZ	L_process_interface154
	NOP
;uart_int_lib.h,353 :: 		eeprom_write(0x7FFC74,(int)(sms_number_1[10]*256));
	MOV	#lo_addr(_sms_number_1+10), W0
	ZE	[W0], W0
	SL	W0, #8, W0
	MOV	W0, W12
	MOV	#64628, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,354 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface156:
	DEC	W7
	BRA NZ	L_process_interface156
	NOP
;uart_int_lib.h,356 :: 		NVMADR=0xFF00;
	MOV	#65280, W0
	MOV	WREG, NVMADR
;uart_int_lib.h,357 :: 		NVMADRU=0x007F;
	MOV	#127, W0
	MOV	WREG, NVMADRU
;uart_int_lib.h,359 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,360 :: 		case 23:
L_process_interface158:
;uart_int_lib.h,363 :: 		location_name[0]=uart1_data[4];
	MOV	#lo_addr(_location_name), W1
	MOV	#lo_addr(_uart1_data+4), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,364 :: 		location_name[1]=uart1_data[5];
	MOV	#lo_addr(_location_name+1), W1
	MOV	#lo_addr(_uart1_data+5), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,365 :: 		location_name[2]=uart1_data[6];
	MOV	#lo_addr(_location_name+2), W1
	MOV	#lo_addr(_uart1_data+6), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,366 :: 		location_name[3]=uart1_data[7];
	MOV	#lo_addr(_location_name+3), W1
	MOV	#lo_addr(_uart1_data+7), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,367 :: 		location_name[4]=uart1_data[8];
	MOV	#lo_addr(_location_name+4), W1
	MOV	#lo_addr(_uart1_data+8), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,368 :: 		location_name[5]=uart1_data[9];
	MOV	#lo_addr(_location_name+5), W1
	MOV	#lo_addr(_uart1_data+9), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,369 :: 		location_name[6]=uart1_data[10];
	MOV	#lo_addr(_location_name+6), W1
	MOV	#lo_addr(_uart1_data+10), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,370 :: 		location_name[7]=uart1_data[11];
	MOV	#lo_addr(_location_name+7), W1
	MOV	#lo_addr(_uart1_data+11), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,371 :: 		location_name[8]=uart1_data[12];
	MOV	#lo_addr(_location_name+8), W1
	MOV	#lo_addr(_uart1_data+12), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,372 :: 		location_name[9]=uart1_data[13];
	MOV	#lo_addr(_location_name+9), W1
	MOV	#lo_addr(_uart1_data+13), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,373 :: 		location_name[10]=uart1_data[14];
	MOV	#lo_addr(_location_name+10), W1
	MOV	#lo_addr(_uart1_data+14), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,374 :: 		location_name[11]=uart1_data[15];
	MOV	#lo_addr(_location_name+11), W1
	MOV	#lo_addr(_uart1_data+15), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,375 :: 		location_name[12]=uart1_data[16];
	MOV	#lo_addr(_location_name+12), W1
	MOV	#lo_addr(_uart1_data+16), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,376 :: 		location_name[13]=uart1_data[17];
	MOV	#lo_addr(_location_name+13), W1
	MOV	#lo_addr(_uart1_data+17), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,377 :: 		location_name[14]=uart1_data[18];
	MOV	#lo_addr(_location_name+14), W1
	MOV	#lo_addr(_uart1_data+18), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,378 :: 		location_name[15]=uart1_data[19];
	MOV	#lo_addr(_location_name+15), W1
	MOV	#lo_addr(_uart1_data+19), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,379 :: 		location_name[16]=uart1_data[20];
	MOV	#lo_addr(_location_name+16), W1
	MOV	#lo_addr(_uart1_data+20), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,380 :: 		location_name[17]=uart1_data[21];
	MOV	#lo_addr(_location_name+17), W1
	MOV	#lo_addr(_uart1_data+21), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,381 :: 		location_name[18]=uart1_data[22];
	MOV	#lo_addr(_location_name+18), W1
	MOV	#lo_addr(_uart1_data+22), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,382 :: 		location_name[19]=uart1_data[23];
	MOV	#lo_addr(_location_name+19), W1
	MOV	#lo_addr(_uart1_data+23), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,383 :: 		location_name[20]=uart1_data[24];
	MOV	#lo_addr(_location_name+20), W1
	MOV	#lo_addr(_uart1_data+24), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,384 :: 		location_name[21]=uart1_data[25];
	MOV	#lo_addr(_location_name+21), W1
	MOV	#lo_addr(_uart1_data+25), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,385 :: 		location_name[22]=uart1_data[26];
	MOV	#lo_addr(_location_name+22), W1
	MOV	#lo_addr(_uart1_data+26), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,386 :: 		location_name[23]=uart1_data[27];
	MOV	#lo_addr(_location_name+23), W1
	MOV	#lo_addr(_uart1_data+27), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,387 :: 		location_name[24]=uart1_data[28];
	MOV	#lo_addr(_location_name+24), W1
	MOV	#lo_addr(_uart1_data+28), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,388 :: 		location_name[25]=uart1_data[29];
	MOV	#lo_addr(_location_name+25), W1
	MOV	#lo_addr(_uart1_data+29), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,389 :: 		location_name[26]=uart1_data[30];
	MOV	#lo_addr(_location_name+26), W1
	MOV	#lo_addr(_uart1_data+30), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,390 :: 		location_name[27]=uart1_data[31];
	MOV	#lo_addr(_location_name+27), W1
	MOV	#lo_addr(_uart1_data+31), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,391 :: 		location_name[28]=uart1_data[32];
	MOV	#lo_addr(_location_name+28), W1
	MOV	#lo_addr(_uart1_data+32), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,392 :: 		location_name[29]=uart1_data[33];
	MOV	#lo_addr(_location_name+29), W1
	MOV	#lo_addr(_uart1_data+33), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,393 :: 		location_name[30]=uart1_data[34];
	MOV	#lo_addr(_location_name+30), W1
	MOV	#lo_addr(_uart1_data+34), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,394 :: 		location_name[31]=uart1_data[35];
	MOV	#lo_addr(_location_name+31), W1
	MOV	#lo_addr(_uart1_data+35), W0
	MOV.B	[W0], [W1]
;uart_int_lib.h,395 :: 		eeprom_write(0x7FFC80,(int)(location_name[0]*256+location_name[1]));
	MOV	#lo_addr(_location_name), W0
	ZE	[W0], W0
	SL	W0, #8, W1
	MOV	#lo_addr(_location_name+1), W0
	ZE	[W0], W0
	ADD	W1, W0, W0
	MOV	W0, W12
	MOV	#64640, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,396 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface159:
	DEC	W7
	BRA NZ	L_process_interface159
	NOP
;uart_int_lib.h,397 :: 		eeprom_write(0x7FFC84,(int)(location_name[2]*256+location_name[3]));
	MOV	#lo_addr(_location_name+2), W0
	ZE	[W0], W0
	SL	W0, #8, W1
	MOV	#lo_addr(_location_name+3), W0
	ZE	[W0], W0
	ADD	W1, W0, W0
	MOV	W0, W12
	MOV	#64644, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,398 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface161:
	DEC	W7
	BRA NZ	L_process_interface161
	NOP
;uart_int_lib.h,399 :: 		eeprom_write(0x7FFC88,(int)(location_name[4]*256+location_name[5]));
	MOV	#lo_addr(_location_name+4), W0
	ZE	[W0], W0
	SL	W0, #8, W1
	MOV	#lo_addr(_location_name+5), W0
	ZE	[W0], W0
	ADD	W1, W0, W0
	MOV	W0, W12
	MOV	#64648, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,400 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface163:
	DEC	W7
	BRA NZ	L_process_interface163
	NOP
;uart_int_lib.h,401 :: 		eeprom_write(0x7FFC8C,(int)(location_name[6]*256+location_name[7]));
	MOV	#lo_addr(_location_name+6), W0
	ZE	[W0], W0
	SL	W0, #8, W1
	MOV	#lo_addr(_location_name+7), W0
	ZE	[W0], W0
	ADD	W1, W0, W0
	MOV	W0, W12
	MOV	#64652, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,402 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface165:
	DEC	W7
	BRA NZ	L_process_interface165
	NOP
;uart_int_lib.h,403 :: 		eeprom_write(0x7FFC90,(int)(location_name[8]*256+location_name[9]));
	MOV	#lo_addr(_location_name+8), W0
	ZE	[W0], W0
	SL	W0, #8, W1
	MOV	#lo_addr(_location_name+9), W0
	ZE	[W0], W0
	ADD	W1, W0, W0
	MOV	W0, W12
	MOV	#64656, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,404 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface167:
	DEC	W7
	BRA NZ	L_process_interface167
	NOP
;uart_int_lib.h,405 :: 		eeprom_write(0x7FFC94,(int)(location_name[10]*256+location_name[11]));
	MOV	#lo_addr(_location_name+10), W0
	ZE	[W0], W0
	SL	W0, #8, W1
	MOV	#lo_addr(_location_name+11), W0
	ZE	[W0], W0
	ADD	W1, W0, W0
	MOV	W0, W12
	MOV	#64660, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,406 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface169:
	DEC	W7
	BRA NZ	L_process_interface169
	NOP
;uart_int_lib.h,407 :: 		eeprom_write(0x7FFC98,(int)(location_name[12]*256+location_name[13]));
	MOV	#lo_addr(_location_name+12), W0
	ZE	[W0], W0
	SL	W0, #8, W1
	MOV	#lo_addr(_location_name+13), W0
	ZE	[W0], W0
	ADD	W1, W0, W0
	MOV	W0, W12
	MOV	#64664, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,408 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface171:
	DEC	W7
	BRA NZ	L_process_interface171
	NOP
;uart_int_lib.h,409 :: 		eeprom_write(0x7FFC9C,(int)(location_name[14]*256+location_name[15]));
	MOV	#lo_addr(_location_name+14), W0
	ZE	[W0], W0
	SL	W0, #8, W1
	MOV	#lo_addr(_location_name+15), W0
	ZE	[W0], W0
	ADD	W1, W0, W0
	MOV	W0, W12
	MOV	#64668, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,410 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface173:
	DEC	W7
	BRA NZ	L_process_interface173
	NOP
;uart_int_lib.h,411 :: 		eeprom_write(0x7FFCA0,(int)(location_name[16]*256+location_name[17]));
	MOV	#lo_addr(_location_name+16), W0
	ZE	[W0], W0
	SL	W0, #8, W1
	MOV	#lo_addr(_location_name+17), W0
	ZE	[W0], W0
	ADD	W1, W0, W0
	MOV	W0, W12
	MOV	#64672, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,412 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface175:
	DEC	W7
	BRA NZ	L_process_interface175
	NOP
;uart_int_lib.h,413 :: 		eeprom_write(0x7FFCA4,(int)(location_name[18]*256+location_name[19]));
	MOV	#lo_addr(_location_name+18), W0
	ZE	[W0], W0
	SL	W0, #8, W1
	MOV	#lo_addr(_location_name+19), W0
	ZE	[W0], W0
	ADD	W1, W0, W0
	MOV	W0, W12
	MOV	#64676, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,414 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface177:
	DEC	W7
	BRA NZ	L_process_interface177
	NOP
;uart_int_lib.h,415 :: 		eeprom_write(0x7FFCA8,(int)(location_name[20]*256+location_name[21]));
	MOV	#lo_addr(_location_name+20), W0
	ZE	[W0], W0
	SL	W0, #8, W1
	MOV	#lo_addr(_location_name+21), W0
	ZE	[W0], W0
	ADD	W1, W0, W0
	MOV	W0, W12
	MOV	#64680, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,416 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface179:
	DEC	W7
	BRA NZ	L_process_interface179
	NOP
;uart_int_lib.h,417 :: 		eeprom_write(0x7FFCAC,(int)(location_name[22]*256+location_name[23]));
	MOV	#lo_addr(_location_name+22), W0
	ZE	[W0], W0
	SL	W0, #8, W1
	MOV	#lo_addr(_location_name+23), W0
	ZE	[W0], W0
	ADD	W1, W0, W0
	MOV	W0, W12
	MOV	#64684, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,418 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface181:
	DEC	W7
	BRA NZ	L_process_interface181
	NOP
;uart_int_lib.h,419 :: 		eeprom_write(0x7FFCB0,(int)(location_name[24]*256+location_name[25]));
	MOV	#lo_addr(_location_name+24), W0
	ZE	[W0], W0
	SL	W0, #8, W1
	MOV	#lo_addr(_location_name+25), W0
	ZE	[W0], W0
	ADD	W1, W0, W0
	MOV	W0, W12
	MOV	#64688, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,420 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface183:
	DEC	W7
	BRA NZ	L_process_interface183
	NOP
;uart_int_lib.h,421 :: 		eeprom_write(0x7FFCB4,(int)(location_name[26]*256+location_name[27]));
	MOV	#lo_addr(_location_name+26), W0
	ZE	[W0], W0
	SL	W0, #8, W1
	MOV	#lo_addr(_location_name+27), W0
	ZE	[W0], W0
	ADD	W1, W0, W0
	MOV	W0, W12
	MOV	#64692, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,422 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface185:
	DEC	W7
	BRA NZ	L_process_interface185
	NOP
;uart_int_lib.h,423 :: 		eeprom_write(0x7FFCB8,(int)(location_name[28]*256+location_name[29]));
	MOV	#lo_addr(_location_name+28), W0
	ZE	[W0], W0
	SL	W0, #8, W1
	MOV	#lo_addr(_location_name+29), W0
	ZE	[W0], W0
	ADD	W1, W0, W0
	MOV	W0, W12
	MOV	#64696, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,424 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface187:
	DEC	W7
	BRA NZ	L_process_interface187
	NOP
;uart_int_lib.h,425 :: 		eeprom_write(0x7FFCBC,(int)(location_name[30]*256+location_name[31]));
	MOV	#lo_addr(_location_name+30), W0
	ZE	[W0], W0
	SL	W0, #8, W1
	MOV	#lo_addr(_location_name+31), W0
	ZE	[W0], W0
	ADD	W1, W0, W0
	MOV	W0, W12
	MOV	#64700, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,426 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface189:
	DEC	W7
	BRA NZ	L_process_interface189
	NOP
;uart_int_lib.h,428 :: 		NVMADR=0xFF00;
	MOV	#65280, W0
	MOV	WREG, NVMADR
;uart_int_lib.h,429 :: 		NVMADRU=0x007F;
	MOV	#127, W0
	MOV	WREG, NVMADRU
;uart_int_lib.h,431 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,432 :: 		case 25:
L_process_interface191:
;uart_int_lib.h,435 :: 		debug_gsm=~debug_gsm;
	MOV	#lo_addr(_debug_gsm), W0
	COM.B	[W0], [W0]
;uart_int_lib.h,437 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,438 :: 		case 32:
L_process_interface192:
;uart_int_lib.h,441 :: 		apndata=uart1_data[4]-48;
	MOV	#lo_addr(_uart1_data+4), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	MOV	W0, _apndata
;uart_int_lib.h,442 :: 		eeprom_write(0x7FFC20,apndata);
	MOV	W0, W12
	MOV	#64544, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,443 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface193:
	DEC	W7
	BRA NZ	L_process_interface193
	NOP
;uart_int_lib.h,445 :: 		NVMADR=0xFF00;
	MOV	#65280, W0
	MOV	WREG, NVMADR
;uart_int_lib.h,446 :: 		NVMADRU=0x007F;
	MOV	#127, W0
	MOV	WREG, NVMADRU
;uart_int_lib.h,448 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,449 :: 		case 34:
L_process_interface195:
;uart_int_lib.h,450 :: 		if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='3' && uart1_data[3]=='4')
	MOV	#lo_addr(_uart1_data), W0
	MOV.B	[W0], W1
	MOV.B	#48, W0
	CP.B	W1, W0
	BRA Z	L__process_interface1120
	GOTO	L__process_interface860
L__process_interface1120:
	MOV	#lo_addr(_uart1_data+1), W0
	MOV.B	[W0], W1
	MOV.B	#48, W0
	CP.B	W1, W0
	BRA Z	L__process_interface1121
	GOTO	L__process_interface859
L__process_interface1121:
	MOV	#lo_addr(_uart1_data+2), W0
	MOV.B	[W0], W1
	MOV.B	#51, W0
	CP.B	W1, W0
	BRA Z	L__process_interface1122
	GOTO	L__process_interface858
L__process_interface1122:
	MOV	#lo_addr(_uart1_data+3), W0
	MOV.B	[W0], W1
	MOV.B	#52, W0
	CP.B	W1, W0
	BRA Z	L__process_interface1123
	GOTO	L__process_interface857
L__process_interface1123:
L__process_interface845:
;uart_int_lib.h,452 :: 		ip1=(uart1_data[4]-48)*100+(uart1_data[5]-48)*10+(uart1_data[6]-48);
	MOV	#lo_addr(_uart1_data+4), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#100, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_uart1_data+5), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+6), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	ADD	W2, W0, W0
	MOV	W0, _ip1
;uart_int_lib.h,453 :: 		eeprom_write(0x7FFC24,ip1);
	MOV	W0, W12
	MOV	#64548, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,454 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface199:
	DEC	W7
	BRA NZ	L_process_interface199
	NOP
;uart_int_lib.h,455 :: 		ip2=(uart1_data[8]-48)*100+(uart1_data[9]-48)*10+(uart1_data[10]-48);
	MOV	#lo_addr(_uart1_data+8), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#100, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_uart1_data+9), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+10), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	ADD	W2, W0, W0
	MOV	W0, _ip2
;uart_int_lib.h,456 :: 		eeprom_write(0x7FFC28,ip2);
	MOV	W0, W12
	MOV	#64552, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,457 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface201:
	DEC	W7
	BRA NZ	L_process_interface201
	NOP
;uart_int_lib.h,458 :: 		ip3=(uart1_data[12]-48)*100+(uart1_data[13]-48)*10+(uart1_data[14]-48);
	MOV	#lo_addr(_uart1_data+12), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#100, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_uart1_data+13), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+14), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	ADD	W2, W0, W0
	MOV	W0, _ip3
;uart_int_lib.h,459 :: 		eeprom_write(0x7FFC2C,ip3);
	MOV	W0, W12
	MOV	#64556, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,460 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface203:
	DEC	W7
	BRA NZ	L_process_interface203
	NOP
;uart_int_lib.h,461 :: 		ip4=(uart1_data[16]-48)*100+(uart1_data[17]-48)*10+(uart1_data[18]-48);
	MOV	#lo_addr(_uart1_data+16), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#100, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_uart1_data+17), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+18), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	ADD	W2, W0, W0
	MOV	W0, _ip4
;uart_int_lib.h,462 :: 		eeprom_write(0x7FFC30,ip4);
	MOV	W0, W12
	MOV	#64560, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,463 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface205:
	DEC	W7
	BRA NZ	L_process_interface205
	NOP
;uart_int_lib.h,464 :: 		port=(uart1_data[20]-48)*10000+(uart1_data[21]-48)*1000+(uart1_data[22]-48)*100+(uart1_data[23]-48)*10+(uart1_data[24]-48);
	MOV	#lo_addr(_uart1_data+20), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10000, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_uart1_data+21), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#1000, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+22), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#100, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+23), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+24), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	ADD	W2, W0, W0
	MOV	W0, _port
;uart_int_lib.h,465 :: 		eeprom_write(0x7FFC34,port);
	MOV	W0, W12
	MOV	#64564, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,466 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface207:
	DEC	W7
	BRA NZ	L_process_interface207
	NOP
;uart_int_lib.h,450 :: 		if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='3' && uart1_data[3]=='4')
L__process_interface860:
L__process_interface859:
L__process_interface858:
L__process_interface857:
;uart_int_lib.h,468 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,469 :: 		case 40:
L_process_interface209:
;uart_int_lib.h,472 :: 		LIMX=(uart1_data[7]-48)+(uart1_data[6]-48)*10+(uart1_data[5]-48)*100+(uart1_data[4]-48)*1000;
	MOV	#lo_addr(_uart1_data+7), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W2
	MOV	#lo_addr(_uart1_data+6), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+5), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#100, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+4), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#1000, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W0
	MOV	W0, _LIMX
;uart_int_lib.h,473 :: 		eeprom_write(0x7FFC3C,LIMX);
	MOV	W0, W12
	MOV	#64572, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,474 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface210:
	DEC	W7
	BRA NZ	L_process_interface210
	NOP
;uart_int_lib.h,476 :: 		NVMADR=0xFF00;
	MOV	#65280, W0
	MOV	WREG, NVMADR
;uart_int_lib.h,477 :: 		NVMADRU=0x007F;
	MOV	#127, W0
	MOV	WREG, NVMADRU
;uart_int_lib.h,479 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,480 :: 		case 41:
L_process_interface212:
;uart_int_lib.h,483 :: 		LIMA=(uart1_data[7]-48)+(uart1_data[6]-48)*10+(uart1_data[5]-48)*100+(uart1_data[4]-48)*1000;
	MOV	#lo_addr(_uart1_data+7), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W2
	MOV	#lo_addr(_uart1_data+6), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+5), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#100, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+4), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#1000, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W0
	MOV	W0, _LIMA
;uart_int_lib.h,484 :: 		eeprom_write(0x7FFC40,LIMA);
	MOV	W0, W12
	MOV	#64576, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,485 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface213:
	DEC	W7
	BRA NZ	L_process_interface213
	NOP
;uart_int_lib.h,487 :: 		NVMADR=0xFF00;
	MOV	#65280, W0
	MOV	WREG, NVMADR
;uart_int_lib.h,488 :: 		NVMADRU=0x007F;
	MOV	#127, W0
	MOV	WREG, NVMADRU
;uart_int_lib.h,490 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,491 :: 		case 42:
L_process_interface215:
;uart_int_lib.h,494 :: 		LIMB=(uart1_data[7]-48)+(uart1_data[6]-48)*10+(uart1_data[5]-48)*100+(uart1_data[4]-48)*1000;
	MOV	#lo_addr(_uart1_data+7), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W2
	MOV	#lo_addr(_uart1_data+6), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+5), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#100, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+4), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#1000, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W0
	MOV	W0, _LIMB
;uart_int_lib.h,495 :: 		eeprom_write(0x7FFC44,LIMB);
	MOV	W0, W12
	MOV	#64580, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,496 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface216:
	DEC	W7
	BRA NZ	L_process_interface216
	NOP
;uart_int_lib.h,498 :: 		NVMADR=0xFF00;
	MOV	#65280, W0
	MOV	WREG, NVMADR
;uart_int_lib.h,499 :: 		NVMADRU=0x007F;
	MOV	#127, W0
	MOV	WREG, NVMADRU
;uart_int_lib.h,501 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,502 :: 		case 43:
L_process_interface218:
;uart_int_lib.h,505 :: 		LIMC=(uart1_data[7]-48)+(uart1_data[6]-48)*10+(uart1_data[5]-48)*100+(uart1_data[4]-48)*1000;
	MOV	#lo_addr(_uart1_data+7), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W2
	MOV	#lo_addr(_uart1_data+6), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+5), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#100, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+4), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#1000, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W0
	MOV	W0, _LIMC
;uart_int_lib.h,506 :: 		eeprom_write(0x7FFC48,LIMC);
	MOV	W0, W12
	MOV	#64584, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,507 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface219:
	DEC	W7
	BRA NZ	L_process_interface219
	NOP
;uart_int_lib.h,509 :: 		NVMADR=0xFF00;
	MOV	#65280, W0
	MOV	WREG, NVMADR
;uart_int_lib.h,510 :: 		NVMADRU=0x007F;
	MOV	#127, W0
	MOV	WREG, NVMADRU
;uart_int_lib.h,512 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,513 :: 		case 44:
L_process_interface221:
;uart_int_lib.h,516 :: 		LIMD=(uart1_data[7]-48)+(uart1_data[6]-48)*10+(uart1_data[5]-48)*100+(uart1_data[4]-48)*1000;
	MOV	#lo_addr(_uart1_data+7), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W2
	MOV	#lo_addr(_uart1_data+6), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+5), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#100, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+4), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#1000, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W0
	MOV	W0, _LIMD
;uart_int_lib.h,517 :: 		eeprom_write(0x7FFC4C,LIMD);
	MOV	W0, W12
	MOV	#64588, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,518 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface222:
	DEC	W7
	BRA NZ	L_process_interface222
	NOP
;uart_int_lib.h,520 :: 		NVMADR=0xFF00;
	MOV	#65280, W0
	MOV	WREG, NVMADR
;uart_int_lib.h,521 :: 		NVMADRU=0x007F;
	MOV	#127, W0
	MOV	WREG, NVMADRU
;uart_int_lib.h,523 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,524 :: 		case 45:
L_process_interface224:
;uart_int_lib.h,527 :: 		LIMITE=(uart1_data[7]-48)+(uart1_data[6]-48)*10+(uart1_data[5]-48)*100+(uart1_data[4]-48)*1000;
	MOV	#lo_addr(_uart1_data+7), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W2
	MOV	#lo_addr(_uart1_data+6), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+5), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#100, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+4), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#1000, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W0
	MOV	W0, _LIMITE
;uart_int_lib.h,528 :: 		eeprom_write(0x7FFC50,LIMITE);
	MOV	W0, W12
	MOV	#64592, W10
	MOV	#127, W11
	CALL	_EEPROM_Write
;uart_int_lib.h,529 :: 		delay_ms(5);
	MOV	#24573, W7
L_process_interface225:
	DEC	W7
	BRA NZ	L_process_interface225
	NOP
;uart_int_lib.h,531 :: 		NVMADR=0xFF00;
	MOV	#65280, W0
	MOV	WREG, NVMADR
;uart_int_lib.h,532 :: 		NVMADRU=0x007F;
	MOV	#127, W0
	MOV	WREG, NVMADRU
;uart_int_lib.h,534 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,535 :: 		case 46:
L_process_interface227:
;uart_int_lib.h,538 :: 		longtostr(totalv1a,debug_txt);
	MOV	#lo_addr(_debug_txt), W12
	MOV	_totalv1a, W10
	MOV	_totalv1a+2, W11
	CALL	_LongToStr
;uart_int_lib.h,539 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,540 :: 		bytetostr((unsigned short)(totalv1a/current_interval.l1acount),debug_txt);
	MOV	_current_interval, W2
	ASR	W2, #15, W3
	MOV	_totalv1a, W0
	MOV	_totalv1a+2, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_debug_txt), W11
	MOV.B	W0, W10
	CALL	_ByteToStr
;uart_int_lib.h,541 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,542 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,543 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,544 :: 		longtostr(totalv1b,debug_txt);
	MOV	#lo_addr(_debug_txt), W12
	MOV	_totalv1b, W10
	MOV	_totalv1b+2, W11
	CALL	_LongToStr
;uart_int_lib.h,545 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,546 :: 		bytetostr((unsigned short)(totalv1b/current_interval.l1bcount),debug_txt);
	MOV	_current_interval+10, W2
	ASR	W2, #15, W3
	MOV	_totalv1b, W0
	MOV	_totalv1b+2, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_debug_txt), W11
	MOV.B	W0, W10
	CALL	_ByteToStr
;uart_int_lib.h,547 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,548 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,549 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,550 :: 		longtostr(totalv1c,debug_txt);
	MOV	#lo_addr(_debug_txt), W12
	MOV	_totalv1c, W10
	MOV	_totalv1c+2, W11
	CALL	_LongToStr
;uart_int_lib.h,551 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,552 :: 		bytetostr((unsigned short)(totalv1c/current_interval.l1ccount),debug_txt);
	MOV	_current_interval+20, W2
	ASR	W2, #15, W3
	MOV	_totalv1c, W0
	MOV	_totalv1c+2, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_debug_txt), W11
	MOV.B	W0, W10
	CALL	_ByteToStr
;uart_int_lib.h,553 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,554 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,555 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,556 :: 		longtostr(totalv1d,debug_txt);
	MOV	#lo_addr(_debug_txt), W12
	MOV	_totalv1d, W10
	MOV	_totalv1d+2, W11
	CALL	_LongToStr
;uart_int_lib.h,557 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,558 :: 		bytetostr((unsigned short)(totalv1d/current_interval.l1dcount),debug_txt);
	MOV	_current_interval+30, W2
	ASR	W2, #15, W3
	MOV	_totalv1d, W0
	MOV	_totalv1d+2, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_debug_txt), W11
	MOV.B	W0, W10
	CALL	_ByteToStr
;uart_int_lib.h,559 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,560 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,561 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,562 :: 		longtostr(totalv1e,debug_txt);
	MOV	#lo_addr(_debug_txt), W12
	MOV	_totalv1e, W10
	MOV	_totalv1e+2, W11
	CALL	_LongToStr
;uart_int_lib.h,563 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,564 :: 		bytetostr((unsigned short)(totalv1e/current_interval.l1ecount),debug_txt);
	MOV	_current_interval+40, W2
	ASR	W2, #15, W3
	MOV	_totalv1e, W0
	MOV	_totalv1e+2, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_debug_txt), W11
	MOV.B	W0, W10
	CALL	_ByteToStr
;uart_int_lib.h,565 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,566 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,567 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,568 :: 		longtostr(totalv1x,debug_txt);
	MOV	#lo_addr(_debug_txt), W12
	MOV	_totalv1x, W10
	MOV	_totalv1x+2, W11
	CALL	_LongToStr
;uart_int_lib.h,569 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,570 :: 		bytetostr((unsigned short)(totalv1x/current_interval.l1xcount),debug_txt);
	MOV	_current_interval+50, W2
	ASR	W2, #15, W3
	MOV	_totalv1x, W0
	MOV	_totalv1x+2, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_debug_txt), W11
	MOV.B	W0, W10
	CALL	_ByteToStr
;uart_int_lib.h,571 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,572 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,573 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,574 :: 		longtostr(totalv2a,debug_txt);
	MOV	#lo_addr(_debug_txt), W12
	MOV	_totalv2a, W10
	MOV	_totalv2a+2, W11
	CALL	_LongToStr
;uart_int_lib.h,575 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,576 :: 		bytetostr((unsigned short)(totalv2a/current_interval.l2acount),debug_txt);
	MOV	_current_interval+62, W2
	ASR	W2, #15, W3
	MOV	_totalv2a, W0
	MOV	_totalv2a+2, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_debug_txt), W11
	MOV.B	W0, W10
	CALL	_ByteToStr
;uart_int_lib.h,577 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,578 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,579 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,580 :: 		longtostr(totalv2b,debug_txt);
	MOV	#lo_addr(_debug_txt), W12
	MOV	_totalv2b, W10
	MOV	_totalv2b+2, W11
	CALL	_LongToStr
;uart_int_lib.h,581 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,582 :: 		bytetostr((unsigned short)(totalv2b/current_interval.l2bcount),debug_txt);
	MOV	_current_interval+72, W2
	ASR	W2, #15, W3
	MOV	_totalv2b, W0
	MOV	_totalv2b+2, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_debug_txt), W11
	MOV.B	W0, W10
	CALL	_ByteToStr
;uart_int_lib.h,583 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,584 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,585 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,586 :: 		longtostr(totalv2c,debug_txt);
	MOV	#lo_addr(_debug_txt), W12
	MOV	_totalv2c, W10
	MOV	_totalv2c+2, W11
	CALL	_LongToStr
;uart_int_lib.h,587 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,588 :: 		bytetostr((unsigned short)(totalv2c/current_interval.l2ccount),debug_txt);
	MOV	_current_interval+82, W2
	ASR	W2, #15, W3
	MOV	_totalv2c, W0
	MOV	_totalv2c+2, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_debug_txt), W11
	MOV.B	W0, W10
	CALL	_ByteToStr
;uart_int_lib.h,589 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,590 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,591 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,592 :: 		longtostr(totalv2d,debug_txt);
	MOV	#lo_addr(_debug_txt), W12
	MOV	_totalv2d, W10
	MOV	_totalv2d+2, W11
	CALL	_LongToStr
;uart_int_lib.h,593 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,594 :: 		bytetostr((unsigned short)(totalv2d/current_interval.l2dcount),debug_txt);
	MOV	_current_interval+92, W2
	ASR	W2, #15, W3
	MOV	_totalv2d, W0
	MOV	_totalv2d+2, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_debug_txt), W11
	MOV.B	W0, W10
	CALL	_ByteToStr
;uart_int_lib.h,595 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,596 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,597 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,598 :: 		longtostr(totalv2e,debug_txt);
	MOV	#lo_addr(_debug_txt), W12
	MOV	_totalv2e, W10
	MOV	_totalv2e+2, W11
	CALL	_LongToStr
;uart_int_lib.h,599 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,600 :: 		bytetostr((unsigned short)(totalv2e/current_interval.l2ecount),debug_txt);
	MOV	_current_interval+102, W2
	ASR	W2, #15, W3
	MOV	_totalv2e, W0
	MOV	_totalv2e+2, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_debug_txt), W11
	MOV.B	W0, W10
	CALL	_ByteToStr
;uart_int_lib.h,601 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,602 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,603 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,604 :: 		longtostr(totalv2x,debug_txt);
	MOV	#lo_addr(_debug_txt), W12
	MOV	_totalv2x, W10
	MOV	_totalv2x+2, W11
	CALL	_LongToStr
;uart_int_lib.h,605 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,606 :: 		bytetostr((unsigned short)(totalv2x/current_interval.l2xcount),debug_txt);
	MOV	_current_interval+112, W2
	ASR	W2, #15, W3
	MOV	_totalv2x, W0
	MOV	_totalv2x+2, W1
	CLR	W4
	CALL	__Divide_32x32
	MOV	#lo_addr(_debug_txt), W11
	MOV.B	W0, W10
	CALL	_ByteToStr
;uart_int_lib.h,607 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,609 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,610 :: 		case 88:
L_process_interface228:
;uart_int_lib.h,611 :: 		send_out("Loops: ");
	MOV	#lo_addr(?lstr_7_91_457), W10
	CALL	_send_out
;uart_int_lib.h,612 :: 		UART1_Write(loop[0]+48);
	MOV	#48, W1
	MOV	#lo_addr(_loop), W0
	ADD	W1, [W0], W0
	MOV	W0, W10
	CALL	_UART1_Write
;uart_int_lib.h,613 :: 		UART1_Write(loop[1]+48);
	MOV	#48, W1
	MOV	#lo_addr(_loop+2), W0
	ADD	W1, [W0], W0
	MOV	W0, W10
	CALL	_UART1_Write
;uart_int_lib.h,614 :: 		UART1_Write(loop[2]+48);
	MOV	#48, W1
	MOV	#lo_addr(_loop+4), W0
	ADD	W1, [W0], W0
	MOV	W0, W10
	CALL	_UART1_Write
;uart_int_lib.h,615 :: 		UART1_Write(loop[3]+48);
	MOV	#48, W1
	MOV	#lo_addr(_loop+6), W0
	ADD	W1, [W0], W0
	MOV	W0, W10
	CALL	_UART1_Write
;uart_int_lib.h,616 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,617 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,618 :: 		send_out("IS H Device?: ");
	MOV	#lo_addr(?lstr_8_91_457), W10
	CALL	_send_out
;uart_int_lib.h,619 :: 		UART1_Write(AUTCAL+48);
	MOV	#48, W1
	MOV	#lo_addr(_AUTCAL), W0
	ADD	W1, [W0], W0
	MOV	W0, W10
	CALL	_UART1_Write
;uart_int_lib.h,620 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,621 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,623 :: 		send_out("X: ");
	MOV	#lo_addr(?lstr_9_91_457), W10
	CALL	_send_out
;uart_int_lib.h,624 :: 		inttostr(LIMX,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_LIMX, W10
	CALL	_IntToStr
;uart_int_lib.h,625 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,626 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,627 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,628 :: 		send_out("A: ");
	MOV	#lo_addr(?lstr_10_91_457), W10
	CALL	_send_out
;uart_int_lib.h,629 :: 		inttostr(LIMA,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_LIMA, W10
	CALL	_IntToStr
;uart_int_lib.h,630 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,631 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,632 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,633 :: 		send_out("B: ");
	MOV	#lo_addr(?lstr_11_91_457), W10
	CALL	_send_out
;uart_int_lib.h,634 :: 		inttostr(LIMB,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_LIMB, W10
	CALL	_IntToStr
;uart_int_lib.h,635 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,636 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,637 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,638 :: 		send_out("C: ");
	MOV	#lo_addr(?lstr_12_91_457), W10
	CALL	_send_out
;uart_int_lib.h,639 :: 		inttostr(LIMC,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_LIMC, W10
	CALL	_IntToStr
;uart_int_lib.h,640 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,641 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,642 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,643 :: 		send_out("D: ");
	MOV	#lo_addr(?lstr_13_91_457), W10
	CALL	_send_out
;uart_int_lib.h,644 :: 		inttostr(LIMD,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_LIMD, W10
	CALL	_IntToStr
;uart_int_lib.h,645 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,646 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,647 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,648 :: 		send_out("E: ");
	MOV	#lo_addr(?lstr_14_91_457), W10
	CALL	_send_out
;uart_int_lib.h,649 :: 		inttostr(LIMITE,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_LIMITE, W10
	CALL	_IntToStr
;uart_int_lib.h,650 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,651 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,652 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,653 :: 		send_out("Margin: ");
	MOV	#lo_addr(?lstr_15_91_457), W10
	CALL	_send_out
;uart_int_lib.h,654 :: 		inttostr(MARGINTOP,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_MARGINTOP, W10
	CALL	_IntToStr
;uart_int_lib.h,655 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,656 :: 		inttostr(MARGINBOT,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_MARGINBOT, W10
	CALL	_IntToStr
;uart_int_lib.h,657 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,658 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,659 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,660 :: 		send_out("APN: ");
	MOV	#lo_addr(?lstr_16_91_457), W10
	CALL	_send_out
;uart_int_lib.h,661 :: 		inttostr(apndata,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_apndata, W10
	CALL	_IntToStr
;uart_int_lib.h,662 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,665 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,666 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,667 :: 		send_out("LoopLen: ");
	MOV	#lo_addr(?lstr_17_91_457), W10
	CALL	_send_out
;uart_int_lib.h,668 :: 		inttostr(loop_distance,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_loop_distance, W10
	CALL	_IntToStr
;uart_int_lib.h,669 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,670 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,671 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,672 :: 		send_out("LoopWdt: ");
	MOV	#lo_addr(?lstr_18_91_457), W10
	CALL	_send_out
;uart_int_lib.h,673 :: 		inttostr(loop_width,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_loop_width, W10
	CALL	_IntToStr
;uart_int_lib.h,674 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,675 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,676 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,677 :: 		send_out("Speed: ");
	MOV	#lo_addr(?lstr_19_91_457), W10
	CALL	_send_out
;uart_int_lib.h,678 :: 		inttostr(DSPEED1,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_DSPEED1, W10
	CALL	_IntToStr
;uart_int_lib.h,679 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,680 :: 		inttostr(NSPEED1,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_NSPEED1, W10
	CALL	_IntToStr
;uart_int_lib.h,681 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,682 :: 		inttostr(DSPEED2,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_DSPEED2, W10
	CALL	_IntToStr
;uart_int_lib.h,683 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,684 :: 		inttostr(NSPEED2,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_NSPEED2, W10
	CALL	_IntToStr
;uart_int_lib.h,685 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,686 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,687 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,689 :: 		send_out("Err: ");
	MOV	#lo_addr(?lstr_20_91_457), W10
	CALL	_send_out
;uart_int_lib.h,690 :: 		inttostr(error_byte,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_error_byte, W10
	CALL	_IntToStr
;uart_int_lib.h,691 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,692 :: 		inttostr(error_byte_last,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_error_byte_last, W10
	CALL	_IntToStr
;uart_int_lib.h,693 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,694 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,695 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,697 :: 		send_out("Power: ");
	MOV	#lo_addr(?lstr_21_91_457), W10
	CALL	_send_out
;uart_int_lib.h,698 :: 		inttostr(power_type,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_power_type, W10
	CALL	_IntToStr
;uart_int_lib.h,699 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,700 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,701 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,702 :: 		send_out("Name: ");
	MOV	#lo_addr(?lstr_22_91_457), W10
	CALL	_send_out
;uart_int_lib.h,703 :: 		UART1_Write_Text(location_name);
	MOV	#lo_addr(_location_name), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,704 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,705 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,706 :: 		send_out("SMS: ");
	MOV	#lo_addr(?lstr_23_91_457), W10
	CALL	_send_out
;uart_int_lib.h,707 :: 		UART1_Write_Text(sms_number_1);
	MOV	#lo_addr(_sms_number_1), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,708 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,709 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,710 :: 		send_out("SRV: ");
	MOV	#lo_addr(?lstr_24_91_457), W10
	CALL	_send_out
;uart_int_lib.h,711 :: 		inttostr(ip1,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_ip1, W10
	CALL	_IntToStr
;uart_int_lib.h,713 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,714 :: 		send_out(".");
	MOV	#lo_addr(?lstr_25_91_457), W10
	CALL	_send_out
;uart_int_lib.h,715 :: 		inttostr(ip2,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_ip2, W10
	CALL	_IntToStr
;uart_int_lib.h,716 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,717 :: 		send_out(".");
	MOV	#lo_addr(?lstr_26_91_457), W10
	CALL	_send_out
;uart_int_lib.h,718 :: 		inttostr(ip3,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_ip3, W10
	CALL	_IntToStr
;uart_int_lib.h,719 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,720 :: 		send_out(".");
	MOV	#lo_addr(?lstr_27_91_457), W10
	CALL	_send_out
;uart_int_lib.h,721 :: 		inttostr(ip4,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_ip4, W10
	CALL	_IntToStr
;uart_int_lib.h,722 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,723 :: 		send_out(":");
	MOV	#lo_addr(?lstr_28_91_457), W10
	CALL	_send_out
;uart_int_lib.h,724 :: 		inttostr(port,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_port, W10
	CALL	_IntToStr
;uart_int_lib.h,725 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,726 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,727 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,732 :: 		send_out(system_model);
	MOV	#lo_addr(?lstr_29_91_457), W10
	CALL	_send_out
;uart_int_lib.h,733 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,734 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,735 :: 		send_out(version);
	MOV	#lo_addr(?lstr_30_91_457), W10
	CALL	_send_out
;uart_int_lib.h,736 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;uart_int_lib.h,737 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,739 :: 		send_out("By Ali Jalilvand");
	MOV	#lo_addr(?lstr_31_91_457), W10
	CALL	_send_out
;uart_int_lib.h,741 :: 		break;
	GOTO	L_process_interface94
;uart_int_lib.h,743 :: 		default : UART1_Write_Text(datetimesec);
L_process_interface229:
	MOV	#lo_addr(_datetimesec), W10
	CALL	_UART1_Write_Text
;uart_int_lib.h,744 :: 		}
	GOTO	L_process_interface94
L_process_interface93:
	MOV	_function_code, W0
	CP	W0, #0
	BRA NZ	L__process_interface1124
	GOTO	L_process_interface95
L__process_interface1124:
	MOV	_function_code, W0
	CP	W0, #2
	BRA NZ	L__process_interface1125
	GOTO	L_process_interface96
L__process_interface1125:
	MOV	#197, W1
	MOV	#lo_addr(_function_code), W0
	CP	W1, [W0]
	BRA NZ	L__process_interface1126
	GOTO	L_process_interface105
L__process_interface1126:
	MOV	_function_code, W0
	CP	W0, #3
	BRA NZ	L__process_interface1127
	GOTO	L_process_interface112
L__process_interface1127:
	MOV	_function_code, W0
	CP	W0, #4
	BRA NZ	L__process_interface1128
	GOTO	L_process_interface115
L__process_interface1128:
	MOV	_function_code, W0
	CP	W0, #5
	BRA NZ	L__process_interface1129
	GOTO	L_process_interface116
L__process_interface1129:
	MOV	_function_code, W0
	CP	W0, #6
	BRA NZ	L__process_interface1130
	GOTO	L_process_interface117
L__process_interface1130:
	MOV	_function_code, W0
	CP	W0, #7
	BRA NZ	L__process_interface1131
	GOTO	L_process_interface118
L__process_interface1131:
	MOV	_function_code, W0
	CP	W0, #8
	BRA NZ	L__process_interface1132
	GOTO	L_process_interface119
L__process_interface1132:
	MOV	_function_code, W0
	CP	W0, #10
	BRA NZ	L__process_interface1133
	GOTO	L_process_interface120
L__process_interface1133:
	MOV	_function_code, W0
	CP	W0, #11
	BRA NZ	L__process_interface1134
	GOTO	L_process_interface121
L__process_interface1134:
	MOV	_function_code, W0
	CP	W0, #12
	BRA NZ	L__process_interface1135
	GOTO	L_process_interface125
L__process_interface1135:
	MOV	_function_code, W0
	CP	W0, #13
	BRA NZ	L__process_interface1136
	GOTO	L_process_interface126
L__process_interface1136:
	MOV	_function_code, W0
	CP	W0, #17
	BRA NZ	L__process_interface1137
	GOTO	L_process_interface127
L__process_interface1137:
	MOV	_function_code, W0
	CP	W0, #18
	BRA NZ	L__process_interface1138
	GOTO	L_process_interface128
L__process_interface1138:
	MOV	_function_code, W0
	CP	W0, #19
	BRA NZ	L__process_interface1139
	GOTO	L_process_interface133
L__process_interface1139:
	MOV	_function_code, W0
	CP	W0, #21
	BRA NZ	L__process_interface1140
	GOTO	L_process_interface142
L__process_interface1140:
	MOV	_function_code, W0
	CP	W0, #22
	BRA NZ	L__process_interface1141
	GOTO	L_process_interface145
L__process_interface1141:
	MOV	_function_code, W0
	CP	W0, #23
	BRA NZ	L__process_interface1142
	GOTO	L_process_interface158
L__process_interface1142:
	MOV	_function_code, W0
	CP	W0, #25
	BRA NZ	L__process_interface1143
	GOTO	L_process_interface191
L__process_interface1143:
	MOV	#32, W1
	MOV	#lo_addr(_function_code), W0
	CP	W1, [W0]
	BRA NZ	L__process_interface1144
	GOTO	L_process_interface192
L__process_interface1144:
	MOV	#34, W1
	MOV	#lo_addr(_function_code), W0
	CP	W1, [W0]
	BRA NZ	L__process_interface1145
	GOTO	L_process_interface195
L__process_interface1145:
	MOV	#40, W1
	MOV	#lo_addr(_function_code), W0
	CP	W1, [W0]
	BRA NZ	L__process_interface1146
	GOTO	L_process_interface209
L__process_interface1146:
	MOV	#41, W1
	MOV	#lo_addr(_function_code), W0
	CP	W1, [W0]
	BRA NZ	L__process_interface1147
	GOTO	L_process_interface212
L__process_interface1147:
	MOV	#42, W1
	MOV	#lo_addr(_function_code), W0
	CP	W1, [W0]
	BRA NZ	L__process_interface1148
	GOTO	L_process_interface215
L__process_interface1148:
	MOV	#43, W1
	MOV	#lo_addr(_function_code), W0
	CP	W1, [W0]
	BRA NZ	L__process_interface1149
	GOTO	L_process_interface218
L__process_interface1149:
	MOV	#44, W1
	MOV	#lo_addr(_function_code), W0
	CP	W1, [W0]
	BRA NZ	L__process_interface1150
	GOTO	L_process_interface221
L__process_interface1150:
	MOV	#45, W1
	MOV	#lo_addr(_function_code), W0
	CP	W1, [W0]
	BRA NZ	L__process_interface1151
	GOTO	L_process_interface224
L__process_interface1151:
	MOV	#46, W1
	MOV	#lo_addr(_function_code), W0
	CP	W1, [W0]
	BRA NZ	L__process_interface1152
	GOTO	L_process_interface227
L__process_interface1152:
	MOV	#88, W1
	MOV	#lo_addr(_function_code), W0
	CP	W1, [W0]
	BRA NZ	L__process_interface1153
	GOTO	L_process_interface228
L__process_interface1153:
	GOTO	L_process_interface229
L_process_interface94:
;uart_int_lib.h,745 :: 		UART1_Write(13); UART1_Write(10); send_out("OK"); UART1_Write(13); UART1_Write(10);
	MOV	#13, W10
	CALL	_UART1_Write
	MOV	#10, W10
	CALL	_UART1_Write
	MOV	#lo_addr(?lstr_32_91_457), W10
	CALL	_send_out
	MOV	#13, W10
	CALL	_UART1_Write
	MOV	#10, W10
	CALL	_UART1_Write
;uart_int_lib.h,746 :: 		}
L_end_process_interface:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _process_interface

_clear_uart1:

;uart_int_lib.h,747 :: 		void clear_uart1()
;uart_int_lib.h,750 :: 		for(clear_uart1_cnt=0;clear_uart1_cnt<49;clear_uart1_cnt++)
	MOV	#lo_addr(_clear_uart1_cnt), W1
	CLR	W0
	MOV.B	W0, [W1]
L_clear_uart1230:
	MOV	#lo_addr(_clear_uart1_cnt), W0
	MOV.B	[W0], W1
	MOV.B	#49, W0
	CP.B	W1, W0
	BRA LTU	L__clear_uart11155
	GOTO	L_clear_uart1231
L__clear_uart11155:
;uart_int_lib.h,752 :: 		uart1_data[clear_uart1_cnt]=0;
	MOV	#lo_addr(_clear_uart1_cnt), W0
	ZE	[W0], W1
	MOV	#lo_addr(_uart1_data), W0
	ADD	W0, W1, W1
	CLR	W0
	MOV.B	W0, [W1]
;uart_int_lib.h,750 :: 		for(clear_uart1_cnt=0;clear_uart1_cnt<49;clear_uart1_cnt++)
	MOV.B	#1, W1
	MOV	#lo_addr(_clear_uart1_cnt), W0
	ADD.B	W1, [W0], [W0]
;uart_int_lib.h,753 :: 		}
	GOTO	L_clear_uart1230
L_clear_uart1231:
;uart_int_lib.h,754 :: 		uart1_data_pointer=0;
	MOV	#lo_addr(_uart1_data_pointer), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart_int_lib.h,755 :: 		uart1_data_received=0;
	MOV	#lo_addr(_uart1_data_received), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart_int_lib.h,756 :: 		U1STAbits.OERR=0;
	BCLR	U1STAbits, #1
;uart_int_lib.h,757 :: 		}
L_end_clear_uart1:
	RETURN
; end of _clear_uart1

_clear_uart2:

;uart_int_lib.h,759 :: 		void clear_uart2()
;uart_int_lib.h,762 :: 		for(clear_uart2_cnt=0;clear_uart2_cnt<49;clear_uart2_cnt++)
	MOV	#lo_addr(_clear_uart2_cnt), W1
	CLR	W0
	MOV.B	W0, [W1]
L_clear_uart2233:
	MOV	#lo_addr(_clear_uart2_cnt), W0
	MOV.B	[W0], W1
	MOV.B	#49, W0
	CP.B	W1, W0
	BRA LTU	L__clear_uart21157
	GOTO	L_clear_uart2234
L__clear_uart21157:
;uart_int_lib.h,764 :: 		uart2_data[clear_uart2_cnt]=0;
	MOV	#lo_addr(_clear_uart2_cnt), W0
	ZE	[W0], W1
	MOV	#lo_addr(_uart2_data), W0
	ADD	W0, W1, W1
	CLR	W0
	MOV.B	W0, [W1]
;uart_int_lib.h,762 :: 		for(clear_uart2_cnt=0;clear_uart2_cnt<49;clear_uart2_cnt++)
	MOV.B	#1, W1
	MOV	#lo_addr(_clear_uart2_cnt), W0
	ADD.B	W1, [W0], [W0]
;uart_int_lib.h,765 :: 		}
	GOTO	L_clear_uart2233
L_clear_uart2234:
;uart_int_lib.h,766 :: 		uart2_data_pointer=0;
	MOV	#lo_addr(_uart2_data_pointer), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart_int_lib.h,767 :: 		U2STAbits.OERR=0;
	BCLR	U2STAbits, #1
;uart_int_lib.h,768 :: 		}
L_end_clear_uart2:
	RETURN
; end of _clear_uart2

_set_error:

;uart_int_lib.h,770 :: 		void set_error(unsigned int errb)
;uart_int_lib.h,772 :: 		error_byte=error_byte|errb;
	MOV	#lo_addr(_error_byte), W0
	IOR	W10, [W0], [W0]
;uart_int_lib.h,774 :: 		}
L_end_set_error:
	RETURN
; end of _set_error

_reset_error:

;uart_int_lib.h,775 :: 		void reset_error(unsigned int errb)
;uart_int_lib.h,777 :: 		error_byte=error_byte&(~errb);
	MOV	W10, W0
	COM	W0, W1
	MOV	#lo_addr(_error_byte), W0
	AND	W1, [W0], [W0]
;uart_int_lib.h,779 :: 		}
L_end_reset_error:
	RETURN
; end of _reset_error

_is_error:

;uart_int_lib.h,780 :: 		char is_error(unsigned int errb)
;uart_int_lib.h,782 :: 		if((error_byte&errb)==0) return(0);
	MOV	#lo_addr(_error_byte), W0
	AND	W10, [W0], W0
	CP	W0, #0
	BRA Z	L__is_error1161
	GOTO	L_is_error236
L__is_error1161:
	CLR	W0
	GOTO	L_end_is_error
L_is_error236:
;uart_int_lib.h,783 :: 		else  return(1);
	MOV.B	#1, W0
;uart_int_lib.h,784 :: 		}
L_end_is_error:
	RETURN
; end of _is_error

_reset_class:

;classification.h,1 :: 		void reset_class(unsigned short lane)
;classification.h,3 :: 		if(lane==0)
	CP.B	W10, #0
	BRA Z	L__reset_class1163
	GOTO	L_reset_class238
L__reset_class1163:
;classification.h,5 :: 		onloop0=0;
	BCLR	LATE0_bit, BitPos(LATE0_bit+0)
;classification.h,6 :: 		onloop1=0;
	BCLR	LATE1_bit, BitPos(LATE1_bit+0)
;classification.h,7 :: 		line1step=0;
	MOV	#lo_addr(_line1step), W1
	CLR	W0
	MOV.B	W0, [W1]
;classification.h,8 :: 		}
	GOTO	L_reset_class239
L_reset_class238:
;classification.h,11 :: 		onloop2=0;
	BCLR	LATE2_bit, BitPos(LATE2_bit+0)
;classification.h,12 :: 		onloop3=0;
	BCLR	LATE3_bit, BitPos(LATE3_bit+0)
;classification.h,13 :: 		line2step=0;
	MOV	#lo_addr(_line2step), W1
	CLR	W0
	MOV.B	W0, [W1]
;classification.h,14 :: 		}
L_reset_class239:
;classification.h,15 :: 		T1[lane]=0;
	ZE	W10, W0
	SL	W0, #2, W1
	MOV	#lo_addr(_T1), W0
	ADD	W0, W1, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;classification.h,16 :: 		T2[lane]=0;
	ZE	W10, W0
	SL	W0, #2, W1
	MOV	#lo_addr(_T2), W0
	ADD	W0, W1, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;classification.h,17 :: 		T3[lane]=0;
	ZE	W10, W0
	SL	W0, #2, W1
	MOV	#lo_addr(_T3), W0
	ADD	W0, W1, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;classification.h,18 :: 		Line_Dir[lane]=0;
	ZE	W10, W1
	MOV	#lo_addr(_Line_Dir), W0
	ADD	W0, W1, W1
	CLR	W0
	MOV.B	W0, [W1]
;classification.h,19 :: 		timexen[lane]=0;
	ZE	W10, W1
	MOV	#lo_addr(_timexen), W0
	ADD	W0, W1, W1
	CLR	W0
	MOV.B	W0, [W1]
;classification.h,20 :: 		timex[lane]=0;
	ZE	W10, W0
	SL	W0, #2, W1
	MOV	#lo_addr(_timex), W0
	ADD	W0, W1, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;classification.h,21 :: 		wspeed=0;
	MOV	#lo_addr(_wspeed), W1
	CLR	W0
	MOV.B	W0, [W1]
;classification.h,22 :: 		wgrab=0;
	MOV	#lo_addr(_wgrab), W1
	CLR	W0
	MOV.B	W0, [W1]
;classification.h,23 :: 		wheadway=0;
	MOV	#lo_addr(_wheadway), W1
	CLR	W0
	MOV.B	W0, [W1]
;classification.h,24 :: 		}
L_end_reset_class:
	RETURN
; end of _reset_class

_cal_class:
	LNK	#14

;classification.h,25 :: 		void cal_class(unsigned short lane)
;classification.h,28 :: 		vehicle_speed0=(double)(loop_distance)*1000;
	PUSH	W11
	PUSH	W12
	PUSH	W10
	MOV	_loop_distance, W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#17530, W3
	CALL	__Mul_FP
	POP	W10
	MOV	W0, [W14+8]
	MOV	W1, [W14+10]
	MOV	W0, _vehicle_speed0
	MOV	W1, _vehicle_speed0+2
;classification.h,29 :: 		vehicle_speed1=(double)(loop_distance)*1000;
	MOV	W0, _vehicle_speed1
	MOV	W1, _vehicle_speed1+2
;classification.h,30 :: 		vehicle_speed0=vehicle_speed0/((double)(T1[lane]));
	ZE	W10, W0
	SL	W0, #2, W1
	MOV	W1, [W14+4]
	MOV	#lo_addr(_T1), W0
	ADD	W0, W1, W0
	MOV	W0, [W14+12]
	PUSH	W10
	MOV.D	[W0], W0
	SETM	W2
	CALL	__Long2Float
	POP	W10
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	MOV	[W14+8], W0
	MOV	[W14+10], W1
	PUSH.D	W2
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	PUSH	W10
	CALL	__Div_FP
	POP	W10
	POP.D	W2
	MOV	W0, _vehicle_speed0
	MOV	W1, _vehicle_speed0+2
;classification.h,31 :: 		vehicle_speed1=vehicle_speed1/((double)(T3[lane]-T2[lane]));
	MOV	#lo_addr(_T3), W0
	MOV	[W14+4], W1
	ADD	W0, W1, W4
	MOV	W4, [W14+8]
	MOV	#lo_addr(_T2), W0
	ADD	W0, W1, W0
	MOV	W0, [W14+4]
	MOV.D	[W0], W2
	SUBR	W2, [W4++], W0
	SUBBR	W3, [W4--], W1
	PUSH	W10
	SETM	W2
	CALL	__Long2Float
	MOV.D	W0, W2
	MOV	_vehicle_speed1, W0
	MOV	_vehicle_speed1+2, W1
	CALL	__Div_FP
	MOV	W0, _vehicle_speed1
	MOV	W1, _vehicle_speed1+2
;classification.h,32 :: 		vehicle_speed = (vehicle_speed0+vehicle_speed1)/2;
	MOV	_vehicle_speed0, W2
	MOV	_vehicle_speed0+2, W3
	CALL	__AddSub_FP
	MOV	#0, W2
	MOV	#16384, W3
	CALL	__Div_FP
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	MOV	W0, _vehicle_speed
	MOV	W1, _vehicle_speed+2
;classification.h,36 :: 		T2S=(T2[lane]+(T3[lane]-T1[lane]))/2;
	MOV	[W14+12], W0
	MOV	[W0++], W1
	MOV	[W0--], W2
	MOV	[W14+8], W0
	SUBR	W1, [W0++], W3
	SUBBR	W2, [W0--], W4
	MOV	[W14+4], W2
	ADD	W3, [W2++], W0
	ADDC	W4, [W2--], W1
	LSR	W1, W1
	RRC	W0, W0
	MOV	W0, _T2S
	MOV	W1, _T2S+2
;classification.h,37 :: 		vehicle_lenght=vehicle_speed*(double)(T2S);
	SETM	W2
	CALL	__Long2Float
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	CALL	__Mul_FP
	MOV	W0, _vehicle_lenght
	MOV	W1, _vehicle_lenght+2
;classification.h,38 :: 		vehicle_lenght/=1000;
	MOV	#0, W2
	MOV	#17530, W3
	CALL	__Div_FP
	MOV	W0, [W14+4]
	MOV	W1, [W14+6]
	MOV	W0, _vehicle_lenght
	MOV	W1, _vehicle_lenght+2
;classification.h,39 :: 		vehicle_lenght-=(double)loop_width;
	MOV	_loop_width, W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	POP	W10
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	MOV	[W14+4], W0
	MOV	[W14+6], W1
	PUSH.D	W2
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	PUSH	W10
	CALL	__Sub_FP
	POP	W10
	POP.D	W2
	MOV	W0, _vehicle_lenght
	MOV	W1, _vehicle_lenght+2
;classification.h,40 :: 		lastvehicle.speed=(unsigned short)(floor(0.036*vehicle_speed));
	PUSH	W10
	MOV	#29884, W0
	MOV	#15635, W1
	MOV	_vehicle_speed, W2
	MOV	_vehicle_speed+2, W3
	CALL	__Mul_FP
	MOV.D	W0, W10
	CALL	_floor
	CALL	__Float2Longint
	POP	W10
	MOV	#lo_addr(_lastvehicle+1), W1
	MOV.B	W0, [W1]
;classification.h,41 :: 		lastvehicle.dir=Line_Dir[lane];
	ZE	W10, W1
	MOV	#lo_addr(_Line_Dir), W0
	ADD	W0, W1, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_lastvehicle), W0
	MOV.B	W1, [W0]
;classification.h,43 :: 		tsdata[0]=datetimesec[2];
	MOV	#lo_addr(_tsdata), W1
	MOV	#lo_addr(_datetimesec+2), W0
	MOV.B	[W0], [W1]
;classification.h,44 :: 		tsdata[1]=datetimesec[3];
	MOV	#lo_addr(_tsdata+1), W1
	MOV	#lo_addr(_datetimesec+3), W0
	MOV.B	[W0], [W1]
;classification.h,45 :: 		tsdata[3]=datetimesec[5];
	MOV	#lo_addr(_tsdata+3), W1
	MOV	#lo_addr(_datetimesec+5), W0
	MOV.B	[W0], [W1]
;classification.h,46 :: 		tsdata[4]=datetimesec[6];
	MOV	#lo_addr(_tsdata+4), W1
	MOV	#lo_addr(_datetimesec+6), W0
	MOV.B	[W0], [W1]
;classification.h,47 :: 		tsdata[6]=datetimesec[8];
	MOV	#lo_addr(_tsdata+6), W1
	MOV	#lo_addr(_datetimesec+8), W0
	MOV.B	[W0], [W1]
;classification.h,48 :: 		tsdata[7]=datetimesec[9];
	MOV	#lo_addr(_tsdata+7), W1
	MOV	#lo_addr(_datetimesec+9), W0
	MOV.B	[W0], [W1]
;classification.h,49 :: 		tsdata[9]=datetimesec[11];
	MOV	#lo_addr(_tsdata+9), W1
	MOV	#lo_addr(_datetimesec+11), W0
	MOV.B	[W0], [W1]
;classification.h,50 :: 		tsdata[10]=datetimesec[12];
	MOV	#lo_addr(_tsdata+10), W1
	MOV	#lo_addr(_datetimesec+12), W0
	MOV.B	[W0], [W1]
;classification.h,51 :: 		tsdata[12]=datetimesec[14];
	MOV	#lo_addr(_tsdata+12), W1
	MOV	#lo_addr(_datetimesec+14), W0
	MOV.B	[W0], [W1]
;classification.h,52 :: 		tsdata[13]=datetimesec[15];
	MOV	#lo_addr(_tsdata+13), W1
	MOV	#lo_addr(_datetimesec+15), W0
	MOV.B	[W0], [W1]
;classification.h,53 :: 		tsdata[15]=datetimesec[17];
	MOV	#lo_addr(_tsdata+15), W1
	MOV	#lo_addr(_datetimesec+17), W0
	MOV.B	[W0], [W1]
;classification.h,54 :: 		tsdata[16]=datetimesec[18];
	MOV	#lo_addr(_tsdata+16), W1
	MOV	#lo_addr(_datetimesec+18), W0
	MOV.B	[W0], [W1]
;classification.h,55 :: 		tsdata[18]=datetimesec[20];
	MOV	#lo_addr(_tsdata+18), W1
	MOV	#lo_addr(_datetimesec+20), W0
	MOV.B	[W0], [W1]
;classification.h,56 :: 		if(vehicle_lenght<LIMA)
	PUSH	W10
	MOV	_LIMA, W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV.D	W0, W2
	MOV	_vehicle_lenght, W0
	MOV	_vehicle_lenght+2, W1
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L__cal_class1165
	INC.B	W0
L__cal_class1165:
	POP	W10
	CP0.B	W0
	BRA NZ	L__cal_class1166
	GOTO	L_cal_class240
L__cal_class1166:
;classification.h,58 :: 		if(current_time.hour >5 && current_time.hour<21)
	MOV	#lo_addr(_current_time+3), W0
	MOV.B	[W0], W0
	CP.B	W0, #5
	BRA GTU	L__cal_class1167
	GOTO	L__cal_class864
L__cal_class1167:
	MOV	#lo_addr(_current_time+3), W0
	MOV.B	[W0], W0
	CP.B	W0, #21
	BRA LTU	L__cal_class1168
	GOTO	L__cal_class863
L__cal_class1168:
L__cal_class862:
;classification.h,60 :: 		if(lastvehicle.speed > (unsigned short)(DSPEED1)) wspeed=1;
	MOV	#lo_addr(_lastvehicle+1), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_DSPEED1), W0
	CP.B	W1, [W0]
	BRA GTU	L__cal_class1169
	GOTO	L_cal_class244
L__cal_class1169:
	MOV	#lo_addr(_wspeed), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
L_cal_class244:
;classification.h,61 :: 		}
	GOTO	L_cal_class245
;classification.h,58 :: 		if(current_time.hour >5 && current_time.hour<21)
L__cal_class864:
L__cal_class863:
;classification.h,64 :: 		if(lastvehicle.speed > (unsigned short)(NSPEED1)) wspeed=1;
	MOV	#lo_addr(_lastvehicle+1), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_NSPEED1), W0
	CP.B	W1, [W0]
	BRA GTU	L__cal_class1170
	GOTO	L_cal_class246
L__cal_class1170:
	MOV	#lo_addr(_wspeed), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
L_cal_class246:
;classification.h,65 :: 		}
L_cal_class245:
;classification.h,66 :: 		}
	GOTO	L_cal_class247
L_cal_class240:
;classification.h,69 :: 		if(current_time.hour >5 && current_time.hour<21)
	MOV	#lo_addr(_current_time+3), W0
	MOV.B	[W0], W0
	CP.B	W0, #5
	BRA GTU	L__cal_class1171
	GOTO	L__cal_class866
L__cal_class1171:
	MOV	#lo_addr(_current_time+3), W0
	MOV.B	[W0], W0
	CP.B	W0, #21
	BRA LTU	L__cal_class1172
	GOTO	L__cal_class865
L__cal_class1172:
L__cal_class861:
;classification.h,71 :: 		if(lastvehicle.speed > (unsigned short)(DSPEED2)) wspeed=1;
	MOV	#lo_addr(_lastvehicle+1), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_DSPEED2), W0
	CP.B	W1, [W0]
	BRA GTU	L__cal_class1173
	GOTO	L_cal_class251
L__cal_class1173:
	MOV	#lo_addr(_wspeed), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
L_cal_class251:
;classification.h,72 :: 		}
	GOTO	L_cal_class252
;classification.h,69 :: 		if(current_time.hour >5 && current_time.hour<21)
L__cal_class866:
L__cal_class865:
;classification.h,75 :: 		if(lastvehicle.speed > (unsigned short)(NSPEED2)) wspeed=1;
	MOV	#lo_addr(_lastvehicle+1), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_NSPEED2), W0
	CP.B	W1, [W0]
	BRA GTU	L__cal_class1174
	GOTO	L_cal_class253
L__cal_class1174:
	MOV	#lo_addr(_wspeed), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
L_cal_class253:
;classification.h,76 :: 		}
L_cal_class252:
;classification.h,77 :: 		}
L_cal_class247:
;classification.h,78 :: 		if(lastvehicle.dir!=line1dir)
	MOV	#lo_addr(_lastvehicle), W0
	MOV.B	[W0], W0
	CP.B	W0, #12
	BRA NZ	L__cal_class1175
	GOTO	L_cal_class254
L__cal_class1175:
;classification.h,80 :: 		wgrab=1;
	MOV	#lo_addr(_wgrab), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;classification.h,81 :: 		if(lane==0) lane=1;
	CP.B	W10, #0
	BRA Z	L__cal_class1176
	GOTO	L_cal_class255
L__cal_class1176:
	MOV.B	#1, W10
	GOTO	L_cal_class256
L_cal_class255:
;classification.h,82 :: 		else lane =0;
	CLR	W10
L_cal_class256:
;classification.h,83 :: 		}
L_cal_class254:
;classification.h,84 :: 		if(current_gap[lane]<gap_delay)
	ZE	W10, W0
	SL	W0, #1, W1
	MOV	#lo_addr(_current_gap), W0
	ADD	W0, W1, W0
	MOV	[W0], W1
	MOV	#2000, W0
	CP	W1, W0
	BRA LT	L__cal_class1177
	GOTO	L_cal_class257
L__cal_class1177:
;classification.h,86 :: 		wheadway=1;
	MOV	#lo_addr(_wheadway), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;classification.h,87 :: 		}
L_cal_class257:
;classification.h,89 :: 		if(lane==0)
	CP.B	W10, #0
	BRA Z	L__cal_class1178
	GOTO	L_cal_class258
L__cal_class1178:
;classification.h,91 :: 		if(vehicle_lenght<LIMX)
	PUSH	W10
	MOV	_LIMX, W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV.D	W0, W2
	MOV	_vehicle_lenght, W0
	MOV	_vehicle_lenght+2, W1
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L__cal_class1179
	INC.B	W0
L__cal_class1179:
	POP	W10
	CP0.B	W0
	BRA NZ	L__cal_class1180
	GOTO	L_cal_class259
L__cal_class1180:
;classification.h,93 :: 		lastvehicle.vclass='X';
	MOV	#lo_addr(_lastvehicle+2), W1
	MOV.B	#88, W0
	MOV.B	W0, [W1]
;classification.h,94 :: 		current_interval.l1xcount++;
	MOV	_current_interval+50, W0
	INC	W0
	MOV	W0, _current_interval+50
;classification.h,95 :: 		if(wspeed==1) current_interval.l1xspeed++;
	MOV	#lo_addr(_wspeed), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1181
	GOTO	L_cal_class260
L__cal_class1181:
	MOV	_current_interval+54, W0
	INC	W0
	MOV	W0, _current_interval+54
L_cal_class260:
;classification.h,96 :: 		if(wgrab==1) current_interval.l1xgrab++;
	MOV	#lo_addr(_wgrab), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1182
	GOTO	L_cal_class261
L__cal_class1182:
	MOV	_current_interval+56, W0
	INC	W0
	MOV	W0, _current_interval+56
L_cal_class261:
;classification.h,97 :: 		if(wheadway==1) current_interval.l1xheadway++;
	MOV	#lo_addr(_wheadway), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1183
	GOTO	L_cal_class262
L__cal_class1183:
	MOV	_current_interval+58, W0
	INC	W0
	MOV	W0, _current_interval+58
L_cal_class262:
;classification.h,98 :: 		totalv1x+=lastvehicle.speed;
	MOV	#lo_addr(_lastvehicle+1), W0
	ZE	[W0], W1
	CLR	W2
	MOV	#lo_addr(_totalv1x), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;classification.h,99 :: 		}
	GOTO	L_cal_class263
L_cal_class259:
;classification.h,100 :: 		else if(vehicle_lenght<LIMA)
	PUSH	W10
	MOV	_LIMA, W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV.D	W0, W2
	MOV	_vehicle_lenght, W0
	MOV	_vehicle_lenght+2, W1
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L__cal_class1184
	INC.B	W0
L__cal_class1184:
	POP	W10
	CP0.B	W0
	BRA NZ	L__cal_class1185
	GOTO	L_cal_class264
L__cal_class1185:
;classification.h,102 :: 		lastvehicle.vclass='A';
	MOV	#lo_addr(_lastvehicle+2), W1
	MOV.B	#65, W0
	MOV.B	W0, [W1]
;classification.h,103 :: 		current_interval.l1acount++;
	MOV	_current_interval, W0
	INC	W0
	MOV	W0, _current_interval
;classification.h,104 :: 		if(wspeed==1) current_interval.l1aspeed++;
	MOV	#lo_addr(_wspeed), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1186
	GOTO	L_cal_class265
L__cal_class1186:
	MOV	_current_interval+4, W0
	INC	W0
	MOV	W0, _current_interval+4
L_cal_class265:
;classification.h,105 :: 		if(wgrab==1) current_interval.l1agrab++;
	MOV	#lo_addr(_wgrab), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1187
	GOTO	L_cal_class266
L__cal_class1187:
	MOV	_current_interval+6, W0
	INC	W0
	MOV	W0, _current_interval+6
L_cal_class266:
;classification.h,106 :: 		if(wheadway==1) current_interval.l1aheadway++;
	MOV	#lo_addr(_wheadway), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1188
	GOTO	L_cal_class267
L__cal_class1188:
	MOV	_current_interval+8, W0
	INC	W0
	MOV	W0, _current_interval+8
L_cal_class267:
;classification.h,107 :: 		totalv1a+=lastvehicle.speed;
	MOV	#lo_addr(_lastvehicle+1), W0
	ZE	[W0], W1
	CLR	W2
	MOV	#lo_addr(_totalv1a), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;classification.h,108 :: 		}
	GOTO	L_cal_class268
L_cal_class264:
;classification.h,109 :: 		else if(vehicle_lenght<LIMB)
	PUSH	W10
	MOV	_LIMB, W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV.D	W0, W2
	MOV	_vehicle_lenght, W0
	MOV	_vehicle_lenght+2, W1
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L__cal_class1189
	INC.B	W0
L__cal_class1189:
	POP	W10
	CP0.B	W0
	BRA NZ	L__cal_class1190
	GOTO	L_cal_class269
L__cal_class1190:
;classification.h,111 :: 		lastvehicle.vclass='B';
	MOV	#lo_addr(_lastvehicle+2), W1
	MOV.B	#66, W0
	MOV.B	W0, [W1]
;classification.h,112 :: 		current_interval.l1bcount++;
	MOV	_current_interval+10, W0
	INC	W0
	MOV	W0, _current_interval+10
;classification.h,113 :: 		if(wspeed==1) current_interval.l1bspeed++;
	MOV	#lo_addr(_wspeed), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1191
	GOTO	L_cal_class270
L__cal_class1191:
	MOV	_current_interval+14, W0
	INC	W0
	MOV	W0, _current_interval+14
L_cal_class270:
;classification.h,114 :: 		if(wgrab==1) current_interval.l1bgrab++;
	MOV	#lo_addr(_wgrab), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1192
	GOTO	L_cal_class271
L__cal_class1192:
	MOV	_current_interval+16, W0
	INC	W0
	MOV	W0, _current_interval+16
L_cal_class271:
;classification.h,115 :: 		if(wheadway==1) current_interval.l1bheadway++;
	MOV	#lo_addr(_wheadway), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1193
	GOTO	L_cal_class272
L__cal_class1193:
	MOV	_current_interval+18, W0
	INC	W0
	MOV	W0, _current_interval+18
L_cal_class272:
;classification.h,116 :: 		totalv1b+=lastvehicle.speed;
	MOV	#lo_addr(_lastvehicle+1), W0
	ZE	[W0], W1
	CLR	W2
	MOV	#lo_addr(_totalv1b), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;classification.h,117 :: 		}
	GOTO	L_cal_class273
L_cal_class269:
;classification.h,118 :: 		else if(vehicle_lenght<LIMC)
	PUSH	W10
	MOV	_LIMC, W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV.D	W0, W2
	MOV	_vehicle_lenght, W0
	MOV	_vehicle_lenght+2, W1
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L__cal_class1194
	INC.B	W0
L__cal_class1194:
	POP	W10
	CP0.B	W0
	BRA NZ	L__cal_class1195
	GOTO	L_cal_class274
L__cal_class1195:
;classification.h,120 :: 		lastvehicle.vclass='C';
	MOV	#lo_addr(_lastvehicle+2), W1
	MOV.B	#67, W0
	MOV.B	W0, [W1]
;classification.h,121 :: 		current_interval.l1ccount++;
	MOV	_current_interval+20, W0
	INC	W0
	MOV	W0, _current_interval+20
;classification.h,122 :: 		if(wspeed==1) current_interval.l1cspeed++;
	MOV	#lo_addr(_wspeed), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1196
	GOTO	L_cal_class275
L__cal_class1196:
	MOV	_current_interval+24, W0
	INC	W0
	MOV	W0, _current_interval+24
L_cal_class275:
;classification.h,123 :: 		if(wgrab==1) current_interval.l1cgrab++;
	MOV	#lo_addr(_wgrab), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1197
	GOTO	L_cal_class276
L__cal_class1197:
	MOV	_current_interval+26, W0
	INC	W0
	MOV	W0, _current_interval+26
L_cal_class276:
;classification.h,124 :: 		if(wheadway==1) current_interval.l1cheadway++;
	MOV	#lo_addr(_wheadway), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1198
	GOTO	L_cal_class277
L__cal_class1198:
	MOV	_current_interval+28, W0
	INC	W0
	MOV	W0, _current_interval+28
L_cal_class277:
;classification.h,125 :: 		totalv1c+=lastvehicle.speed;
	MOV	#lo_addr(_lastvehicle+1), W0
	ZE	[W0], W1
	CLR	W2
	MOV	#lo_addr(_totalv1c), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;classification.h,126 :: 		}
	GOTO	L_cal_class278
L_cal_class274:
;classification.h,127 :: 		else if(vehicle_lenght<LIMD)
	PUSH	W10
	MOV	_LIMD, W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV.D	W0, W2
	MOV	_vehicle_lenght, W0
	MOV	_vehicle_lenght+2, W1
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L__cal_class1199
	INC.B	W0
L__cal_class1199:
	POP	W10
	CP0.B	W0
	BRA NZ	L__cal_class1200
	GOTO	L_cal_class279
L__cal_class1200:
;classification.h,129 :: 		lastvehicle.vclass='D';
	MOV	#lo_addr(_lastvehicle+2), W1
	MOV.B	#68, W0
	MOV.B	W0, [W1]
;classification.h,130 :: 		current_interval.l1dcount++;
	MOV	_current_interval+30, W0
	INC	W0
	MOV	W0, _current_interval+30
;classification.h,131 :: 		if(wspeed==1) current_interval.l1dspeed++;
	MOV	#lo_addr(_wspeed), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1201
	GOTO	L_cal_class280
L__cal_class1201:
	MOV	_current_interval+34, W0
	INC	W0
	MOV	W0, _current_interval+34
L_cal_class280:
;classification.h,132 :: 		if(wgrab==1) current_interval.l1dgrab++;
	MOV	#lo_addr(_wgrab), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1202
	GOTO	L_cal_class281
L__cal_class1202:
	MOV	_current_interval+36, W0
	INC	W0
	MOV	W0, _current_interval+36
L_cal_class281:
;classification.h,133 :: 		if(wheadway==1) current_interval.l1dheadway++;
	MOV	#lo_addr(_wheadway), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1203
	GOTO	L_cal_class282
L__cal_class1203:
	MOV	_current_interval+38, W0
	INC	W0
	MOV	W0, _current_interval+38
L_cal_class282:
;classification.h,134 :: 		totalv1d+=lastvehicle.speed;
	MOV	#lo_addr(_lastvehicle+1), W0
	ZE	[W0], W1
	CLR	W2
	MOV	#lo_addr(_totalv1d), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;classification.h,135 :: 		}
	GOTO	L_cal_class283
L_cal_class279:
;classification.h,136 :: 		else if(vehicle_lenght<LIMITE)
	PUSH	W10
	MOV	_LIMITE, W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV.D	W0, W2
	MOV	_vehicle_lenght, W0
	MOV	_vehicle_lenght+2, W1
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L__cal_class1204
	INC.B	W0
L__cal_class1204:
	POP	W10
	CP0.B	W0
	BRA NZ	L__cal_class1205
	GOTO	L_cal_class284
L__cal_class1205:
;classification.h,138 :: 		lastvehicle.vclass='E';
	MOV	#lo_addr(_lastvehicle+2), W1
	MOV.B	#69, W0
	MOV.B	W0, [W1]
;classification.h,139 :: 		current_interval.l1ecount++;
	MOV	_current_interval+40, W0
	INC	W0
	MOV	W0, _current_interval+40
;classification.h,140 :: 		if(wspeed==1) current_interval.l1espeed++;
	MOV	#lo_addr(_wspeed), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1206
	GOTO	L_cal_class285
L__cal_class1206:
	MOV	_current_interval+44, W0
	INC	W0
	MOV	W0, _current_interval+44
L_cal_class285:
;classification.h,141 :: 		if(wgrab==1) current_interval.l1egrab++;
	MOV	#lo_addr(_wgrab), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1207
	GOTO	L_cal_class286
L__cal_class1207:
	MOV	_current_interval+46, W0
	INC	W0
	MOV	W0, _current_interval+46
L_cal_class286:
;classification.h,142 :: 		if(wheadway==1) current_interval.l1eheadway++;
	MOV	#lo_addr(_wheadway), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1208
	GOTO	L_cal_class287
L__cal_class1208:
	MOV	_current_interval+48, W0
	INC	W0
	MOV	W0, _current_interval+48
L_cal_class287:
;classification.h,143 :: 		totalv1e+=lastvehicle.speed;
	MOV	#lo_addr(_lastvehicle+1), W0
	ZE	[W0], W1
	CLR	W2
	MOV	#lo_addr(_totalv1e), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;classification.h,144 :: 		}
	GOTO	L_cal_class288
L_cal_class284:
;classification.h,147 :: 		lastvehicle.vclass='X';
	MOV	#lo_addr(_lastvehicle+2), W1
	MOV.B	#88, W0
	MOV.B	W0, [W1]
;classification.h,148 :: 		current_interval.l1xcount++;
	MOV	_current_interval+50, W0
	INC	W0
	MOV	W0, _current_interval+50
;classification.h,149 :: 		if(wspeed==1) current_interval.l1xspeed++;
	MOV	#lo_addr(_wspeed), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1209
	GOTO	L_cal_class289
L__cal_class1209:
	MOV	_current_interval+54, W0
	INC	W0
	MOV	W0, _current_interval+54
L_cal_class289:
;classification.h,150 :: 		if(wgrab==1) current_interval.l1xgrab++;
	MOV	#lo_addr(_wgrab), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1210
	GOTO	L_cal_class290
L__cal_class1210:
	MOV	_current_interval+56, W0
	INC	W0
	MOV	W0, _current_interval+56
L_cal_class290:
;classification.h,151 :: 		if(wheadway==1) current_interval.l1xheadway++;
	MOV	#lo_addr(_wheadway), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1211
	GOTO	L_cal_class291
L__cal_class1211:
	MOV	_current_interval+58, W0
	INC	W0
	MOV	W0, _current_interval+58
L_cal_class291:
;classification.h,152 :: 		totalv1x+=lastvehicle.speed;
	MOV	#lo_addr(_lastvehicle+1), W0
	ZE	[W0], W1
	CLR	W2
	MOV	#lo_addr(_totalv1x), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;classification.h,153 :: 		}
L_cal_class288:
L_cal_class283:
L_cal_class278:
L_cal_class273:
L_cal_class268:
L_cal_class263:
;classification.h,154 :: 		}
	GOTO	L_cal_class292
L_cal_class258:
;classification.h,155 :: 		else if(lane==1)
	CP.B	W10, #1
	BRA Z	L__cal_class1212
	GOTO	L_cal_class293
L__cal_class1212:
;classification.h,157 :: 		if(vehicle_lenght<LIMX)
	PUSH	W10
	MOV	_LIMX, W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV.D	W0, W2
	MOV	_vehicle_lenght, W0
	MOV	_vehicle_lenght+2, W1
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L__cal_class1213
	INC.B	W0
L__cal_class1213:
	POP	W10
	CP0.B	W0
	BRA NZ	L__cal_class1214
	GOTO	L_cal_class294
L__cal_class1214:
;classification.h,159 :: 		lastvehicle.vclass='X';
	MOV	#lo_addr(_lastvehicle+2), W1
	MOV.B	#88, W0
	MOV.B	W0, [W1]
;classification.h,160 :: 		current_interval.l2xcount++;
	MOV	_current_interval+112, W0
	INC	W0
	MOV	W0, _current_interval+112
;classification.h,161 :: 		if(wspeed==1) current_interval.l2xspeed++;
	MOV	#lo_addr(_wspeed), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1215
	GOTO	L_cal_class295
L__cal_class1215:
	MOV	_current_interval+116, W0
	INC	W0
	MOV	W0, _current_interval+116
L_cal_class295:
;classification.h,162 :: 		if(wgrab==1) current_interval.l2xgrab++;
	MOV	#lo_addr(_wgrab), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1216
	GOTO	L_cal_class296
L__cal_class1216:
	MOV	_current_interval+118, W0
	INC	W0
	MOV	W0, _current_interval+118
L_cal_class296:
;classification.h,163 :: 		if(wheadway==1) current_interval.l2xheadway++;
	MOV	#lo_addr(_wheadway), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1217
	GOTO	L_cal_class297
L__cal_class1217:
	MOV	_current_interval+120, W0
	INC	W0
	MOV	W0, _current_interval+120
L_cal_class297:
;classification.h,164 :: 		totalv2x+=lastvehicle.speed;
	MOV	#lo_addr(_lastvehicle+1), W0
	ZE	[W0], W1
	CLR	W2
	MOV	#lo_addr(_totalv2x), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;classification.h,165 :: 		}
	GOTO	L_cal_class298
L_cal_class294:
;classification.h,166 :: 		else if(vehicle_lenght<LIMA)
	PUSH	W10
	MOV	_LIMA, W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV.D	W0, W2
	MOV	_vehicle_lenght, W0
	MOV	_vehicle_lenght+2, W1
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L__cal_class1218
	INC.B	W0
L__cal_class1218:
	POP	W10
	CP0.B	W0
	BRA NZ	L__cal_class1219
	GOTO	L_cal_class299
L__cal_class1219:
;classification.h,168 :: 		lastvehicle.vclass='A';
	MOV	#lo_addr(_lastvehicle+2), W1
	MOV.B	#65, W0
	MOV.B	W0, [W1]
;classification.h,169 :: 		current_interval.l2acount++;
	MOV	_current_interval+62, W0
	INC	W0
	MOV	W0, _current_interval+62
;classification.h,170 :: 		if(wspeed==1) current_interval.l2aspeed++;
	MOV	#lo_addr(_wspeed), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1220
	GOTO	L_cal_class300
L__cal_class1220:
	MOV	_current_interval+66, W0
	INC	W0
	MOV	W0, _current_interval+66
L_cal_class300:
;classification.h,171 :: 		if(wgrab==1) current_interval.l2agrab++;
	MOV	#lo_addr(_wgrab), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1221
	GOTO	L_cal_class301
L__cal_class1221:
	MOV	_current_interval+68, W0
	INC	W0
	MOV	W0, _current_interval+68
L_cal_class301:
;classification.h,172 :: 		if(wheadway==1) current_interval.l2aheadway++;
	MOV	#lo_addr(_wheadway), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1222
	GOTO	L_cal_class302
L__cal_class1222:
	MOV	_current_interval+70, W0
	INC	W0
	MOV	W0, _current_interval+70
L_cal_class302:
;classification.h,173 :: 		totalv2a+=lastvehicle.speed;
	MOV	#lo_addr(_lastvehicle+1), W0
	ZE	[W0], W1
	CLR	W2
	MOV	#lo_addr(_totalv2a), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;classification.h,174 :: 		}
	GOTO	L_cal_class303
L_cal_class299:
;classification.h,175 :: 		else if(vehicle_lenght<LIMB)
	PUSH	W10
	MOV	_LIMB, W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV.D	W0, W2
	MOV	_vehicle_lenght, W0
	MOV	_vehicle_lenght+2, W1
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L__cal_class1223
	INC.B	W0
L__cal_class1223:
	POP	W10
	CP0.B	W0
	BRA NZ	L__cal_class1224
	GOTO	L_cal_class304
L__cal_class1224:
;classification.h,177 :: 		lastvehicle.vclass='B';
	MOV	#lo_addr(_lastvehicle+2), W1
	MOV.B	#66, W0
	MOV.B	W0, [W1]
;classification.h,178 :: 		current_interval.l2bcount++;
	MOV	_current_interval+72, W0
	INC	W0
	MOV	W0, _current_interval+72
;classification.h,179 :: 		if(wspeed==1) current_interval.l2bspeed++;
	MOV	#lo_addr(_wspeed), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1225
	GOTO	L_cal_class305
L__cal_class1225:
	MOV	_current_interval+76, W0
	INC	W0
	MOV	W0, _current_interval+76
L_cal_class305:
;classification.h,180 :: 		if(wgrab==1) current_interval.l2bgrab++;
	MOV	#lo_addr(_wgrab), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1226
	GOTO	L_cal_class306
L__cal_class1226:
	MOV	_current_interval+78, W0
	INC	W0
	MOV	W0, _current_interval+78
L_cal_class306:
;classification.h,181 :: 		if(wheadway==1) current_interval.l2bheadway++;
	MOV	#lo_addr(_wheadway), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1227
	GOTO	L_cal_class307
L__cal_class1227:
	MOV	_current_interval+80, W0
	INC	W0
	MOV	W0, _current_interval+80
L_cal_class307:
;classification.h,182 :: 		totalv2b+=lastvehicle.speed;
	MOV	#lo_addr(_lastvehicle+1), W0
	ZE	[W0], W1
	CLR	W2
	MOV	#lo_addr(_totalv2b), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;classification.h,183 :: 		}
	GOTO	L_cal_class308
L_cal_class304:
;classification.h,184 :: 		else if(vehicle_lenght<LIMC)
	PUSH	W10
	MOV	_LIMC, W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV.D	W0, W2
	MOV	_vehicle_lenght, W0
	MOV	_vehicle_lenght+2, W1
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L__cal_class1228
	INC.B	W0
L__cal_class1228:
	POP	W10
	CP0.B	W0
	BRA NZ	L__cal_class1229
	GOTO	L_cal_class309
L__cal_class1229:
;classification.h,186 :: 		lastvehicle.vclass='C';
	MOV	#lo_addr(_lastvehicle+2), W1
	MOV.B	#67, W0
	MOV.B	W0, [W1]
;classification.h,187 :: 		current_interval.l2ccount++;
	MOV	_current_interval+82, W0
	INC	W0
	MOV	W0, _current_interval+82
;classification.h,188 :: 		if(wspeed==1) current_interval.l2cspeed++;
	MOV	#lo_addr(_wspeed), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1230
	GOTO	L_cal_class310
L__cal_class1230:
	MOV	_current_interval+86, W0
	INC	W0
	MOV	W0, _current_interval+86
L_cal_class310:
;classification.h,189 :: 		if(wgrab==1) current_interval.l2cgrab++;
	MOV	#lo_addr(_wgrab), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1231
	GOTO	L_cal_class311
L__cal_class1231:
	MOV	_current_interval+88, W0
	INC	W0
	MOV	W0, _current_interval+88
L_cal_class311:
;classification.h,190 :: 		if(wheadway==1) current_interval.l2cheadway++;
	MOV	#lo_addr(_wheadway), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1232
	GOTO	L_cal_class312
L__cal_class1232:
	MOV	_current_interval+90, W0
	INC	W0
	MOV	W0, _current_interval+90
L_cal_class312:
;classification.h,191 :: 		totalv2c+=lastvehicle.speed;
	MOV	#lo_addr(_lastvehicle+1), W0
	ZE	[W0], W1
	CLR	W2
	MOV	#lo_addr(_totalv2c), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;classification.h,192 :: 		}
	GOTO	L_cal_class313
L_cal_class309:
;classification.h,193 :: 		else if(vehicle_lenght<LIMD)
	PUSH	W10
	MOV	_LIMD, W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV.D	W0, W2
	MOV	_vehicle_lenght, W0
	MOV	_vehicle_lenght+2, W1
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L__cal_class1233
	INC.B	W0
L__cal_class1233:
	POP	W10
	CP0.B	W0
	BRA NZ	L__cal_class1234
	GOTO	L_cal_class314
L__cal_class1234:
;classification.h,195 :: 		lastvehicle.vclass='D';
	MOV	#lo_addr(_lastvehicle+2), W1
	MOV.B	#68, W0
	MOV.B	W0, [W1]
;classification.h,196 :: 		current_interval.l2dcount++;
	MOV	_current_interval+92, W0
	INC	W0
	MOV	W0, _current_interval+92
;classification.h,197 :: 		if(wspeed==1) current_interval.l2dspeed++;
	MOV	#lo_addr(_wspeed), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1235
	GOTO	L_cal_class315
L__cal_class1235:
	MOV	_current_interval+96, W0
	INC	W0
	MOV	W0, _current_interval+96
L_cal_class315:
;classification.h,198 :: 		if(wgrab==1) current_interval.l2dgrab++;
	MOV	#lo_addr(_wgrab), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1236
	GOTO	L_cal_class316
L__cal_class1236:
	MOV	_current_interval+98, W0
	INC	W0
	MOV	W0, _current_interval+98
L_cal_class316:
;classification.h,199 :: 		if(wheadway==1) current_interval.l2dheadway++;
	MOV	#lo_addr(_wheadway), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1237
	GOTO	L_cal_class317
L__cal_class1237:
	MOV	_current_interval+100, W0
	INC	W0
	MOV	W0, _current_interval+100
L_cal_class317:
;classification.h,200 :: 		totalv2d+=lastvehicle.speed;
	MOV	#lo_addr(_lastvehicle+1), W0
	ZE	[W0], W1
	CLR	W2
	MOV	#lo_addr(_totalv2d), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;classification.h,201 :: 		}
	GOTO	L_cal_class318
L_cal_class314:
;classification.h,202 :: 		else if(vehicle_lenght<LIMITE)
	PUSH	W10
	MOV	_LIMITE, W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV.D	W0, W2
	MOV	_vehicle_lenght, W0
	MOV	_vehicle_lenght+2, W1
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L__cal_class1238
	INC.B	W0
L__cal_class1238:
	POP	W10
	CP0.B	W0
	BRA NZ	L__cal_class1239
	GOTO	L_cal_class319
L__cal_class1239:
;classification.h,204 :: 		lastvehicle.vclass='E';
	MOV	#lo_addr(_lastvehicle+2), W1
	MOV.B	#69, W0
	MOV.B	W0, [W1]
;classification.h,205 :: 		current_interval.l2ecount++;
	MOV	_current_interval+102, W0
	INC	W0
	MOV	W0, _current_interval+102
;classification.h,206 :: 		if(wspeed==1) current_interval.l2espeed++;
	MOV	#lo_addr(_wspeed), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1240
	GOTO	L_cal_class320
L__cal_class1240:
	MOV	_current_interval+106, W0
	INC	W0
	MOV	W0, _current_interval+106
L_cal_class320:
;classification.h,207 :: 		if(wgrab==1) current_interval.l2egrab++;
	MOV	#lo_addr(_wgrab), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1241
	GOTO	L_cal_class321
L__cal_class1241:
	MOV	_current_interval+108, W0
	INC	W0
	MOV	W0, _current_interval+108
L_cal_class321:
;classification.h,208 :: 		if(wheadway==1) current_interval.l2eheadway++;
	MOV	#lo_addr(_wheadway), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1242
	GOTO	L_cal_class322
L__cal_class1242:
	MOV	_current_interval+110, W0
	INC	W0
	MOV	W0, _current_interval+110
L_cal_class322:
;classification.h,209 :: 		totalv2e+=lastvehicle.speed;
	MOV	#lo_addr(_lastvehicle+1), W0
	ZE	[W0], W1
	CLR	W2
	MOV	#lo_addr(_totalv2e), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;classification.h,210 :: 		}
	GOTO	L_cal_class323
L_cal_class319:
;classification.h,213 :: 		lastvehicle.vclass='X';
	MOV	#lo_addr(_lastvehicle+2), W1
	MOV.B	#88, W0
	MOV.B	W0, [W1]
;classification.h,214 :: 		current_interval.l2xcount++;
	MOV	_current_interval+112, W0
	INC	W0
	MOV	W0, _current_interval+112
;classification.h,215 :: 		if(wspeed==1) current_interval.l2xspeed++;
	MOV	#lo_addr(_wspeed), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1243
	GOTO	L_cal_class324
L__cal_class1243:
	MOV	_current_interval+116, W0
	INC	W0
	MOV	W0, _current_interval+116
L_cal_class324:
;classification.h,216 :: 		if(wgrab==1) current_interval.l2xgrab++;
	MOV	#lo_addr(_wgrab), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1244
	GOTO	L_cal_class325
L__cal_class1244:
	MOV	_current_interval+118, W0
	INC	W0
	MOV	W0, _current_interval+118
L_cal_class325:
;classification.h,217 :: 		if(wheadway==1) current_interval.l2xheadway++;
	MOV	#lo_addr(_wheadway), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1245
	GOTO	L_cal_class326
L__cal_class1245:
	MOV	_current_interval+120, W0
	INC	W0
	MOV	W0, _current_interval+120
L_cal_class326:
;classification.h,218 :: 		totalv2x+=lastvehicle.speed;
	MOV	#lo_addr(_lastvehicle+1), W0
	ZE	[W0], W1
	CLR	W2
	MOV	#lo_addr(_totalv2x), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;classification.h,219 :: 		}
L_cal_class323:
L_cal_class318:
L_cal_class313:
L_cal_class308:
L_cal_class303:
L_cal_class298:
;classification.h,220 :: 		}
L_cal_class293:
L_cal_class292:
;classification.h,221 :: 		tsdata[22] = lastvehicle.vclass;
	MOV	#lo_addr(_tsdata+22), W1
	MOV	#lo_addr(_lastvehicle+2), W0
	MOV.B	[W0], [W1]
;classification.h,222 :: 		tsdata[20] = lane+49;
	MOV.B	#49, W1
	MOV	#lo_addr(_tsdata+20), W0
	ADD.B	W10, W1, [W0]
;classification.h,223 :: 		bytetostr(lastvehicle.speed,tmp3);
	PUSH	W10
	MOV	#lo_addr(_tmp3), W11
	MOV	#lo_addr(_lastvehicle+1), W0
	MOV.B	[W0], W10
	CALL	_ByteToStr
	POP	W10
;classification.h,224 :: 		tsdata[24]=tmp3[0];
	MOV	#lo_addr(_tsdata+24), W1
	MOV	#lo_addr(_tmp3), W0
	MOV.B	[W0], [W1]
;classification.h,225 :: 		tsdata[25]=tmp3[1];
	MOV	#lo_addr(_tsdata+25), W1
	MOV	#lo_addr(_tmp3+1), W0
	MOV.B	[W0], [W1]
;classification.h,226 :: 		tsdata[26]=tmp3[2];
	MOV	#lo_addr(_tsdata+26), W1
	MOV	#lo_addr(_tmp3+2), W0
	MOV.B	[W0], [W1]
;classification.h,227 :: 		if(wspeed==1) tsdata[28] = 49;
	MOV	#lo_addr(_wspeed), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1246
	GOTO	L_cal_class327
L__cal_class1246:
	MOV	#lo_addr(_tsdata+28), W1
	MOV.B	#49, W0
	MOV.B	W0, [W1]
	GOTO	L_cal_class328
L_cal_class327:
;classification.h,228 :: 		else          tsdata[28] = 48;
	MOV	#lo_addr(_tsdata+28), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
L_cal_class328:
;classification.h,229 :: 		if(wgrab==1)  tsdata[29] = 49;
	MOV	#lo_addr(_wgrab), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1247
	GOTO	L_cal_class329
L__cal_class1247:
	MOV	#lo_addr(_tsdata+29), W1
	MOV.B	#49, W0
	MOV.B	W0, [W1]
	GOTO	L_cal_class330
L_cal_class329:
;classification.h,230 :: 		else          tsdata[29] = 48;
	MOV	#lo_addr(_tsdata+29), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
L_cal_class330:
;classification.h,231 :: 		if(wheadway==1) tsdata[30] = 49;
	MOV	#lo_addr(_wheadway), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__cal_class1248
	GOTO	L_cal_class331
L__cal_class1248:
	MOV	#lo_addr(_tsdata+30), W1
	MOV.B	#49, W0
	MOV.B	W0, [W1]
	GOTO	L_cal_class332
L_cal_class331:
;classification.h,232 :: 		else          tsdata[30] = 48;
	MOV	#lo_addr(_tsdata+30), W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
L_cal_class332:
;classification.h,234 :: 		tsdata[31]=0;
	MOV	#lo_addr(_tsdata+31), W1
	CLR	W0
	MOV.B	W0, [W1]
;classification.h,235 :: 		tsdata[32]=0;
	MOV	#lo_addr(_tsdata+32), W1
	CLR	W0
	MOV.B	W0, [W1]
;classification.h,236 :: 		for(tmpcnt=0;tmpcnt<strlen(tsdata);tmpcnt++) if(tsdata[tmpcnt]==' ') tsdata[tmpcnt]='0';
	MOV	#lo_addr(_tmpcnt), W1
	CLR	W0
	MOV.B	W0, [W1]
L_cal_class333:
	PUSH	W10
	MOV	#lo_addr(_tsdata), W10
	CALL	_strlen
	POP	W10
	MOV	#lo_addr(_tmpcnt), W1
	SE	[W1], W1
	CP	W1, W0
	BRA LT	L__cal_class1249
	GOTO	L_cal_class334
L__cal_class1249:
	MOV	#lo_addr(_tmpcnt), W0
	SE	[W0], W1
	MOV	#lo_addr(_tsdata), W0
	ADD	W0, W1, W0
	MOV.B	[W0], W1
	MOV.B	#32, W0
	CP.B	W1, W0
	BRA Z	L__cal_class1250
	GOTO	L_cal_class336
L__cal_class1250:
	MOV	#lo_addr(_tmpcnt), W0
	SE	[W0], W1
	MOV	#lo_addr(_tsdata), W0
	ADD	W0, W1, W1
	MOV.B	#48, W0
	MOV.B	W0, [W1]
L_cal_class336:
	MOV.B	#1, W1
	MOV	#lo_addr(_tmpcnt), W0
	ADD.B	W1, [W0], [W0]
	GOTO	L_cal_class333
L_cal_class334:
;classification.h,239 :: 		UART1_Write_Text(tsdata);
	PUSH	W10
	MOV	#lo_addr(_tsdata), W10
	CALL	_UART1_Write_Text
;classification.h,240 :: 		UART1_Write(',');
	MOV	#44, W10
	CALL	_UART1_Write
;classification.h,241 :: 		longtostr((long)(floor(vehicle_lenght)),debug_txt);
	MOV	_vehicle_lenght, W10
	MOV	_vehicle_lenght+2, W11
	CALL	_floor
	CALL	__Float2Longint
	MOV	#lo_addr(_debug_txt), W12
	MOV.D	W0, W10
	CALL	_LongToStr
;classification.h,242 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;classification.h,243 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;classification.h,244 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
	POP	W10
;classification.h,246 :: 		tsdata[31]=13;
	MOV	#lo_addr(_tsdata+31), W1
	MOV.B	#13, W0
	MOV.B	W0, [W1]
;classification.h,247 :: 		tsdata[32]=10;
	MOV	#lo_addr(_tsdata+32), W1
	MOV.B	#10, W0
	MOV.B	W0, [W1]
;classification.h,248 :: 		mmc_vbv_send=1;
	MOV	#lo_addr(_mmc_vbv_send), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;classification.h,249 :: 		current_gap[lane]=0;
	ZE	W10, W0
	SL	W0, #1, W1
	MOV	#lo_addr(_current_gap), W0
	ADD	W0, W1, W1
	CLR	W0
	MOV	W0, [W1]
;classification.h,251 :: 		reset_class(lane);
	CALL	_reset_class
;classification.h,253 :: 		}
L_end_cal_class:
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of _cal_class

_measure_loops:

;classification.h,254 :: 		void measure_loops()
;classification.h,256 :: 		if(!onloop0 && loop[0] && dev[0]>MARGINTOP && ((line1step==0) || (line1step==1 && Line_Dir[0]==21)))
	PUSH	W10
	BTSC	LATE0_bit, BitPos(LATE0_bit+0)
	GOTO	L__measure_loops904
	MOV	#lo_addr(_loop), W0
	CP0	[W0]
	BRA NZ	L__measure_loops1252
	GOTO	L__measure_loops903
L__measure_loops1252:
	MOV	_dev, W1
	MOV	#lo_addr(_MARGINTOP), W0
	CP	W1, [W0]
	BRA GT	L__measure_loops1253
	GOTO	L__measure_loops902
L__measure_loops1253:
	MOV	#lo_addr(_line1step), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA NZ	L__measure_loops1254
	GOTO	L__measure_loops901
L__measure_loops1254:
	MOV	#lo_addr(_line1step), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__measure_loops1255
	GOTO	L__measure_loops900
L__measure_loops1255:
	MOV	#lo_addr(_Line_Dir), W0
	MOV.B	[W0], W0
	CP.B	W0, #21
	BRA Z	L__measure_loops1256
	GOTO	L__measure_loops899
L__measure_loops1256:
	GOTO	L__measure_loops897
L__measure_loops900:
L__measure_loops899:
	GOTO	L_measure_loops343
L__measure_loops897:
L__measure_loops901:
L__measure_loops896:
;classification.h,258 :: 		onloop0=1;
	BSET	LATE0_bit, BitPos(LATE0_bit+0)
;classification.h,259 :: 		if(timexen[0])
	MOV	#lo_addr(_timexen), W0
	CP0.B	[W0]
	BRA NZ	L__measure_loops1257
	GOTO	L_measure_loops344
L__measure_loops1257:
;classification.h,261 :: 		T1[0]=timex[0];
	MOV	_timex, W0
	MOV	_timex+2, W1
	MOV	W0, _T1
	MOV	W1, _T1+2
;classification.h,262 :: 		line1step=2;
	MOV	#lo_addr(_line1step), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;classification.h,263 :: 		}
	GOTO	L_measure_loops345
L_measure_loops344:
;classification.h,266 :: 		timexen[0]=1;
	MOV	#lo_addr(_timexen), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;classification.h,267 :: 		line1step=1;
	MOV	#lo_addr(_line1step), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;classification.h,268 :: 		caldata[1]=freq_mean[1];
	MOV	_freq_mean+4, W0
	MOV	_freq_mean+6, W1
	MOV	W0, _caldata+4
	MOV	W1, _caldata+6
;classification.h,269 :: 		Line_Dir[0]=12;
	MOV	#lo_addr(_Line_Dir), W1
	MOV.B	#12, W0
	MOV.B	W0, [W1]
;classification.h,270 :: 		}
L_measure_loops345:
;classification.h,271 :: 		}
	GOTO	L_measure_loops346
L_measure_loops343:
;classification.h,256 :: 		if(!onloop0 && loop[0] && dev[0]>MARGINTOP && ((line1step==0) || (line1step==1 && Line_Dir[0]==21)))
L__measure_loops904:
L__measure_loops903:
L__measure_loops902:
;classification.h,272 :: 		else if(onloop0 && loop[0] && dev[0]<MARGINBOT && ((line1step==2 && Line_Dir[0]==12) || (line1step==3 && Line_Dir[0]==21)))
	BTSS	LATE0_bit, BitPos(LATE0_bit+0)
	GOTO	L__measure_loops911
	MOV	#lo_addr(_loop), W0
	CP0	[W0]
	BRA NZ	L__measure_loops1258
	GOTO	L__measure_loops910
L__measure_loops1258:
	MOV	_dev, W1
	MOV	#lo_addr(_MARGINBOT), W0
	CP	W1, [W0]
	BRA LT	L__measure_loops1259
	GOTO	L__measure_loops909
L__measure_loops1259:
	MOV	#lo_addr(_line1step), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__measure_loops1260
	GOTO	L__measure_loops906
L__measure_loops1260:
	MOV	#lo_addr(_Line_Dir), W0
	MOV.B	[W0], W0
	CP.B	W0, #12
	BRA Z	L__measure_loops1261
	GOTO	L__measure_loops905
L__measure_loops1261:
	GOTO	L__measure_loops893
L__measure_loops906:
L__measure_loops905:
	MOV	#lo_addr(_line1step), W0
	MOV.B	[W0], W0
	CP.B	W0, #3
	BRA Z	L__measure_loops1262
	GOTO	L__measure_loops908
L__measure_loops1262:
	MOV	#lo_addr(_Line_Dir), W0
	MOV.B	[W0], W0
	CP.B	W0, #21
	BRA Z	L__measure_loops1263
	GOTO	L__measure_loops907
L__measure_loops1263:
	GOTO	L__measure_loops893
L__measure_loops908:
L__measure_loops907:
	GOTO	L_measure_loops355
L__measure_loops893:
L__measure_loops892:
;classification.h,274 :: 		onloop0=0;
	BCLR	LATE0_bit, BitPos(LATE0_bit+0)
;classification.h,275 :: 		if(T2[0]>0)
	MOV	_T2, W0
	MOV	_T2+2, W1
	CP	W0, #0
	CPB	W1, #0
	BRA GT	L__measure_loops1264
	GOTO	L_measure_loops356
L__measure_loops1264:
;classification.h,277 :: 		T3[0]=timex[0];
	MOV	_timex, W0
	MOV	_timex+2, W1
	MOV	W0, _T3
	MOV	W1, _T3+2
;classification.h,278 :: 		line1step=0;
	MOV	#lo_addr(_line1step), W1
	CLR	W0
	MOV.B	W0, [W1]
;classification.h,279 :: 		caldata[1]=freq_mean[1];
	MOV	_freq_mean+4, W0
	MOV	_freq_mean+6, W1
	MOV	W0, _caldata+4
	MOV	W1, _caldata+6
;classification.h,281 :: 		cal_class0=1;
	MOV	#lo_addr(_cal_class0), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;classification.h,282 :: 		}
	GOTO	L_measure_loops357
L_measure_loops356:
;classification.h,285 :: 		T2[0]=timex[0];
	MOV	_timex, W0
	MOV	_timex+2, W1
	MOV	W0, _T2
	MOV	W1, _T2+2
;classification.h,286 :: 		line1step=3;
	MOV	#lo_addr(_line1step), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;classification.h,287 :: 		}
L_measure_loops357:
;classification.h,288 :: 		}
	GOTO	L_measure_loops358
L_measure_loops355:
;classification.h,272 :: 		else if(onloop0 && loop[0] && dev[0]<MARGINBOT && ((line1step==2 && Line_Dir[0]==12) || (line1step==3 && Line_Dir[0]==21)))
L__measure_loops911:
L__measure_loops910:
L__measure_loops909:
;classification.h,289 :: 		else if(onloop0 && loop[0] && dev[0]<MARGINBOT)
	BTSS	LATE0_bit, BitPos(LATE0_bit+0)
	GOTO	L__measure_loops914
	MOV	#lo_addr(_loop), W0
	CP0	[W0]
	BRA NZ	L__measure_loops1265
	GOTO	L__measure_loops913
L__measure_loops1265:
	MOV	_dev, W1
	MOV	#lo_addr(_MARGINBOT), W0
	CP	W1, [W0]
	BRA LT	L__measure_loops1266
	GOTO	L__measure_loops912
L__measure_loops1266:
L__measure_loops891:
;classification.h,291 :: 		reset_class(0);
	CLR	W10
	CALL	_reset_class
;classification.h,289 :: 		else if(onloop0 && loop[0] && dev[0]<MARGINBOT)
L__measure_loops914:
L__measure_loops913:
L__measure_loops912:
;classification.h,292 :: 		}
L_measure_loops358:
L_measure_loops346:
;classification.h,293 :: 		if(!onloop2 && loop[2] && dev[2]>MARGINTOP && ((line2step==0) || (line2step==1 && Line_Dir[1]==21)))
	BTSC	LATE2_bit, BitPos(LATE2_bit+0)
	GOTO	L__measure_loops920
	MOV	#lo_addr(_loop+4), W0
	CP0	[W0]
	BRA NZ	L__measure_loops1267
	GOTO	L__measure_loops919
L__measure_loops1267:
	MOV	_dev+4, W1
	MOV	#lo_addr(_MARGINTOP), W0
	CP	W1, [W0]
	BRA GT	L__measure_loops1268
	GOTO	L__measure_loops918
L__measure_loops1268:
	MOV	#lo_addr(_line2step), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA NZ	L__measure_loops1269
	GOTO	L__measure_loops917
L__measure_loops1269:
	MOV	#lo_addr(_line2step), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__measure_loops1270
	GOTO	L__measure_loops916
L__measure_loops1270:
	MOV	#lo_addr(_Line_Dir+1), W0
	MOV.B	[W0], W0
	CP.B	W0, #21
	BRA Z	L__measure_loops1271
	GOTO	L__measure_loops915
L__measure_loops1271:
	GOTO	L__measure_loops889
L__measure_loops916:
L__measure_loops915:
	GOTO	L_measure_loops368
L__measure_loops889:
L__measure_loops917:
L__measure_loops888:
;classification.h,295 :: 		onloop2=1;
	BSET	LATE2_bit, BitPos(LATE2_bit+0)
;classification.h,296 :: 		if(timexen[1])
	MOV	#lo_addr(_timexen+1), W0
	CP0.B	[W0]
	BRA NZ	L__measure_loops1272
	GOTO	L_measure_loops369
L__measure_loops1272:
;classification.h,298 :: 		T1[1]=timex[1];
	MOV	_timex+4, W0
	MOV	_timex+6, W1
	MOV	W0, _T1+4
	MOV	W1, _T1+6
;classification.h,299 :: 		line2step=2;
	MOV	#lo_addr(_line2step), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;classification.h,300 :: 		}
	GOTO	L_measure_loops370
L_measure_loops369:
;classification.h,303 :: 		timexen[1]=1;
	MOV	#lo_addr(_timexen+1), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;classification.h,304 :: 		line2step=1;
	MOV	#lo_addr(_line2step), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;classification.h,305 :: 		caldata[3]=freq_mean[3];
	MOV	_freq_mean+12, W0
	MOV	_freq_mean+14, W1
	MOV	W0, _caldata+12
	MOV	W1, _caldata+14
;classification.h,306 :: 		Line_Dir[1]=12;
	MOV	#lo_addr(_Line_Dir+1), W1
	MOV.B	#12, W0
	MOV.B	W0, [W1]
;classification.h,307 :: 		}
L_measure_loops370:
;classification.h,308 :: 		}
	GOTO	L_measure_loops371
L_measure_loops368:
;classification.h,293 :: 		if(!onloop2 && loop[2] && dev[2]>MARGINTOP && ((line2step==0) || (line2step==1 && Line_Dir[1]==21)))
L__measure_loops920:
L__measure_loops919:
L__measure_loops918:
;classification.h,309 :: 		else if(onloop2 && loop[2] && dev[2]<MARGINBOT && ((line2step==2 && Line_Dir[1]==12) || (line2step==3 && Line_Dir[1]==21)))
	BTSS	LATE2_bit, BitPos(LATE2_bit+0)
	GOTO	L__measure_loops927
	MOV	#lo_addr(_loop+4), W0
	CP0	[W0]
	BRA NZ	L__measure_loops1273
	GOTO	L__measure_loops926
L__measure_loops1273:
	MOV	_dev+4, W1
	MOV	#lo_addr(_MARGINBOT), W0
	CP	W1, [W0]
	BRA LT	L__measure_loops1274
	GOTO	L__measure_loops925
L__measure_loops1274:
	MOV	#lo_addr(_line2step), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__measure_loops1275
	GOTO	L__measure_loops922
L__measure_loops1275:
	MOV	#lo_addr(_Line_Dir+1), W0
	MOV.B	[W0], W0
	CP.B	W0, #12
	BRA Z	L__measure_loops1276
	GOTO	L__measure_loops921
L__measure_loops1276:
	GOTO	L__measure_loops885
L__measure_loops922:
L__measure_loops921:
	MOV	#lo_addr(_line2step), W0
	MOV.B	[W0], W0
	CP.B	W0, #3
	BRA Z	L__measure_loops1277
	GOTO	L__measure_loops924
L__measure_loops1277:
	MOV	#lo_addr(_Line_Dir+1), W0
	MOV.B	[W0], W0
	CP.B	W0, #21
	BRA Z	L__measure_loops1278
	GOTO	L__measure_loops923
L__measure_loops1278:
	GOTO	L__measure_loops885
L__measure_loops924:
L__measure_loops923:
	GOTO	L_measure_loops380
L__measure_loops885:
L__measure_loops884:
;classification.h,311 :: 		onloop2=0;
	BCLR	LATE2_bit, BitPos(LATE2_bit+0)
;classification.h,312 :: 		if(T2[1]>0)
	MOV	_T2+4, W0
	MOV	_T2+6, W1
	CP	W0, #0
	CPB	W1, #0
	BRA GT	L__measure_loops1279
	GOTO	L_measure_loops381
L__measure_loops1279:
;classification.h,314 :: 		T3[1]=timex[1];
	MOV	_timex+4, W0
	MOV	_timex+6, W1
	MOV	W0, _T3+4
	MOV	W1, _T3+6
;classification.h,315 :: 		line2step=0;
	MOV	#lo_addr(_line2step), W1
	CLR	W0
	MOV.B	W0, [W1]
;classification.h,316 :: 		caldata[3]=freq_mean[3];
	MOV	_freq_mean+12, W0
	MOV	_freq_mean+14, W1
	MOV	W0, _caldata+12
	MOV	W1, _caldata+14
;classification.h,318 :: 		cal_class1=1;
	MOV	#lo_addr(_cal_class1), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;classification.h,320 :: 		}
	GOTO	L_measure_loops382
L_measure_loops381:
;classification.h,323 :: 		T2[1]=timex[1];
	MOV	_timex+4, W0
	MOV	_timex+6, W1
	MOV	W0, _T2+4
	MOV	W1, _T2+6
;classification.h,324 :: 		line2step=3;
	MOV	#lo_addr(_line2step), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;classification.h,325 :: 		}
L_measure_loops382:
;classification.h,326 :: 		}
	GOTO	L_measure_loops383
L_measure_loops380:
;classification.h,309 :: 		else if(onloop2 && loop[2] && dev[2]<MARGINBOT && ((line2step==2 && Line_Dir[1]==12) || (line2step==3 && Line_Dir[1]==21)))
L__measure_loops927:
L__measure_loops926:
L__measure_loops925:
;classification.h,327 :: 		else if(onloop2 && loop[2] && dev[2]<MARGINBOT)
	BTSS	LATE2_bit, BitPos(LATE2_bit+0)
	GOTO	L__measure_loops930
	MOV	#lo_addr(_loop+4), W0
	CP0	[W0]
	BRA NZ	L__measure_loops1280
	GOTO	L__measure_loops929
L__measure_loops1280:
	MOV	_dev+4, W1
	MOV	#lo_addr(_MARGINBOT), W0
	CP	W1, [W0]
	BRA LT	L__measure_loops1281
	GOTO	L__measure_loops928
L__measure_loops1281:
L__measure_loops883:
;classification.h,329 :: 		reset_class(1);
	MOV.B	#1, W10
	CALL	_reset_class
;classification.h,327 :: 		else if(onloop2 && loop[2] && dev[2]<MARGINBOT)
L__measure_loops930:
L__measure_loops929:
L__measure_loops928:
;classification.h,330 :: 		}
L_measure_loops383:
L_measure_loops371:
;classification.h,332 :: 		if(!onloop1 && loop[1] && dev[1]>MARGINTOP && ((line1step==0) || (line1step==1 && Line_Dir[0]==12)))
	BTSC	LATE1_bit, BitPos(LATE1_bit+0)
	GOTO	L__measure_loops936
	MOV	#lo_addr(_loop+2), W0
	CP0	[W0]
	BRA NZ	L__measure_loops1282
	GOTO	L__measure_loops935
L__measure_loops1282:
	MOV	_dev+2, W1
	MOV	#lo_addr(_MARGINTOP), W0
	CP	W1, [W0]
	BRA GT	L__measure_loops1283
	GOTO	L__measure_loops934
L__measure_loops1283:
	MOV	#lo_addr(_line1step), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA NZ	L__measure_loops1284
	GOTO	L__measure_loops933
L__measure_loops1284:
	MOV	#lo_addr(_line1step), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__measure_loops1285
	GOTO	L__measure_loops932
L__measure_loops1285:
	MOV	#lo_addr(_Line_Dir), W0
	MOV.B	[W0], W0
	CP.B	W0, #12
	BRA Z	L__measure_loops1286
	GOTO	L__measure_loops931
L__measure_loops1286:
	GOTO	L__measure_loops881
L__measure_loops932:
L__measure_loops931:
	GOTO	L_measure_loops393
L__measure_loops881:
L__measure_loops933:
L__measure_loops880:
;classification.h,334 :: 		onloop1=1;
	BSET	LATE1_bit, BitPos(LATE1_bit+0)
;classification.h,335 :: 		if(timexen[0])
	MOV	#lo_addr(_timexen), W0
	CP0.B	[W0]
	BRA NZ	L__measure_loops1287
	GOTO	L_measure_loops394
L__measure_loops1287:
;classification.h,337 :: 		T1[0]=timex[0];
	MOV	_timex, W0
	MOV	_timex+2, W1
	MOV	W0, _T1
	MOV	W1, _T1+2
;classification.h,338 :: 		line1step=2;
	MOV	#lo_addr(_line1step), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;classification.h,339 :: 		}
	GOTO	L_measure_loops395
L_measure_loops394:
;classification.h,342 :: 		timexen[0]=1;
	MOV	#lo_addr(_timexen), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;classification.h,343 :: 		line1step=1;
	MOV	#lo_addr(_line1step), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;classification.h,344 :: 		caldata[0]=freq_mean[0];
	MOV	_freq_mean, W0
	MOV	_freq_mean+2, W1
	MOV	W0, _caldata
	MOV	W1, _caldata+2
;classification.h,345 :: 		Line_Dir[0]=21;
	MOV	#lo_addr(_Line_Dir), W1
	MOV.B	#21, W0
	MOV.B	W0, [W1]
;classification.h,346 :: 		}
L_measure_loops395:
;classification.h,347 :: 		}
	GOTO	L_measure_loops396
L_measure_loops393:
;classification.h,332 :: 		if(!onloop1 && loop[1] && dev[1]>MARGINTOP && ((line1step==0) || (line1step==1 && Line_Dir[0]==12)))
L__measure_loops936:
L__measure_loops935:
L__measure_loops934:
;classification.h,348 :: 		else if(onloop1 && loop[1] && dev[1]<MARGINBOT && ((line1step==3 && Line_Dir[0]==12) || (line1step==2 && Line_Dir[0]==21)))
	BTSS	LATE1_bit, BitPos(LATE1_bit+0)
	GOTO	L__measure_loops943
	MOV	#lo_addr(_loop+2), W0
	CP0	[W0]
	BRA NZ	L__measure_loops1288
	GOTO	L__measure_loops942
L__measure_loops1288:
	MOV	_dev+2, W1
	MOV	#lo_addr(_MARGINBOT), W0
	CP	W1, [W0]
	BRA LT	L__measure_loops1289
	GOTO	L__measure_loops941
L__measure_loops1289:
	MOV	#lo_addr(_line1step), W0
	MOV.B	[W0], W0
	CP.B	W0, #3
	BRA Z	L__measure_loops1290
	GOTO	L__measure_loops938
L__measure_loops1290:
	MOV	#lo_addr(_Line_Dir), W0
	MOV.B	[W0], W0
	CP.B	W0, #12
	BRA Z	L__measure_loops1291
	GOTO	L__measure_loops937
L__measure_loops1291:
	GOTO	L__measure_loops877
L__measure_loops938:
L__measure_loops937:
	MOV	#lo_addr(_line1step), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__measure_loops1292
	GOTO	L__measure_loops940
L__measure_loops1292:
	MOV	#lo_addr(_Line_Dir), W0
	MOV.B	[W0], W0
	CP.B	W0, #21
	BRA Z	L__measure_loops1293
	GOTO	L__measure_loops939
L__measure_loops1293:
	GOTO	L__measure_loops877
L__measure_loops940:
L__measure_loops939:
	GOTO	L_measure_loops405
L__measure_loops877:
L__measure_loops876:
;classification.h,350 :: 		onloop1=0;
	BCLR	LATE1_bit, BitPos(LATE1_bit+0)
;classification.h,351 :: 		if(T2[0]>0)
	MOV	_T2, W0
	MOV	_T2+2, W1
	CP	W0, #0
	CPB	W1, #0
	BRA GT	L__measure_loops1294
	GOTO	L_measure_loops406
L__measure_loops1294:
;classification.h,353 :: 		T3[0]=timex[0];
	MOV	_timex, W0
	MOV	_timex+2, W1
	MOV	W0, _T3
	MOV	W1, _T3+2
;classification.h,354 :: 		line1step=0;
	MOV	#lo_addr(_line1step), W1
	CLR	W0
	MOV.B	W0, [W1]
;classification.h,355 :: 		caldata[0]=freq_mean[0];
	MOV	_freq_mean, W0
	MOV	_freq_mean+2, W1
	MOV	W0, _caldata
	MOV	W1, _caldata+2
;classification.h,357 :: 		cal_class0=1;
	MOV	#lo_addr(_cal_class0), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;classification.h,358 :: 		}
	GOTO	L_measure_loops407
L_measure_loops406:
;classification.h,361 :: 		T2[0]=timex[0];
	MOV	_timex, W0
	MOV	_timex+2, W1
	MOV	W0, _T2
	MOV	W1, _T2+2
;classification.h,362 :: 		line1step=3;
	MOV	#lo_addr(_line1step), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;classification.h,363 :: 		}
L_measure_loops407:
;classification.h,364 :: 		}
	GOTO	L_measure_loops408
L_measure_loops405:
;classification.h,348 :: 		else if(onloop1 && loop[1] && dev[1]<MARGINBOT && ((line1step==3 && Line_Dir[0]==12) || (line1step==2 && Line_Dir[0]==21)))
L__measure_loops943:
L__measure_loops942:
L__measure_loops941:
;classification.h,365 :: 		else if(onloop1 && loop[1] && dev[1]<MARGINBOT)
	BTSS	LATE1_bit, BitPos(LATE1_bit+0)
	GOTO	L__measure_loops946
	MOV	#lo_addr(_loop+2), W0
	CP0	[W0]
	BRA NZ	L__measure_loops1295
	GOTO	L__measure_loops945
L__measure_loops1295:
	MOV	_dev+2, W1
	MOV	#lo_addr(_MARGINBOT), W0
	CP	W1, [W0]
	BRA LT	L__measure_loops1296
	GOTO	L__measure_loops944
L__measure_loops1296:
L__measure_loops875:
;classification.h,367 :: 		reset_class(0);
	CLR	W10
	CALL	_reset_class
;classification.h,365 :: 		else if(onloop1 && loop[1] && dev[1]<MARGINBOT)
L__measure_loops946:
L__measure_loops945:
L__measure_loops944:
;classification.h,368 :: 		}
L_measure_loops408:
L_measure_loops396:
;classification.h,369 :: 		if(!onloop3 && loop[3] && dev[3]>MARGINTOP && ((line2step==0) || (line2step==1 && Line_Dir[1]==12)))
	BTSC	LATE3_bit, BitPos(LATE3_bit+0)
	GOTO	L__measure_loops952
	MOV	#lo_addr(_loop+6), W0
	CP0	[W0]
	BRA NZ	L__measure_loops1297
	GOTO	L__measure_loops951
L__measure_loops1297:
	MOV	_dev+6, W1
	MOV	#lo_addr(_MARGINTOP), W0
	CP	W1, [W0]
	BRA GT	L__measure_loops1298
	GOTO	L__measure_loops950
L__measure_loops1298:
	MOV	#lo_addr(_line2step), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA NZ	L__measure_loops1299
	GOTO	L__measure_loops949
L__measure_loops1299:
	MOV	#lo_addr(_line2step), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__measure_loops1300
	GOTO	L__measure_loops948
L__measure_loops1300:
	MOV	#lo_addr(_Line_Dir+1), W0
	MOV.B	[W0], W0
	CP.B	W0, #12
	BRA Z	L__measure_loops1301
	GOTO	L__measure_loops947
L__measure_loops1301:
	GOTO	L__measure_loops873
L__measure_loops948:
L__measure_loops947:
	GOTO	L_measure_loops418
L__measure_loops873:
L__measure_loops949:
L__measure_loops872:
;classification.h,371 :: 		onloop3=1;
	BSET	LATE3_bit, BitPos(LATE3_bit+0)
;classification.h,372 :: 		if(timexen[1])
	MOV	#lo_addr(_timexen+1), W0
	CP0.B	[W0]
	BRA NZ	L__measure_loops1302
	GOTO	L_measure_loops419
L__measure_loops1302:
;classification.h,374 :: 		T1[1]=timex[1];
	MOV	_timex+4, W0
	MOV	_timex+6, W1
	MOV	W0, _T1+4
	MOV	W1, _T1+6
;classification.h,375 :: 		line2step=2;
	MOV	#lo_addr(_line2step), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;classification.h,376 :: 		}
	GOTO	L_measure_loops420
L_measure_loops419:
;classification.h,379 :: 		timexen[1]=1;
	MOV	#lo_addr(_timexen+1), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;classification.h,380 :: 		line2step=1;
	MOV	#lo_addr(_line2step), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;classification.h,381 :: 		caldata[2]=freq_mean[2];
	MOV	_freq_mean+8, W0
	MOV	_freq_mean+10, W1
	MOV	W0, _caldata+8
	MOV	W1, _caldata+10
;classification.h,382 :: 		Line_Dir[1]=21;
	MOV	#lo_addr(_Line_Dir+1), W1
	MOV.B	#21, W0
	MOV.B	W0, [W1]
;classification.h,383 :: 		}
L_measure_loops420:
;classification.h,384 :: 		}
	GOTO	L_measure_loops421
L_measure_loops418:
;classification.h,369 :: 		if(!onloop3 && loop[3] && dev[3]>MARGINTOP && ((line2step==0) || (line2step==1 && Line_Dir[1]==12)))
L__measure_loops952:
L__measure_loops951:
L__measure_loops950:
;classification.h,385 :: 		else if(onloop3 && loop[3] && dev[3]<MARGINBOT && ((line2step==3 && Line_Dir[1]==12) || (line2step==2 && Line_Dir[1]==21)))
	BTSS	LATE3_bit, BitPos(LATE3_bit+0)
	GOTO	L__measure_loops959
	MOV	#lo_addr(_loop+6), W0
	CP0	[W0]
	BRA NZ	L__measure_loops1303
	GOTO	L__measure_loops958
L__measure_loops1303:
	MOV	_dev+6, W1
	MOV	#lo_addr(_MARGINBOT), W0
	CP	W1, [W0]
	BRA LT	L__measure_loops1304
	GOTO	L__measure_loops957
L__measure_loops1304:
	MOV	#lo_addr(_line2step), W0
	MOV.B	[W0], W0
	CP.B	W0, #3
	BRA Z	L__measure_loops1305
	GOTO	L__measure_loops954
L__measure_loops1305:
	MOV	#lo_addr(_Line_Dir+1), W0
	MOV.B	[W0], W0
	CP.B	W0, #12
	BRA Z	L__measure_loops1306
	GOTO	L__measure_loops953
L__measure_loops1306:
	GOTO	L__measure_loops869
L__measure_loops954:
L__measure_loops953:
	MOV	#lo_addr(_line2step), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__measure_loops1307
	GOTO	L__measure_loops956
L__measure_loops1307:
	MOV	#lo_addr(_Line_Dir+1), W0
	MOV.B	[W0], W0
	CP.B	W0, #21
	BRA Z	L__measure_loops1308
	GOTO	L__measure_loops955
L__measure_loops1308:
	GOTO	L__measure_loops869
L__measure_loops956:
L__measure_loops955:
	GOTO	L_measure_loops430
L__measure_loops869:
L__measure_loops868:
;classification.h,387 :: 		onloop3=0;
	BCLR	LATE3_bit, BitPos(LATE3_bit+0)
;classification.h,388 :: 		if(T2[1]>0)
	MOV	_T2+4, W0
	MOV	_T2+6, W1
	CP	W0, #0
	CPB	W1, #0
	BRA GT	L__measure_loops1309
	GOTO	L_measure_loops431
L__measure_loops1309:
;classification.h,391 :: 		T3[1]=timex[1];
	MOV	_timex+4, W0
	MOV	_timex+6, W1
	MOV	W0, _T3+4
	MOV	W1, _T3+6
;classification.h,393 :: 		line2step=0;
	MOV	#lo_addr(_line2step), W1
	CLR	W0
	MOV.B	W0, [W1]
;classification.h,394 :: 		caldata[2]=freq_mean[2];
	MOV	_freq_mean+8, W0
	MOV	_freq_mean+10, W1
	MOV	W0, _caldata+8
	MOV	W1, _caldata+10
;classification.h,396 :: 		cal_class1=1;
	MOV	#lo_addr(_cal_class1), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;classification.h,397 :: 		}
	GOTO	L_measure_loops432
L_measure_loops431:
;classification.h,400 :: 		T2[1]=timex[1];
	MOV	_timex+4, W0
	MOV	_timex+6, W1
	MOV	W0, _T2+4
	MOV	W1, _T2+6
;classification.h,401 :: 		line2step=3;
	MOV	#lo_addr(_line2step), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;classification.h,402 :: 		}
L_measure_loops432:
;classification.h,403 :: 		}
	GOTO	L_measure_loops433
L_measure_loops430:
;classification.h,385 :: 		else if(onloop3 && loop[3] && dev[3]<MARGINBOT && ((line2step==3 && Line_Dir[1]==12) || (line2step==2 && Line_Dir[1]==21)))
L__measure_loops959:
L__measure_loops958:
L__measure_loops957:
;classification.h,404 :: 		else if(onloop3 && loop[3] && dev[3]<MARGINBOT)
	BTSS	LATE3_bit, BitPos(LATE3_bit+0)
	GOTO	L__measure_loops962
	MOV	#lo_addr(_loop+6), W0
	CP0	[W0]
	BRA NZ	L__measure_loops1310
	GOTO	L__measure_loops961
L__measure_loops1310:
	MOV	_dev+6, W1
	MOV	#lo_addr(_MARGINBOT), W0
	CP	W1, [W0]
	BRA LT	L__measure_loops1311
	GOTO	L__measure_loops960
L__measure_loops1311:
L__measure_loops867:
;classification.h,406 :: 		reset_class(1);
	MOV.B	#1, W10
	CALL	_reset_class
;classification.h,404 :: 		else if(onloop3 && loop[3] && dev[3]<MARGINBOT)
L__measure_loops962:
L__measure_loops961:
L__measure_loops960:
;classification.h,407 :: 		}
L_measure_loops433:
L_measure_loops421:
;classification.h,451 :: 		}
L_end_measure_loops:
	POP	W10
	RETURN
; end of _measure_loops

_TRAP_OSC:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;91-7.c,13 :: 		void TRAP_OSC() org 0x6
;91-7.c,15 :: 		OSCFAIL_bit=0;
	BCLR	OSCFAIL_bit, BitPos(OSCFAIL_bit+0)
;91-7.c,16 :: 		Reset();
	RESET
;91-7.c,17 :: 		}
L_end_TRAP_OSC:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _TRAP_OSC

_TRAP_ADR:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;91-7.c,18 :: 		void TRAP_ADR() org 0x8
;91-7.c,20 :: 		ADDRERR_bit=0;
	BCLR	ADDRERR_bit, BitPos(ADDRERR_bit+0)
;91-7.c,21 :: 		Reset();
	RESET
;91-7.c,22 :: 		}
L_end_TRAP_ADR:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _TRAP_ADR

_TRAP_STK:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;91-7.c,23 :: 		void TRAP_STK() org 0xA
;91-7.c,25 :: 		STKERR_bit=0;
	BCLR	STKERR_bit, BitPos(STKERR_bit+0)
;91-7.c,26 :: 		Reset();
	RESET
;91-7.c,27 :: 		}
L_end_TRAP_STK:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _TRAP_STK

_TRAP_ART:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;91-7.c,28 :: 		void TRAP_ART() org 0xC
;91-7.c,30 :: 		MATHERR_bit=0;
	BCLR	MATHERR_bit, BitPos(MATHERR_bit+0)
;91-7.c,31 :: 		Reset();
	RESET
;91-7.c,32 :: 		}
L_end_TRAP_ART:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _TRAP_ART

_TMR4INT:
	LNK	#8
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;91-7.c,34 :: 		void TMR4INT() iv IVT_ADDR_T4INTERRUPT
;91-7.c,40 :: 		T2CON.TON=0;
	PUSH	W10
	BCLR	T2CON, #15
;91-7.c,41 :: 		if(timexen[0]) timex[0]++;
	MOV	#lo_addr(_timexen), W0
	CP0.B	[W0]
	BRA NZ	L__TMR4INT1317
	GOTO	L_TMR4INT437
L__TMR4INT1317:
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_timex), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
L_TMR4INT437:
;91-7.c,42 :: 		if(timexen[1]) timex[1]++;
	MOV	#lo_addr(_timexen+1), W0
	CP0.B	[W0]
	BRA NZ	L__TMR4INT1318
	GOTO	L_TMR4INT438
L__TMR4INT1318:
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_timex+4), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
L_TMR4INT438:
;91-7.c,44 :: 		if(!docal)
	MOV	#lo_addr(_docal), W0
	CP0.B	[W0]
	BRA Z	L__TMR4INT1319
	GOTO	L_TMR4INT439
L__TMR4INT1319:
;91-7.c,46 :: 		if(current_gap[0]<10000) current_gap[0]++;
	MOV	_current_gap, W1
	MOV	#10000, W0
	CP	W1, W0
	BRA LT	L__TMR4INT1320
	GOTO	L_TMR4INT440
L__TMR4INT1320:
	MOV	#1, W1
	MOV	#lo_addr(_current_gap), W0
	ADD	W1, [W0], [W0]
L_TMR4INT440:
;91-7.c,47 :: 		if(current_gap[1]<10000) current_gap[1]++;
	MOV	_current_gap+2, W1
	MOV	#10000, W0
	CP	W1, W0
	BRA LT	L__TMR4INT1321
	GOTO	L_TMR4INT441
L__TMR4INT1321:
	MOV	#1, W1
	MOV	#lo_addr(_current_gap+2), W0
	ADD	W1, [W0], [W0]
L_TMR4INT441:
;91-7.c,48 :: 		if(onloop0) l1occ++;
	BTSS	LATE0_bit, BitPos(LATE0_bit+0)
	GOTO	L_TMR4INT442
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_l1occ), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
L_TMR4INT442:
;91-7.c,49 :: 		if(onloop1) l1occ++;
	BTSS	LATE1_bit, BitPos(LATE1_bit+0)
	GOTO	L_TMR4INT443
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_l1occ), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
L_TMR4INT443:
;91-7.c,50 :: 		if(onloop2) l2occ++;
	BTSS	LATE2_bit, BitPos(LATE2_bit+0)
	GOTO	L_TMR4INT444
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_l2occ), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
L_TMR4INT444:
;91-7.c,51 :: 		if(onloop3) l2occ++;
	BTSS	LATE3_bit, BitPos(LATE3_bit+0)
	GOTO	L_TMR4INT445
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_l2occ), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
L_TMR4INT445:
;91-7.c,53 :: 		}
L_TMR4INT439:
;91-7.c,54 :: 		loop_error_tmp=0;
	MOV	#lo_addr(_loop_error_tmp), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,55 :: 		capw=0;
	CLR	W0
	CLR	W1
	MOV	W0, _capw
	MOV	W1, _capw+2
;91-7.c,56 :: 		capx=0;
	CLR	W0
	CLR	W1
	MOV	W0, _capx
	MOV	W1, _capx+2
;91-7.c,57 :: 		capy=0;
	CLR	W0
	CLR	W1
	MOV	W0, _capy
	MOV	W1, _capy+2
;91-7.c,58 :: 		capz=0;
	CLR	W0
	CLR	W1
	MOV	W0, _capz
	MOV	W1, _capz+2
;91-7.c,60 :: 		capw=(unsigned long)(IC7BUF);
	MOV	IC7BUF, WREG
	CLR	W1
	MOV	W0, _capw
	MOV	W1, _capw+2
;91-7.c,61 :: 		capw=(unsigned long)(IC7BUF);
	MOV	IC7BUF, WREG
	CLR	W1
	MOV	W0, _capw
	MOV	W1, _capw+2
;91-7.c,62 :: 		if(IC7CON.ICBNE) loop_error_tmp=1;
	BTSS	IC7CON, #3
	GOTO	L_TMR4INT446
	MOV	#lo_addr(_loop_error_tmp), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
L_TMR4INT446:
;91-7.c,63 :: 		capz=(unsigned long)(IC7BUF);
	MOV	IC7BUF, WREG
	CLR	W1
	MOV	W0, _capz
	MOV	W1, _capz+2
;91-7.c,64 :: 		capx=(unsigned long)(IC7BUF);
	MOV	IC7BUF, WREG
	CLR	W1
	MOV	W0, _capx
	MOV	W1, _capx+2
;91-7.c,65 :: 		IC7CON=0;
	CLR	IC7CON
;91-7.c,66 :: 		TMR2=0;
	CLR	TMR2
;91-7.c,67 :: 		if(loop_error_tmp==0)
	MOV	#lo_addr(_loop_error_tmp), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__TMR4INT1322
	GOTO	L_TMR4INT447
L__TMR4INT1322:
;91-7.c,69 :: 		dev[current_loop]=0;
	MOV	#lo_addr(_current_loop), W0
	SE	[W0], W0
	SL	W0, #1, W1
	MOV	#lo_addr(_dev), W0
	ADD	W0, W1, W1
	CLR	W0
	MOV	W0, [W1]
;91-7.c,70 :: 		if(current_loop==0)
	MOV	#lo_addr(_current_loop), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__TMR4INT1323
	GOTO	L_TMR4INT448
L__TMR4INT1323:
;91-7.c,72 :: 		set_error(LP1_ERR);
	MOV	#2, W10
	CALL	_set_error
;91-7.c,73 :: 		}
L_TMR4INT448:
;91-7.c,74 :: 		if(current_loop==1)
	MOV	#lo_addr(_current_loop), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__TMR4INT1324
	GOTO	L_TMR4INT449
L__TMR4INT1324:
;91-7.c,76 :: 		set_error(LP2_ERR);
	MOV	#4, W10
	CALL	_set_error
;91-7.c,77 :: 		}
L_TMR4INT449:
;91-7.c,78 :: 		if(current_loop==2)
	MOV	#lo_addr(_current_loop), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__TMR4INT1325
	GOTO	L_TMR4INT450
L__TMR4INT1325:
;91-7.c,80 :: 		set_error(LP3_ERR);
	MOV	#8, W10
	CALL	_set_error
;91-7.c,81 :: 		}
L_TMR4INT450:
;91-7.c,82 :: 		if(current_loop==3)
	MOV	#lo_addr(_current_loop), W0
	MOV.B	[W0], W0
	CP.B	W0, #3
	BRA Z	L__TMR4INT1326
	GOTO	L_TMR4INT451
L__TMR4INT1326:
;91-7.c,84 :: 		set_error(LP4_ERR);
	MOV	#16, W10
	CALL	_set_error
;91-7.c,85 :: 		}
L_TMR4INT451:
;91-7.c,86 :: 		}
	GOTO	L_TMR4INT452
L_TMR4INT447:
;91-7.c,90 :: 		freq_mean[current_loop]=(capz-capw);
	MOV	#lo_addr(_current_loop), W0
	SE	[W0], W0
	SL	W0, #2, W1
	MOV	#lo_addr(_freq_mean), W0
	ADD	W0, W1, W5
	MOV	_capz, W3
	MOV	_capz+2, W4
	MOV	#lo_addr(_capw), W2
	SUB	W3, [W2++], W0
	SUBB	W4, [W2--], W1
	MOV.D	W0, [W5]
;91-7.c,93 :: 		freq_help=(float)(caldata[current_loop]-freq_mean[current_loop]);
	MOV	#lo_addr(_current_loop), W0
	SE	[W0], W0
	SL	W0, #2, W1
	MOV	#lo_addr(_caldata), W0
	ADD	W0, W1, W4
	MOV	W4, [W14+0]
	MOV	#lo_addr(_freq_mean), W0
	ADD	W0, W1, W0
	MOV.D	[W0], W2
	SUBR	W2, [W4++], W0
	SUBBR	W3, [W4--], W1
	CALL	__Long2Float
	MOV	W0, [W14+4]
	MOV	W1, [W14+6]
	MOV	W0, _freq_help
	MOV	W1, _freq_help+2
;91-7.c,94 :: 		freq_help/=(float)(caldata[current_loop]);
	MOV	[W14+0], W0
	MOV.D	[W0], W0
	CALL	__Long2Float
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	MOV	[W14+4], W0
	MOV	[W14+6], W1
	PUSH.D	W2
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	CALL	__Div_FP
	POP.D	W2
	MOV	W0, _freq_help
	MOV	W1, _freq_help+2
;91-7.c,95 :: 		freq_help*=10000;
	MOV	#16384, W2
	MOV	#17948, W3
	CALL	__Mul_FP
	MOV	W0, _freq_help
	MOV	W1, _freq_help+2
;91-7.c,96 :: 		dev[current_loop]=(int)(freq_help);
	MOV	#lo_addr(_current_loop), W2
	SE	[W2], W2
	SL	W2, #1, W3
	MOV	#lo_addr(_dev), W2
	ADD	W2, W3, W2
	MOV	W2, [W14+0]
	CALL	__Float2Longint
	MOV	[W14+0], W1
	MOV	W0, [W1]
;91-7.c,97 :: 		if(current_loop==0)
	MOV	#lo_addr(_current_loop), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__TMR4INT1327
	GOTO	L_TMR4INT453
L__TMR4INT1327:
;91-7.c,99 :: 		reset_error(LP1_ERR);
	MOV	#2, W10
	CALL	_reset_error
;91-7.c,100 :: 		}
L_TMR4INT453:
;91-7.c,101 :: 		if(current_loop==1)
	MOV	#lo_addr(_current_loop), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__TMR4INT1328
	GOTO	L_TMR4INT454
L__TMR4INT1328:
;91-7.c,103 :: 		reset_error(LP2_ERR);
	MOV	#4, W10
	CALL	_reset_error
;91-7.c,104 :: 		}
L_TMR4INT454:
;91-7.c,105 :: 		if(current_loop==2)
	MOV	#lo_addr(_current_loop), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__TMR4INT1329
	GOTO	L_TMR4INT455
L__TMR4INT1329:
;91-7.c,107 :: 		reset_error(LP3_ERR);
	MOV	#8, W10
	CALL	_reset_error
;91-7.c,108 :: 		}
L_TMR4INT455:
;91-7.c,109 :: 		if(current_loop==3)
	MOV	#lo_addr(_current_loop), W0
	MOV.B	[W0], W0
	CP.B	W0, #3
	BRA Z	L__TMR4INT1330
	GOTO	L_TMR4INT456
L__TMR4INT1330:
;91-7.c,111 :: 		reset_error(LP4_ERR);
	MOV	#16, W10
	CALL	_reset_error
;91-7.c,112 :: 		}
L_TMR4INT456:
;91-7.c,113 :: 		}
L_TMR4INT452:
;91-7.c,114 :: 		do
L_TMR4INT457:
;91-7.c,116 :: 		current_loop++;
	MOV.B	#1, W1
	MOV	#lo_addr(_current_loop), W0
	ADD.B	W1, [W0], [W0]
;91-7.c,117 :: 		if(current_loop==4) current_loop=0;
	MOV	#lo_addr(_current_loop), W0
	MOV.B	[W0], W0
	CP.B	W0, #4
	BRA Z	L__TMR4INT1331
	GOTO	L_TMR4INT460
L__TMR4INT1331:
	MOV	#lo_addr(_current_loop), W1
	CLR	W0
	MOV.B	W0, [W1]
L_TMR4INT460:
;91-7.c,118 :: 		}while(loop[current_loop]==0);
	MOV	#lo_addr(_current_loop), W0
	SE	[W0], W0
	SL	W0, #1, W1
	MOV	#lo_addr(_loop), W0
	ADD	W0, W1, W0
	MOV	[W0], W0
	CP	W0, #0
	BRA NZ	L__TMR4INT1332
	GOTO	L_TMR4INT457
L__TMR4INT1332:
;91-7.c,119 :: 		if(AUTCAL) IC7CON=0x00E5;
	MOV	#lo_addr(_AUTCAL), W0
	CP0	[W0]
	BRA NZ	L__TMR4INT1333
	GOTO	L_TMR4INT461
L__TMR4INT1333:
	MOV	#229, W0
	MOV	WREG, IC7CON
	GOTO	L_TMR4INT462
L_TMR4INT461:
;91-7.c,120 :: 		else IC7CON=0x00E4;
	MOV	#228, W0
	MOV	WREG, IC7CON
L_TMR4INT462:
;91-7.c,121 :: 		LATD=current_loop;
	MOV	#lo_addr(_current_loop), W0
	SE	[W0], W0
	MOV	WREG, LATD
;91-7.c,122 :: 		T2CON.TON=1;
	BSET	T2CON, #15
;91-7.c,123 :: 		if(docal) forth++;
	MOV	#lo_addr(_docal), W0
	CP0.B	[W0]
	BRA NZ	L__TMR4INT1334
	GOTO	L_TMR4INT463
L__TMR4INT1334:
	MOV.B	#1, W1
	MOV	#lo_addr(_forth), W0
	ADD.B	W1, [W0], [W0]
L_TMR4INT463:
;91-7.c,125 :: 		measure_loops();
	CALL	_measure_loops
;91-7.c,127 :: 		how_many_micro++;
	MOV	#1, W1
	MOV	#lo_addr(_how_many_micro), W0
	ADD	W1, [W0], [W0]
;91-7.c,128 :: 		if(how_many_micro==1000)
	MOV	_how_many_micro, W1
	MOV	#1000, W0
	CP	W1, W0
	BRA Z	L__TMR4INT1335
	GOTO	L_TMR4INT464
L__TMR4INT1335:
;91-7.c,130 :: 		milisec=0;
	CLR	W0
	MOV	W0, _milisec
;91-7.c,131 :: 		timer_1_sec=1;
	MOV	#lo_addr(_timer_1_sec), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;91-7.c,133 :: 		if(current_time.second<59) current_time.second++;
	MOV	#lo_addr(_current_time+1), W0
	MOV.B	[W0], W1
	MOV.B	#59, W0
	CP.B	W1, W0
	BRA LTU	L__TMR4INT1336
	GOTO	L_TMR4INT465
L__TMR4INT1336:
	MOV	#lo_addr(_current_time+1), W0
	MOV.B	[W0], W0
	ADD.B	W0, #1, W1
	MOV	#lo_addr(_current_time+1), W0
	MOV.B	W1, [W0]
	GOTO	L_TMR4INT466
L_TMR4INT465:
;91-7.c,136 :: 		current_time.second=0;
	MOV	#lo_addr(_current_time+1), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,137 :: 		if(current_time.minute<59) current_time.minute++;
	MOV	#lo_addr(_current_time+2), W0
	MOV.B	[W0], W1
	MOV.B	#59, W0
	CP.B	W1, W0
	BRA LTU	L__TMR4INT1337
	GOTO	L_TMR4INT467
L__TMR4INT1337:
	MOV	#lo_addr(_current_time+2), W0
	MOV.B	[W0], W0
	ADD.B	W0, #1, W1
	MOV	#lo_addr(_current_time+2), W0
	MOV.B	W1, [W0]
	GOTO	L_TMR4INT468
L_TMR4INT467:
;91-7.c,140 :: 		current_time.minute=0;
	MOV	#lo_addr(_current_time+2), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,141 :: 		if(current_time.hour<23) current_time.hour++;
	MOV	#lo_addr(_current_time+3), W0
	MOV.B	[W0], W0
	CP.B	W0, #23
	BRA LTU	L__TMR4INT1338
	GOTO	L_TMR4INT469
L__TMR4INT1338:
	MOV	#lo_addr(_current_time+3), W0
	MOV.B	[W0], W0
	ADD.B	W0, #1, W1
	MOV	#lo_addr(_current_time+3), W0
	MOV.B	W1, [W0]
	GOTO	L_TMR4INT470
L_TMR4INT469:
;91-7.c,144 :: 		current_time.hour=0;
	MOV	#lo_addr(_current_time+3), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,145 :: 		if(current_time.day<31) current_time.day++;
	MOV	#lo_addr(_current_time+4), W0
	MOV.B	[W0], W0
	CP.B	W0, #31
	BRA LTU	L__TMR4INT1339
	GOTO	L_TMR4INT471
L__TMR4INT1339:
	MOV	#lo_addr(_current_time+4), W0
	MOV.B	[W0], W0
	ADD.B	W0, #1, W1
	MOV	#lo_addr(_current_time+4), W0
	MOV.B	W1, [W0]
	GOTO	L_TMR4INT472
L_TMR4INT471:
;91-7.c,148 :: 		current_time.day=1;
	MOV	#lo_addr(_current_time+4), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;91-7.c,149 :: 		if(current_time.month<12) current_time.month++;
	MOV	#lo_addr(_current_time+5), W0
	MOV.B	[W0], W0
	CP.B	W0, #12
	BRA LTU	L__TMR4INT1340
	GOTO	L_TMR4INT473
L__TMR4INT1340:
	MOV	#lo_addr(_current_time+5), W0
	MOV.B	[W0], W0
	ADD.B	W0, #1, W1
	MOV	#lo_addr(_current_time+5), W0
	MOV.B	W1, [W0]
	GOTO	L_TMR4INT474
L_TMR4INT473:
;91-7.c,152 :: 		current_time.year++;
	MOV	#lo_addr(_current_time+6), W0
	MOV.B	[W0], W0
	ADD.B	W0, #1, W1
	MOV	#lo_addr(_current_time+6), W0
	MOV.B	W1, [W0]
;91-7.c,153 :: 		}
L_TMR4INT474:
;91-7.c,154 :: 		}
L_TMR4INT472:
;91-7.c,155 :: 		}
L_TMR4INT470:
;91-7.c,156 :: 		}
L_TMR4INT468:
;91-7.c,157 :: 		}
L_TMR4INT466:
;91-7.c,158 :: 		how_many_micro=0;
	CLR	W0
	MOV	W0, _how_many_micro
;91-7.c,159 :: 		}
L_TMR4INT464:
;91-7.c,160 :: 		milisec=how_many_micro;
	MOV	_how_many_micro, W0
	MOV	W0, _milisec
;91-7.c,161 :: 		T4IF_bit=0;
	BCLR	T4IF_bit, BitPos(T4IF_bit+0)
;91-7.c,162 :: 		}
L_end_TMR4INT:
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	ULNK
	RETFIE
; end of _TMR4INT

_cal:
	LNK	#2

;91-7.c,163 :: 		void cal()                  //CAlibrate
;91-7.c,166 :: 		docal=1;
	MOV	#lo_addr(_docal), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;91-7.c,167 :: 		longk=0;
	MOV	#lo_addr(_longk), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,168 :: 		for(cal_k=0;cal_k<4;cal_k++)
	MOV	#lo_addr(_cal_k), W1
	CLR	W0
	MOV.B	W0, [W1]
L_cal475:
	MOV	#lo_addr(_cal_k), W0
	MOV.B	[W0], W0
	CP.B	W0, #4
	BRA LTU	L__cal1342
	GOTO	L_cal476
L__cal1342:
;91-7.c,170 :: 		caldata[cal_k]=0;
	MOV	#lo_addr(_cal_k), W0
	ZE	[W0], W0
	SL	W0, #2, W1
	MOV	#lo_addr(_caldata), W0
	ADD	W0, W1, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;91-7.c,171 :: 		calsum[cal_k]=0;
	MOV	#lo_addr(_cal_k), W0
	ZE	[W0], W0
	SL	W0, #2, W1
	MOV	#lo_addr(_calsum), W0
	ADD	W0, W1, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;91-7.c,172 :: 		calpointer[cal_k]=0;
	MOV	#lo_addr(_cal_k), W0
	ZE	[W0], W0
	SL	W0, #1, W1
	MOV	#lo_addr(_calpointer), W0
	ADD	W0, W1, W1
	CLR	W0
	MOV	W0, [W1]
;91-7.c,168 :: 		for(cal_k=0;cal_k<4;cal_k++)
	MOV.B	#1, W1
	MOV	#lo_addr(_cal_k), W0
	ADD.B	W1, [W0], [W0]
;91-7.c,173 :: 		}
	GOTO	L_cal475
L_cal476:
;91-7.c,174 :: 		while(longk<10)
L_cal478:
	MOV	#lo_addr(_longk), W0
	MOV.B	[W0], W0
	CP.B	W0, #10
	BRA LTU	L__cal1343
	GOTO	L_cal479
L__cal1343:
;91-7.c,176 :: 		while(forth<4);
L_cal480:
	MOV	#lo_addr(_forth), W0
	MOV.B	[W0], W0
	CP.B	W0, #4
	BRA LT	L__cal1344
	GOTO	L_cal481
L__cal1344:
	GOTO	L_cal480
L_cal481:
;91-7.c,177 :: 		calsum[0]+=(freq_mean[0]);
	MOV	_freq_mean, W1
	MOV	_freq_mean+2, W2
	MOV	#lo_addr(_calsum), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;91-7.c,178 :: 		calpointer[0]++;
	MOV	#1, W1
	MOV	#lo_addr(_calpointer), W0
	ADD	W1, [W0], [W0]
;91-7.c,179 :: 		calsum[1]+=(freq_mean[1]);
	MOV	_freq_mean+4, W1
	MOV	_freq_mean+6, W2
	MOV	#lo_addr(_calsum+4), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;91-7.c,180 :: 		calpointer[1]++;
	MOV	#1, W1
	MOV	#lo_addr(_calpointer+2), W0
	ADD	W1, [W0], [W0]
;91-7.c,181 :: 		calsum[2]+=(freq_mean[2]);
	MOV	_freq_mean+8, W1
	MOV	_freq_mean+10, W2
	MOV	#lo_addr(_calsum+8), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;91-7.c,182 :: 		calpointer[2]++;
	MOV	#1, W1
	MOV	#lo_addr(_calpointer+4), W0
	ADD	W1, [W0], [W0]
;91-7.c,183 :: 		calsum[3]+=(freq_mean[3]);
	MOV	_freq_mean+12, W1
	MOV	_freq_mean+14, W2
	MOV	#lo_addr(_calsum+12), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;91-7.c,184 :: 		calpointer[3]++;
	MOV	#1, W1
	MOV	#lo_addr(_calpointer+6), W0
	ADD	W1, [W0], [W0]
;91-7.c,185 :: 		forth=0;
	MOV	#lo_addr(_forth), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,186 :: 		longk++;
	MOV.B	#1, W1
	MOV	#lo_addr(_longk), W0
	ADD.B	W1, [W0], [W0]
;91-7.c,187 :: 		delay_ms(100);
	MOV	#8, W8
	MOV	#32716, W7
L_cal482:
	DEC	W7
	BRA NZ	L_cal482
	DEC	W8
	BRA NZ	L_cal482
;91-7.c,188 :: 		}
	GOTO	L_cal478
L_cal479:
;91-7.c,189 :: 		for(cal_k=0;cal_k<4;cal_k++)
	MOV	#lo_addr(_cal_k), W1
	CLR	W0
	MOV.B	W0, [W1]
L_cal484:
	MOV	#lo_addr(_cal_k), W0
	MOV.B	[W0], W0
	CP.B	W0, #4
	BRA LTU	L__cal1345
	GOTO	L_cal485
L__cal1345:
;91-7.c,191 :: 		caldata[cal_k]=(unsigned long)(calsum[cal_k]/(unsigned long)(calpointer[cal_k]));
	MOV	#lo_addr(_cal_k), W0
	ZE	[W0], W0
	SL	W0, #2, W1
	MOV	#lo_addr(_caldata), W0
	ADD	W0, W1, W0
	MOV	W0, [W14+0]
	MOV	#lo_addr(_calsum), W0
	ADD	W0, W1, W0
	MOV.D	[W0], W4
	MOV	#lo_addr(_cal_k), W0
	ZE	[W0], W0
	SL	W0, #1, W1
	MOV	#lo_addr(_calpointer), W0
	ADD	W0, W1, W0
	MOV	[W0], W2
	CLR	W3
	MOV.D	W4, W0
	CLR	W4
	CALL	__Divide_32x32
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;91-7.c,189 :: 		for(cal_k=0;cal_k<4;cal_k++)
	MOV.B	#1, W1
	MOV	#lo_addr(_cal_k), W0
	ADD.B	W1, [W0], [W0]
;91-7.c,192 :: 		}
	GOTO	L_cal484
L_cal485:
;91-7.c,193 :: 		docal=0;
	MOV	#lo_addr(_docal), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,194 :: 		}
L_end_cal:
	ULNK
	RETURN
; end of _cal

_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 52
	MOV	#4, W0
	IOR	68

;91-7.c,195 :: 		void main() {
;91-7.c,197 :: 		NSTDIS_bit=1;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	BSET	NSTDIS_bit, BitPos(NSTDIS_bit+0)
;91-7.c,198 :: 		modem_pwr=1;
	BSET	LATB2_bit, BitPos(LATB2_bit+0)
;91-7.c,199 :: 		PWRKEY=0;
	BCLR	LATB7_bit, BitPos(LATB7_bit+0)
;91-7.c,200 :: 		milisec=0;
	CLR	W0
	MOV	W0, _milisec
;91-7.c,201 :: 		memory_error=1;
	MOV	#lo_addr(_memory_error), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;91-7.c,202 :: 		reset_interval_data();
	CALL	_reset_interval_data
;91-7.c,203 :: 		forth=0;
	MOV	#lo_addr(_forth), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,204 :: 		sim_reset=0;
	MOV	#lo_addr(_sim_reset), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,205 :: 		sim_reset_step=0;
	MOV	#lo_addr(_sim_reset_step), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,206 :: 		sim_reset_timer=0;
	MOV	#lo_addr(_sim_reset_timer), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,207 :: 		ADPCFG=0xFFFC;                             //   Setting Analog Channels
	MOV	#65532, W0
	MOV	WREG, ADPCFG
;91-7.c,208 :: 		PWMCON1=0x0000;
	CLR	PWMCON1
;91-7.c,209 :: 		OVDCON=0x0000;
	CLR	OVDCON
;91-7.c,210 :: 		gprs_timer_en=0;
	MOV	#lo_addr(_gprs_timer_en), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,211 :: 		HMM=eeprom_read(0x7FFCC8);
	MOV	#64712, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _HMM
;91-7.c,213 :: 		tris_init();
	CALL	_tris_init
;91-7.c,215 :: 		l1occ=0;
	CLR	W0
	CLR	W1
	MOV	W0, _l1occ
	MOV	W1, _l1occ+2
;91-7.c,216 :: 		l2occ=0;
	CLR	W0
	CLR	W1
	MOV	W0, _l2occ
	MOV	W1, _l2occ+2
;91-7.c,217 :: 		rtc=0;
	BCLR	LATF0_bit, BitPos(LATF0_bit+0)
;91-7.c,218 :: 		mmc=1;
	BSET	LATF1_bit, BitPos(LATF1_bit+0)
;91-7.c,219 :: 		current_gap[0]=0;
	CLR	W0
	MOV	W0, _current_gap
;91-7.c,220 :: 		current_gap[1]=0;
	CLR	W0
	MOV	W0, _current_gap+2
;91-7.c,221 :: 		mmc_int_send=0;
	MOV	#lo_addr(_mmc_int_send), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,222 :: 		spi_busy=0;
	MOV	#lo_addr(_spi_busy), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,223 :: 		reset_interval();
	CALL	_reset_interval
;91-7.c,224 :: 		IPC0=0x2000;
	MOV	#8192, W0
	MOV	WREG, IPC0
;91-7.c,225 :: 		IPC2=0x0010;
	MOV	#16, W0
	MOV	WREG, IPC2
;91-7.c,226 :: 		IPC4=0x0000;
	CLR	IPC4
;91-7.c,227 :: 		IPC5=0x0070;
	MOV	#112, W0
	MOV	WREG, IPC5
;91-7.c,228 :: 		IPC6=0x0003;
	MOV	#3, W0
	MOV	WREG, IPC6
;91-7.c,229 :: 		debug=0;
	MOV	#lo_addr(_debug), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,230 :: 		send_sms=0;
	MOV	#lo_addr(_send_sms), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,231 :: 		delay_ms(100);
	MOV	#8, W8
	MOV	#32716, W7
L_main487:
	DEC	W7
	BRA NZ	L_main487
	DEC	W8
	BRA NZ	L_main487
;91-7.c,232 :: 		MARGINTOP=eeprom_read(0x7FFC00);
	MOV	#64512, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _MARGINTOP
;91-7.c,233 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main489:
	DEC	W7
	BRA NZ	L_main489
	DEC	W8
	BRA NZ	L_main489
	NOP
	NOP
;91-7.c,234 :: 		MARGINBOT=eeprom_read(0x7FFC04);
	MOV	#64516, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _MARGINBOT
;91-7.c,235 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main491:
	DEC	W7
	BRA NZ	L_main491
	DEC	W8
	BRA NZ	L_main491
	NOP
	NOP
;91-7.c,236 :: 		loop[0]=eeprom_read(0x7FFC08);
	MOV	#64520, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _loop
;91-7.c,237 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main493:
	DEC	W7
	BRA NZ	L_main493
	DEC	W8
	BRA NZ	L_main493
	NOP
	NOP
;91-7.c,238 :: 		loop[1]=eeprom_read(0x7FFC0C);
	MOV	#64524, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _loop+2
;91-7.c,239 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main495:
	DEC	W7
	BRA NZ	L_main495
	DEC	W8
	BRA NZ	L_main495
	NOP
	NOP
;91-7.c,240 :: 		loop[2]=eeprom_read(0x7FFC10);
	MOV	#64528, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _loop+4
;91-7.c,241 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main497:
	DEC	W7
	BRA NZ	L_main497
	DEC	W8
	BRA NZ	L_main497
	NOP
	NOP
;91-7.c,242 :: 		loop[3]=eeprom_read(0x7FFC14);
	MOV	#64532, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _loop+6
;91-7.c,243 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main499:
	DEC	W7
	BRA NZ	L_main499
	DEC	W8
	BRA NZ	L_main499
	NOP
	NOP
;91-7.c,244 :: 		loop_distance=eeprom_read(0x7FFC18);
	MOV	#64536, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _loop_distance
;91-7.c,245 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main501:
	DEC	W7
	BRA NZ	L_main501
	DEC	W8
	BRA NZ	L_main501
	NOP
	NOP
;91-7.c,246 :: 		loop_width=eeprom_read(0x7FFC1C);
	MOV	#64540, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _loop_width
;91-7.c,247 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main503:
	DEC	W7
	BRA NZ	L_main503
	DEC	W8
	BRA NZ	L_main503
	NOP
	NOP
;91-7.c,248 :: 		if(loop_distance<150 || loop_distance>500)
	MOV	#150, W1
	MOV	#lo_addr(_loop_distance), W0
	CP	W1, [W0]
	BRA LE	L__main1347
	GOTO	L__main983
L__main1347:
	MOV	_loop_distance, W1
	MOV	#500, W0
	CP	W1, W0
	BRA LE	L__main1348
	GOTO	L__main982
L__main1348:
	GOTO	L_main507
L__main983:
L__main982:
;91-7.c,250 :: 		if(loop_width==140) loop_distance=200;
	MOV	#140, W1
	MOV	#lo_addr(_loop_width), W0
	CP	W1, [W0]
	BRA Z	L__main1349
	GOTO	L_main508
L__main1349:
	MOV	#200, W0
	MOV	W0, _loop_distance
	GOTO	L_main509
L_main508:
;91-7.c,251 :: 		else loop_distance=400;
	MOV	#400, W0
	MOV	W0, _loop_distance
L_main509:
;91-7.c,252 :: 		}
L_main507:
;91-7.c,253 :: 		apndata=eeprom_read(0x7FFC20);
	MOV	#64544, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _apndata
;91-7.c,254 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main510:
	DEC	W7
	BRA NZ	L_main510
	DEC	W8
	BRA NZ	L_main510
	NOP
	NOP
;91-7.c,255 :: 		ip1=eeprom_read(0x7FFC24);
	MOV	#64548, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _ip1
;91-7.c,256 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main512:
	DEC	W7
	BRA NZ	L_main512
	DEC	W8
	BRA NZ	L_main512
	NOP
	NOP
;91-7.c,257 :: 		ip2=eeprom_read(0x7FFC28);
	MOV	#64552, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _ip2
;91-7.c,258 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main514:
	DEC	W7
	BRA NZ	L_main514
	DEC	W8
	BRA NZ	L_main514
	NOP
	NOP
;91-7.c,259 :: 		ip3=eeprom_read(0x7FFC2C);
	MOV	#64556, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _ip3
;91-7.c,260 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main516:
	DEC	W7
	BRA NZ	L_main516
	DEC	W8
	BRA NZ	L_main516
	NOP
	NOP
;91-7.c,261 :: 		ip4=eeprom_read(0x7FFC30);
	MOV	#64560, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _ip4
;91-7.c,262 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main518:
	DEC	W7
	BRA NZ	L_main518
	DEC	W8
	BRA NZ	L_main518
	NOP
	NOP
;91-7.c,263 :: 		port=eeprom_read(0x7FFC34);
	MOV	#64564, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _port
;91-7.c,264 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main520:
	DEC	W7
	BRA NZ	L_main520
	DEC	W8
	BRA NZ	L_main520
	NOP
	NOP
;91-7.c,267 :: 		DSPEED1=eeprom_read(0x7FFCC0);
	MOV	#64704, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _DSPEED1
;91-7.c,268 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main522:
	DEC	W7
	BRA NZ	L_main522
	DEC	W8
	BRA NZ	L_main522
	NOP
	NOP
;91-7.c,269 :: 		NSPEED1=eeprom_read(0x7FFCC4);
	MOV	#64708, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _NSPEED1
;91-7.c,270 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main524:
	DEC	W7
	BRA NZ	L_main524
	DEC	W8
	BRA NZ	L_main524
	NOP
	NOP
;91-7.c,271 :: 		DSPEED2=eeprom_read(0x7FFCD0);
	MOV	#64720, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _DSPEED2
;91-7.c,272 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main526:
	DEC	W7
	BRA NZ	L_main526
	DEC	W8
	BRA NZ	L_main526
	NOP
	NOP
;91-7.c,273 :: 		NSPEED2=eeprom_read(0x7FFCD4);
	MOV	#64724, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _NSPEED2
;91-7.c,274 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main528:
	DEC	W7
	BRA NZ	L_main528
	DEC	W8
	BRA NZ	L_main528
	NOP
	NOP
;91-7.c,275 :: 		AUTCAL=eeprom_read(0x7FFCCC);
	MOV	#64716, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _AUTCAL
;91-7.c,276 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main530:
	DEC	W7
	BRA NZ	L_main530
	DEC	W8
	BRA NZ	L_main530
	NOP
	NOP
;91-7.c,277 :: 		LIMX=eeprom_read(0x7FFC3C);
	MOV	#64572, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _LIMX
;91-7.c,278 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main532:
	DEC	W7
	BRA NZ	L_main532
	DEC	W8
	BRA NZ	L_main532
	NOP
	NOP
;91-7.c,279 :: 		LIMA=eeprom_read(0x7FFC40);
	MOV	#64576, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _LIMA
;91-7.c,280 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main534:
	DEC	W7
	BRA NZ	L_main534
	DEC	W8
	BRA NZ	L_main534
	NOP
	NOP
;91-7.c,281 :: 		LIMB=eeprom_read(0x7FFC44);
	MOV	#64580, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _LIMB
;91-7.c,282 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main536:
	DEC	W7
	BRA NZ	L_main536
	DEC	W8
	BRA NZ	L_main536
	NOP
	NOP
;91-7.c,283 :: 		LIMC=eeprom_read(0x7FFC48);
	MOV	#64584, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _LIMC
;91-7.c,284 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main538:
	DEC	W7
	BRA NZ	L_main538
	DEC	W8
	BRA NZ	L_main538
	NOP
	NOP
;91-7.c,285 :: 		LIMD=eeprom_read(0x7FFC4C);
	MOV	#64588, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _LIMD
;91-7.c,286 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main540:
	DEC	W7
	BRA NZ	L_main540
	DEC	W8
	BRA NZ	L_main540
	NOP
	NOP
;91-7.c,287 :: 		LIMITE=eeprom_read(0x7FFC50);
	MOV	#64592, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _LIMITE
;91-7.c,288 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main542:
	DEC	W7
	BRA NZ	L_main542
	DEC	W8
	BRA NZ	L_main542
	NOP
	NOP
;91-7.c,289 :: 		PRVAL=eeprom_read(0x7FFC54);
	MOV	#64596, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _PRVAL
;91-7.c,290 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main544:
	DEC	W7
	BRA NZ	L_main544
	DEC	W8
	BRA NZ	L_main544
	NOP
	NOP
;91-7.c,291 :: 		power_type=eeprom_read(0x7FFC58);
	MOV	#64600, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	W0, _power_type
;91-7.c,292 :: 		delay_ms(30);
	MOV	#3, W8
	MOV	#16367, W7
L_main546:
	DEC	W7
	BRA NZ	L_main546
	DEC	W8
	BRA NZ	L_main546
	NOP
	NOP
;91-7.c,293 :: 		sms_number_1[0]=(char)(eeprom_read(0x7FFC60)/256);
	MOV	#64608, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	LSR	W0, #8, W1
	MOV	#lo_addr(_sms_number_1), W0
	MOV.B	W1, [W0]
;91-7.c,294 :: 		delay_ms(3);
	MOV	#14744, W7
L_main548:
	DEC	W7
	BRA NZ	L_main548
;91-7.c,295 :: 		sms_number_1[1]=(char)(eeprom_read(0x7FFC60)%256);
	MOV	#64608, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	#255, W1
	AND	W0, W1, W1
	MOV	#lo_addr(_sms_number_1+1), W0
	MOV.B	W1, [W0]
;91-7.c,296 :: 		delay_ms(3);
	MOV	#14744, W7
L_main550:
	DEC	W7
	BRA NZ	L_main550
;91-7.c,297 :: 		sms_number_1[2]=(char)(eeprom_read(0x7FFC64)/256);
	MOV	#64612, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	LSR	W0, #8, W1
	MOV	#lo_addr(_sms_number_1+2), W0
	MOV.B	W1, [W0]
;91-7.c,298 :: 		delay_ms(3);
	MOV	#14744, W7
L_main552:
	DEC	W7
	BRA NZ	L_main552
;91-7.c,299 :: 		sms_number_1[3]=(char)(eeprom_read(0x7FFC64)%256);
	MOV	#64612, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	#255, W1
	AND	W0, W1, W1
	MOV	#lo_addr(_sms_number_1+3), W0
	MOV.B	W1, [W0]
;91-7.c,300 :: 		delay_ms(3);
	MOV	#14744, W7
L_main554:
	DEC	W7
	BRA NZ	L_main554
;91-7.c,301 :: 		sms_number_1[4]=(char)(eeprom_read(0x7FFC68)/256);
	MOV	#64616, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	LSR	W0, #8, W1
	MOV	#lo_addr(_sms_number_1+4), W0
	MOV.B	W1, [W0]
;91-7.c,302 :: 		delay_ms(3);
	MOV	#14744, W7
L_main556:
	DEC	W7
	BRA NZ	L_main556
;91-7.c,303 :: 		sms_number_1[5]=(char)(eeprom_read(0x7FFC68)%256);
	MOV	#64616, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	#255, W1
	AND	W0, W1, W1
	MOV	#lo_addr(_sms_number_1+5), W0
	MOV.B	W1, [W0]
;91-7.c,304 :: 		delay_ms(3);
	MOV	#14744, W7
L_main558:
	DEC	W7
	BRA NZ	L_main558
;91-7.c,305 :: 		sms_number_1[6]=(char)(eeprom_read(0x7FFC6C)/256);
	MOV	#64620, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	LSR	W0, #8, W1
	MOV	#lo_addr(_sms_number_1+6), W0
	MOV.B	W1, [W0]
;91-7.c,306 :: 		delay_ms(3);
	MOV	#14744, W7
L_main560:
	DEC	W7
	BRA NZ	L_main560
;91-7.c,307 :: 		sms_number_1[7]=(char)(eeprom_read(0x7FFC6C)%256);
	MOV	#64620, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	#255, W1
	AND	W0, W1, W1
	MOV	#lo_addr(_sms_number_1+7), W0
	MOV.B	W1, [W0]
;91-7.c,308 :: 		delay_ms(3);
	MOV	#14744, W7
L_main562:
	DEC	W7
	BRA NZ	L_main562
;91-7.c,309 :: 		sms_number_1[8]=(char)(eeprom_read(0x7FFC70)/256);
	MOV	#64624, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	LSR	W0, #8, W1
	MOV	#lo_addr(_sms_number_1+8), W0
	MOV.B	W1, [W0]
;91-7.c,310 :: 		delay_ms(3);
	MOV	#14744, W7
L_main564:
	DEC	W7
	BRA NZ	L_main564
;91-7.c,311 :: 		sms_number_1[9]=(char)(eeprom_read(0x7FFC70)%256);
	MOV	#64624, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	#255, W1
	AND	W0, W1, W1
	MOV	#lo_addr(_sms_number_1+9), W0
	MOV.B	W1, [W0]
;91-7.c,312 :: 		delay_ms(3);
	MOV	#14744, W7
L_main566:
	DEC	W7
	BRA NZ	L_main566
;91-7.c,313 :: 		sms_number_1[10]=(char)(eeprom_read(0x7FFC74)/256);
	MOV	#64628, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	LSR	W0, #8, W1
	MOV	#lo_addr(_sms_number_1+10), W0
	MOV.B	W1, [W0]
;91-7.c,314 :: 		delay_ms(3);
	MOV	#14744, W7
L_main568:
	DEC	W7
	BRA NZ	L_main568
;91-7.c,316 :: 		location_name[0]=(char)(eeprom_read(0x7FFC80)/256);
	MOV	#64640, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	LSR	W0, #8, W1
	MOV	#lo_addr(_location_name), W0
	MOV.B	W1, [W0]
;91-7.c,317 :: 		delay_ms(3);
	MOV	#14744, W7
L_main570:
	DEC	W7
	BRA NZ	L_main570
;91-7.c,318 :: 		location_name[1]=(char)(eeprom_read(0x7FFC80)%256);
	MOV	#64640, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	#255, W1
	AND	W0, W1, W1
	MOV	#lo_addr(_location_name+1), W0
	MOV.B	W1, [W0]
;91-7.c,319 :: 		delay_ms(3);
	MOV	#14744, W7
L_main572:
	DEC	W7
	BRA NZ	L_main572
;91-7.c,320 :: 		location_name[2]=(char)(eeprom_read(0x7FFC84)/256);
	MOV	#64644, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	LSR	W0, #8, W1
	MOV	#lo_addr(_location_name+2), W0
	MOV.B	W1, [W0]
;91-7.c,321 :: 		delay_ms(3);
	MOV	#14744, W7
L_main574:
	DEC	W7
	BRA NZ	L_main574
;91-7.c,322 :: 		location_name[3]=(char)(eeprom_read(0x7FFC84)%256);
	MOV	#64644, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	#255, W1
	AND	W0, W1, W1
	MOV	#lo_addr(_location_name+3), W0
	MOV.B	W1, [W0]
;91-7.c,323 :: 		delay_ms(3);
	MOV	#14744, W7
L_main576:
	DEC	W7
	BRA NZ	L_main576
;91-7.c,324 :: 		location_name[4]=(char)(eeprom_read(0x7FFC88)/256);
	MOV	#64648, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	LSR	W0, #8, W1
	MOV	#lo_addr(_location_name+4), W0
	MOV.B	W1, [W0]
;91-7.c,325 :: 		delay_ms(3);
	MOV	#14744, W7
L_main578:
	DEC	W7
	BRA NZ	L_main578
;91-7.c,326 :: 		location_name[5]=(char)(eeprom_read(0x7FFC88)%256);
	MOV	#64648, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	#255, W1
	AND	W0, W1, W1
	MOV	#lo_addr(_location_name+5), W0
	MOV.B	W1, [W0]
;91-7.c,327 :: 		delay_ms(3);
	MOV	#14744, W7
L_main580:
	DEC	W7
	BRA NZ	L_main580
;91-7.c,328 :: 		location_name[6]=(char)(eeprom_read(0x7FFC8C)/256);
	MOV	#64652, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	LSR	W0, #8, W1
	MOV	#lo_addr(_location_name+6), W0
	MOV.B	W1, [W0]
;91-7.c,329 :: 		delay_ms(3);
	MOV	#14744, W7
L_main582:
	DEC	W7
	BRA NZ	L_main582
;91-7.c,330 :: 		location_name[7]=(char)(eeprom_read(0x7FFC8C)%256);
	MOV	#64652, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	#255, W1
	AND	W0, W1, W1
	MOV	#lo_addr(_location_name+7), W0
	MOV.B	W1, [W0]
;91-7.c,331 :: 		delay_ms(3);
	MOV	#14744, W7
L_main584:
	DEC	W7
	BRA NZ	L_main584
;91-7.c,332 :: 		location_name[8]=(char)(eeprom_read(0x7FFC90)/256);
	MOV	#64656, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	LSR	W0, #8, W1
	MOV	#lo_addr(_location_name+8), W0
	MOV.B	W1, [W0]
;91-7.c,333 :: 		delay_ms(3);
	MOV	#14744, W7
L_main586:
	DEC	W7
	BRA NZ	L_main586
;91-7.c,334 :: 		location_name[9]=(char)(eeprom_read(0x7FFC90)%256);
	MOV	#64656, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	#255, W1
	AND	W0, W1, W1
	MOV	#lo_addr(_location_name+9), W0
	MOV.B	W1, [W0]
;91-7.c,335 :: 		delay_ms(3);
	MOV	#14744, W7
L_main588:
	DEC	W7
	BRA NZ	L_main588
;91-7.c,336 :: 		location_name[10]=(char)(eeprom_read(0x7FFC94)/256);
	MOV	#64660, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	LSR	W0, #8, W1
	MOV	#lo_addr(_location_name+10), W0
	MOV.B	W1, [W0]
;91-7.c,337 :: 		delay_ms(3);
	MOV	#14744, W7
L_main590:
	DEC	W7
	BRA NZ	L_main590
;91-7.c,338 :: 		location_name[11]=(char)(eeprom_read(0x7FFC94)%256);
	MOV	#64660, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	#255, W1
	AND	W0, W1, W1
	MOV	#lo_addr(_location_name+11), W0
	MOV.B	W1, [W0]
;91-7.c,339 :: 		delay_ms(3);
	MOV	#14744, W7
L_main592:
	DEC	W7
	BRA NZ	L_main592
;91-7.c,340 :: 		location_name[12]=(char)(eeprom_read(0x7FFC98)/256);
	MOV	#64664, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	LSR	W0, #8, W1
	MOV	#lo_addr(_location_name+12), W0
	MOV.B	W1, [W0]
;91-7.c,341 :: 		delay_ms(3);
	MOV	#14744, W7
L_main594:
	DEC	W7
	BRA NZ	L_main594
;91-7.c,342 :: 		location_name[13]=(char)(eeprom_read(0x7FFC98)%256);
	MOV	#64664, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	#255, W1
	AND	W0, W1, W1
	MOV	#lo_addr(_location_name+13), W0
	MOV.B	W1, [W0]
;91-7.c,343 :: 		delay_ms(3);
	MOV	#14744, W7
L_main596:
	DEC	W7
	BRA NZ	L_main596
;91-7.c,344 :: 		location_name[14]=(char)(eeprom_read(0x7FFC9C)/256);
	MOV	#64668, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	LSR	W0, #8, W1
	MOV	#lo_addr(_location_name+14), W0
	MOV.B	W1, [W0]
;91-7.c,345 :: 		delay_ms(3);
	MOV	#14744, W7
L_main598:
	DEC	W7
	BRA NZ	L_main598
;91-7.c,346 :: 		location_name[15]=(char)(eeprom_read(0x7FFC9C)%256);
	MOV	#64668, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	#255, W1
	AND	W0, W1, W1
	MOV	#lo_addr(_location_name+15), W0
	MOV.B	W1, [W0]
;91-7.c,347 :: 		delay_ms(3);
	MOV	#14744, W7
L_main600:
	DEC	W7
	BRA NZ	L_main600
;91-7.c,348 :: 		location_name[16]=(char)(eeprom_read(0x7FFCA0)/256);
	MOV	#64672, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	LSR	W0, #8, W1
	MOV	#lo_addr(_location_name+16), W0
	MOV.B	W1, [W0]
;91-7.c,349 :: 		delay_ms(3);
	MOV	#14744, W7
L_main602:
	DEC	W7
	BRA NZ	L_main602
;91-7.c,350 :: 		location_name[17]=(char)(eeprom_read(0x7FFCA0)%256);
	MOV	#64672, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	#255, W1
	AND	W0, W1, W1
	MOV	#lo_addr(_location_name+17), W0
	MOV.B	W1, [W0]
;91-7.c,351 :: 		delay_ms(3);
	MOV	#14744, W7
L_main604:
	DEC	W7
	BRA NZ	L_main604
;91-7.c,352 :: 		location_name[18]=(char)(eeprom_read(0x7FFCA4)/256);
	MOV	#64676, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	LSR	W0, #8, W1
	MOV	#lo_addr(_location_name+18), W0
	MOV.B	W1, [W0]
;91-7.c,353 :: 		delay_ms(3);
	MOV	#14744, W7
L_main606:
	DEC	W7
	BRA NZ	L_main606
;91-7.c,354 :: 		location_name[19]=(char)(eeprom_read(0x7FFCA4)%256);
	MOV	#64676, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	#255, W1
	AND	W0, W1, W1
	MOV	#lo_addr(_location_name+19), W0
	MOV.B	W1, [W0]
;91-7.c,355 :: 		delay_ms(3);
	MOV	#14744, W7
L_main608:
	DEC	W7
	BRA NZ	L_main608
;91-7.c,356 :: 		location_name[20]=(char)(eeprom_read(0x7FFCA8)/256);
	MOV	#64680, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	LSR	W0, #8, W1
	MOV	#lo_addr(_location_name+20), W0
	MOV.B	W1, [W0]
;91-7.c,357 :: 		delay_ms(3);
	MOV	#14744, W7
L_main610:
	DEC	W7
	BRA NZ	L_main610
;91-7.c,358 :: 		location_name[21]=(char)(eeprom_read(0x7FFCA8)%256);
	MOV	#64680, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	#255, W1
	AND	W0, W1, W1
	MOV	#lo_addr(_location_name+21), W0
	MOV.B	W1, [W0]
;91-7.c,359 :: 		delay_ms(3);
	MOV	#14744, W7
L_main612:
	DEC	W7
	BRA NZ	L_main612
;91-7.c,360 :: 		location_name[22]=(char)(eeprom_read(0x7FFCAC)/256);
	MOV	#64684, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	LSR	W0, #8, W1
	MOV	#lo_addr(_location_name+22), W0
	MOV.B	W1, [W0]
;91-7.c,361 :: 		delay_ms(3);
	MOV	#14744, W7
L_main614:
	DEC	W7
	BRA NZ	L_main614
;91-7.c,362 :: 		location_name[23]=(char)(eeprom_read(0x7FFCAC)%256);
	MOV	#64684, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	#255, W1
	AND	W0, W1, W1
	MOV	#lo_addr(_location_name+23), W0
	MOV.B	W1, [W0]
;91-7.c,363 :: 		delay_ms(3);
	MOV	#14744, W7
L_main616:
	DEC	W7
	BRA NZ	L_main616
;91-7.c,364 :: 		location_name[24]=(char)(eeprom_read(0x7FFCB0)/256);
	MOV	#64688, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	LSR	W0, #8, W1
	MOV	#lo_addr(_location_name+24), W0
	MOV.B	W1, [W0]
;91-7.c,365 :: 		delay_ms(3);
	MOV	#14744, W7
L_main618:
	DEC	W7
	BRA NZ	L_main618
;91-7.c,366 :: 		location_name[25]=(char)(eeprom_read(0x7FFCB0)%256);
	MOV	#64688, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	#255, W1
	AND	W0, W1, W1
	MOV	#lo_addr(_location_name+25), W0
	MOV.B	W1, [W0]
;91-7.c,367 :: 		delay_ms(3);
	MOV	#14744, W7
L_main620:
	DEC	W7
	BRA NZ	L_main620
;91-7.c,368 :: 		location_name[26]=(char)(eeprom_read(0x7FFCB4)/256);
	MOV	#64692, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	LSR	W0, #8, W1
	MOV	#lo_addr(_location_name+26), W0
	MOV.B	W1, [W0]
;91-7.c,369 :: 		delay_ms(3);
	MOV	#14744, W7
L_main622:
	DEC	W7
	BRA NZ	L_main622
;91-7.c,370 :: 		location_name[27]=(char)(eeprom_read(0x7FFCB4)%256);
	MOV	#64692, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	#255, W1
	AND	W0, W1, W1
	MOV	#lo_addr(_location_name+27), W0
	MOV.B	W1, [W0]
;91-7.c,371 :: 		delay_ms(3);
	MOV	#14744, W7
L_main624:
	DEC	W7
	BRA NZ	L_main624
;91-7.c,372 :: 		location_name[28]=(char)(eeprom_read(0x7FFCB8)/256);
	MOV	#64696, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	LSR	W0, #8, W1
	MOV	#lo_addr(_location_name+28), W0
	MOV.B	W1, [W0]
;91-7.c,373 :: 		delay_ms(3);
	MOV	#14744, W7
L_main626:
	DEC	W7
	BRA NZ	L_main626
;91-7.c,374 :: 		location_name[29]=(char)(eeprom_read(0x7FFCB8)%256);
	MOV	#64696, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	#255, W1
	AND	W0, W1, W1
	MOV	#lo_addr(_location_name+29), W0
	MOV.B	W1, [W0]
;91-7.c,375 :: 		delay_ms(3);
	MOV	#14744, W7
L_main628:
	DEC	W7
	BRA NZ	L_main628
;91-7.c,376 :: 		location_name[30]=(char)(eeprom_read(0x7FFCBC)/256);
	MOV	#64700, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	LSR	W0, #8, W1
	MOV	#lo_addr(_location_name+30), W0
	MOV.B	W1, [W0]
;91-7.c,377 :: 		delay_ms(3);
	MOV	#14744, W7
L_main630:
	DEC	W7
	BRA NZ	L_main630
;91-7.c,378 :: 		location_name[31]=(char)(eeprom_read(0x7FFCBC)%256);
	MOV	#64700, W10
	MOV	#127, W11
	CALL	_EEPROM_Read
	MOV	#255, W1
	AND	W0, W1, W1
	MOV	#lo_addr(_location_name+31), W0
	MOV.B	W1, [W0]
;91-7.c,379 :: 		delay_ms(3);
	MOV	#14744, W7
L_main632:
	DEC	W7
	BRA NZ	L_main632
;91-7.c,382 :: 		NVMADR=0xFF00;
	MOV	#65280, W0
	MOV	WREG, NVMADR
;91-7.c,383 :: 		NVMADRU=0x007F;
	MOV	#127, W0
	MOV	WREG, NVMADRU
;91-7.c,385 :: 		timer_1_sec=0;
	MOV	#lo_addr(_timer_1_sec), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,387 :: 		dis_int=0;
	MOV	#lo_addr(_dis_int), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,388 :: 		gsm_ready=0;
	MOV	#lo_addr(_gsm_ready), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,389 :: 		debug_gsm=0;
	MOV	#lo_addr(_debug_gsm), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,390 :: 		line1step=0;
	MOV	#lo_addr(_line1step), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,391 :: 		line2step=0;
	MOV	#lo_addr(_line2step), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,392 :: 		tmrcp_init();
	CALL	_tmrcp_init
;91-7.c,393 :: 		uart_init();
	CALL	_uart_init
;91-7.c,394 :: 		delay_ms(10);
	MOV	#49146, W7
L_main634:
	DEC	W7
	BRA NZ	L_main634
	NOP
	NOP
;91-7.c,395 :: 		ADC1_Init();
	CALL	_ADC1_Init
;91-7.c,396 :: 		delay_ms(10);
	MOV	#49146, W7
L_main636:
	DEC	W7
	BRA NZ	L_main636
	NOP
	NOP
;91-7.c,397 :: 		Clrwdt();
	CLRWDT
;91-7.c,398 :: 		spifat_init();
	CALL	_spifat_init
;91-7.c,399 :: 		Clrwdt();
	CLRWDT
;91-7.c,400 :: 		bytetostr(memory_error,debug_txt);
	MOV	#lo_addr(_debug_txt), W11
	MOV	#lo_addr(_memory_error), W0
	MOV.B	[W0], W10
	CALL	_ByteToStr
;91-7.c,401 :: 		UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
;91-7.c,402 :: 		err_cnt=0;
	MOV	#lo_addr(_err_cnt), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,403 :: 		err_cnt2=0;
	MOV	#lo_addr(_err_cnt2), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,404 :: 		delay_ms(10);
	MOV	#49146, W7
L_main638:
	DEC	W7
	BRA NZ	L_main638
	NOP
	NOP
;91-7.c,405 :: 		rtc_init();
	CALL	_rtc_init
;91-7.c,407 :: 		delay_ms(10);
	MOV	#49146, W7
L_main640:
	DEC	W7
	BRA NZ	L_main640
	NOP
	NOP
;91-7.c,408 :: 		INT0EP_bit=1;
	BSET	INT0EP_bit, BitPos(INT0EP_bit+0)
;91-7.c,409 :: 		INT0IF_bit=0;
	BCLR	INT0IF_bit, BitPos(INT0IF_bit+0)
;91-7.c,410 :: 		INT0IE_bit=0;
	BCLR	INT0IE_bit, BitPos(INT0IE_bit+0)
;91-7.c,411 :: 		status=0;
	BCLR	LATE4_bit, BitPos(LATE4_bit+0)
;91-7.c,412 :: 		charge_control=0;
	BCLR	LATB8_bit, BitPos(LATB8_bit+0)
;91-7.c,413 :: 		onloop0=1;
	BSET	LATE0_bit, BitPos(LATE0_bit+0)
;91-7.c,414 :: 		onloop1=1;
	BSET	LATE1_bit, BitPos(LATE1_bit+0)
;91-7.c,415 :: 		onloop2=1;
	BSET	LATE2_bit, BitPos(LATE2_bit+0)
;91-7.c,416 :: 		onloop3=1;
	BSET	LATE3_bit, BitPos(LATE3_bit+0)
;91-7.c,417 :: 		cal();
	CALL	_cal
;91-7.c,418 :: 		onloop0=0;
	BCLR	LATE0_bit, BitPos(LATE0_bit+0)
;91-7.c,419 :: 		onloop1=0;
	BCLR	LATE1_bit, BitPos(LATE1_bit+0)
;91-7.c,420 :: 		onloop2=0;
	BCLR	LATE2_bit, BitPos(LATE2_bit+0)
;91-7.c,421 :: 		onloop3=0;
	BCLR	LATE3_bit, BitPos(LATE3_bit+0)
;91-7.c,422 :: 		reset_class(0);
	CLR	W10
	CALL	_reset_class
;91-7.c,423 :: 		reset_class(1);
	MOV.B	#1, W10
	CALL	_reset_class
;91-7.c,424 :: 		jj=0;
	CLR	W0
	MOV	W0, _jj
;91-7.c,425 :: 		memory_error_sent=0;
	MOV	#lo_addr(_memory_error_sent), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,426 :: 		memory_ok_sent=1;
	MOV	#lo_addr(_memory_ok_sent), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;91-7.c,427 :: 		connection_state=0;
	BCLR	LATE5_bit, BitPos(LATE5_bit+0)
;91-7.c,428 :: 		gprs_send=0;
	MOV	#lo_addr(_gprs_send), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,432 :: 		RTC_read();
	CALL	_rtc_read
;91-7.c,433 :: 		dis_int=1;
	MOV	#lo_addr(_dis_int), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;91-7.c,434 :: 		sim900_restart();
	CALL	_sim900_restart
;91-7.c,435 :: 		dis_int=0;
	MOV	#lo_addr(_dis_int), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,437 :: 		cal_class0=0;
	MOV	#lo_addr(_cal_class0), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,438 :: 		cal_class1=0;
	MOV	#lo_addr(_cal_class1), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,439 :: 		send_sms=5;
	MOV	#lo_addr(_send_sms), W1
	MOV.B	#5, W0
	MOV.B	W0, [W1]
;91-7.c,440 :: 		while(1)
L_main642:
;91-7.c,442 :: 		asm{PWRSAV #1}
	PWRSAV	#1
;91-7.c,444 :: 		rtc_read();
	CALL	_rtc_read
;91-7.c,447 :: 		if(cal_class0>0)
	MOV	#lo_addr(_cal_class0), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA GTU	L__main1350
	GOTO	L_main644
L__main1350:
;91-7.c,449 :: 		cal_class(0);
	CLR	W10
	CALL	_cal_class
;91-7.c,450 :: 		cal_class0=0;
	MOV	#lo_addr(_cal_class0), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,451 :: 		}
L_main644:
;91-7.c,452 :: 		if(cal_class1>0)
	MOV	#lo_addr(_cal_class1), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA GTU	L__main1351
	GOTO	L_main645
L__main1351:
;91-7.c,454 :: 		cal_class(1);
	MOV.B	#1, W10
	CALL	_cal_class
;91-7.c,455 :: 		cal_class1=0;
	MOV	#lo_addr(_cal_class1), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,456 :: 		}
L_main645:
;91-7.c,457 :: 		for(tmpcnt=0;tmpcnt<4;tmpcnt++)
	MOV	#lo_addr(_tmpcnt), W1
	CLR	W0
	MOV.B	W0, [W1]
L_main646:
	MOV	#lo_addr(_tmpcnt), W0
	MOV.B	[W0], W0
	CP.B	W0, #4
	BRA LT	L__main1352
	GOTO	L_main647
L__main1352:
;91-7.c,459 :: 		if(abs(dev[tmpcnt])<3) cal_timer[tmpcnt]=0;
	MOV	#lo_addr(_tmpcnt), W0
	SE	[W0], W0
	SL	W0, #1, W1
	MOV	#lo_addr(_dev), W0
	ADD	W0, W1, W0
	MOV	[W0], W10
	CALL	_abs
	CP	W0, #3
	BRA LT	L__main1353
	GOTO	L_main649
L__main1353:
	MOV	#lo_addr(_tmpcnt), W0
	SE	[W0], W1
	MOV	#lo_addr(_cal_timer), W0
	ADD	W0, W1, W1
	CLR	W0
	MOV.B	W0, [W1]
L_main649:
;91-7.c,457 :: 		for(tmpcnt=0;tmpcnt<4;tmpcnt++)
	MOV.B	#1, W1
	MOV	#lo_addr(_tmpcnt), W0
	ADD.B	W1, [W0], [W0]
;91-7.c,460 :: 		}
	GOTO	L_main646
L_main647:
;91-7.c,461 :: 		if(uart1_data_received==1)
	MOV	#lo_addr(_uart1_data_received), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__main1354
	GOTO	L_main650
L__main1354:
;91-7.c,463 :: 		function_code=(int)((uart1_data[3]-48))+(int)((uart1_data[2]-48)*10)+(int)((uart1_data[1]-48)*100)+(int)((uart1_data[0]-48)*1000);
	MOV	#lo_addr(_uart1_data+3), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	MOV	W0, W2
	MOV	#lo_addr(_uart1_data+2), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W2
	MOV	#lo_addr(_uart1_data+1), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#100, W0
	MUL.SS	W1, W0, W0
	ADD	W2, W0, W4
	MOV	#lo_addr(_uart1_data), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#1000, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_function_code), W0
	ADD	W4, W2, [W0]
;91-7.c,464 :: 		process_interface();
	CALL	_process_interface
;91-7.c,465 :: 		clear_uart1();
	CALL	_clear_uart1
;91-7.c,466 :: 		}
L_main650:
;91-7.c,467 :: 		if(timer_1_sec==1)
	MOV	#lo_addr(_timer_1_sec), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__main1355
	GOTO	L_main651
L__main1355:
;91-7.c,469 :: 		rtc_read();
	CALL	_rtc_read
;91-7.c,470 :: 		status=!status;
	BTG	LATE4_bit, BitPos(LATE4_bit+0)
;91-7.c,471 :: 		Clrwdt();
	CLRWDT
;91-7.c,472 :: 		if(sim_reset_timer>0) sim_reset_timer=sim_reset_timer-1;
	MOV	#lo_addr(_sim_reset_timer), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA GTU	L__main1356
	GOTO	L_main652
L__main1356:
	MOV.B	#1, W1
	MOV	#lo_addr(_sim_reset_timer), W0
	SUBR.B	W1, [W0], [W0]
L_main652:
;91-7.c,473 :: 		for(tmpcnt=0;tmpcnt<4;tmpcnt++)
	MOV	#lo_addr(_tmpcnt), W1
	CLR	W0
	MOV.B	W0, [W1]
L_main653:
	MOV	#lo_addr(_tmpcnt), W0
	MOV.B	[W0], W0
	CP.B	W0, #4
	BRA LT	L__main1357
	GOTO	L_main654
L__main1357:
;91-7.c,475 :: 		cal_timer[tmpcnt]++;
	MOV	#lo_addr(_tmpcnt), W0
	SE	[W0], W1
	MOV	#lo_addr(_cal_timer), W0
	ADD	W0, W1, W1
	MOV.B	[W1], W0
	ADD.B	W0, #1, [W1]
;91-7.c,476 :: 		if(cal_timer[tmpcnt]>30)
	MOV	#lo_addr(_tmpcnt), W0
	SE	[W0], W1
	MOV	#lo_addr(_cal_timer), W0
	ADD	W0, W1, W0
	MOV.B	[W0], W0
	CP.B	W0, #30
	BRA GTU	L__main1358
	GOTO	L_main656
L__main1358:
;91-7.c,478 :: 		freq_sum_cal=(unsigned long)(caldata[tmpcnt]+freq_mean[tmpcnt]);
	MOV	#lo_addr(_tmpcnt), W0
	SE	[W0], W0
	SL	W0, #2, W1
	MOV	#lo_addr(_caldata), W0
	ADD	W0, W1, W4
	MOV	#lo_addr(_freq_mean), W0
	ADD	W0, W1, W0
	MOV.D	[W0], W2
	ADD	W2, [W4++], W0
	ADDC	W3, [W4--], W1
	MOV	W0, _freq_sum_cal
	MOV	W1, _freq_sum_cal+2
;91-7.c,479 :: 		caldata[tmpcnt]=(unsigned long)(freq_sum_cal/2);
	LSR	W1, W1
	RRC	W0, W0
	MOV.D	W0, [W4]
;91-7.c,480 :: 		}
L_main656:
;91-7.c,473 :: 		for(tmpcnt=0;tmpcnt<4;tmpcnt++)
	MOV.B	#1, W1
	MOV	#lo_addr(_tmpcnt), W0
	ADD.B	W1, [W0], [W0]
;91-7.c,481 :: 		}
	GOTO	L_main653
L_main654:
;91-7.c,482 :: 		if(!onloop0 && !onloop1) reset_class(0);
	BTSC	LATE0_bit, BitPos(LATE0_bit+0)
	GOTO	L__main985
	BTSC	LATE1_bit, BitPos(LATE1_bit+0)
	GOTO	L__main984
L__main980:
	CLR	W10
	CALL	_reset_class
L__main985:
L__main984:
;91-7.c,483 :: 		if(!onloop2 && !onloop3) reset_class(1);
	BTSC	LATE2_bit, BitPos(LATE2_bit+0)
	GOTO	L__main987
	BTSC	LATE3_bit, BitPos(LATE3_bit+0)
	GOTO	L__main986
L__main979:
	MOV.B	#1, W10
	CALL	_reset_class
L__main987:
L__main986:
;91-7.c,484 :: 		if(gprs_send>0) { clear_uart2(); UART2_Write(gprs_send); gprs_send=0; }
	MOV	#lo_addr(_gprs_send), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA GT	L__main1359
	GOTO	L_main663
L__main1359:
	CALL	_clear_uart2
	MOV	#lo_addr(_gprs_send), W0
	SE	[W0], W10
	CALL	_UART2_Write
	MOV	#lo_addr(_gprs_send), W1
	CLR	W0
	MOV.B	W0, [W1]
L_main663:
;91-7.c,485 :: 		if(current_time.second==0)
	MOV	#lo_addr(_current_time+1), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__main1360
	GOTO	L_main664
L__main1360:
;91-7.c,487 :: 		longtostr((vbat*0.388509+7),debug_txt);
	MOV	_vbat, W0
	MOV	_vbat+2, W1
	SETM	W2
	CALL	__Long2Float
	MOV	#60071, W2
	MOV	#16070, W3
	CALL	__Mul_FP
	MOV	#0, W2
	MOV	#16608, W3
	CALL	__AddSub_FP
	CALL	__Float2Longint
	MOV	#lo_addr(_debug_txt), W12
	MOV.D	W0, W10
	CALL	_LongToStr
;91-7.c,488 :: 		if(debug_gsm) UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_gsm), W0
	CP0.B	[W0]
	BRA NZ	L__main1361
	GOTO	L_main665
L__main1361:
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
L_main665:
;91-7.c,489 :: 		if(solar<50)
	MOV	#50, W1
	MOV	#0, W2
	MOV	#lo_addr(_solar), W0
	CP	W1, [W0++]
	CPB	W2, [W0--]
	BRA GT	L__main1362
	GOTO	L_main666
L__main1362:
;91-7.c,490 :: 		longtostr(0,debug_txt);
	MOV	#lo_addr(_debug_txt), W12
	CLR	W10
	CLR	W11
	CALL	_LongToStr
	GOTO	L_main667
L_main666:
;91-7.c,492 :: 		longtostr((solar*0.388509),debug_txt);
	MOV	_solar, W0
	MOV	_solar+2, W1
	SETM	W2
	CALL	__Long2Float
	MOV	#60071, W2
	MOV	#16070, W3
	CALL	__Mul_FP
	CALL	__Float2Longint
	MOV	#lo_addr(_debug_txt), W12
	MOV.D	W0, W10
	CALL	_LongToStr
L_main667:
;91-7.c,493 :: 		if(debug_gsm) UART1_Write_Text(debug_txt);
	MOV	#lo_addr(_debug_gsm), W0
	CP0.B	[W0]
	BRA NZ	L__main1363
	GOTO	L_main668
L__main1363:
	MOV	#lo_addr(_debug_txt), W10
	CALL	_UART1_Write_Text
L_main668:
;91-7.c,494 :: 		if(debug_gsm) UART1_Write(13);
	MOV	#lo_addr(_debug_gsm), W0
	CP0.B	[W0]
	BRA NZ	L__main1364
	GOTO	L_main669
L__main1364:
	MOV	#13, W10
	CALL	_UART1_Write
L_main669:
;91-7.c,495 :: 		if(debug_gsm) UART1_Write(10);
	MOV	#lo_addr(_debug_gsm), W0
	CP0.B	[W0]
	BRA NZ	L__main1365
	GOTO	L_main670
L__main1365:
	MOV	#10, W10
	CALL	_UART1_Write
L_main670:
;91-7.c,496 :: 		if(current_time.minute%INTERVALPERIOD==0)
	MOV	#lo_addr(_current_time+2), W0
	ZE	[W0], W0
	MOV	#5, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	W1, W0
	CP	W0, #0
	BRA Z	L__main1366
	GOTO	L_main671
L__main1366:
;91-7.c,498 :: 		cal_interval();
	CALL	_cal_interval
;91-7.c,499 :: 		interval_data[262]=13;
	MOV	#lo_addr(_interval_data+262), W1
	MOV.B	#13, W0
	MOV.B	W0, [W1]
;91-7.c,500 :: 		interval_data[263]=10;
	MOV	#lo_addr(_interval_data+263), W1
	MOV.B	#10, W0
	MOV.B	W0, [W1]
;91-7.c,501 :: 		if(debug_gsm)
	MOV	#lo_addr(_debug_gsm), W0
	CP0.B	[W0]
	BRA NZ	L__main1367
	GOTO	L_main672
L__main1367:
;91-7.c,502 :: 		for(cal_interval_cnt=0;cal_interval_cnt<264;cal_interval_cnt++)
	CLR	W0
	MOV	W0, _cal_interval_cnt
L_main673:
	MOV	_cal_interval_cnt, W1
	MOV	#264, W0
	CP	W1, W0
	BRA LTU	L__main1368
	GOTO	L_main674
L__main1368:
;91-7.c,504 :: 		UART1_Write(interval_data[cal_interval_cnt]);
	MOV	#lo_addr(_interval_data), W1
	MOV	#lo_addr(_cal_interval_cnt), W0
	ADD	W1, [W0], W0
	ZE	[W0], W10
	CALL	_UART1_Write
;91-7.c,502 :: 		for(cal_interval_cnt=0;cal_interval_cnt<264;cal_interval_cnt++)
	MOV	#1, W1
	MOV	#lo_addr(_cal_interval_cnt), W0
	ADD	W1, [W0], [W0]
;91-7.c,505 :: 		}
	GOTO	L_main673
L_main674:
L_main672:
;91-7.c,506 :: 		mmc_int_send=1;
	MOV	#lo_addr(_mmc_int_send), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;91-7.c,507 :: 		connection_state=0;
	BCLR	LATE5_bit, BitPos(LATE5_bit+0)
;91-7.c,508 :: 		gprs_state=0;
	MOV	#lo_addr(_gprs_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,510 :: 		}
L_main671:
;91-7.c,511 :: 		if(current_time.minute==0 && current_time.hour==0)
	MOV	#lo_addr(_current_time+2), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__main1369
	GOTO	L__main989
L__main1369:
	MOV	#lo_addr(_current_time+3), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__main1370
	GOTO	L__main988
L__main1370:
L__main978:
;91-7.c,513 :: 		sim900_restart();
	CALL	_sim900_restart
;91-7.c,511 :: 		if(current_time.minute==0 && current_time.hour==0)
L__main989:
L__main988:
;91-7.c,516 :: 		}
L_main664:
;91-7.c,517 :: 		if(!mdmstat) sim900_restart();
	BTSC	RB6_bit, BitPos(RB6_bit+0)
	GOTO	L_main679
	CALL	_sim900_restart
L_main679:
;91-7.c,518 :: 		vbat=(long)ADC1_Get_Sample(0);
	CLR	W10
	CALL	_ADC1_Get_Sample
	MOV	W0, W2
	CLR	W3
	MOV	W2, _vbat
	MOV	W3, _vbat+2
;91-7.c,519 :: 		if(vbat<230) set_error(LBT_ERR);
	MOV	#230, W0
	MOV	#0, W1
	CP	W2, W0
	CPB	W3, W1
	BRA LT	L__main1371
	GOTO	L_main680
L__main1371:
	MOV	#128, W10
	CALL	_set_error
	GOTO	L_main681
L_main680:
;91-7.c,520 :: 		else reset_error(LBT_ERR);
	MOV	#128, W10
	CALL	_reset_error
L_main681:
;91-7.c,521 :: 		solar=(long)ADC1_Get_Sample(1);
	MOV	#1, W10
	CALL	_ADC1_Get_Sample
	CLR	W1
	MOV	W0, _solar
	MOV	W1, _solar+2
;91-7.c,522 :: 		if(power_type==0)              //solar power
	MOV	_power_type, W0
	CP	W0, #0
	BRA Z	L__main1372
	GOTO	L_main682
L__main1372:
;91-7.c,524 :: 		if(current_time.hour>10  && current_time.hour<14 && solar<200) set_error(SOL_ERR);
	MOV	#lo_addr(_current_time+3), W0
	MOV.B	[W0], W0
	CP.B	W0, #10
	BRA GTU	L__main1373
	GOTO	L__main992
L__main1373:
	MOV	#lo_addr(_current_time+3), W0
	MOV.B	[W0], W0
	CP.B	W0, #14
	BRA LTU	L__main1374
	GOTO	L__main991
L__main1374:
	MOV	#200, W1
	MOV	#0, W2
	MOV	#lo_addr(_solar), W0
	CP	W1, [W0++]
	CPB	W2, [W0--]
	BRA GT	L__main1375
	GOTO	L__main990
L__main1375:
L__main977:
	MOV	#64, W10
	CALL	_set_error
L__main992:
L__main991:
L__main990:
;91-7.c,525 :: 		if(solar>250) reset_error(SOL_ERR);
	MOV	#250, W1
	MOV	#0, W2
	MOV	#lo_addr(_solar), W0
	CP	W1, [W0++]
	CPB	W2, [W0--]
	BRA LT	L__main1376
	GOTO	L_main686
L__main1376:
	MOV	#64, W10
	CALL	_reset_error
L_main686:
;91-7.c,527 :: 		}
	GOTO	L_main687
L_main682:
;91-7.c,528 :: 		else if(power_type==1)              //night power
	MOV	_power_type, W0
	CP	W0, #1
	BRA Z	L__main1377
	GOTO	L_main688
L__main1377:
;91-7.c,530 :: 		if(current_time.minute==30 && current_time.hour==22 && solar<200) set_error(VMN_ERR);
	MOV	#lo_addr(_current_time+2), W0
	MOV.B	[W0], W0
	CP.B	W0, #30
	BRA Z	L__main1378
	GOTO	L__main995
L__main1378:
	MOV	#lo_addr(_current_time+3), W0
	MOV.B	[W0], W0
	CP.B	W0, #22
	BRA Z	L__main1379
	GOTO	L__main994
L__main1379:
	MOV	#200, W1
	MOV	#0, W2
	MOV	#lo_addr(_solar), W0
	CP	W1, [W0++]
	CPB	W2, [W0--]
	BRA GT	L__main1380
	GOTO	L__main993
L__main1380:
L__main976:
	MOV	#32, W10
	CALL	_set_error
L__main995:
L__main994:
L__main993:
;91-7.c,531 :: 		if(solar>250) reset_error(VMN_ERR);
	MOV	#250, W1
	MOV	#0, W2
	MOV	#lo_addr(_solar), W0
	CP	W1, [W0++]
	CPB	W2, [W0--]
	BRA LT	L__main1381
	GOTO	L_main692
L__main1381:
	MOV	#32, W10
	CALL	_reset_error
L_main692:
;91-7.c,532 :: 		}
	GOTO	L_main693
L_main688:
;91-7.c,533 :: 		else if(power_type==2)              //backup power
	MOV	_power_type, W0
	CP	W0, #2
	BRA Z	L__main1382
	GOTO	L_main694
L__main1382:
;91-7.c,535 :: 		if(solar<200) set_error(VMN_ERR);
	MOV	#200, W1
	MOV	#0, W2
	MOV	#lo_addr(_solar), W0
	CP	W1, [W0++]
	CPB	W2, [W0--]
	BRA GT	L__main1383
	GOTO	L_main695
L__main1383:
	MOV	#32, W10
	CALL	_set_error
L_main695:
;91-7.c,536 :: 		if(solar>250)
	MOV	#250, W1
	MOV	#0, W2
	MOV	#lo_addr(_solar), W0
	CP	W1, [W0++]
	CPB	W2, [W0--]
	BRA LT	L__main1384
	GOTO	L_main696
L__main1384:
;91-7.c,538 :: 		reset_error(VMN_ERR);
	MOV	#32, W10
	CALL	_reset_error
;91-7.c,539 :: 		charge_control=1;
	BSET	LATB8_bit, BitPos(LATB8_bit+0)
;91-7.c,540 :: 		}
L_main696:
;91-7.c,541 :: 		}
L_main694:
L_main693:
L_main687:
;91-7.c,542 :: 		if(gprs_timer_en)
	MOV	#lo_addr(_gprs_timer_en), W0
	CP0.B	[W0]
	BRA NZ	L__main1385
	GOTO	L_main697
L__main1385:
;91-7.c,544 :: 		if(gprs_timer<=gprs_end_timer) gprs_timer++;
	MOV	#lo_addr(_gprs_timer), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_gprs_end_timer), W0
	CP.B	W1, [W0]
	BRA LE	L__main1386
	GOTO	L_main698
L__main1386:
	MOV.B	#1, W1
	MOV	#lo_addr(_gprs_timer), W0
	ADD.B	W1, [W0], [W0]
	GOTO	L_main699
L_main698:
;91-7.c,547 :: 		uart2_data_received=1;
	MOV	#lo_addr(_uart2_data_received), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;91-7.c,548 :: 		err_cnt2++;
	MOV.B	#1, W1
	MOV	#lo_addr(_err_cnt2), W0
	ADD.B	W1, [W0], [W0]
;91-7.c,549 :: 		gprs_timer_en=0;
	MOV	#lo_addr(_gprs_timer_en), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,550 :: 		}
L_main699:
;91-7.c,551 :: 		}
L_main697:
;91-7.c,552 :: 		timer_1_sec=0;
	MOV	#lo_addr(_timer_1_sec), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,553 :: 		if(gsm_ready>0) gsm_ready--;
	MOV	#lo_addr(_gsm_ready), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA GTU	L__main1387
	GOTO	L_main700
L__main1387:
	MOV.B	#1, W1
	MOV	#lo_addr(_gsm_ready), W0
	SUBR.B	W1, [W0], [W0]
L_main700:
;91-7.c,554 :: 		if(is_error(MMC_ERR)) mmc_error=status;
	MOV	#1, W10
	CALL	_is_error
	CP0.B	W0
	BRA NZ	L__main1388
	GOTO	L_main701
L__main1388:
	BTSS	LATE4_bit, BitPos(LATE4_bit+0)
	BCLR	LATB5_bit, BitPos(LATB5_bit+0)
	BTSC	LATE4_bit, BitPos(LATE4_bit+0)
	BSET	LATB5_bit, BitPos(LATB5_bit+0)
	GOTO	L_main702
L_main701:
;91-7.c,555 :: 		else mmc_error=0;
	BCLR	LATB5_bit, BitPos(LATB5_bit+0)
L_main702:
;91-7.c,556 :: 		}
L_main651:
;91-7.c,557 :: 		if(err_cnt>60 || err_cnt2>20)
	MOV	#lo_addr(_err_cnt), W0
	MOV.B	[W0], W1
	MOV.B	#60, W0
	CP.B	W1, W0
	BRA LEU	L__main1389
	GOTO	L__main997
L__main1389:
	MOV	#lo_addr(_err_cnt2), W0
	MOV.B	[W0], W0
	CP.B	W0, #20
	BRA LEU	L__main1390
	GOTO	L__main996
L__main1390:
	GOTO	L_main705
L__main997:
L__main996:
;91-7.c,559 :: 		sim900_restart();
	CALL	_sim900_restart
;91-7.c,560 :: 		err_cnt=0;
	MOV	#lo_addr(_err_cnt), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,561 :: 		err_cnt2=0;
	MOV	#lo_addr(_err_cnt2), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,562 :: 		}
L_main705:
;91-7.c,563 :: 		if(mmc_int_send==1)
	MOV	#lo_addr(_mmc_int_send), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__main1391
	GOTO	L_main706
L__main1391:
;91-7.c,565 :: 		interval_data[262]=13;
	MOV	#lo_addr(_interval_data+262), W1
	MOV.B	#13, W0
	MOV.B	W0, [W1]
;91-7.c,566 :: 		interval_data[263]=10;
	MOV	#lo_addr(_interval_data+263), W1
	MOV.B	#10, W0
	MOV.B	W0, [W1]
;91-7.c,567 :: 		current_sector= 31*24*60*(unsigned long)((interval_data[10]-48)*10+(interval_data[11]-48));
	MOV	#lo_addr(_interval_data+10), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_interval_data+11), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	ADD	W2, W0, W0
	ASR	W0, #15, W1
	MOV	#44640, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	W0, _current_sector
	MOV	W1, _current_sector+2
;91-7.c,568 :: 		current_sector+= 24*60*(unsigned long)((interval_data[12]-48)*10+(interval_data[13]-48));
	MOV	#lo_addr(_interval_data+12), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_interval_data+13), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	ADD	W2, W0, W0
	ASR	W0, #15, W1
	MOV	#1440, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	#lo_addr(_current_sector), W2
	ADD	W0, [W2], [W2++]
	ADDC	W1, [W2], [W2--]
;91-7.c,569 :: 		current_sector+= 60*(unsigned long)((interval_data[14]-48)*10+(interval_data[15]-48));
	MOV	#lo_addr(_interval_data+14), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_interval_data+15), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	ADD	W2, W0, W0
	ASR	W0, #15, W1
	MOV	#60, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	#lo_addr(_current_sector), W2
	ADD	W0, [W2], [W2++]
	ADDC	W1, [W2], [W2--]
;91-7.c,570 :: 		current_sector+= (unsigned long)((interval_data[16]-48)*10+(interval_data[17]-48));
	MOV	#lo_addr(_interval_data+16), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_interval_data+17), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	ADD	W2, W0, W0
	MOV	W0, W3
	ASR	W3, #15, W4
	MOV	#lo_addr(_current_sector), W2
	ADD	W3, [W2++], W0
	ADDC	W4, [W2--], W1
	MOV	W0, _current_sector
	MOV	W1, _current_sector+2
;91-7.c,571 :: 		Mmc_Write_Sector(current_sector, interval_data);
	MOV	#lo_addr(_interval_data), W12
	MOV.D	W0, W10
	CALL	_Mmc_Write_Sector
;91-7.c,572 :: 		mmc_int_send=0;
	MOV	#lo_addr(_mmc_int_send), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,573 :: 		}
L_main706:
;91-7.c,574 :: 		if(debug)
	MOV	#lo_addr(_debug), W0
	CP0.B	[W0]
	BRA NZ	L__main1392
	GOTO	L_main707
L__main1392:
;91-7.c,576 :: 		for(tmpcnt=0;tmpcnt<4;tmpcnt++)
	MOV	#lo_addr(_tmpcnt), W1
	CLR	W0
	MOV.B	W0, [W1]
L_main708:
	MOV	#lo_addr(_tmpcnt), W0
	MOV.B	[W0], W0
	CP.B	W0, #4
	BRA LT	L__main1393
	GOTO	L_main709
L__main1393:
;91-7.c,577 :: 		if(loop[tmpcnt])
	MOV	#lo_addr(_tmpcnt), W0
	SE	[W0], W0
	SL	W0, #1, W1
	MOV	#lo_addr(_loop), W0
	ADD	W0, W1, W0
	MOV	[W0], W0
	CP0	W0
	BRA NZ	L__main1394
	GOTO	L_main711
L__main1394:
;91-7.c,579 :: 		inttostr(dev[tmpcnt],tmp7);
	MOV	#lo_addr(_tmpcnt), W0
	SE	[W0], W0
	SL	W0, #1, W1
	MOV	#lo_addr(_dev), W0
	ADD	W0, W1, W0
	MOV	#lo_addr(_tmp7), W11
	MOV	[W0], W10
	CALL	_IntToStr
;91-7.c,580 :: 		UART1_Write_Text(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_UART1_Write_Text
;91-7.c,585 :: 		}
L_main711:
;91-7.c,576 :: 		for(tmpcnt=0;tmpcnt<4;tmpcnt++)
	MOV.B	#1, W1
	MOV	#lo_addr(_tmpcnt), W0
	ADD.B	W1, [W0], [W0]
;91-7.c,585 :: 		}
	GOTO	L_main708
L_main709:
;91-7.c,586 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;91-7.c,587 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;91-7.c,589 :: 		}
L_main707:
;91-7.c,590 :: 		if(sim_reset==1)
	MOV	#lo_addr(_sim_reset), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__main1395
	GOTO	L_main712
L__main1395:
;91-7.c,592 :: 		if(sim_reset_step==0)
	MOV	#lo_addr(_sim_reset_step), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__main1396
	GOTO	L_main713
L__main1396:
;91-7.c,594 :: 		modem_pwr=1;
	BSET	LATB2_bit, BitPos(LATB2_bit+0)
;91-7.c,595 :: 		sim_reset_timer=5;
	MOV	#lo_addr(_sim_reset_timer), W1
	MOV.B	#5, W0
	MOV.B	W0, [W1]
;91-7.c,596 :: 		sim_reset_step=1;
	MOV	#lo_addr(_sim_reset_step), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;91-7.c,598 :: 		}
	GOTO	L_main714
L_main713:
;91-7.c,599 :: 		else if(sim_reset_timer==0)
	MOV	#lo_addr(_sim_reset_timer), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__main1397
	GOTO	L_main715
L__main1397:
;91-7.c,601 :: 		if(sim_reset_step==1)
	MOV	#lo_addr(_sim_reset_step), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__main1398
	GOTO	L_main716
L__main1398:
;91-7.c,603 :: 		sim_reset_timer=2;
	MOV	#lo_addr(_sim_reset_timer), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;91-7.c,604 :: 		sim_reset_step=2;
	MOV	#lo_addr(_sim_reset_step), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;91-7.c,606 :: 		PWRKEY=0;
	BCLR	LATB7_bit, BitPos(LATB7_bit+0)
;91-7.c,607 :: 		connection_state=0;
	BCLR	LATE5_bit, BitPos(LATE5_bit+0)
;91-7.c,608 :: 		gprs_state=0;
	MOV	#lo_addr(_gprs_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,609 :: 		modem_pwr=0;
	BCLR	LATB2_bit, BitPos(LATB2_bit+0)
;91-7.c,610 :: 		pwrkey=1;
	BSET	LATB7_bit, BitPos(LATB7_bit+0)
;91-7.c,611 :: 		}
	GOTO	L_main717
L_main716:
;91-7.c,612 :: 		else if(sim_reset_step==2)
	MOV	#lo_addr(_sim_reset_step), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__main1399
	GOTO	L_main718
L__main1399:
;91-7.c,614 :: 		sim_reset_timer=15;
	MOV	#lo_addr(_sim_reset_timer), W1
	MOV.B	#15, W0
	MOV.B	W0, [W1]
;91-7.c,615 :: 		sim_reset_step=3;
	MOV	#lo_addr(_sim_reset_step), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;91-7.c,616 :: 		gsm_ready=20;
	MOV	#lo_addr(_gsm_ready), W1
	MOV.B	#20, W0
	MOV.B	W0, [W1]
;91-7.c,617 :: 		pwrkey=0;
	BCLR	LATB7_bit, BitPos(LATB7_bit+0)
;91-7.c,624 :: 		}
	GOTO	L_main719
L_main718:
;91-7.c,625 :: 		else if(sim_reset_step==3)
	MOV	#lo_addr(_sim_reset_step), W0
	MOV.B	[W0], W0
	CP.B	W0, #3
	BRA Z	L__main1400
	GOTO	L_main720
L__main1400:
;91-7.c,627 :: 		sim_reset_timer=1;
	MOV	#lo_addr(_sim_reset_timer), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;91-7.c,628 :: 		sim_reset_step=4;
	MOV	#lo_addr(_sim_reset_step), W1
	MOV.B	#4, W0
	MOV.B	W0, [W1]
;91-7.c,630 :: 		pwrkey=0;
	BCLR	LATB7_bit, BitPos(LATB7_bit+0)
;91-7.c,631 :: 		clear_uart2();
	CALL	_clear_uart2
;91-7.c,632 :: 		UART2_Write('A');
	MOV	#65, W10
	CALL	_UART2_Write
;91-7.c,634 :: 		UART2_Write('T');
	MOV	#84, W10
	CALL	_UART2_Write
;91-7.c,636 :: 		UART2_Write(13);
	MOV	#13, W10
	CALL	_UART2_Write
;91-7.c,637 :: 		}
	GOTO	L_main721
L_main720:
;91-7.c,638 :: 		else if(sim_reset_step==4)
	MOV	#lo_addr(_sim_reset_step), W0
	MOV.B	[W0], W0
	CP.B	W0, #4
	BRA Z	L__main1401
	GOTO	L_main722
L__main1401:
;91-7.c,640 :: 		sim_reset_timer=1;
	MOV	#lo_addr(_sim_reset_timer), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;91-7.c,641 :: 		sim_reset_step=5;
	MOV	#lo_addr(_sim_reset_step), W1
	MOV.B	#5, W0
	MOV.B	W0, [W1]
;91-7.c,643 :: 		send_atc("AT+IPR=115200");
	MOV	#lo_addr(?lstr_33_91_457), W10
	CALL	_send_atc
;91-7.c,644 :: 		UART2_Write(13);
	MOV	#13, W10
	CALL	_UART2_Write
;91-7.c,645 :: 		}
	GOTO	L_main723
L_main722:
;91-7.c,646 :: 		else if(sim_reset_step==5)
	MOV	#lo_addr(_sim_reset_step), W0
	MOV.B	[W0], W0
	CP.B	W0, #5
	BRA Z	L__main1402
	GOTO	L_main724
L__main1402:
;91-7.c,648 :: 		sim_reset_timer=1;
	MOV	#lo_addr(_sim_reset_timer), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;91-7.c,649 :: 		sim_reset_step=6;
	MOV	#lo_addr(_sim_reset_step), W1
	MOV.B	#6, W0
	MOV.B	W0, [W1]
;91-7.c,651 :: 		send_atc("AT+CSCLK=2");
	MOV	#lo_addr(?lstr_34_91_457), W10
	CALL	_send_atc
;91-7.c,652 :: 		UART2_Write(13);
	MOV	#13, W10
	CALL	_UART2_Write
;91-7.c,653 :: 		}
	GOTO	L_main725
L_main724:
;91-7.c,654 :: 		else if(sim_reset_step==6)
	MOV	#lo_addr(_sim_reset_step), W0
	MOV.B	[W0], W0
	CP.B	W0, #6
	BRA Z	L__main1403
	GOTO	L_main726
L__main1403:
;91-7.c,656 :: 		sim_reset_timer=1;
	MOV	#lo_addr(_sim_reset_timer), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;91-7.c,657 :: 		sim_reset_step=7;
	MOV	#lo_addr(_sim_reset_step), W1
	MOV.B	#7, W0
	MOV.B	W0, [W1]
;91-7.c,659 :: 		send_atc("AT&W");
	MOV	#lo_addr(?lstr_35_91_457), W10
	CALL	_send_atc
;91-7.c,660 :: 		UART2_Write(13);
	MOV	#13, W10
	CALL	_UART2_Write
;91-7.c,661 :: 		}
	GOTO	L_main727
L_main726:
;91-7.c,662 :: 		else if(sim_reset_step==7)
	MOV	#lo_addr(_sim_reset_step), W0
	MOV.B	[W0], W0
	CP.B	W0, #7
	BRA Z	L__main1404
	GOTO	L_main728
L__main1404:
;91-7.c,664 :: 		sim_reset_timer=1;
	MOV	#lo_addr(_sim_reset_timer), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;91-7.c,665 :: 		sim_reset_step=8;
	MOV	#lo_addr(_sim_reset_step), W1
	MOV.B	#8, W0
	MOV.B	W0, [W1]
;91-7.c,667 :: 		send_atc(gsm_ate0);
	MOV	#lo_addr(_gsm_ate0), W10
	CALL	_send_atc
;91-7.c,668 :: 		UART2_Write(13);
	MOV	#13, W10
	CALL	_UART2_Write
;91-7.c,669 :: 		}
	GOTO	L_main729
L_main728:
;91-7.c,670 :: 		else if(sim_reset_step==8)
	MOV	#lo_addr(_sim_reset_step), W0
	MOV.B	[W0], W0
	CP.B	W0, #8
	BRA Z	L__main1405
	GOTO	L_main730
L__main1405:
;91-7.c,672 :: 		sim_reset_timer=3;
	MOV	#lo_addr(_sim_reset_timer), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;91-7.c,673 :: 		sim_reset_step=9;
	MOV	#lo_addr(_sim_reset_step), W1
	MOV.B	#9, W0
	MOV.B	W0, [W1]
;91-7.c,675 :: 		send_atc("AT+CMGDA=\"DEL");
	MOV	#lo_addr(?lstr_36_91_457), W10
	CALL	_send_atc
;91-7.c,676 :: 		UART2_Write(' ');
	MOV	#32, W10
	CALL	_UART2_Write
;91-7.c,677 :: 		send_atc("ALL\"");
	MOV	#lo_addr(?lstr_37_91_457), W10
	CALL	_send_atc
;91-7.c,678 :: 		UART2_Write(13);
	MOV	#13, W10
	CALL	_UART2_Write
;91-7.c,679 :: 		}
	GOTO	L_main731
L_main730:
;91-7.c,680 :: 		else if(sim_reset_step==9)
	MOV	#lo_addr(_sim_reset_step), W0
	MOV.B	[W0], W0
	CP.B	W0, #9
	BRA Z	L__main1406
	GOTO	L_main732
L__main1406:
;91-7.c,682 :: 		sim_reset_timer=3;
	MOV	#lo_addr(_sim_reset_timer), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;91-7.c,683 :: 		sim_reset_step=10;
	MOV	#lo_addr(_sim_reset_step), W1
	MOV.B	#10, W0
	MOV.B	W0, [W1]
;91-7.c,685 :: 		send_atc("AT+CGATT=1");
	MOV	#lo_addr(?lstr_38_91_457), W10
	CALL	_send_atc
;91-7.c,686 :: 		UART2_Write(13);
	MOV	#13, W10
	CALL	_UART2_Write
;91-7.c,687 :: 		delay_ms(50);
	MOV	#4, W8
	MOV	#49125, W7
L_main733:
	DEC	W7
	BRA NZ	L_main733
	DEC	W8
	BRA NZ	L_main733
	NOP
;91-7.c,688 :: 		send_atc("AT+CSMP=17,167,0,0");
	MOV	#lo_addr(?lstr_39_91_457), W10
	CALL	_send_atc
;91-7.c,689 :: 		UART2_Write(13);
	MOV	#13, W10
	CALL	_UART2_Write
;91-7.c,690 :: 		}
	GOTO	L_main735
L_main732:
;91-7.c,691 :: 		else if(sim_reset_step==10)
	MOV	#lo_addr(_sim_reset_step), W0
	MOV.B	[W0], W0
	CP.B	W0, #10
	BRA Z	L__main1407
	GOTO	L_main736
L__main1407:
;91-7.c,693 :: 		clear_uart2();
	CALL	_clear_uart2
;91-7.c,694 :: 		connection_state=0;
	BCLR	LATE5_bit, BitPos(LATE5_bit+0)
;91-7.c,695 :: 		gprs_state=0;
	MOV	#lo_addr(_gprs_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,696 :: 		sim_reset=0;
	MOV	#lo_addr(_sim_reset), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,697 :: 		sim_reset_step=0;
	MOV	#lo_addr(_sim_reset_step), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,698 :: 		sim_reset_timer=0;
	MOV	#lo_addr(_sim_reset_timer), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,700 :: 		}
L_main736:
L_main735:
L_main731:
L_main729:
L_main727:
L_main725:
L_main723:
L_main721:
L_main719:
L_main717:
;91-7.c,701 :: 		}
L_main715:
L_main714:
;91-7.c,702 :: 		}
	GOTO	L_main737
L_main712:
;91-7.c,703 :: 		else if(gsm_ready==0)
	MOV	#lo_addr(_gsm_ready), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__main1408
	GOTO	L_main738
L__main1408:
;91-7.c,705 :: 		if(!connection_state)
	BTSC	LATE5_bit, BitPos(LATE5_bit+0)
	GOTO	L_main739
;91-7.c,708 :: 		if(gprs_state==0)     // CIPSHUT
	MOV	#lo_addr(_gprs_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__main1409
	GOTO	L_main740
L__main1409:
;91-7.c,711 :: 		set_gprs_timer(0);
	CLR	W10
	CALL	_set_gprs_timer
;91-7.c,712 :: 		clear_uart2();
	CALL	_clear_uart2
;91-7.c,713 :: 		UART2_Write('A');
	MOV	#65, W10
	CALL	_UART2_Write
;91-7.c,714 :: 		delay_ms(10);
	MOV	#49146, W7
L_main741:
	DEC	W7
	BRA NZ	L_main741
	NOP
	NOP
;91-7.c,715 :: 		send_atc(gsm_cipshut);
	MOV	#lo_addr(_gsm_cipshut), W10
	CALL	_send_atc
;91-7.c,716 :: 		delay_us(50);
	MOV	#245, W7
L_main743:
	DEC	W7
	BRA NZ	L_main743
	NOP
	NOP
;91-7.c,718 :: 		gprs_send=13;
	MOV	#lo_addr(_gprs_send), W1
	MOV.B	#13, W0
	MOV.B	W0, [W1]
;91-7.c,719 :: 		gprs_state=1;
	MOV	#lo_addr(_gprs_state), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;91-7.c,720 :: 		}
	GOTO	L_main745
L_main740:
;91-7.c,721 :: 		else if(uart2_data_received)
	MOV	#lo_addr(_uart2_data_received), W0
	CP0.B	[W0]
	BRA NZ	L__main1410
	GOTO	L_main746
L__main1410:
;91-7.c,723 :: 		gprs_timer_en=0;
	MOV	#lo_addr(_gprs_timer_en), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,724 :: 		uart2_data_received=0;
	MOV	#lo_addr(_uart2_data_received), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,725 :: 		if(gprs_state==1)
	MOV	#lo_addr(_gprs_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__main1411
	GOTO	L_main747
L__main1411:
;91-7.c,728 :: 		if(uart2_data_pointer>1 && uart2_data[uart2_data_pointer-2] == 'O' && uart2_data[uart2_data_pointer-1] == 'K')
	MOV	#lo_addr(_uart2_data_pointer), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA GT	L__main1412
	GOTO	L__main1000
L__main1412:
	MOV	#lo_addr(_uart2_data_pointer), W0
	SE	[W0], W0
	SUB	W0, #2, W1
	MOV	#lo_addr(_uart2_data), W0
	ADD	W0, W1, W0
	MOV.B	[W0], W1
	MOV.B	#79, W0
	CP.B	W1, W0
	BRA Z	L__main1413
	GOTO	L__main999
L__main1413:
	MOV	#lo_addr(_uart2_data_pointer), W0
	SE	[W0], W0
	SUB	W0, #1, W1
	MOV	#lo_addr(_uart2_data), W0
	ADD	W0, W1, W0
	MOV.B	[W0], W1
	MOV.B	#75, W0
	CP.B	W1, W0
	BRA Z	L__main1414
	GOTO	L__main998
L__main1414:
L__main974:
;91-7.c,730 :: 		send_atc(gsm_cstt[apndata]);
	MOV	#100, W1
	MOV	#lo_addr(_apndata), W0
	MUL.UU	W1, [W0], W2
	MOV	#lo_addr(_gsm_cstt), W0
	ADD	W0, W2, W0
	MOV	W0, W10
	CALL	_send_atc
;91-7.c,731 :: 		set_gprs_timer(0);
	CLR	W10
	CALL	_set_gprs_timer
;91-7.c,732 :: 		delay_us(50);
	MOV	#245, W7
L_main751:
	DEC	W7
	BRA NZ	L_main751
	NOP
	NOP
;91-7.c,733 :: 		clear_UART2();
	CALL	_clear_uart2
;91-7.c,734 :: 		gprs_send=13;
	MOV	#lo_addr(_gprs_send), W1
	MOV.B	#13, W0
	MOV.B	W0, [W1]
;91-7.c,735 :: 		gprs_state=2;
	MOV	#lo_addr(_gprs_state), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;91-7.c,737 :: 		}
	GOTO	L_main753
;91-7.c,728 :: 		if(uart2_data_pointer>1 && uart2_data[uart2_data_pointer-2] == 'O' && uart2_data[uart2_data_pointer-1] == 'K')
L__main1000:
L__main999:
L__main998:
;91-7.c,740 :: 		err_cnt++;
	MOV.B	#1, W1
	MOV	#lo_addr(_err_cnt), W0
	ADD.B	W1, [W0], [W0]
;91-7.c,741 :: 		gprs_state=0;
	MOV	#lo_addr(_gprs_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,742 :: 		}
L_main753:
;91-7.c,743 :: 		}
	GOTO	L_main754
L_main747:
;91-7.c,744 :: 		else if(gprs_state==2)
	MOV	#lo_addr(_gprs_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__main1415
	GOTO	L_main755
L__main1415:
;91-7.c,747 :: 		if(uart2_data_pointer>1 && uart2_data[uart2_data_pointer-2] == 'O'  && uart2_data[uart2_data_pointer-1] == 'K')
	MOV	#lo_addr(_uart2_data_pointer), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA GT	L__main1416
	GOTO	L__main1003
L__main1416:
	MOV	#lo_addr(_uart2_data_pointer), W0
	SE	[W0], W0
	SUB	W0, #2, W1
	MOV	#lo_addr(_uart2_data), W0
	ADD	W0, W1, W0
	MOV.B	[W0], W1
	MOV.B	#79, W0
	CP.B	W1, W0
	BRA Z	L__main1417
	GOTO	L__main1002
L__main1417:
	MOV	#lo_addr(_uart2_data_pointer), W0
	SE	[W0], W0
	SUB	W0, #1, W1
	MOV	#lo_addr(_uart2_data), W0
	ADD	W0, W1, W0
	MOV.B	[W0], W1
	MOV.B	#75, W0
	CP.B	W1, W0
	BRA Z	L__main1418
	GOTO	L__main1001
L__main1418:
L__main973:
;91-7.c,749 :: 		send_atc(gsm_ciicr);
	MOV	#lo_addr(_gsm_ciicr), W10
	CALL	_send_atc
;91-7.c,750 :: 		set_gprs_timer(35);
	MOV.B	#35, W10
	CALL	_set_gprs_timer
;91-7.c,751 :: 		delay_us(50);
	MOV	#245, W7
L_main759:
	DEC	W7
	BRA NZ	L_main759
	NOP
	NOP
;91-7.c,752 :: 		clear_UART2();
	CALL	_clear_uart2
;91-7.c,753 :: 		gprs_send=13;
	MOV	#lo_addr(_gprs_send), W1
	MOV.B	#13, W0
	MOV.B	W0, [W1]
;91-7.c,754 :: 		gprs_state=3;
	MOV	#lo_addr(_gprs_state), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;91-7.c,755 :: 		}
	GOTO	L_main761
;91-7.c,747 :: 		if(uart2_data_pointer>1 && uart2_data[uart2_data_pointer-2] == 'O'  && uart2_data[uart2_data_pointer-1] == 'K')
L__main1003:
L__main1002:
L__main1001:
;91-7.c,758 :: 		err_cnt++;
	MOV.B	#1, W1
	MOV	#lo_addr(_err_cnt), W0
	ADD.B	W1, [W0], [W0]
;91-7.c,759 :: 		gprs_state=0;
	MOV	#lo_addr(_gprs_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,760 :: 		}
L_main761:
;91-7.c,761 :: 		}
	GOTO	L_main762
L_main755:
;91-7.c,762 :: 		else if(gprs_state==3)
	MOV	#lo_addr(_gprs_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #3
	BRA Z	L__main1419
	GOTO	L_main763
L__main1419:
;91-7.c,765 :: 		if(uart2_data_pointer>1 && uart2_data[uart2_data_pointer-2] == 'O'  && uart2_data[uart2_data_pointer-1] == 'K')
	MOV	#lo_addr(_uart2_data_pointer), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA GT	L__main1420
	GOTO	L__main1006
L__main1420:
	MOV	#lo_addr(_uart2_data_pointer), W0
	SE	[W0], W0
	SUB	W0, #2, W1
	MOV	#lo_addr(_uart2_data), W0
	ADD	W0, W1, W0
	MOV.B	[W0], W1
	MOV.B	#79, W0
	CP.B	W1, W0
	BRA Z	L__main1421
	GOTO	L__main1005
L__main1421:
	MOV	#lo_addr(_uart2_data_pointer), W0
	SE	[W0], W0
	SUB	W0, #1, W1
	MOV	#lo_addr(_uart2_data), W0
	ADD	W0, W1, W0
	MOV.B	[W0], W1
	MOV.B	#75, W0
	CP.B	W1, W0
	BRA Z	L__main1422
	GOTO	L__main1004
L__main1422:
L__main972:
;91-7.c,767 :: 		send_atc(gsm_cifsr);
	MOV	#lo_addr(_gsm_cifsr), W10
	CALL	_send_atc
;91-7.c,768 :: 		set_gprs_timer(0);
	CLR	W10
	CALL	_set_gprs_timer
;91-7.c,769 :: 		delay_us(50);
	MOV	#245, W7
L_main767:
	DEC	W7
	BRA NZ	L_main767
	NOP
	NOP
;91-7.c,770 :: 		clear_UART2();
	CALL	_clear_uart2
;91-7.c,771 :: 		gprs_send=13;
	MOV	#lo_addr(_gprs_send), W1
	MOV.B	#13, W0
	MOV.B	W0, [W1]
;91-7.c,772 :: 		gprs_state=4;
	MOV	#lo_addr(_gprs_state), W1
	MOV.B	#4, W0
	MOV.B	W0, [W1]
;91-7.c,773 :: 		}
	GOTO	L_main769
;91-7.c,765 :: 		if(uart2_data_pointer>1 && uart2_data[uart2_data_pointer-2] == 'O'  && uart2_data[uart2_data_pointer-1] == 'K')
L__main1006:
L__main1005:
L__main1004:
;91-7.c,776 :: 		err_cnt++;
	MOV.B	#1, W1
	MOV	#lo_addr(_err_cnt), W0
	ADD.B	W1, [W0], [W0]
;91-7.c,777 :: 		gprs_state=0;
	MOV	#lo_addr(_gprs_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,778 :: 		}
L_main769:
;91-7.c,779 :: 		}
	GOTO	L_main770
L_main763:
;91-7.c,780 :: 		else if(gprs_state==4)
	MOV	#lo_addr(_gprs_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #4
	BRA Z	L__main1423
	GOTO	L_main771
L__main1423:
;91-7.c,783 :: 		if(uart2_data_pointer>6)
	MOV	#lo_addr(_uart2_data_pointer), W0
	MOV.B	[W0], W0
	CP.B	W0, #6
	BRA GT	L__main1424
	GOTO	L_main772
L__main1424:
;91-7.c,785 :: 		send_atc(gsm_cipstart);
	MOV	#lo_addr(_gsm_cipstart), W10
	CALL	_send_atc
;91-7.c,787 :: 		inttostr(ip1,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_ip1, W10
	CALL	_IntToStr
;91-7.c,788 :: 		send_atc(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_send_atc
;91-7.c,789 :: 		UART2_Write('.');
	MOV	#46, W10
	CALL	_UART2_Write
;91-7.c,790 :: 		delay_us(5);
	MOV	#24, W7
L_main773:
	DEC	W7
	BRA NZ	L_main773
	NOP
	NOP
;91-7.c,791 :: 		inttostr(ip2,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_ip2, W10
	CALL	_IntToStr
;91-7.c,792 :: 		send_atc(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_send_atc
;91-7.c,793 :: 		UART2_Write('.');
	MOV	#46, W10
	CALL	_UART2_Write
;91-7.c,794 :: 		delay_us(5);
	MOV	#24, W7
L_main775:
	DEC	W7
	BRA NZ	L_main775
	NOP
	NOP
;91-7.c,795 :: 		inttostr(ip3,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_ip3, W10
	CALL	_IntToStr
;91-7.c,796 :: 		send_atc(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_send_atc
;91-7.c,797 :: 		UART2_Write('.');
	MOV	#46, W10
	CALL	_UART2_Write
;91-7.c,798 :: 		delay_us(5);
	MOV	#24, W7
L_main777:
	DEC	W7
	BRA NZ	L_main777
	NOP
	NOP
;91-7.c,799 :: 		inttostr(ip4,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_ip4, W10
	CALL	_IntToStr
;91-7.c,800 :: 		send_atc(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_send_atc
;91-7.c,801 :: 		send_atc("\",");
	MOV	#lo_addr(?lstr_40_91_457), W10
	CALL	_send_atc
;91-7.c,802 :: 		inttostr(port,tmp7);
	MOV	#lo_addr(_tmp7), W11
	MOV	_port, W10
	CALL	_IntToStr
;91-7.c,803 :: 		send_atc(tmp7);
	MOV	#lo_addr(_tmp7), W10
	CALL	_send_atc
;91-7.c,804 :: 		gprs_send=13;
	MOV	#lo_addr(_gprs_send), W1
	MOV.B	#13, W0
	MOV.B	W0, [W1]
;91-7.c,805 :: 		gprs_state=5;
	MOV	#lo_addr(_gprs_state), W1
	MOV.B	#5, W0
	MOV.B	W0, [W1]
;91-7.c,806 :: 		clear_UART2();
	CALL	_clear_uart2
;91-7.c,807 :: 		set_gprs_timer(2);
	MOV.B	#2, W10
	CALL	_set_gprs_timer
;91-7.c,808 :: 		}
	GOTO	L_main779
L_main772:
;91-7.c,811 :: 		err_cnt++;
	MOV.B	#1, W1
	MOV	#lo_addr(_err_cnt), W0
	ADD.B	W1, [W0], [W0]
;91-7.c,812 :: 		gprs_state=0;
	MOV	#lo_addr(_gprs_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,813 :: 		}
L_main779:
;91-7.c,814 :: 		}
	GOTO	L_main780
L_main771:
;91-7.c,815 :: 		else if(gprs_state==5)
	MOV	#lo_addr(_gprs_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #5
	BRA Z	L__main1425
	GOTO	L_main781
L__main1425:
;91-7.c,818 :: 		if(uart2_data_pointer>3 && uart2_data[uart2_data_pointer-4] == 'T' && uart2_data[uart2_data_pointer-2] == 'O' && uart2_data[uart2_data_pointer-1] == 'K')
	MOV	#lo_addr(_uart2_data_pointer), W0
	MOV.B	[W0], W0
	CP.B	W0, #3
	BRA GT	L__main1426
	GOTO	L__main1010
L__main1426:
	MOV	#lo_addr(_uart2_data_pointer), W0
	SE	[W0], W0
	SUB	W0, #4, W1
	MOV	#lo_addr(_uart2_data), W0
	ADD	W0, W1, W0
	MOV.B	[W0], W1
	MOV.B	#84, W0
	CP.B	W1, W0
	BRA Z	L__main1427
	GOTO	L__main1009
L__main1427:
	MOV	#lo_addr(_uart2_data_pointer), W0
	SE	[W0], W0
	SUB	W0, #2, W1
	MOV	#lo_addr(_uart2_data), W0
	ADD	W0, W1, W0
	MOV.B	[W0], W1
	MOV.B	#79, W0
	CP.B	W1, W0
	BRA Z	L__main1428
	GOTO	L__main1008
L__main1428:
	MOV	#lo_addr(_uart2_data_pointer), W0
	SE	[W0], W0
	SUB	W0, #1, W1
	MOV	#lo_addr(_uart2_data), W0
	ADD	W0, W1, W0
	MOV.B	[W0], W1
	MOV.B	#75, W0
	CP.B	W1, W0
	BRA Z	L__main1429
	GOTO	L__main1007
L__main1429:
L__main971:
;91-7.c,820 :: 		connection_state=1;
	BSET	LATE5_bit, BitPos(LATE5_bit+0)
;91-7.c,821 :: 		clear_uart2();
	CALL	_clear_uart2
;91-7.c,822 :: 		gprs_state=0;
	MOV	#lo_addr(_gprs_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,823 :: 		uart2_data_received=1;
	MOV	#lo_addr(_uart2_data_received), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;91-7.c,824 :: 		err_cnt=0;
	MOV	#lo_addr(_err_cnt), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,825 :: 		err_cnt2=0;
	MOV	#lo_addr(_err_cnt2), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,826 :: 		u2func=100;
	MOV	#100, W0
	MOV	W0, _u2func
;91-7.c,827 :: 		}
	GOTO	L_main785
;91-7.c,818 :: 		if(uart2_data_pointer>3 && uart2_data[uart2_data_pointer-4] == 'T' && uart2_data[uart2_data_pointer-2] == 'O' && uart2_data[uart2_data_pointer-1] == 'K')
L__main1010:
L__main1009:
L__main1008:
L__main1007:
;91-7.c,828 :: 		else if(uart2_data_pointer>1 && uart2_data[uart2_data_pointer-2] == 'O' && uart2_data[uart2_data_pointer-1] == 'K')
	MOV	#lo_addr(_uart2_data_pointer), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA GT	L__main1430
	GOTO	L__main1013
L__main1430:
	MOV	#lo_addr(_uart2_data_pointer), W0
	SE	[W0], W0
	SUB	W0, #2, W1
	MOV	#lo_addr(_uart2_data), W0
	ADD	W0, W1, W0
	MOV.B	[W0], W1
	MOV.B	#79, W0
	CP.B	W1, W0
	BRA Z	L__main1431
	GOTO	L__main1012
L__main1431:
	MOV	#lo_addr(_uart2_data_pointer), W0
	SE	[W0], W0
	SUB	W0, #1, W1
	MOV	#lo_addr(_uart2_data), W0
	ADD	W0, W1, W0
	MOV.B	[W0], W1
	MOV.B	#75, W0
	CP.B	W1, W0
	BRA Z	L__main1432
	GOTO	L__main1011
L__main1432:
L__main970:
;91-7.c,830 :: 		clear_UART2();
	CALL	_clear_uart2
;91-7.c,831 :: 		set_gprs_timer(20);
	MOV.B	#20, W10
	CALL	_set_gprs_timer
;91-7.c,832 :: 		}
	GOTO	L_main789
;91-7.c,828 :: 		else if(uart2_data_pointer>1 && uart2_data[uart2_data_pointer-2] == 'O' && uart2_data[uart2_data_pointer-1] == 'K')
L__main1013:
L__main1012:
L__main1011:
;91-7.c,835 :: 		err_cnt++;
	MOV.B	#1, W1
	MOV	#lo_addr(_err_cnt), W0
	ADD.B	W1, [W0], [W0]
;91-7.c,836 :: 		gprs_state=0;
	MOV	#lo_addr(_gprs_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,837 :: 		}
L_main789:
L_main785:
;91-7.c,838 :: 		}
L_main781:
L_main780:
L_main770:
L_main762:
L_main754:
;91-7.c,840 :: 		}
L_main746:
L_main745:
;91-7.c,841 :: 		}
	GOTO	L_main790
L_main739:
;91-7.c,844 :: 		if(uart2_data_received)
	MOV	#lo_addr(_uart2_data_received), W0
	CP0.B	[W0]
	BRA NZ	L__main1433
	GOTO	L_main791
L__main1433:
;91-7.c,846 :: 		uart2_data_received=0;
	MOV	#lo_addr(_uart2_data_received), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,847 :: 		if(uart2_data[0]=='C' && uart2_data[1]=='L' && uart2_data[2]=='O' && uart2_data[3]=='S')
	MOV	#lo_addr(_uart2_data), W0
	MOV.B	[W0], W1
	MOV.B	#67, W0
	CP.B	W1, W0
	BRA Z	L__main1434
	GOTO	L__main1017
L__main1434:
	MOV	#lo_addr(_uart2_data+1), W0
	MOV.B	[W0], W1
	MOV.B	#76, W0
	CP.B	W1, W0
	BRA Z	L__main1435
	GOTO	L__main1016
L__main1435:
	MOV	#lo_addr(_uart2_data+2), W0
	MOV.B	[W0], W1
	MOV.B	#79, W0
	CP.B	W1, W0
	BRA Z	L__main1436
	GOTO	L__main1015
L__main1436:
	MOV	#lo_addr(_uart2_data+3), W0
	MOV.B	[W0], W1
	MOV.B	#83, W0
	CP.B	W1, W0
	BRA Z	L__main1437
	GOTO	L__main1014
L__main1437:
L__main969:
;91-7.c,849 :: 		connection_state=0;
	BCLR	LATE5_bit, BitPos(LATE5_bit+0)
;91-7.c,850 :: 		gprs_state=0;
	MOV	#lo_addr(_gprs_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,851 :: 		}
	GOTO	L_main795
;91-7.c,847 :: 		if(uart2_data[0]=='C' && uart2_data[1]=='L' && uart2_data[2]=='O' && uart2_data[3]=='S')
L__main1017:
L__main1016:
L__main1015:
L__main1014:
;91-7.c,854 :: 		if(gprs_state==0)
	MOV	#lo_addr(_gprs_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__main1438
	GOTO	L_main796
L__main1438:
;91-7.c,856 :: 		if((uart2_data[0]=='0') || u2func==100)
	MOV	#lo_addr(_uart2_data), W0
	MOV.B	[W0], W1
	MOV.B	#48, W0
	CP.B	W1, W0
	BRA NZ	L__main1439
	GOTO	L__main1019
L__main1439:
	MOV	#100, W1
	MOV	#lo_addr(_u2func), W0
	CP	W1, [W0]
	BRA NZ	L__main1440
	GOTO	L__main1018
L__main1440:
	GOTO	L_main799
L__main1019:
L__main1018:
;91-7.c,858 :: 		UART2_Write('A');
	MOV	#65, W10
	CALL	_UART2_Write
;91-7.c,859 :: 		delay_ms(10);
	MOV	#49146, W7
L_main800:
	DEC	W7
	BRA NZ	L_main800
	NOP
	NOP
;91-7.c,860 :: 		send_atc(gsm_cipsend);
	MOV	#lo_addr(_gsm_cipsend), W10
	CALL	_send_atc
;91-7.c,861 :: 		if(u2func==100)
	MOV	#100, W1
	MOV	#lo_addr(_u2func), W0
	CP	W1, [W0]
	BRA Z	L__main1441
	GOTO	L_main802
L__main1441:
;91-7.c,863 :: 		send_atc("59");
	MOV	#lo_addr(?lstr_41_91_457), W10
	CALL	_send_atc
;91-7.c,864 :: 		}
	GOTO	L_main803
L_main802:
;91-7.c,865 :: 		else if(uart2_data[0]=='0' && uart2_data[1]=='1' && uart2_data[2]=='9' && uart2_data[3]=='7')
	MOV	#lo_addr(_uart2_data), W0
	MOV.B	[W0], W1
	MOV.B	#48, W0
	CP.B	W1, W0
	BRA Z	L__main1442
	GOTO	L__main1033
L__main1442:
	MOV	#lo_addr(_uart2_data+1), W0
	MOV.B	[W0], W1
	MOV.B	#49, W0
	CP.B	W1, W0
	BRA Z	L__main1443
	GOTO	L__main1032
L__main1443:
	MOV	#lo_addr(_uart2_data+2), W0
	MOV.B	[W0], W1
	MOV.B	#57, W0
	CP.B	W1, W0
	BRA Z	L__main1444
	GOTO	L__main1031
L__main1444:
	MOV	#lo_addr(_uart2_data+3), W0
	MOV.B	[W0], W1
	MOV.B	#55, W0
	CP.B	W1, W0
	BRA Z	L__main1445
	GOTO	L__main1030
L__main1445:
L__main967:
;91-7.c,867 :: 		u2func=3;
	MOV	#3, W0
	MOV	W0, _u2func
;91-7.c,869 :: 		current_sector= 31*24*60*(unsigned long)((uart2_data[6]-48)*10+(uart2_data[7]-48));
	MOV	#lo_addr(_uart2_data+6), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_uart2_data+7), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	ADD	W2, W0, W0
	ASR	W0, #15, W1
	MOV	#44640, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	W0, _current_sector
	MOV	W1, _current_sector+2
;91-7.c,870 :: 		current_sector+= 24*60*(unsigned long)((uart2_data[8]-48)*10+(uart2_data[9]-48));
	MOV	#lo_addr(_uart2_data+8), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_uart2_data+9), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	ADD	W2, W0, W0
	ASR	W0, #15, W1
	MOV	#1440, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	#lo_addr(_current_sector), W2
	ADD	W0, [W2], [W2++]
	ADDC	W1, [W2], [W2--]
;91-7.c,871 :: 		current_sector+= 60*(unsigned long)((uart2_data[10]-48)*10+(uart2_data[11]-48));
	MOV	#lo_addr(_uart2_data+10), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_uart2_data+11), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	ADD	W2, W0, W0
	ASR	W0, #15, W1
	MOV	#60, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	#lo_addr(_current_sector), W2
	ADD	W0, [W2], [W2++]
	ADDC	W1, [W2], [W2--]
;91-7.c,872 :: 		current_sector+= (unsigned long)((uart2_data[12]-48)*10+(uart2_data[13]-48));
	MOV	#lo_addr(_uart2_data+12), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W1
	MOV	#10, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_uart2_data+13), W0
	ZE	[W0], W1
	MOV	#48, W0
	SUB	W1, W0, W0
	ADD	W2, W0, W0
	MOV	W0, W3
	ASR	W3, #15, W4
	MOV	#lo_addr(_current_sector), W2
	ADD	W3, [W2++], W0
	ADDC	W4, [W2--], W1
	MOV	W0, _current_sector
	MOV	W1, _current_sector+2
;91-7.c,873 :: 		Mmc_Read_Sector(current_sector, interval_data);
	MOV	#lo_addr(_interval_data), W12
	MOV.D	W0, W10
	CALL	_Mmc_Read_Sector
;91-7.c,875 :: 		interval_data[9]!=uart2_data[5] ||
	MOV	#lo_addr(_interval_data+8), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_uart2_data+4), W0
	CP.B	W1, [W0]
	BRA Z	L__main1446
	GOTO	L__main1029
L__main1446:
	MOV	#lo_addr(_interval_data+9), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_uart2_data+5), W0
	CP.B	W1, [W0]
	BRA Z	L__main1447
	GOTO	L__main1028
L__main1447:
;91-7.c,876 :: 		interval_data[10]!=uart2_data[6] ||
	MOV	#lo_addr(_interval_data+10), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_uart2_data+6), W0
	CP.B	W1, [W0]
	BRA Z	L__main1448
	GOTO	L__main1027
L__main1448:
;91-7.c,877 :: 		interval_data[11]!=uart2_data[7] ||
	MOV	#lo_addr(_interval_data+11), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_uart2_data+7), W0
	CP.B	W1, [W0]
	BRA Z	L__main1449
	GOTO	L__main1026
L__main1449:
;91-7.c,878 :: 		interval_data[12]!=uart2_data[8] ||
	MOV	#lo_addr(_interval_data+12), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_uart2_data+8), W0
	CP.B	W1, [W0]
	BRA Z	L__main1450
	GOTO	L__main1025
L__main1450:
;91-7.c,879 :: 		interval_data[13]!=uart2_data[9] ||
	MOV	#lo_addr(_interval_data+13), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_uart2_data+9), W0
	CP.B	W1, [W0]
	BRA Z	L__main1451
	GOTO	L__main1024
L__main1451:
;91-7.c,880 :: 		interval_data[14]!=uart2_data[10] ||
	MOV	#lo_addr(_interval_data+14), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_uart2_data+10), W0
	CP.B	W1, [W0]
	BRA Z	L__main1452
	GOTO	L__main1023
L__main1452:
;91-7.c,881 :: 		interval_data[15]!=uart2_data[11] ||
	MOV	#lo_addr(_interval_data+15), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_uart2_data+11), W0
	CP.B	W1, [W0]
	BRA Z	L__main1453
	GOTO	L__main1022
L__main1453:
;91-7.c,882 :: 		interval_data[16]!=uart2_data[12] ||
	MOV	#lo_addr(_interval_data+16), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_uart2_data+12), W0
	CP.B	W1, [W0]
	BRA Z	L__main1454
	GOTO	L__main1021
L__main1454:
;91-7.c,883 :: 		interval_data[17]!=uart2_data[13])
	MOV	#lo_addr(_interval_data+17), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_uart2_data+13), W0
	CP.B	W1, [W0]
	BRA Z	L__main1455
	GOTO	L__main1020
L__main1455:
	GOTO	L_main809
;91-7.c,875 :: 		interval_data[9]!=uart2_data[5] ||
L__main1029:
L__main1028:
;91-7.c,876 :: 		interval_data[10]!=uart2_data[6] ||
L__main1027:
;91-7.c,877 :: 		interval_data[11]!=uart2_data[7] ||
L__main1026:
;91-7.c,878 :: 		interval_data[12]!=uart2_data[8] ||
L__main1025:
;91-7.c,879 :: 		interval_data[13]!=uart2_data[9] ||
L__main1024:
;91-7.c,880 :: 		interval_data[14]!=uart2_data[10] ||
L__main1023:
;91-7.c,881 :: 		interval_data[15]!=uart2_data[11] ||
L__main1022:
;91-7.c,882 :: 		interval_data[16]!=uart2_data[12] ||
L__main1021:
;91-7.c,883 :: 		interval_data[17]!=uart2_data[13])
L__main1020:
;91-7.c,885 :: 		reset_interval_data();
	CALL	_reset_interval_data
;91-7.c,886 :: 		interval_data[8]=uart2_data[4];
	MOV	#lo_addr(_interval_data+8), W1
	MOV	#lo_addr(_uart2_data+4), W0
	MOV.B	[W0], [W1]
;91-7.c,887 :: 		interval_data[9]=uart2_data[5];
	MOV	#lo_addr(_interval_data+9), W1
	MOV	#lo_addr(_uart2_data+5), W0
	MOV.B	[W0], [W1]
;91-7.c,888 :: 		interval_data[10]=uart2_data[6];
	MOV	#lo_addr(_interval_data+10), W1
	MOV	#lo_addr(_uart2_data+6), W0
	MOV.B	[W0], [W1]
;91-7.c,889 :: 		interval_data[11]=uart2_data[7];
	MOV	#lo_addr(_interval_data+11), W1
	MOV	#lo_addr(_uart2_data+7), W0
	MOV.B	[W0], [W1]
;91-7.c,890 :: 		interval_data[12]=uart2_data[8];
	MOV	#lo_addr(_interval_data+12), W1
	MOV	#lo_addr(_uart2_data+8), W0
	MOV.B	[W0], [W1]
;91-7.c,891 :: 		interval_data[13]=uart2_data[9];
	MOV	#lo_addr(_interval_data+13), W1
	MOV	#lo_addr(_uart2_data+9), W0
	MOV.B	[W0], [W1]
;91-7.c,892 :: 		interval_data[14]=uart2_data[10];
	MOV	#lo_addr(_interval_data+14), W1
	MOV	#lo_addr(_uart2_data+10), W0
	MOV.B	[W0], [W1]
;91-7.c,893 :: 		interval_data[15]=uart2_data[11];
	MOV	#lo_addr(_interval_data+15), W1
	MOV	#lo_addr(_uart2_data+11), W0
	MOV.B	[W0], [W1]
;91-7.c,894 :: 		interval_data[16]=uart2_data[12];
	MOV	#lo_addr(_interval_data+16), W1
	MOV	#lo_addr(_uart2_data+12), W0
	MOV.B	[W0], [W1]
;91-7.c,895 :: 		interval_data[17]=uart2_data[13];
	MOV	#lo_addr(_interval_data+17), W1
	MOV	#lo_addr(_uart2_data+13), W0
	MOV.B	[W0], [W1]
;91-7.c,896 :: 		}
L_main809:
;91-7.c,897 :: 		interval_data[262]=13;
	MOV	#lo_addr(_interval_data+262), W1
	MOV.B	#13, W0
	MOV.B	W0, [W1]
;91-7.c,898 :: 		interval_data[263]=10;
	MOV	#lo_addr(_interval_data+263), W1
	MOV.B	#10, W0
	MOV.B	W0, [W1]
;91-7.c,899 :: 		interval_data[264]=0;
	MOV	#lo_addr(_interval_data+264), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,900 :: 		send_atc("287");
	MOV	#lo_addr(?lstr_42_91_457), W10
	CALL	_send_atc
;91-7.c,901 :: 		}
	GOTO	L_main810
;91-7.c,865 :: 		else if(uart2_data[0]=='0' && uart2_data[1]=='1' && uart2_data[2]=='9' && uart2_data[3]=='7')
L__main1033:
L__main1032:
L__main1031:
L__main1030:
;91-7.c,902 :: 		else if(uart2_data[0]=='0' && uart2_data[1]=='0' && uart2_data[2]=='1' && uart2_data[3]=='2')
	MOV	#lo_addr(_uart2_data), W0
	MOV.B	[W0], W1
	MOV.B	#48, W0
	CP.B	W1, W0
	BRA Z	L__main1456
	GOTO	L__main1037
L__main1456:
	MOV	#lo_addr(_uart2_data+1), W0
	MOV.B	[W0], W1
	MOV.B	#48, W0
	CP.B	W1, W0
	BRA Z	L__main1457
	GOTO	L__main1036
L__main1457:
	MOV	#lo_addr(_uart2_data+2), W0
	MOV.B	[W0], W1
	MOV.B	#49, W0
	CP.B	W1, W0
	BRA Z	L__main1458
	GOTO	L__main1035
L__main1458:
	MOV	#lo_addr(_uart2_data+3), W0
	MOV.B	[W0], W1
	MOV.B	#50, W0
	CP.B	W1, W0
	BRA Z	L__main1459
	GOTO	L__main1034
L__main1459:
L__main965:
;91-7.c,904 :: 		rtc_write(2);
	MOV.B	#2, W10
	CALL	_rtc_write
;91-7.c,905 :: 		rtc_read();
	CALL	_rtc_read
;91-7.c,906 :: 		u2func=12;
	MOV	#12, W0
	MOV	W0, _u2func
;91-7.c,907 :: 		send_atc("33");
	MOV	#lo_addr(?lstr_43_91_457), W10
	CALL	_send_atc
;91-7.c,902 :: 		else if(uart2_data[0]=='0' && uart2_data[1]=='0' && uart2_data[2]=='1' && uart2_data[3]=='2')
L__main1037:
L__main1036:
L__main1035:
L__main1034:
;91-7.c,908 :: 		}
L_main810:
L_main803:
;91-7.c,909 :: 		UART2_Write(13);
	MOV	#13, W10
	CALL	_UART2_Write
;91-7.c,914 :: 		sending_ready=0;
	MOV	#lo_addr(_sending_ready), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,915 :: 		sending_ready_i=0;
	MOV	#lo_addr(_sending_ready_i), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,916 :: 		while(!sending_ready && sending_ready_i<100)
L_main814:
	MOV	#lo_addr(_sending_ready), W0
	CP0.B	[W0]
	BRA Z	L__main1460
	GOTO	L__main1039
L__main1460:
	MOV	#lo_addr(_sending_ready_i), W0
	MOV.B	[W0], W1
	MOV.B	#100, W0
	CP.B	W1, W0
	BRA LT	L__main1461
	GOTO	L__main1038
L__main1461:
L__main964:
;91-7.c,918 :: 		delay_ms(20);
	MOV	#2, W8
	MOV	#32756, W7
L_main818:
	DEC	W7
	BRA NZ	L_main818
	DEC	W8
	BRA NZ	L_main818
	NOP
	NOP
;91-7.c,919 :: 		sending_ready_i++;
	MOV.B	#1, W1
	MOV	#lo_addr(_sending_ready_i), W0
	ADD.B	W1, [W0], [W0]
;91-7.c,920 :: 		if(sending_ready_i==40)UART2_Write(13);
	MOV	#lo_addr(_sending_ready_i), W0
	MOV.B	[W0], W1
	MOV.B	#40, W0
	CP.B	W1, W0
	BRA Z	L__main1462
	GOTO	L_main820
L__main1462:
	MOV	#13, W10
	CALL	_UART2_Write
L_main820:
;91-7.c,921 :: 		}
	GOTO	L_main814
;91-7.c,916 :: 		while(!sending_ready && sending_ready_i<100)
L__main1039:
L__main1038:
;91-7.c,924 :: 		if(sending_ready)
	MOV	#lo_addr(_sending_ready), W0
	CP0.B	[W0]
	BRA NZ	L__main1463
	GOTO	L_main821
L__main1463:
;91-7.c,926 :: 		clear_UART2();
	CALL	_clear_uart2
;91-7.c,927 :: 		if(u2func==3)
	MOV	_u2func, W0
	CP	W0, #3
	BRA Z	L__main1464
	GOTO	L_main822
L__main1464:
;91-7.c,929 :: 		send_atc("8821");
	MOV	#lo_addr(?lstr_44_91_457), W10
	CALL	_send_atc
;91-7.c,930 :: 		send_atc(datetimesec);
	MOV	#lo_addr(_datetimesec), W10
	CALL	_send_atc
;91-7.c,931 :: 		send_atc(interval_data);
	MOV	#lo_addr(_interval_data), W10
	CALL	_send_atc
;91-7.c,932 :: 		}
	GOTO	L_main823
L_main822:
;91-7.c,933 :: 		else if(u2func==12)
	MOV	_u2func, W0
	CP	W0, #12
	BRA Z	L__main1465
	GOTO	L_main824
L__main1465:
;91-7.c,935 :: 		send_atc("8012");
	MOV	#lo_addr(?lstr_45_91_457), W10
	CALL	_send_atc
;91-7.c,936 :: 		send_atc(datetimesec);
	MOV	#lo_addr(_datetimesec), W10
	CALL	_send_atc
;91-7.c,937 :: 		send_atc(system_id);
	MOV	#lo_addr(_system_id), W10
	CALL	_send_atc
;91-7.c,938 :: 		}
	GOTO	L_main825
L_main824:
;91-7.c,939 :: 		else if(u2func==100)
	MOV	#100, W1
	MOV	#lo_addr(_u2func), W0
	CP	W1, [W0]
	BRA Z	L__main1466
	GOTO	L_main826
L__main1466:
;91-7.c,941 :: 		send_atc("8000");
	MOV	#lo_addr(?lstr_46_91_457), W10
	CALL	_send_atc
;91-7.c,942 :: 		send_atc(datetimesec);
	MOV	#lo_addr(_datetimesec), W10
	CALL	_send_atc
;91-7.c,943 :: 		send_atc(system_id);
	MOV	#lo_addr(_system_id), W10
	CALL	_send_atc
;91-7.c,944 :: 		send_atc(system_model);
	MOV	#lo_addr(?lstr_47_91_457), W10
	CALL	_send_atc
;91-7.c,945 :: 		send_atc(version);
	MOV	#lo_addr(?lstr_48_91_457), W10
	CALL	_send_atc
;91-7.c,946 :: 		send_atc("READY");
	MOV	#lo_addr(?lstr_49_91_457), W10
	CALL	_send_atc
;91-7.c,947 :: 		}
L_main826:
L_main825:
L_main823:
;91-7.c,948 :: 		u2func=0;
	CLR	W0
	MOV	W0, _u2func
;91-7.c,949 :: 		gprs_send=0;
	MOV	#lo_addr(_gprs_send), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,950 :: 		set_gprs_timer(20);
	MOV.B	#20, W10
	CALL	_set_gprs_timer
;91-7.c,951 :: 		gprs_state=1;
	MOV	#lo_addr(_gprs_state), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;91-7.c,952 :: 		clear_uart2();
	CALL	_clear_uart2
;91-7.c,953 :: 		uart2_data_received=0;
	MOV	#lo_addr(_uart2_data_received), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,954 :: 		}
	GOTO	L_main827
L_main821:
;91-7.c,957 :: 		gprs_state=0;
	MOV	#lo_addr(_gprs_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,958 :: 		connection_state=0;
	BCLR	LATE5_bit, BitPos(LATE5_bit+0)
;91-7.c,959 :: 		}
L_main827:
;91-7.c,960 :: 		}
	GOTO	L_main828
L_main799:
;91-7.c,963 :: 		gprs_state=0;
	MOV	#lo_addr(_gprs_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,964 :: 		connection_state=0;
	BCLR	LATE5_bit, BitPos(LATE5_bit+0)
;91-7.c,965 :: 		}
L_main828:
;91-7.c,966 :: 		}
	GOTO	L_main829
L_main796:
;91-7.c,967 :: 		else if(gprs_state==1)
	MOV	#lo_addr(_gprs_state), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__main1467
	GOTO	L_main830
L__main1467:
;91-7.c,969 :: 		if(uart2_data[0]=='S' && uart2_data[1]=='E' && uart2_data[5]=='O' && uart2_data[6]=='K')
	MOV	#lo_addr(_uart2_data), W0
	MOV.B	[W0], W1
	MOV.B	#83, W0
	CP.B	W1, W0
	BRA Z	L__main1468
	GOTO	L__main1043
L__main1468:
	MOV	#lo_addr(_uart2_data+1), W0
	MOV.B	[W0], W1
	MOV.B	#69, W0
	CP.B	W1, W0
	BRA Z	L__main1469
	GOTO	L__main1042
L__main1469:
	MOV	#lo_addr(_uart2_data+5), W0
	MOV.B	[W0], W1
	MOV.B	#79, W0
	CP.B	W1, W0
	BRA Z	L__main1470
	GOTO	L__main1041
L__main1470:
	MOV	#lo_addr(_uart2_data+6), W0
	MOV.B	[W0], W1
	MOV.B	#75, W0
	CP.B	W1, W0
	BRA Z	L__main1471
	GOTO	L__main1040
L__main1471:
L__main963:
;91-7.c,971 :: 		gprs_state=0;
	MOV	#lo_addr(_gprs_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,972 :: 		gprs_timer_en=0;
	MOV	#lo_addr(_gprs_timer_en), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,973 :: 		clear_uart2();
	CALL	_clear_uart2
;91-7.c,974 :: 		u2func=0;
	CLR	W0
	MOV	W0, _u2func
;91-7.c,975 :: 		}
	GOTO	L_main834
;91-7.c,969 :: 		if(uart2_data[0]=='S' && uart2_data[1]=='E' && uart2_data[5]=='O' && uart2_data[6]=='K')
L__main1043:
L__main1042:
L__main1041:
L__main1040:
;91-7.c,978 :: 		gprs_state=0;
	MOV	#lo_addr(_gprs_state), W1
	CLR	W0
	MOV.B	W0, [W1]
;91-7.c,979 :: 		connection_state=0;
	BCLR	LATE5_bit, BitPos(LATE5_bit+0)
;91-7.c,980 :: 		}
L_main834:
;91-7.c,981 :: 		}
L_main830:
L_main829:
;91-7.c,982 :: 		}
L_main795:
;91-7.c,983 :: 		}
L_main791:
;91-7.c,984 :: 		}
L_main790:
;91-7.c,985 :: 		}
L_main738:
L_main737:
;91-7.c,986 :: 		}
	GOTO	L_main642
;91-7.c,987 :: 		}
L_end_main:
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main
