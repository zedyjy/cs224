
.data
globalNodeKeyArray: .space 100 # list keys
globalNodeValueArray: .space 100 # list keys
globalNodeKeyArraySize: .space 4
pleaseEnterKey: .asciiz "Please enter key: "
pleaseEnterValue: .asciiz "Please enter value: "
endl: .asciiz "\n"
dashWithSpace: .asciiz " - "
simpleDash: .asciiz "-"
askListSize: .asciiz "\n Please Enter List Size: \n"
prompt1: .asciiz " \n Please enter: 1 - create linked list, 0 - exit \n"
sizePrompt: .asciiz " Size: "

.text
main:
sw $zero,globalNodeKeyArraySize($zero)

jal initMenu

#move $a0,$s0
#jal createLinkedList
#move $s1,$v0 #head node address

#move $a0,$s1
#move $a1,$s0
#jal printList

#la $a0,globalNodeKeyArray
#la $a1,globalNodeValueArray
#lw $a2,globalNodeKeyArraySize($zero)
#jal createLinkedListFromTwoArraysOfSameSize

#move $a0,$v0
#lw $a1,globalNodeKeyArraySize($zero)
#jal printList

#la $a0,globalNodeKeyArray
#lw $a1,globalNodeKeyArraySize($zero)
#jal printArray

li $v0,10
syscall


initMenu: #uses s0,s1,
# STACK SAVE
addi	$sp, $sp, -16
sw	$s0, 0($sp)
sw	$s1, 4($sp)
sw	$ra, 8($sp)
sw	$s2, 12($sp)
#--------------------------
li $s0,-1 #users choice
li $s1,0 #list size

menuLoop:
li $v0,4
la $a0,prompt1
syscall

li $v0,5
syscall

move $s0,$v0

beq $s0,0,exitMenuAndClose
beq $s0,1,createListThing

createListThingComplete:
j menuLoop

createListThing:
li $s0,-1

li $v0,4
la $a0,askListSize
syscall

li $v0,5
syscall
move $s1,$v0 #list size

move $a0,$s1
jal createLinkedList
move $s2,$v0 #head node address

move $a0,$s2
move $a1,$s1
jal printList

la $a0,globalNodeKeyArray
la $a1,globalNodeValueArray
lw $a2,globalNodeKeyArraySize($zero)
jal createLinkedListFromTwoArraysOfSameSize

move $a0,$v0
lw $a1,globalNodeKeyArraySize($zero)
jal printList

j createListThingComplete

exitMenuAndClose:
#--------------------------
# STACK RELOAD
lw	$s0, 0($sp)
lw	$s1, 4($sp)
lw	$ra, 8($sp)
lw	$s2, 12($sp)
addi	$sp, $sp, 16

jr $ra



#-----------------
#-----------------
#-----------------
# a0 size of list
# returns v0, head node address
createLinkedList: #uses s0,s1,s2,s3,s4,s5,s6
#STACK SAVE
addi	$sp, $sp, -32
sw	$s0, 0($sp)
sw	$s1, 4($sp)
sw	$s2, 8($sp)
sw	$s3, 12($sp)
sw	$s4, 16($sp)
sw 	$ra, 20($sp)
sw 	$s5, 24($sp)
sw 	$s6, 28($sp)
#------------------------
	move $s0,$a0  #size of list

	# make head node
	li	$v0, 9
	li	$a0, 12
	syscall
	
	move $s1,$v0  #store head node address
	move $s4, $v0 #copy of head node address
	
	li $s2,0 #node counter
	
	# Get head node key and value ??
	li $v0,4
	la $a0,pleaseEnterKey
	syscall

	li $v0,5
	syscall
	
	sw $v0,0($s1)
	
	sw $v0,globalNodeKeyArray($zero)
	li $t0,1
	sw $t0,globalNodeKeyArraySize($zero)
	

	li $v0,4
	la $a0,pleaseEnterValue
	syscall

	li $v0,5
	syscall

	sw $v0,4($s1)
	sw $v0,globalNodeValueArray($zero)

subi $s0,$s0,1 # head node count fix
addNodeLoop:
beq $s0,$s2,endAddNodeLoop
 # allocate spce for node
	li	$v0, 9
	li	$a0, 12
	syscall

move $s3,$v0 # s3 now has temp node address
sw $v0,8($s1) #make previous node point to this new node
move $s1, $v0 # make new node ready for pointing

li $v0,4
la $a0,pleaseEnterKey
syscall

li $v0,5
syscall

sw $v0,0($s3)

move $s5,$v0

li $v0,4
la $a0,pleaseEnterValue
syscall

li $v0,5
syscall

sw $v0,4($s3)
move $s6,$v0

move $a0,$s5
move $a1,$s6
jal addUniqueKeyToArray

addi $s2,$s2,1
j addNodeLoop

endAddNodeLoop:
move $v0,$s4
#-----------------
#STACK RELOAD
lw	$s0, 0($sp)
lw	$s1, 4($sp)
lw	$s2, 8($sp)
lw	$s3, 12($sp)
lw	$s4, 16($sp)
lw 	$ra, 20($sp)
lw 	$s5, 24($sp)
lw	$s6, 28($sp)
addi	$sp, $sp, 32

jr $ra


#-----------------
#-----------------
#-----------------
# a0 array 1 address, a1 array 2 address, a2 size
createLinkedListFromTwoArraysOfSameSize: #uses s0,s1,s2,s3,s4,s5,s6

#STACK SAVE
addi	$sp, $sp, -28
sw	$s0, 0($sp)
sw	$s1, 4($sp)
sw	$s2, 8($sp)
sw	$s3, 12($sp)
sw	$s4, 16($sp)
sw 	$s5, 20($sp)
sw	$s6, 24($sp)
#-----------------
move $s0,$a0 # array address 1
move $s1,$a1 # array address 2
move $s2,$a2 #size

# make head node
li	$v0, 9
li	$a0, 12
syscall
	
move $s3,$v0  #store head node address
move $s4, $v0 #copy of head node address

lw $t0,globalNodeKeyArray($zero)
lw $t1,globalNodeValueArray($zero)

sw $t0,0($s3) #store head key
sw $t1,4($s3) #store head value

subi $s2,$s2,1 # head node count fix
addi $s0,$s0,4 # array siz fix
addi $s1,$s1,4

li $s5,0 #counter
arrayToListLoop:
beq $s5,$s2,exitarrayToListLoop

lw $t0,0($s0) # loop key
lw $t1,0($s1) # loop value

 # allocate space for  NEW node
li	$v0, 9
li	$a0, 12
syscall

move $s6,$v0 # s6 now has temp node address
sw $v0,8($s3) #make previous node point to this new node
move $s3, $v0 # make new node ready for pointing

sw $t0,0($s3)
sw $t1,4($s3)


addi $s5,$s5,1
addi $s0, $s0, 4
addi $s1, $s1, 4
j arrayToListLoop

exitarrayToListLoop:
move $v0,$s4
#STACK RELOAD
lw	$s0, 0($sp)
lw	$s1, 4($sp)
lw	$s2, 8($sp)
lw	$s3, 12($sp)
lw	$s4, 16($sp)
lw 	$s5, 20($sp)
lw	$s6, 24($sp)
addi	$sp, $sp, 28
#-----------------
jr $ra



#-----------------
#-----------------
#-----------------
# a0 address of head node , a1 list size
#--------------------------------
printList: #uses s0,s1,s2,s3,s5,s6
#STACK SAVE
addi	$sp, $sp, -24
sw	$s0, 0($sp)
sw	$s1, 4($sp)
sw	$s2, 8($sp)
sw	$s3, 12($sp)
sw	$s5, 16($sp)
sw	$s6, 20($sp)
#------------------------
move $s0,$a0 #address of current node
move $s6,$a1 #size
li $s5,0 #counter

li $v0,4
la $a0,endl
syscall

li $v0,4
la $a0,sizePrompt
syscall

li $v0,1
move $a0,$s6,
syscall

li $v0,4
la $a0,endl
syscall


printLoop:
beq $s6,$s5,endPrintLoop

lw $s1,8($s0) #address of next node
lw $s2, 0($s0) #key of node
lw $s3, 4($s0) #value of node

li $v0,1
move $a0,$s2
syscall

li $v0, 4
la $a0, dashWithSpace
syscall

li $v0, 1
move $a0, $s3
syscall

li $v0, 4
la $a0, dashWithSpace
syscall

li	$v0, 34
move	$a0, $s0 # current node address
syscall

li $v0, 4
la $a0, dashWithSpace
syscall

li	$v0, 34
move	$a0, $s1 # next node address
syscall

li $v0,4
la $a0,endl
syscall

add $s5,$s5,1
move $s0,$s1 #move to next node
j printLoop

endPrintLoop:
#STACK SAVE
lw	$s0, 0($sp)
lw	$s1, 4($sp)
lw	$s2, 8($sp)
lw	$s3, 12($sp)
lw	$s5, 16($sp)
lw	$s6, 20($sp)
addi	$sp, $sp, 24
#------------------------
li $v0,4
la $a0,endl
syscall
jr $ra


#-----------------
#-----------------
#-----------------
# a0 key to add , a1 value
addUniqueKeyToArray: #uses s0,s1,s2,s3,s4,s5
#STACK SAVE
addi	$sp, $sp, -28
sw	$s0, 0($sp)
sw	$s1, 4($sp)
sw	$s2, 8($sp)
sw	$s3, 12($sp)
sw	$s4, 16($sp)
sw	$s5, 20($sp)
sw	$ra, 24($sp)
#------------------------
move $s0,$a0 #key
move $s5,$a1 #value
lw $s1,globalNodeKeyArraySize($zero) #size
li $s2,0 #counter
li $s3,0 #pointer


keyLoop:
lw $s4, globalNodeKeyArray($s3)
beq $s0,$s4,duplicateFound
beq $s1,$s2,duplicateNOTFound

addi $s2,$s2,1
addi $s3,$s3,4
j keyLoop

duplicateFound:

move $a0,$s0
move $a1,$s5
jal addUpvalues 

#STACK RELOAD
lw	$s0, 0($sp)
lw	$s1, 4($sp)
lw	$s2, 8($sp)
lw	$s3, 12($sp)
lw	$s4, 16($sp)
lw	$s5, 20($sp)
lw	$ra, 24($sp)
addi	$sp, $sp, 28
#------------------------
jr $ra

duplicateNOTFound:
sw $s0, globalNodeKeyArray($s3)
sw $s5,globalNodeValueArray($s3)
add $s1,$s1,1
sw $s1,globalNodeKeyArraySize($zero)
#STACK RELOAD
lw	$s0, 0($sp)
lw	$s1, 4($sp)
lw	$s2, 8($sp)
lw	$s3, 12($sp)
lw	$s4, 16($sp)
lw	$s5, 20($sp)
lw	$ra, 24($sp)
addi	$sp, $sp, 28
#------------------------
jr $ra


#-----------------
#-----------------
#-----------------
# a0 key, a1 value
addUpvalues: #uses s0,s1,s2,s3,s4,s5
#STACK SAVE
addi	$sp, $sp, -28
sw	$s0, 0($sp)
sw	$s1, 4($sp)
sw	$s2, 8($sp)
sw	$s3, 12($sp)
sw	$s4, 16($sp)
sw	$s5, 20($sp)
sw	$ra, 24($sp)
#-----------------------
move $s0,$a0 #key
move $s1,$a1 #value
lw $s2,globalNodeKeyArraySize($zero)
li $s3,0 #counter
li $s4,0 #pointer

addLoop:
lw $s5,globalNodeKeyArray($s4)
beq $s3,$s2,exitAddLoop
beq $s0,$s5,addValueAtThisKey

addi $s3,$s3,1
addi $s4,$s4,4
j addLoop

addValueAtThisKey:
lw $s5,globalNodeValueArray($s4)
add $s5,$s5,$s1
sw $s5,globalNodeValueArray($s4)
#STACK RELOAD
lw	$s0, 0($sp)
lw	$s1, 4($sp)
lw	$s2, 8($sp)
lw	$s3, 12($sp)
lw	$s4, 16($sp)
lw	$s5, 20($sp)
lw	$ra, 24($sp)
addi	$sp, $sp, 28
#-----------------------

jr $ra

exitAddLoop:
#STACK RELOAD
lw	$s0, 0($sp)
lw	$s1, 4($sp)
lw	$s2, 8($sp)
lw	$s3, 12($sp)
lw	$s4, 16($sp)
lw	$s5, 20($sp)
lw	$ra, 24($sp)
addi	$sp, $sp, 28
#-----------------------
jr $ra

#-----------------
#-----------------
#-----------------


# a0 - starting address
# a1 - size
printArray: #uses s0,s1,s2
#STACK SAVE
addi	$sp, $sp, -16
sw	$s0, 0($sp)
sw	$s1, 4($sp)
sw	$s2, 8($sp)
sw	$s3, 12($sp)
#------------------------
move $s0,$a0 #starting address
move $s1,$a1 #size
li $s2,0 #counter
li $s3,0 #pointer

otherLoop:
beq $s2,$s1, endotherLoop

li $v0,1
lw $a0, globalNodeKeyArray($s3)
syscall

li $v0,4
la $a0,simpleDash
syscall

li $v0,1
lw $a0,globalNodeValueArray($s3)
syscall

li $v0,4
la $a0,dashWithSpace
syscall

addi $s2,$s2,1
addi $s0,$s0,4
addi $s3,$s3,4
j otherLoop

endotherLoop:
#STACK RELOAD
lw	$s0, 0($sp)
lw	$s1, 4($sp)
lw	$s2, 8($sp)
lw	$s4, 12($sp)
addi	$sp, $sp, 16
#------------------------
li $v0,4
la $a0,endl
syscall
jr $ra
