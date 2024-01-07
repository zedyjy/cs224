######################################QUESTION 2###############################################  
.data
getInstruction: .asciiz "Please enter a number that is between 1 and 31: "
errorMessage: .asciiz "Divisor cannot be zero. "
count: .word 0
getDividend: .asciiz "Please enter a positive number to be divided: "
getDivisor: .asciiz "Please enter a poistive number to divide: "
quotientDeclare: .asciiz "quotient is: "
remainderDeclare: .asciiz "  remainder is: "
endl:	.asciiz "\n"
	.text
	
main:
    	##2nd question##
    	li $v0, 4
    	la $a0, getDividend
    	syscall
    	li $v0, 5
    	syscall
    	
    	move $s0, $v0
    	move $a0, $v0
    	
    	li $v0, 4
    	la $a0, getDivisor
    	syscall
    	li $v0, 5
    	syscall
    	move $s1, $v0
    	move $a1, $v0
    	jal recursiveDivision
    	

#TODO: error message non-positive
recursiveDivision:
	addi $sp, $sp, -12        # Allocate stack space
	sw $ra, 0($sp)            # Save return address
	sw $a0, 4($sp)            # Save return address
    	sw $a1, 8($sp)     
    	
    	bgt $a1,$a0, errorRecursiveDivision
    	beq $a1, $0, errorZero
    
    	bgt $a0, $s1, result         # Check for dividend <= 0
    	
    	addi $a1, $a1, 1          # Increment quotient
    	sub $a0, $a0, $a1         # Subtract divisor from dividend
    	
    	
    	jal recursiveDivision
    	
result:
	lw $a1, 8($sp)            # Save divisor
    	
	li $v0, 4
    	la $a0, quotientDeclare
    	syscall	
	
	li $v0, 1
    	move $a0, $a1
    	syscall
	
	li $v0, 4
    	la $a0, remainderDeclare
    	syscall	
    	
    	li $v0, 1
    	move $a0, $s0
    	syscall
    	j done

errorRecursiveDivision:
	move $a0, $s0
	move $a1, $s1
	j result
	
errorZero:
	li $v0, 4
    	la $a0, endl
    	syscall
	li $v0, 4
    	la $a0, errorMessage
    	syscall
    	li $v0, 4
    	la $a0, endl
    	syscall
    	j main	
    	
done:
	li $v0, 10
	syscall
