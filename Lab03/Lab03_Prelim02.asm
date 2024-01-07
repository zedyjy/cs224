#####################################QUESTION 1############################################
.data 
message: .asciiz "Please enter the register number:"
result: .asciiz "Count for the usage of entered register number: "
error: .asciiz "Out of range input. \n"

.text
main:
	la $a0, message
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	blt $v0, 1, finish
	bgt $v0, 31, finish
	
	move $s0, $v0 #register number searched for
	move $s1, $zero #counter for the register 
	 
	jal subprogram
	
subprogram:
	addi $sp, $sp, -32
	sw $s0, 8($sp) 
	sw $s1, 4($sp) 
	addi $s2, $ra, 20 
	sw $s2, 0($sp)

	add $t0, $t0, $t1
	
	la $t2, message
	lw $t1, 0($t2)
	jal getRaInstruction
	
getRaInstruction:
	sw $ra, 12($sp)
	sw $s3, 16($sp)
	sw $s4 ,20($sp)
	sw $s5, 24($sp)
	sw $s6, 32($sp)
	jal getInstruction
	
getInstruction: 
	lw $s0, 0($sp)
	
	lw $s1, 12($sp) 
	
	beq $s1, $s0 done

	lw $s2, 0($s0)

	addi $s0, $s0, 4
	sw $s0, 0($sp)
	
	srl $s3, $s2, 26
	beqz $s3, getRType 
	
	bne $s3, 2 ,itypeCheck 
	j getInstruction 


getRType:
	andi $s4, $s2, 0x03E00000
	srl $s4, $s4, 21 
	lw $s5, 8($sp)
	beq $s4, $s5 ,increment
	j getRType2
increment:
	lw $s6 ,4($sp)
	addi $s6 ,$s6 ,1
	sw $s6 ,4($sp)
	
getRType2:
	andi $s4, $s2, 0x001F0000
	srl $s4, $s4, 16
	lw $s5 ,8($sp)
	beq $s4 ,$s5, increment2
	beqz $s3, getRType3
	j getInstruction
	
increment2:
	lw $s6, 4($sp)
	addi $s6 ,$s6, 1
	sw $s6 ,4($sp)	

	
getRType3:
	bnez $s3, getInstruction
	andi $s4, $s2, 0x0000F800
	srl $s4, $s4, 11
	lw $s5, 8($sp)
	beq $s4 ,$s5, increment3
	j getInstruction

increment3:
	lw $s6 ,4($sp)
	addi $s6 ,$s6 ,1
	sw $s6 ,4($sp)	
	j getInstruction 
	
itypeCheck:
	bne $s3, 3 ,getRType
	j getInstruction 

done:  
	la $a0, result
	li $v0 ,4
	syscall
	
	lw $a0 ,4($sp)
	li $v0 ,1
	syscall
	
	lw $s0 ,8($sp) 
	lw $s1, 4($sp) 
	lw $s2, 0($sp)
	
	lw $ra ,12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6 ,32($sp)
	
	li $v0, 10
	syscall
	
finish:
	la $a0, error
	li $v0, 4
	syscall
	
	li $v0,10
	syscall	
