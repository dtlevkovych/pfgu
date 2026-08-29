.section .data

GNOME_STOCK_BUTTON_YES:
    .ascii "Button_Yes\0"
GNOME_STOCK_BUTTON_NO:
    .ascii "Button_No\0"
GNOME_MESSAGE_BOX_QUESTION:
    .ascii "question\0"

.equ NULL, 0

signal_destroy:
    .ascii "destroy\0"
signal_delete_event:
    .ascii "delete_event\0"
signal_clicked:
    .ascii "clicked\0"

app_id:
    .ascii "gnome-example\0"
app_version:
    .ascii "1.000\0"
app_title:
    .ascii "Gnome Example Program\0"
button_quit_text:
    .ascii "I Want to Quit the GNOME Example Program\0"
quit_question:
    .ascii "Are you sure you want to quit?\0"

.section .bss
.equ WORD_SIZE, 4
.lcomm appPtr, WORD_SIZE
.lcomm btnQuit, WORD_SIZE

.section .text
.globl main
.type main, @function

main:
    pushl %ebp
    movl %esp, %ebp

    pushl 12(%ebp)
    pushl 8(%ebp)
    pushl $app_version
    pushl $app_id
    call gnome_init
    addl $16, %esp

    pushl $app_title
    pushl $app_id
    call gnome_app_new
    addl $8, %esp
    movl %eax, appPtr

    pushl $button_quit_text
    call gtk_button_new_with_label
    addl $4, %esp
    movl %eax, btnQuit

    pushl btnQuit
    pushl appPtr
    call gnome_app_set_contents
    addl $8, %esp

    pushl btnQuit
    call gtk_widget_show
    addl $4, %esp

    pushl appPtr
    call gtk_widget_show
    addl $4, %esp

    pushl $NULL
    pushl $delete_handler
    pushl $signal_delete_event
    pushl appPtr
    call gtk_signal_connect
    addl $16, %esp

    pushl $NULL
    pushl $destroy_handler
    pushl $signal_destroy
    pushl appPtr
    call gtk_signal_connect
    addl $16, %esp

    pushl $NULL
    pushl $click_handler
    pushl $signal_clicked
    pushl btnQuit
    call gtk_signal_connect
    addl $16, %esp

    call gtk_main

    movl $0, %eax
    leave
    ret

destroy_handler:
    pushl %ebp
    movl %esp, %ebp
    call gtk_main_quit
    movl $0, %eax
    leave
    ret

delete_handler:
    movl $1, %eax
    ret

click_handler:
    pushl %ebp
    movl %esp, %ebp

    pushl $NULL
    pushl $GNOME_STOCK_BUTTON_NO
    pushl $GNOME_STOCK_BUTTON_YES
    pushl $GNOME_MESSAGE_BOX_QUESTION
    pushl $quit_question
    call gnome_message_box_new
    addl $16, %esp

    pushl $1
    pushl %eax
    call gtk_window_set_modal
    popl %eax
    addl $4, %esp

    pushl %eax
    call gtk_widget_show
    popl %eax

    pushl %eax
    call gnome_dialog_run_and_close
    addl $4, %esp

    cmpl $0, %eax
    jne click_handler_end
    call gtk_main_quit

click_handler_end:
    leave
    ret
