.data
continueMsg:	.asciiz "\nEnter 0 to quit the program, 1 to continue: "
enterInput: .asciiz "\nEnter the register value (decimal): "
inputHex:	.asciiz "\nInput(hex): "
ouputHex:	.asciiz "\nOutput(hex): "
lineBreak: .asciiz "\n**************************************************"
.text
main:

la $a0, enterInput # Enter the register value (in decimal):
li $v0, 4 #print string
syscall

li $v0, 5 #read integer
syscall 
move $t0, $v0

la $a0,lineBreak 
li $v0, 4 #print string
syscall

la $a0, inputHex #"\nInput(hex): "
li $v0, 4 #print string
syscall

move $a0, $t0 #$a0 = integer to print
li $v0, 34  #print integer in hexadecimal
syscall

move $a0, $t0

jal reverseBits

move $t0, $v0

la $a0, ouputHex #"\nOutput(hex): "
li $v0, 4 #print string
syscall

move $a0, $t0 ##$a0 = integer to print
li $v0, 34 ##print integer in hexadecimal
syscall

la $a0,lineBreak 
li $v0, 4 #print string
syscall

la $a0, continueMsg 
li $v0, 4 #print string
syscall

li $v0, 5 #read integer
syscall
move $t0, $v0

beq $t0, $zero, exit

j main

exit:
li $v0, 10
syscall

reverseBits:
	addi $sp,$sp,-24
	sw $s4, 20($sp)
	sw $s3, 16($sp)
	sw $s0, 12($sp)
	sw $s1, 8($sp)
	sw $s2, 4($sp)
	sw $ra, 0($sp)

    move $s0, $a0  # Copy the input integer to $t0
    li $s1, 1  # Initialize a mask with the lowest bit set
    li $s2, 0  # Initialize the result to 0
    li $s3, 32  # Number of bits to reverse

reverseLoop:
    and $s4, $s0, $s1  # Extract the lowest bit
    sll $s2, $s2, 1  # Shift the result left by one bit
    or $s2, $s2, $s4  # Set the extracted bit in the result
    srl $s0, $s0, 1  # Shift the input right by one bit
    subi $s3, $s3, 1  # Decrement the loop counter
    beq $s3,$0, doneReverse
    j reverseLoop  # Continue looping if not all bits are reversed

   doneReverse:
    move $v0, $s2  # Store the result in $v0
    
    lw $ra, 0($sp)
    lw $s2, 4($sp)
    lw $s1, 8($sp)
    lw $s0, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    addi $sp,$sp,24
	
