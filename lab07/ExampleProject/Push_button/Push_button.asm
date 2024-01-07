_main:
;Push_button.c,8 :: 		void main() {
;Push_button.c,10 :: 		AD1PCFG = 0xFFFF; // Configure
ORI	R2, R0, 65535
SW	R2, Offset(AD1PCFG+0)(GP)
;Push_button.c,11 :: 		DDPCON.JTAGEN = 0; // disable JTAG
LBU	R2, Offset(DDPCON+0)(GP)
INS	R2, R0, 3, 1
SB	R2, Offset(DDPCON+0)(GP)
;Push_button.c,13 :: 		TRISA = 0x0000; //portC is used as an output (for DC Motor)
SW	R0, Offset(TRISA+0)(GP)
;Push_button.c,14 :: 		PORTA = 0Xffff;
ORI	R2, R0, 65535
SW	R2, Offset(PORTA+0)(GP)
;Push_button.c,17 :: 		TRISE = 0xFFFF; //portE is used as an input (for push buttons)
ORI	R2, R0, 65535
SW	R2, Offset(TRISE+0)(GP)
;Push_button.c,18 :: 		PORTE = 0X0000;
SW	R0, Offset(PORTE+0)(GP)
;Push_button.c,22 :: 		while(1) {
L_main0:
;Push_button.c,24 :: 		PORTAbits.RA1 = PORTEbits.RE0;; // button 0, counter clockwise
LBU	R2, Offset(PORTEbits+0)(GP)
EXT	R3, R2, 0, 1
LBU	R2, Offset(PORTAbits+0)(GP)
INS	R2, R3, 1, 1
SB	R2, Offset(PORTAbits+0)(GP)
;Push_button.c,25 :: 		PORTAbits.RA2 = PORTEbits.RE1; // button 1, clockwise
LBU	R2, Offset(PORTEbits+0)(GP)
EXT	R3, R2, 1, 1
LBU	R2, Offset(PORTAbits+0)(GP)
INS	R2, R3, 2, 1
SB	R2, Offset(PORTAbits+0)(GP)
;Push_button.c,27 :: 		}
J	L_main0
NOP	
;Push_button.c,28 :: 		}
L_end_main:
L__main_end_loop:
J	L__main_end_loop
NOP	
; end of _main
