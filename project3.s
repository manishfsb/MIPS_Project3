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

	lb $a0, 0($sp)
	addi $sp, $sp, 1
	
Check:	beq $s3, 4, End
	
	addi $s3, $s3, 1
	addi $s1, $s1, 1
	j Loop1
	
End:	li $v0, 10 
	syscall	
