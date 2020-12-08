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
	add $t2, $ra, $zero
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
