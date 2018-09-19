# Isabella Bond
# CDA 3101 Factorial

.data 
	promptMsg:	.asciiz "Entger a number to find its factorial: "
	resultMsg:	.asciiz "The result is "
	number:		.word   0
	answer:		.word   0

.text    #where code session starts
main: 
	#print the prompt message
	li $v0, 4
	la $a0, promptMsg
	syscall

	#read user's input 
	li $v0, 5
	syscall

	sw $v0, number      #store the input value into number

	#call the factorial function
	lw 	$a0, number
	jal fact 
	sw  $v0, answer     #returned value is stored in $v0

	#display the result
	li	$v0, 4
	la	$a0, resultMsg
	syscall

	li	$v0, 1
	lw  $a0, answer
	syscall

	#tell the os this is the end
	li $v0, 10
	syscall

#find factorial function
fact: 
	subu $sp, $sp, 8       #make space on the stack
	sw	 $ra, 0($sp)
	sw	 $s0, 4($sp)       #all values are stored 4 bytes apart

	#base case
	li $v0, 1			#return value = 1
	beq $a0, 0, factorialDone

	#recursive step
	#fact(number -1)
	move $s0, $a0
	subu  $a0, $a0, 1
	jal  fact

	mul $v0, $s0, $v0

factorialDone:
	#restore value from the stack
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addu $sp, $sp, 8

	jr $ra    #return