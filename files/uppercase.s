.section .data

.equ OPEN, 5
.equ WRITE, 4
.equ READ, 3
.equ CLOSE, 6
.equ EXIT, 1

.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101

.equ LINUX_SYSCALL, 0x80
.equ END_OF_FILE, 0

.section .bss
.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text

.equ ST_SIZE_RESERVE, 8
.equ ST_FD_IN, 0
.equ ST_FD_OUT, 4
.equ ST_ARGC, 8
.equ ST_ARGV_0, 12
.equ ST_ARGV_1, 16
.equ ST_ARGV_2, 20

.globl _start

_start:
    subl $ST_SIZE_RESERVE, %esp
    movl %esp, %ebp

open_files:
open_fd_in:
    movl ST_ARGV_1(%ebp), %ebx
    movl $O_RDONLY, %ecx
    movl $0666, %edx
    movl $OPEN, %eax
    int $LINUX_SYSCALL

store_fd_in:
    movl %eax, ST_FD_IN(%ebp)

open_fd_out:
    movl ST_ARGV_2(%ebp), %ebx
    movl $O_CREAT_WRONLY_TRUNC, %ecx
    movl $0666, %edx
    movl $OPEN, %eax
    int $LINUX_SYSCALL

store_fd_out:
    movl %eax, ST_FD_OUT(%ebp)

read_loop_begin:
    movl ST_FD_IN(%ebp), %ebx
    movl $BUFFER_DATA, %ecx
    movl $BUFFER_SIZE, %edx
    movl $READ, %eax
    int $LINUX_SYSCALL

    cmpl $END_OF_FILE, %eax
    jle end_loop

continue_read_loop:
    pushl $BUFFER_DATA
    pushl %eax
    call convert_to_upper
    popl %eax
    popl %ebx

    movl ST_FD_OUT(%ebp), %ebx
    movl $BUFFER_DATA, %ecx
    movl %eax, %edx
    movl $WRITE, %eax
    int $LINUX_SYSCALL

    jmp read_loop_begin

end_loop:
    movl ST_FD_OUT(%ebp), %ebx
    movl $CLOSE, %eax
    int $LINUX_SYSCALL

    movl ST_FD_IN(%ebp), %ebx
    movl $CLOSE, %eax
    int $LINUX_SYSCALL

    movl $0, %ebx
    movl $EXIT, %eax
    int $LINUX_SYSCALL


.equ LOWERCASE_A, 'a'
.equ LOWERCASE_Z, 'z'
.equ UPPER_CONVERSION, 'A' - 'a'

.equ ST_BUFFER_LEN, 8
.equ ST_BUFFER, 12

convert_to_upper:
    pushl %ebp
    movl %esp, %ebp

    movl ST_BUFFER(%ebp), %eax
    movl ST_BUFFER_LEN(%ebp), %ebx
    movl $0, %edi

    cmpl $0, %ebx
    je end_convert_loop

convert_loop:
    movb (%eax,%edi,1), %cl

    cmpb $LOWERCASE_A, %cl
    jl next_byte
    cmpb $LOWERCASE_Z, %cl
    jg next_byte

    addb $UPPER_CONVERSION, %cl
    movb %cl, (%eax,%edi,1)

next_byte:
    incl %edi
    cmpl %edi, %ebx
    jne convert_loop

end_convert_loop:
    movl %ebp, %esp
    popl %ebp
    ret
