#CS224
#Recitation No: 02
#Section No: 04
#Zeynep Doða Dellal	
#22002572
#3/10/2023
.data
x: .word 0
reversed_x: .word 0  
endl: .asciiz "\n"
prompt: .asciiz "Enter the decimal: "
continue_prompt: .asciiz "Do you want to continue? (1 for yes, 0 for no): "

.text
main:
    	# main
input_loop:
    	# Prompt the user for input
    	li $v0, 4
    	la $a0, prompt
    	syscall

    	# Read an integer from the user and store it in $a0
    	li $v0, 5
    	syscall
    	move $a0, $v0

    	# Store the user input in the memory location of x
    	sw $a0, x

    	lw $a1, x             
    	addiu $a0, $zero, 0     # Counter LSB
    	li $v0, 1               
    	move $a2, $zero   

    	jal reverse
	
    	# Print a newline 
    	li $v0, 4
    	la $a0, endl
    	syscall

    	# Ask if the user wants to continue
    	li $v0, 4
    	la $a0, continue_prompt
    	syscall

    	# Read the user's choice (1 for yes, 0 for no)
    	li $v0, 5
    	syscall
    	move $a0, $v0

    	# Check if the user wants to continue
    	beq $a0, 1, input_loop

	addi $sp,$sp,8
	lw $s0, 0($sp)
	lw $ra, 4($sp)
	
    	# Exit the program
    	li $v0, 10
    	syscall

reverse:
	addi $sp,$sp,-8
	sw $s0, 0($sp)
	sw $ra, 4($sp)
	
    	beq $a0, 32, reverse_end    # If a0 == 32 exit 
    	sll $a2, $a2, 1           # Left shift the reversed
    	and $s0, $a1, 1           # Extract the LSB
    	or $a2, $a2, $s0          # Add the bit to the reversed
    	srl $a1, $a1, 1           # Right shift the original

    	addi $a0, $a0, 1           # Increase the counter
    	j reverse

reverse_end:
    	# Store the reversed
    	sw $a2, reversed_x

    	# Convert TO hex and print
    	li $v0, 34              
    	lw $a0, reversed_x     
    	syscall

    	jr $ra
