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
	la $t1, $sp
	addi $sp, $sp, 1
	bne $t0, 44, Loop3
	
Call2:	
	jal Sub2

	
	
End:	li $v0, 10 
	syscall	
