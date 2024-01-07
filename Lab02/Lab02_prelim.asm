#CS224
#Lab No 02
#Section No 04
#Zeynep Doða Dellal
#22002572
#11.10.2023
##########################################################
	.data
arraySize: .word 0        # the size of the array
arrayPtr: .word 0         # a pointer to the array
getSize: .asciiz "Please enter array size: "
getArrayMembersMsg: .asciiz "Please enter the array member: "
endl:	.asciiz "\n"
arrayPrint:	.asciiz " "
arrayAddress: .word 0
FreqTable: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
s6: .asciiz "s6: "
s2: .asciiz "s2: "

# Defined in data segment and assume that it is only accessible by Main (its address will be passed to FindFreq).
# FreqTable 1st word contains the number times the number 0 appears in the array
...
# FreqTable 10th word contains the number times the number 9 appears in the array
# FreqTable 11th word contains the number times any number other than 0 to 9 appears in the array

.text
Main:
	# get size of the array
    	li $v0, 4
    	la $a0, getSize
    	syscall
    
    	# read the size of the array from the user
    	li $v0, 5
    	syscall
    	move $a1, $v0
    
    	# call CreateArray to create the array
    	jal CreateArray
    	
    	# load the size and address of the array
    	lw $t1, arraySize
    	lw $s0, arrayPtr
    	
    	# print the array
    	jal PrintArray
    	
    	lw $a0, arraySize #a0 = array size
    	lw $a1, arrayPtr #a1 = array pointer
    	
    	jal FindFreq
    	
    	# load the size and address of the array
    	li $t1, 11
    	la $s0, FreqTable

	li $v0, 4
    	la $a0, endl
    	syscall
    		
    		
    	jal PrintArray
    	# exit the program
    	li $v0, 10
    	syscall
	
CopyArray:
  move $s0, $a1  # Source array (in $a1)
        move $s1, $t1  # Destination array (in $t1)

        # Copy elements from source to destination
        copyLoop:
            lw $t2, 0($s0)   # Load an element from the source array
            sw $t2, 0($s1)   # Store it in the destination array

            addi $s0, $s0, 4  # Increment source address by 4 bytes (4 bytes per integer)
            addi $s1, $s1, 4  # Increment destination address by 4 bytes

            addi $t0, $t0, -1  # Decrement the element count

            bnez $t0, copyLoop  # Continue copying if not all elements are copied
					
CreateArray:
	addi $sp, $sp, -12
	sw $s0, 8($sp)
	sw $s1, 4($sp)
	sw $s2, 0($sp)
	
	add $s0, $a1, $zero #s0 = array size
	
    	sll $s0, $a1, 2        # $s0= 4 x $a1 (no. of words to be allocatedd)
	# Allocate memory for the array
    	li $v0, 9            # Load the syscall code for memory allocation
    	move $a0, $s0        # Pass the size of the array as an argument
    	syscall
    	move $s0, $v0          # save the address of the allocated memory
    	
    	add $v0, $s0, $zero        # $v0 now contains the address of the allocated memory
    	add $v1, $a1, $zero        # $v1 now contains the size of the allocated array
    	
    	# store the size and address of the array
   	sw $v1, arraySize
    	sw $v0, arrayPtr
    	
    	j InitializeArray
    	
    	jr $ra

InitializeArray:
    	addi $sp, $sp, -12
	sw $s0, 8($sp)
	sw $s1, 4($sp)
	sw $s2, 0($sp)
	
	lw $s1, arraySize
    	lw $s0, arrayPtr
    	
	populateArray:
		beq $s1, $0, done
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
 		addi $s1, $s1, -1     # decrement array size count
 		j populateArray
	
PrintArray:
    	loop2:
	beq $t1, $0, done
    
    	# Print array element
    	lw $a0, ($s0)
    	li $v0, 1
    	syscall
    	
    	# increment array index and pointer
    	addi $s0, $s0, 4
    	subi $t1, $t1, 1     # decrement array size count
    	j loop2
    	
FindFreq:
	addi $sp, $sp, -32
	sw $s7, 28($sp)
	sw $s6, 24($sp)
	sw $s5, 20($sp)
	sw $s4, 16($sp)
	sw $s3, 12($sp)
	sw $s0, 8($sp)
	sw $s1, 4($sp)
	sw $s2, 0($sp)
	
	la $s4, FreqTable
	li $s7, 10
	li $s5, -4
	li $s0, 0
	li $s2, 0
	li $s3, 0
	add $s5, $s5, $s4
	findFreqLoop:
		beq $a0, $zero, storeCount
		# Print array element
    		lw $s1, ($a1)
	
		div $s1, $s7
    		mfhi $s1
    		mflo $s6
    		
    		beq $s0, $s1, incrementCount
    		bne $s6, $zero, computation
    		
    		# increment array index and pointer
    		addi $a1, $a1, 4
    		subi $a0, $a0, 1     # decrement array size count
    		j findFreqLoop
		
	incrementCount:
		addi $s2, $s2, 1
		bne $s6, $zero, computation
		beq $s6, $zero, next
		# increment array index and pointer
    		j findFreqLoop
    		
    	next: 
    		addi $a1, $a1, 4
		subi $a0, $a0, 1     # decrement array size count
		j findFreqLoop
		
    	computation:    		
    		sw $s6, ($a1)
    		
    		
    		j findFreqLoop
	
	storeCount:
		add $s5, $s5, 4
    		# Add the offset to the base address to get the address of the last element
		sw $s2, ($s5)
		
    		li $s2,0
    		add $s0, $s0, 1
    		
    		lw $a0, arraySize
    		add $a0, $a0, 1
    		
    		lw $a1, arrayPtr
		
		li $a2, 9
    		beq $s0, $a2, done
    		j findFreqLoop
    		
		jr $ra
done:
	addi $sp, $sp, 12
	lw $s0, 8($sp)
	lw $s1, 4($sp)
	lw $s2, 0($sp)
    	# return from the function

	jr $ra
