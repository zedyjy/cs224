/*
Configuration for the code below:

Connect portA to J1 Port of 4 Digit Seven Segment Module
Jumpers of portA are : 5V, pull down ( top one to left, other to right )

Connect portE to J2 Port of 4 Digit Seven Segment Module
Jumpers of portE are : 5V, pull down ( top one to left, other to right )

*/

// Hexadecimal values for digits in 7 segment
unsigned char binary_pattern[]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};

void main() {

 AD1PCFG = 0xFFFF;      // Configure AN pins as digital I/O
 JTAGEN_bit = 0;        // Disable JTAG
    
 TRISA = 0x00;  //portA is output to D
 TRISE = 0X00;  //portE is output to AN
 int d = 1;
 int count = 0;
 while(1)
 {
	 // Digit 1
     PORTA=binary_pattern[(d % 10)];     
     PORTE=0x00;                  
     Delay_ms(1);
	 count = count + 1;
	 
     // Digit 2
     PORTA=binary_pattern[(d % 10) + 1];     
     PORTE=0x02;                  
     Delay_ms(1);
     count = count + 1;
	 
     // Digit 3
     PORTA=binary_pattern[(d % 10) + 2];
     PORTE=0x04;
     Delay_ms(1);
     count = count + 1;
	 
     // Digit 4
     PORTA=binary_pattern[(d % 10) + 3];
     PORTE=0x08;
     Delay_ms(1);
	 count = count + 1;
	 
	 if (count >3999) // 4000 count means a second has passed
	 {
		 count = 0
		 d = d + 1;
	 }
 }

}//main