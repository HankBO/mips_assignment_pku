.data
    buf: .space 100
    suc: .asciiz "\nSuccess! Location: "
    fai: .asciiz "\nFail!\n"
    endline: .asciiz "\r\n"
    
.text
.globl main

.macro linebreak
	la $a0,endline
	li $v0,4
	syscall
.end_macro

main:
    linebreak
    la $a0, buf
    li $a1, 100
    li $v0, 8
    syscall
    
inputchar:
    li $v0,12
    syscall
    beq,$v0,'?',exit
    add $t1,$v0,$0 # the value of input char
    add $t2,$0,$0 # mark the position in string
    la $s1, buf # $s1 should be initialized when inputting each time
    
find_loop:
    lb $s0, 0($s1)
    beq $t1,$s0 success
    
    # confirm the existence of next char
    addi $t2,$t2,1
    slt $t3,$t2,$a1 # t3 =1 if t2 is smaller than $a1(the length of string)
    beq $t3,0,fail
    # shift to address of next char
    addi $s1,$s1,1
    j find_loop

success:
    la $a0,suc
    li $v0,4
    syscall
    # print the location
    addi $a0, $t2, 1
    li $v0,1
    syscall
    
    linebreak
    j inputchar
fail:
    la $a0,fai
    li $v0,4
    syscall
    j inputchar
    
exit:
    li $v0,10
