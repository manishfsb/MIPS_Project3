.data
invalid1: .asciiz "NaN"
reply:	.space 10

.text
main:	li $v0, 8
	la $a0, reply
	li $a1, 11
	syscall
	
	la $s1, reply
	addi $s4, $s1, 10
	move $a1, $s1
	
	jal SubP1

SubP1:	

Loop1:	lb $s2, 0($a1)						#loading first character of string later using to iterate through
	
	beq $a0, 32, Add 
	beq $a0, 9, Add
	beq $a0, 0, Add						#Checking for space, tab, null and enter as only leading white spaces
	beq $a0, 10, Add
	
	la $a2, $a1						#In case not a leading space, call SubP2 to look for the four characters
	add $t4, $ra, $zero					#t4 stores return address of the first subprogram
	jal SubP2
									
Add:	addi $a1, $a1, 1					#To iterate through each character
	j Loop1
	
SubP2:	move $a0, $a2
	add $t6, $ra, $zero					#t6 to store ra of subP2 to later return to subP1
	jal Sub3
	
	beq $v0, -1, NaN					#In case v0 contains -1, it indicates an invalid character was passed
	addi $t7, $t7, v0					#Total of all the valid characters we passed
	
	move $v1, $t7
	j Return2
	
	
NaN:	move $v1, $v0

Return2:	
	j $t6	
									
First:	la $t5, ($a0)						#Loading the first valid character from the substring
	
Sub3:
	blt $t5, 48, invalid						
	bgt $t5, 115, invalid 
	
	bge $t5, 97, Lower					#checking if characters are valid in our base system, if they are, they will go to the respective branches	
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

return:									#total value of the characters, if valid stored in s0, moved to v0 to return to our subprogram.
	jr $ra									#return to the next line after where we call our program

End:	li $v0, 10 
	syscall	