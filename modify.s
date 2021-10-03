; -----------
;   modify.s
; -----------

.text
.align 2

.global modify

; ------------
;   modify
; ------------
modify:
    str     lr, [sp, #-16]!
    str     X19, [sp, #-16]!
    str     X20, [sp, #-16]!
    str     X21, [sp, #-16]!
    str     X22, [sp, #-16]!

    mov     X19, X0         ;   board(X19) = arg0
    mov     X20, X1         ;   col(X20) = arg1
    mov     X21, X2         ;   row(X21) = arg2
    mov     X22, X3         ;   change(X22) = arg3

    add     X0, X20, X21, lsl 3
    ldrb    W9, [X19, X0]   ;   cell(W9) = board[col + (row << 3)]
    
    

    ldr     X22, [sp], #16
    ldr     X21, [sp], #16
    ldr     X20, [sp], #16
    ldr     X19, [sp], #16
    ldr     lr, [sp], #16
    ret