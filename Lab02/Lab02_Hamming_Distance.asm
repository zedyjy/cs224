#CS224
#Recitation No: 02
#Section No: 04
#Zeynep Doða Dellal	
#22002572
#3/10/2023

	.data

endl:	.asciiz "\n"
distance:	.asciiz "The Hamming distance is: "
getRegisterOne: .asciiz "Please enter register 1: "
getRegisterTwo: .asciiz "Please enter register 2: "
displayRegister: .asciiz "Registers you entered are: "
andMsg: .asciiz " and "
continueMsg: .asciiz "Enter 1 if you want to continue, 0 if you want to stop: "
chooseOperation: .asciiz "Do you want to continue? (1 for yes, 0 for no): "

.text
Main:	
    	li $v0,1	
	move $a0, $a2
	syscall
    	
    	li $s5, 0 # hamming distance
    	jal CalculateDistanceBetweenRegisters
	
   
    	
CalculateDistanceBetweenRegisters:
	li $s3, 0
	addi $sp, $sp,-8
	sw $s5, 4($sp)
	sw $a1, 8($sp)
	jal getRegisters
	
  	# XOR the two registers together and loop through the result
  	xor $a3, $s5, $a1
  	
  	li $s6, 0
  	loopHammingDistance:
  		beq $a3, $0, loopHammingDistanceDone
  		
  		andi $s3, $a3, 1 
  		
  		srl $a3, $a3, 1  # Shift the result XOR by 1 bit to the right
  		
  		bne $s3, $0, hammingDistanceIncrement
    
    		# Continue looping
    		j loopHammingDistance
  	
  	lw $s5, 4($sp)
	lw $a1, 8($sp)
	addi $sp, $sp,8
	
  	    		
# Increment $s6 if the least significant bit is 1
hammingDistanceIncrement:
    	addi $s6, $s6, 1
    	j loopHammingDistance
    
loopHammingDistanceDone:
	li $v0, 4
    	la $a0, distance
    	syscall
	li $v0,34	# syscall 4 prints the string
	move $a0, $s6
	syscall
	
	li $v0, 4
    	la $a0, endl
    	syscall   
    
	li $v0, 4
    	la $a0, continueMsg
    	syscall
    	
    	li $v0, 5
    	syscall
    	
    	beq $v0, $0, done
    	
    	move $a1,$v0 #index is at a1
    	
    	li $a2, 1
    	beq $a1, $a2, CalculateDistanceBetweenRegisters
    	
    	 
	li $v0, 4
    	la $a0, endl
    	syscall   

done:
	li $v0, 10
    	syscall
	
getRegisters:
	# Prompt user to enter a value for register 1
  	li $v0, 4
  	la $a0, getRegisterOne
  	syscall
  	
  	# Get user input for register 1
  	li $v0, 5
  	syscall
  	move $a1, $v0
  	
  	# Prompt user to enter a value for register 2
  	li $v0, 4
  	la $a0, getRegisterTwo
  	syscall
  
  	# Get user input for register 2
  	li $v0, 5
  	syscall
  	move $s5, $v0
  	
  	li $v0, 4
  	la $a0, displayRegister
  	syscall
  	
  	li $v0,34	# syscall 4 prints the string
	move $a0, $a1
	syscall
	
	li $v0, 4
  	la $a0, andMsg
  	syscall
	
  	li $v0,34	# syscall 4 prints the string
	move $a0, $s5
	syscall
	
	li $v0, 4
  	la $a0, endl
  	syscall

  	jr $ra	
	