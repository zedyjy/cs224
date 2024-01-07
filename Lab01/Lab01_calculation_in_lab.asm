################################################################
#calculation
#CS224
#Lab No: 01
#Section No: 04
#Zeynep Doða Dellal
#22002572
#6.10.2023

##CALCULATION IN LAB
################################################################ 
   .data
    getA: .asciiz "Please enter number a: "
    getB: .asciiz "Please enter number b: "
    getC: .asciiz "Please enter number c: "
    getD: .asciiz "Please enter number d: "
    numA: .word  0 # int user input (4 bytes)
    errorMsg:	.asciiz "a mod c is zero. Calculation cannot continue"
    result: .asciiz "A= "
    newline: .asciiz "\n"
    .text
    .globl start    

start:
    li $v0,4  # syscall 4 prints the string
    la $a0,getB    # get size of the array
    syscall
    # Read integer input
    li $v0, 5
    syscall
    move $t1, $v0 # $t1 = b
    
    li $v0,4  # syscall 4 prints the string
    la $a0,getC    # get size of the array
    syscall
    # Read integer input
    li $v0, 5
    syscall
    move $t2, $v0 # $t2 = c
    
    li $v0,4  # syscall 4 prints the string
    la $a0,getD    # get size of the array
    syscall
    # Read integer input
    li $v0, 5
    syscall
    move $t3, $v0 # $t3 = d
    
    li $a1, 3
    div $t1, $a1
    mflo $t4 #t4=b/3
    
    mult $t4, $t3
    mflo $t4
    
    subi $t4, $t4,5
    add $t4, $t4, $t1
    
    div $t4, $t2
    mfhi $t4
    
        # Print the result
    li $v0, 4
    la $a0, result
    syscall

    li $v0, 1
    move $a0, $t4
    syscall

    # Exit the program
    li $v0, 10
    syscall
    
    