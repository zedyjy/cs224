	#=========================================================		
	.data
line:	
	.asciiz "\n --------------------------------------"

nodeNumberLabel:
	.asciiz	"\n Node No.: "
	
addressOfCurrentNodeLabel:
	.asciiz	"\n Address of Current Node: "
	
addressOfNextNodeLabel:
	.asciiz	"\n Address of Next Node: "
	
dataValueOfCurrentNode:
	.asciiz	"\n Data Value of Current Node: "
	
keyValueOfCurrentNode:
	.asciiz	"\n Key Value of Current Node: "

getKey:
	.asciiz	"\n Enter key value: "
	
getData:
	.asciiz	"\n Enter data value: "
	
	.text
# CS224, Program to be used in Lab 3
# October 16, 2023

	li	$a0, 5 	#create a linked list with 5 nodes
	li	$a1, 5 	#create a linked list with 5 nodes
	jal	createLinkedList
	
# Linked list is pointed by $v0
	move	$a0, $v0	# Pass the linked list address in $a0
	jal 	printLinkedList
		
	move	$a0, $v0	# Pass the linked list address in $a0
	jal sumLinkedList
	
	move	$a0, $v0	# Pass the linked list address in $a0
	jal 	printLinkedList
	
	# Stop. 
	li	$v0, 10
	syscall

createLinkedList:
# $a0: No. of nodes to be created ($a0 >= 1)
# $v0: returns list head
# Node 1 contains 4 in the data field, node i contains the value 4*i in the data field.
# By inserting a data value like this
# when we print linked list we can differentiate the node content from the node sequence no (1, 2, ...).
	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram
	
	move	$s0, $a0	# $s0: no. of nodes to be created.
	li	$s1, 1		# $s1: Node counter
# Create the first node: header.
# Each node is 8 bytes: link field then data field.
	li	$a0, 12
	li	$v0, 9
	syscall
# OK now we have the list head. Save list head pointer 
	move	$s2, $v0	# $s2 points to the first and last node of the linked list.
	move	$s3, $v0	# $s3 now points to the list head.
# sll: So that node 1 data value will be 4, node i data value will be 4*i
	li $v0, 4
    	la $a0, getKey
    	syscall
    	# read the size of the array from the user
    	li $v0, 5
    	syscall
    	move $s4, $v0
    	
    	sw	$s4, 4($s2)	# Store the data value.
    	
    	li $v0, 4
    	la $a0, getData
    	syscall
    	# read the size of the array from the user
    	li $v0, 5
    	syscall
    	move $s4, $v0

	sw	$s4, 8($s2)	# Store the data value.
	
addNode:
# Are we done?
# No. of nodes created compared with the number of nodes to be created.
	beq	$s1, $s0, allDone
	addi	$s1, $s1, 1	# Increment node counter.
	li	$a0, 12 		# Remember: Node size is 8 bytes.
	li	$v0, 9
	syscall
# Connect the this node to the lst node pointed by $s2.
	sw	$v0, 0($s2)
# Now make $s2 pointing to the newly created node.
	move	$s2, $v0	# $s2 now points to the new node.
	
	li $v0, 4
    	la $a0, getKey
    	syscall
    	# read the size of the array from the user
    	li $v0, 5
    	syscall
    	move $s4, $v0
    	
    	sw	$s4, 4($s2)	# Store the data value.
    	
    	li $v0, 4
    	la $a0, getData
    	syscall
    	# read the size of the array from the user
    	li $v0, 5
    	syscall
    	move $s4, $v0
	
	sw	$s4, 8($s2)	# Store the data value.
	
	j	addNode
allDone:
# Make sure that the link field of the last node cotains 0.
# The last node is pointed by $s2.
	sw	$zero, 0($s2)
	move	$v0, $s3	# Now $v0 points to the list head ($s3).
	
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	
	jr	$ra
#=========================================================
printLinkedList:
# Print linked list nodes in the following format
# --------------------------------------
# Node No: xxxx (dec)
# Address of Current Node: xxxx (hex)
# Address of Next Node: xxxx (hex)
# Data Value of Current Node: xxx (dec)
# --------------------------------------

# Save $s registers used
	addi	$sp, $sp, -28
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$s4, 24($sp)
	sw	$s5, 28($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram

# $a0: points to the linked list.
# $s0: Address of current
# s1: Address of next
# $2: Data of current
# $s3: Node counter: 1, 2, ...
	move $s5, $a0	# $s0: points to the current node.
	move $s0, $a0	# $s0: points to the current node.
	li   $s3, 0
printNextNode:
	beq	$s0, $zero, printedAll
				# $s0: Address of current node
	lw	$s1, 0($s0)	# $s1: Address of  next node
	lw	$s2, 4($s0)	# $s2: Data of current node
	lw	$s4, 8($s0)	# $s2: Data of current node
	addi	$s3, $s3, 1
# $s0: address of current node: print in hex.
# $s1: address of next node: print in hex.
# $s2: data field value of current node: print in decimal.
	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, nodeNumberLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s3	# $s3: Node number (position) of current node
	li	$v0, 1
	syscall
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s0	# $s0: Address of current node
	li	$v0, 34
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	move	$a0, $s1	# $s0: Address of next node
	li	$v0, 34
	syscall	
	
	la	$a0, keyValueOfCurrentNode
	li	$v0, 4
	syscall
		
	move	$a0, $s2	# $s2: Data of current node
	li	$v0, 1		
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	move	$a0, $s4	# $s2: Data of current node
	li	$v0, 1		
	syscall	

# Now consider next node.
	move	$s0, $s1	# Consider next node.
	j	printNextNode
printedAll:
	move $v0, $s5	# $s0: points to the current node.
	
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	lw	$s4, 24($sp)
	lw	$s5, 28($sp)
	addi	$sp, $sp, 28
	jr	$ra
	
############################################################################################################
sumLinkedList:
    	addi $sp, $sp, -32
    	sw $s0, 24($sp)
    	sw $s1, 20($sp)
    	sw $s2, 16($sp)
    	sw $s3, 12($sp)
    	sw $s4, 8($sp)
    	sw $s5, 4($sp)

    	move $s0, $a0         # $s0: Current node in the input list
    	li $s1, 0             # $s1: Sum accumulator
    	li $s2, -1            # $s2: Previous key (initialize as an invalid key)

    	# Create the head node of the new linked list
    	li $t0, 0             # $t0: Null pointer
    	sw $t0, 0($sp)        # Initialize new list pointer
    	move $s3, $sp         # $s3: New list pointer
    
    	lw $t2, 8($s0)        # $t2: Value of the current node
        
    	add $s1, $s1, $t2

	loop:
    		beq $s0, $zero, done  # End of the input list

    		lw $t1, 4($s0)        # $t1: Key of the current node
    		lw $t2, 8($s0)        # $t2: Value of the current node

		li $v0, 1
    		move $a0, $t1
    		syscall
    	
    		li $v0, 1
    		move $a0, $s2
    		syscall
	    		
	    	add $s1, $s1, $t2     # Add value to the sum
    		# Check if the key matches the previous one
    		beq $t1, $s2, add_to_sum
    		bne $t1, $s2, update_key

	add_to_sum:
    		sub $s1, $s1, $t2     # Add value to the sum
    		j next_node

	update_key:
    		move $s2, $t1         # Update the previous key
    		#j next_node

	create_node:
    		li $v0, 9             # System call to allocate memory for a new node
    		li $a0, 12            # Node size: 12 bytes
    		syscall

		lw $t4, 4($s0)        # Load the key of the next node
    		move $s2, $t4         # Update the previous key
    
    		# Initialize the new node with the sum and key
    		sw $t0, 0($v0)        # Set link to the next node (or null)
    		sw $t1, 4($v0)        # Set key
    		sw $s1, 8($v0)        # Set sum
    
    		sw $v0, 0($s3)        # Set the link of the previous node to the new node
    
    		move $s3, $v0         # Update new list pointer

    		# Reset the sum accumulator
    		li $s1, 0

	next_node:
    		lw $s0, 0($s0)        # Move to the next node
    		beq $s0, $zero, done  # End of the input list
    		j loop

	done:
    		lw $v0, 0($sp)        # Return the pointer to the new list
    		addi $sp, $sp, 32     # Restore the stack
    		jr $ra

