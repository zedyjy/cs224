################################################################
#calculation
#CS224
#Lab No: 01
#Section No: 04
#Zeynep Doða Dellal
#22002572
#6.10.2023
################################################################ 
##
## Program1.asm - prints out "hello world"
##
##	a0 - points to the string
##

#################################
#					 	#
#		text segment		#
#						#
#################################

	.text		


# execution starts here
	la $a0, n1	# put string address into a0
	lw $a1, n1	# put string address into a0
	beq $a1, $a0, done
	bne $a1, $a0, done1
	
done:

done1:

#################################
#					 	#
#     	 data segment		#
#						#
#################################

	.data
str:	.asciiz "hello Onur\n"
n1:	.word	10
n2:	.word	11

##
## end of file Program1.asm

