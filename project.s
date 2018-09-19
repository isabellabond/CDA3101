# Isabella Bond
# CDA 3101 Recursion 
# 5/28/18

# convert a recursive C function that sums the odd numbers in an array into MIPS instructions 
# should return "The result is 253"

.data
	arr: .word 89, 19, 29, 2, 7, 14, 22, 13, 5, 91  # create an array called arr with 10 assigned integers 
	size: .word 10 									# store the size of the array (10)						    
	resultMessage: .asciiz "\nThe result is " 		# message that is displayed before the result
	finalSum: .word 0								# stores the resulting value that will be returned

.text
.globl main
main:

	# print the result message
	li $v0, 4										# load system call to print a string into $v0
	la $a0, resultMessage						    # load the address of the result message into $a0
	syscall											# print to console

	# store in $a registers becuase they are arguments
	la $a0, arr        		               		    # copy RAM address of arr into register $a0
	lw $a1, size        		                    # store the size of the array arr into register $a1

	jal sumOdd										# jump and link to the function sumOdd

	sw $v0, finalSum     							# store the returned value in resultMessage so that it can be printed to the console

	li $v0, 1										# load system call to print an integer into $v0
	lw $a0, finalSum     							# copy RAM address of finalSum into register $a0
	syscall											# print to console
	
	li $v0, 10										# exit the program
	syscall 

# handles the odd elements of the arary (if it is even it will move to the evenSum function)
sumOdd:
	subu $sp, $sp, 8								# adjust the stack to store two items
	sw $ra, 0($sp)								 	# save the return address to the stack 
	sw $s0, 4($sp)									# save the current odd number to the stack
	
	# base case
	li $v0, 0										# set return value = 0
	beq $a1, $0, sumDone							# if size == 0, call the sumDone function
	
	# get array elements
	li $t0, 0										# set the register $t0 = 0
	li $t1, 0										# set the register $t1 = 0
	add $t0, $a1, $a1								# double the size of the array
	add $t0, $t0, $t0								# double array size again										
	addi $t1, $t0, -4								# subtract 4 from the array size * 4
	add $t2, $t1, $a0								# get the array element by combining array address with element location
	lw $a2, 0($t2)									# load the element into $a2

	# determine whether the element is even or odd
	li $t3, 2       							    # set divisor to 2
    div $a2, $t3									# perform division
    mfhi $t4          						        # save the remainder in $t4
    beq $t4, $0, sumEven			     			# if the remainder is 0 (even num), branch to sumEven

	# recursive step
	move $s0, $a2									# put the odd number in $s0
	subu $a1, $a1, 1								# decrease the size of the array by 1 to access the next element
	jal sumOdd										# jump and link to the sumOdd function
	
	add $v0, $v0, $s0								# update $v0 so that the correct oddSum is printed
	
# when the array size == 0
sumDone:
	lw $ra, 0($sp)									# load return address from the stack
	lw $s0, 4($sp)									# load $s0 from the stack
	addu $sp, $sp, 8								# restore the stack
	jr $ra											# return

# handles an even element in the array
sumEven:
	li $s0, 0										# set the current odd number to 0
	subu $a1, $a1, 1								# decrease the size of the array by 1 to access the next element
	bne $a1, $0, sumOdd 							# as long as the size of the array isn't 0, branch back to sumOdd