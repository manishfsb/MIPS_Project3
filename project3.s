.data
invalid: .asciiz "NaN"
reply:	.space 10

.text
main:	li $v0, 8
	la $a0, reply
	li $a1, 11
	syscall
	
		