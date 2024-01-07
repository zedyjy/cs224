#CS224
#Lab No: 01
#Section No: 04
#Zeynep Doða Dellal
#22002572
#4.10.2023
.data
getB:   .asciiz "Enter the value of B: "
getC:   .asciiz "Enter the value of C: "
getD:   .asciiz "Enter the value of D: "
errorMSG: .asciiz "B or C cannot be zero\n"
msgA: .asciiz "A= "
explanation: .asciiz "\nResult of the operation A = (B / C + D Mod B - C ) / B is above."

.text
.globl start

start:
    	#prompt for input values
    	li $v0, 4
    	la $a0, getB
    	syscall

    	#read B from user input
    	li $v0, 5
    	syscall
    	move $s0, $v0  # B
    	move $s4, $v0 #B

    	li $v0, 4
    	la $a0, getC
    	syscall

    	#read C from user input
    	li $v0, 5
    	syscall
    	move $s1, $v0  # C

    	li $v0, 4
    	la $a0, getD
    	syscall

    	#read D from user input
    	li $v0, 5
    	syscall
    	move $s2, $v0  # D
    
    	#check for zero
    	beq $s1, $zero, error
    	beq $s0, $zero, error

    	# Calculate A = (B / C + D % B - C) / B
    	#div $s0, $s1     # B / C
    	#mflo $t0
    
    	li $t0, 0
    
	loop:
    		blt $s0, $s1, continue
    		sub $s0, $s0, $s1
    		addi $t0, $t0, 1
    		j loop
    	
    	continue:

    	rem $s3, $s2, $s4  # D % B

    	sub $t1, $t0, $s1  # (B / C) - C

    	add $t2, $t1, $s3  # (B / C + D % B - C)

	li $t3, 0
	
	loop2:
    		blt $t2, $s4, continue2
    		sub $t2, $t2, $s4
    		addi $t3, $t3, 1
    		j loop2
	
    	#div $t2, $s0       # (B / C + D % B - C) / B
    	#mflo $t3
	continue2:
    	# Print the result
    	li $v0, 4
    	la $a0, msgA
    	syscall

    	li $v0, 1
    	move $a0, $t3
    	syscall
    
    	li $v0, 4
    	la $a0, explanation
    	syscall

    	# Exit the program
    	li $v0, 10
    	syscall

error: 
	li $v0, 4
    	la $a0, errorMSG
    	syscall
    	j start
		