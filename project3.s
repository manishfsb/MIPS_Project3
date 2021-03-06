.data
invalid1: .asciiz "NaN"
reply:	.space 10

.text
main:	
	li $s6, 0						#To later use to count how many times we've made space for a word in the stack
	
	li $v0, 8
	la $a0, reply
	li $a1, 11						#Taking input from user
	syscall
	
	la $s1, reply
	addi $s4, $s1, 10
	move $a1, $s1
	
	jal SubP1
	
rStack:	beq $s6, 0, End
	lw $a0, ($sp)
	beq $a0, -1, Nan1
	addi $sp, $sp, 4
	addi $s6, $s6, -1

Total:	li $v0,1
	syscall 

Comma:	li $v0, 11
	li $a0, 44
	syscall
	j rStack

Nan1:	li $v0, 4
	la $a0, invalid1
	syscall
	j Comma
	
End:	li $v0, 10 
	syscall
	
SubP1:	

Loop1:	lb $s2, 0($a1)						#loading first character of string later using to iterate through
	
	beq $s2, 32, Add 
	beq $s2, 9, Add
	beq $s2, 0, Add						#Checking for space, tab, null and enter as only leading white spaces
	beq $s2, 10, Add
	
	add $a2, $a1, $zero						#In case not a leading space, call SubP2 to look for the four characters
	add $t4, $ra, $zero					#t4 stores return address of the first subprogram
	jal SubP2
	
	addi $sp, $sp, -4
	addi $s6, $s6, 1
	sw $v0, ($sp)
	
	jr $t4
									
Add:	addi $a1, $a1, 1					#To iterate through each character
	j Loop1
	
SubP2:	move $a0, $a2
	add $t6, $ra, $zero					#t6 to store ra of subP2 to later return to subP1
	jal Sub3
	
	beq $v0, -1, invalid3					#In case v0 contains -1, it indicates an invalid character was passed
	add $t7, $t7, $v0					#Total of all the valid characters we passed
	
	move $v1, $t7
	j Return2
	
	
invalid3:	
	move $v1, $v0

Return2:	
	jr $t6	
									
	
Sub3:

First:	lb $t5, ($a0)						#Loading the first valid character from the substring

	blt $t5, 48, invalid						
	bgt $t5, 115, invalid 
	
	bge $t5, 97, Lower						#checking if characters are valid in our base system, if they are, they will go to the respective branches	
	bgt $t5, 83, invalid
	bgt $t5, 64, Upper
	bgt $t5, 57, invalid
	bge $t5, 48, numeric
							
numeric:li $s7, -48
	j Common							# - 48 in s2 because 0 has value 0 in our base system
							
Lower:	li $s7, -87							# - 87 in s2 because a has value 10 in our base system
	j Common

Upper:	li $s7, -55							# - 55 in s2 because A has value 10 in our base system
			
Common:	add $t5, $t5, $s7
	move $v0, $t5
	j return							#finding the value of the character

invalid:li $v0, -1							#in case, any of the characters are invalid, we store -1 in v1 and later check if it is -1 in print label

return:									#decimal value of the character, if valid stored in s0, moved to v0 to return to our subprogram.
	jr $ra								#return to the next line after where we call our third subprogram

	
