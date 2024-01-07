#CS224
#Lab No: 01
#Section No: 04
#Zeynep Doða Dellal
#22002572
#4.10.2023

    	.data
array:  .space 400
	.align 2 # Allocate 80 bytes = space enough to hold 20 words
getSize: .asciiz "Please enter a number less than 100: "
arraySizeZeroMsg: .asciiz "Array size is zero, no elements to display or reverse."
negatifNumberMsg: .asciiz "Array size cannot be less than zero"
moreThan20Msg: .asciiz "Array size cannot be more than 100"
menuChoice: .asciiz "\nChoose one of the options below to operate:\n 1-)Find max in the array\n2-)Find maximum count\n3-)Find how many numbers are there that can divide the maximum number without a remainder\n4-) Quit\n Please enter your choice: "
arraySize: .word  0 # int user input (4 bytes)
openParanthesis: .asciiz "["
closeParanthesis: .asciiz "]  "
resultMsg: .asciiz "The result is: "
inputChoice: .word 0
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
    	bgt $t0, 100, moreThan20
    	
    	# Load array pointer into $s0
    	la $s0, array
    	addi $t1, $t1, 0
    	
    	jal	populateArray
    	
    	jal 	displayArray

choice:
    	li $v0, 4 
	la $a0, menuChoice
	syscall
	
	li $v0, 5
	syscall
	
	sw $v0, inputChoice
    	move $a1, $v0
    	
    	li $t3, 1
    	li $t7, 2
    	li $t5, 3
    	li $t6, 4
    	
    	beq $a1, $t3, go1
    	
    	beq $a1, $t7, go2
    	
    	beq $a1, $t5, go3
    	
    	beq $a1, $t6, quit

go1:
	jal findMax
	
	li $v0, 4 
	la $a0, resultMsg
	syscall
	
	li $v0, 1
    	move $a0, $t0
    	syscall
    	j choice
go2:
	jal findMax
	jal findMaxCount
	
	li $v0, 4 
	la $a0, resultMsg
	syscall
	
	li $v0, 1
    	move $a0, $s2
    	syscall
    	j choice
go3:
	jal findDivisibleCount
	
	li $v0, 4 
	la $a0, resultMsg
	syscall
	
	li $v0, 1
    	move $a0, $s2
    	syscall
    	j choice

    	j quit
	
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
	beq $t1, $0, done
    
    	la $a0, openParanthesis	#get array members
	li $v0,4	# syscall 4 prints the string
	syscall
    	# Print array element
    	lw $a0, ($s0)
    	li $v0, 1
    	syscall
    	
    	la $a0, closeParanthesis	#get array members
	li $v0,4	# syscall 4 prints the string
	syscall
    	
    	# increment array index and pointer
    	addi $s0, $s0, 4
    	subi $t1, $t1, 1     # decrement array size count
    	j loop
    	
findMax:
	la $s0, array
	lw $s1, arraySize
	lw $t0, 0($s0)
	add $s0, $s0, 4
	loopFindMax:
		beq $s1, $0, done
		lw $t1, 0($s0)
		blt $t0, $t1, changeCurrMax  
		addi $s1, $s1, -1
		addi $s0, $s0, 4
    		j loopFindMax
    	
    	changeCurrMax:
    		move $t0, $t1
    		subi $s1, $s1, 1
		addi $s0, $s0, 4
    		j loopFindMax
    		
findMaxCount:
	la $s0, array
	lw $s1, arraySize
	li $s2, 0
	findMaxCountLoop:
		beq $s1, $zero, done
		lw $t1, 0($s0)
		beq $t1, $t0, incrementCount
		addi $s1, $s1, -1
		addi $s0, $s0, 4
		j findMaxCountLoop
		
	incrementCount:
		addi $s2, $s2, 1
		addi $s1, $s1, -1
		addi $s0, $s0, 4
		j findMaxCountLoop
		
findDivisibleCount:
	la $s0, array
	lw $s1, arraySize
	li $s2, 0
	findDivisibleCountLoop:
		beq $s1, $zero, done
		lw $t1, 0($s0)
		div $t0, $t1
		mfhi $t2
		beq $t1, $t0, skip
		beq $t2, $0, incrementCountDiv
		li $t2, 0
		addi $s1, $s1, -1
		addi $s0, $s0, 4
		j findDivisibleCountLoop
		
	skip:
		addi $s1, $s1, -1
		addi $s0, $s0, 4
		li $t2, 0
		j findDivisibleCountLoop
	
	incrementCountDiv:
		li $t2, 0
		addi $s2, $s2, 1
		addi $s1, $s1, -1
		addi $s0, $s0, 4
		j findDivisibleCountLoop
		
		
		
    		
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
    	
quit:
	# Exit the program
    	li $v0, 10
    	syscall
