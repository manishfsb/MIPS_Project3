.data
invalid: .asciiz "NaN"
reply:	.space 10

.text
main:	li $v0, 8
	la $a0, reply
	li $a1, 11
	syscall
	
	addi $sp, $sp, -1
	lb $sp, 0($a0)

	li $v0, 1
	move $a0, 0($sp)
	syscall


End:	li $v0, 10 
	syscall	