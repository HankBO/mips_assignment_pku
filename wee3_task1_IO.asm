.data
upper:    .asciiz     #使用asciiz 末尾自动加结束符
"Alpha ","Bravo ","Charlie ","Delta ","Echo ","Foxtrot ","Golf ",
"Hotel ","India ","Juliet ","Kilo ","Lima ","Mike ","November ",
"Oscar ","Papa ","Quebec ","Romeo ","Sierra ","Tango ",
"Uniform ","Victor ","Whisky ","X-ray ","Yankee ","Zulu "

lower:  .asciiz
    "alpha ","bravo ","china ","delta ","echo " ,
    "foxtrot " ,"golf ","hotel ","india ","juliet ",
    "kilo ","lima ","mary ","november ","oscar ",
    "paper ","quebec ","reserach ","sierra ","tango ",
    "uniform ","victor ","whisky ","x-ray ","yankee ",
    "zulu "
num:    .asciiz
    "zero","First","Second","Third","Fourth",
    "Fifth","Sixth","Seventh","Eighth","Ninth"

letter_offset:  .word   0,7,14,23,30,36,45,51,58,65,73,79,85,91,101,108,114,122,129,137,144,153,161,169,176,184
num_offset: .word   0,5,11,18,24,31,37,43,51,58 # accroding to the length of a word string and a ','
endline: .asciiz "\r\n"

.macro linebreak
	la $a0,endline
	li $v0,4
	syscall
.end_macro

.text
.globl main
main:
	
	li $v0, 12
	syscall
	# is ?
	beq $v0,'?', exit
	
	# is other symbols?
	blt $v0,'0', others
	ble $v0,'9', getnum
	blt $v0,'A', others
	ble $v0,'Z', getupper
	blt $v0,'a', others
	ble $v0,'z', getlower
	j others

exit:
	li $v0,10
	syscall

others:
	li $v0, 11
	li $a0, '*'
	syscall
	linebreak
	j main

getnum:
        sub $t0,$v0,'0'
        sll $t0,$t0,2 # binary system: 1 -> 1, shift 2 bits -> 100 -> 4
        la $t1,num_offset
        add $t0,$t0,$t1        
        lw $t0,($t0) # value 7 for 1, value 15 for 2
        
        la $t1,num     # t1 Value is the first address in M
        add $a0,$t0,$t1 # a0 is the address of string for $v0 = 4
        li $v0,4
	syscall
	
	linebreak
	j main
	
getupper:
	sub $t0,$v0,'A'
	sll $t0,$t0,2
	la $t1, letter_offset
	add $t0,$t0,$t1
	lw $t0,($t0)
	la $t1,upper
	add $a0,$t0,$t1
	li $v0,4
	syscall
	linebreak
	j main

getlower:
	sub $t0,$v0,'a'
	sll $t0,$t0,2
	la $t1, letter_offset
	add $t0,$t0,$t1
	lw $t0,($t0)
	la $t1,lower
	add $a0,$t0,$t1
	li $v0,4
	syscall
	linebreak
	j main
