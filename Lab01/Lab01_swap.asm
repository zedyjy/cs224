#CS224
#Lab No: 01
#Section No: 04
#Zeynep Doða Dellal
#22002572
#4.10.2023

    	.data
array:  .space 80
	.align 2 # Allocate 80 bytes = space enough to hold 20 words
getSize: .asciiz "Please enter a number less than 20: "
arraySizeZeroMsg: .asciiz "Array size is zero, no elements to display or reverse."
negatifNumberMsg: .asciiz "Array size cannot be less than zero"
moreThan20Msg: .asciiz "Array size cannot be more than 20"
arraySize: .word  0 # int user input (4 bytes)
getArrayMembersMsg: .asciiz "Please enter the array member: "
endl:	.asciiz "\n"
count: .word 0
    .text
    .globl start    

start:
	li $v0, 4 
	la $a0, getSize
	syscall
	
	li $v0, 5
	syscall
	
	sw $v0, arraySize
    	move $t4, $v0

    	# Array size is now in register t0
    	lw $t0, arraySize
    	
    	beq $t0, $zero, zeromsg
    	blt $t0, $zero, negNumberMsg
    	bgt $t0, 20, moreThan20
    	
    	
    	# Load array pointer into $s0
    	la $s0, array
    	addi $t1, $t1, 0
    	
    	jal	populateArray
    	
    	jal reverseArray
    	
    	jal 	displayArray

	
populateArray:
	beq $t1, $t0, done
	la $a0,getArrayMembersMsg	#get array members
	li $v0,4	# syscall 4 prints the string
	syscall
	
	# read integer input
   	li $v0, 5
    	syscall
    
    	# store input in array
    	sw $v0, ($s0)
    
    	# increment array index and pointer
    	addi $s0, $s0, 4
 	addi $t1, $t1, 1     # decrement array size count
 	j populateArray


displayArray:
	# Load array pointer into $s0
	la $s0, array
	lw $t1, arraySize

	loop:
	beq $t1, $0, done2
    
    	# Print array element
    	lw $a0, ($s0)
    	li $v0, 1
    	syscall
    	
    	# increment array index and pointer
    	addi $s0, $s0, 4
    	subi $t1, $t1, 1     # decrement array size count
    	j loop
    	
reverseArray:
	# Load array pointer into $s0
    	la $s0, array

    	# Load array size into $t0
    	lw $t0, arraySize
    	li $t5, 2
    	
	div $t0, $t5  # Divide $t0 by $t1
    	# Retrieve the result
    	mflo $t2      # Load the quotient (result) into $t2
    	
    	lw $t0, arraySize
    	# Calculate the offset to the last element
    	subi $t0, $t0, 1      # Subtract 1 from arraySize to get the index of the last element
    	mul $t0, $t0, 4       # Multiply by 4 (assuming each element is 4 bytes)

    	# Add the offset to the base address to get the address of the last element
    	add $t1, $s0, $t0

	lw $t0, arraySize
    	
    	reverseLoop:
    		beq $t0, $t2, done	
    	
    		#$t3 = temp to hold first t4 = temp to hold last, 
    		
    		lw $t4, 0($t1)
    		lw $t3, 0($s0)
    		
    		sw $t3, ($t1)
    		sw $t4, ($s0)
    		
    		subi $t0, $t0, 1
    		
    		subi $t1, $t1, 4
    		addi $s0, $s0, 4
    		
    		j reverseLoop
	
done2:
	# Exit the program
    	li $v0, 10
    	syscall
    
done:
	jr $ra
	
zeromsg:
	li $v0, 4 
	la $a0, arraySizeZeroMsg
	syscall
	li $v0, 4 
	la $a0, endl
	syscall
	j start
	
negNumberMsg:
	li $v0, 4 
	la $a0, negatifNumberMsg
	syscall
	li $v0, 4 
	la $a0, endl
	syscall
	j start

moreThan20:
	li $v0, 4 
	la $a0, moreThan20Msg
	syscall
	li $v0, 4 
	la $a0, endl
	syscall
	j start
	