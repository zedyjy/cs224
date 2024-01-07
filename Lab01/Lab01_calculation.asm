################################################################
#calculation
#CS224
#Lab No: 01
#Section No: 04
#Zeynep Doða Dellal
#22002572
#6.10.2023
################################################################ 
   .data
    getA: .asciiz "Please enter number a: "
    getB: .asciiz "Please enter number b: "
    getC: .asciiz "Please enter number c: "
    numA: .word  0 # int user input (4 bytes)
    errorMsg:	.asciiz "a mod c is zero. Calculation cannot continue"
    result: .asciiz "Result: "
    newline: .asciiz "\n"
    .text
    .globl start    

start:
    li $v0,4  # syscall 4 prints the string
    la $a0,getA    # get size of the array
    syscall
    # Read integer input
    li $v0, 5
    syscall
    move $t0, $v0 # $t0 = a
  
    li $v0,4  # syscall 4 prints the string
    la $a0,getB    # get size of the array
    syscall
    # Read integer input
    li $v0, 5
    syscall
    move $t1, $v0 # $t1 = b
    
    addi $a1, $a1, 2
    # CALCULATIONS
    mult $t0, $a1
    mflo $t3 #t3 = 2*a
    
    sub $t6, $t3, $t1 #2a-b
    
    add $t4, $t0, $t1 # t4 = a+b
    
    div $t6, $t4 # $t4 = (2a-b)/(a+b)
    mflo $t5 #
    
    beq $t4, $zero, errorMessage

    # Print the result
    li $v0, 4
    la $a0, result
    syscall

    li $v0, 1
    move $a0, $t5
    syscall

    # Exit the program
    li $v0, 10
    syscall

errorMessage:
la $a0,errorMsg	# put string address into a0
li $v0,4	# system call to print
syscall		#   out a string
li $v0, 10
syscall
