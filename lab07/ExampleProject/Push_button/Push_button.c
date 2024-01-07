/*
* DC Motor Simulation
* Connect portC to DC Motor, use 5 Volt and pull up.
* Connect portE to push-buttons, use 3.3V, pull up.
*/
//

void main() {

 AD1PCFG = 0xFFFF; // Configure
 DDPCON.JTAGEN = 0; // disable JTAG

 TRISA = 0x0000; //portC is used as an output (for DC Motor)
 PORTA = 0Xffff;


 TRISE = 0xFFFF; //portE is used as an input (for push buttons)
 PORTE = 0X0000;



 while(1) {

  PORTAbits.RA1 = PORTEbits.RE0;; // button 0, counter clockwise
  PORTAbits.RA2 = PORTEbits.RE1; // button 1, clockwise

 }
}