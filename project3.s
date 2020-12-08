.data
invalid: .asciiz "NaN"
reply:	.space 10

.text
main:	li $v0, 8
	la $a0, reply
	li $a1, 11
	syscall
	
	la $s1, reply
	li $s3, 1
	
Loop1:	lb $s2, 0($s1)
	addi $sp, $sp, -1
	sb $s2, 0($sp)

Check:	beq $s3, 10, Call1
	
	addi $s3, $s3, 1
	addi $s1, $s1, 1
	j Loop1
	
Call1:	jal Sub1

Sub1:	
Loop3:	lb $t0, 0($sp)
	addi $fp, $sp, -1
	addi $sp, $sp, 1
	bne $t0, 44, Loop3
	
Call2:	add $t1, $ra, $zero
	jal Sub2
	
Sub2:
	lb $a0, 0($fp)
	
First:	blt $a1, $s4, Sub						#this branch checks if we're done removing leading spaces, then we check for just the four characters which might or might not be valid						
	lb $a0, 0($a1)

LoopA:
	beq $a0, 32, After2 
	beq $a0, 9, After2
	beq $a0, 0, After2						#Checking for space, tab, null and enter as only leading and trailing white spaces
	beq $a0, 10, After2
	
	beq $t2, 1, invalid
	
	li $t2, 1							#Changing the register to 1 to indicate we have reached our first valid character
	la $t3, 0($a1)							#storing the address and moving address to t3 to later remember where we should start scanning 4 characters from
	addi $a1, $a1, -4						#once we reach the first valid character, we only care about the leading white spaces, we skip the next four characters because they will be filtered in our subprogram
	j First

After2:	
	addi $a1, $a1, -1
	j First

Sub:	beq $t2, $zero, invalid						#if we haven't found a valid character while scanning through all leading and trailing white spaces, instead of proceeding to calculation, we go to the invalid branch
	
	lb $a0, 0($t3)							#Load the character to $a0 and go to filter to check if it's invalid or a lowercase, uppercase or a number
	j Filter
									
After:	blt $t3, $s4, return						#checking if t3 is less than s4 which is the address of the first character, at which point we return out of the program 
	addi $t3, $t3, -1						#decrementing by 1 as we are iterating from the back
	j Sub

Base:	mult $s6, $s5							#keep on multiplying s6 by our base to calculate the total value correctly, equivalent to t6 = t6 * t5 in high level languages
	mflo $s6
	j After								

After1:	beq $t3, $s4, return						#if the white space characters are either the first or last character, we don't check further. If they're not, we check left and right to see if they're invalid
	addi $t1, $t1, 1
	beq $t1, 4, return						
									
	beq $t0, $zero, After
	lb $a0, -1($t3)

	beq $a0, 32, After 
	beq $a0, 9, After
	beq $a0, 0, After						#Checking for space, tab, null, enter and if they are in between valid characters, if not we just move to next character
	beq $a0, 10, After
	j invalid					
	
Filter:	
	beq $a0, 32, After1 
	beq $a0, 9, After1
	beq $a0, 0, After1						#Checking for space, tab, null and enter
	beq $a0, 10, After1						

	
	
	add $t2, $ra, $zero						#t2 stores return address to go back to subprogram 1
	jal Sub3
	
	
	
	
Sub3:

	blt $a0, 48, invalid						
	bgt $a0, 115, invalid 
	
	bge $a0, 97, Lower						#checking if characters are valid in our base system, if they are, they will go to the respective branches	
	bgt $a0, 83, invalid
	bgt $a0, 64, Upper
	bgt $a0, 57, invalid
	bge $a0, 48, numeric
							
numeric:li $s7, -48
	j Common							# - 48 in s2 because 0 has value 0 in our base system
							
Lower:	li $s7, -87							# - 87 in s2 because a has value 10 in our base system
	j Common

Upper:	li $s7, -55							# - 55 in s2 because A has value 10 in our base system
			
Common:	add $a0, $a0, $s7
	move $v0, $a0
	j return						#finding the value of the character

invalid:li $v0, -1							#in case, any of the characters are invalid, we store -1 in v1 and later check if it is -1 in print label

return:								#total value of the characters, if valid stored in s0, moved to v0 to return to our subprogram.
	jr $ra								#return to the next line after where we call our program

End:	li $v0, 10 
	syscall	
