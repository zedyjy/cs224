#line 1 "C:/Users/zeyne/Dropbox/My PC (LAPTOP-UIF680BP)/Desktop/ExampleProject/Push_button/Push_button.c"
#line 8 "C:/Users/zeyne/Dropbox/My PC (LAPTOP-UIF680BP)/Desktop/ExampleProject/Push_button/Push_button.c"
void main() {

 AD1PCFG = 0xFFFF;
 DDPCON.JTAGEN = 0;

 TRISA = 0x0000;
 PORTA = 0Xffff;


 TRISE = 0xFFFF;
 PORTE = 0X0000;



 while(1) {

 PORTAbits.RA1 = PORTEbits.RE0;;
 PORTAbits.RA2 = PORTEbits.RE1;

 }
}
