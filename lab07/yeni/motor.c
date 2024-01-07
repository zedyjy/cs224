/*
Attention!
Configuration  for dc motor project :

Connect portA to motor 
Jumpers of portA are : 5V, pull up ( both of the to the left side )

Connect portE to push-buttons
Jumpers of portE are : 3V3, pull up ( top one to right, other to left )

*/



void Wait() {
 Delay_ms(1000);
}

void main() {

 AD1PCFG = 0xFFFF;

 DDPCON.JTAGEN = 0; // disable JTAG

 TRISA = 0x0000;  //portA is output to turn on LEDs.
 TRISE = 0XFFFF;  //portE is inputs to read push-buttons.

 //LATA = 0XFFFF;
 //LATE = 0X0000;
 PORTE = 0xFFFF;

 while(1)
 {
   if (PORTEbits.RE0 == 1 && PORTEbits.RE1 == 1 ) //Motor not moving if both are turned on
   {
	   PORTAbits.RA1 = 0;
	   PORTAbits.RA2 = 0;
   }
   else if ( PORTEbits.RE0 == 1) // clockwise
   {
	   PORTAbits.RA1 = 1;
   }
   else if ( PORTEbits.RE1 == 1) //counter clockwise
   {
	   PORTAbits.RA2 = 1;
   }
  
 }//while

}//main