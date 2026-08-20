.include "linux.s"
.include "record-def.s"

.section .data
input_file_name:
    .ascii "test.dat\0"

output_file_name:
    .ascii "testout.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE

.section .text
.globl _start
_start:
    .equ INPUT_DESCRIPTOR, -4
    .equ OUTPUT_DESCRIPTOR, -8

    movl %esp, %ebp
    subl $8, %esp

    movl $SYS_OPEN, %eax
    movl $input_file_name, %ebx
    movl $0, %ecx
    movl $0666, %edx
    int $LINUX_SYSCALL
    movl %eax, INPUT_DESCRIPTOR(%ebp)

    movl $SYS_OPEN, %eax
    movl $output_file_name, %ebx
    movl $0101, %ecx
    movl $0666, %edx
    int $LINUX_SYSCALL
    movl %eax, OUTPUT_DESCRIPTOR(%ebp)

loop_begin:
    pushl INPUT_DESCRIPTOR(%ebp)
    pushl $record_buffer
    call read_record
    addl $8, %esp

    cmpl $RECORD_SIZE, %eax
    jne loop_end

    incl record_buffer + RECORD_AGE

    pushl OUTPUT_DESCRIPTOR(%ebp)
    pushl $record_buffer
    call write_record
    addl $8, %esp

    jmp loop_begin

loop_end:
    movl $SYS_EXIT, %eax
    movl $0, %ebx
    int $LINUX_SYSCALL
