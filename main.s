; ----------------------------------------
;   main.s - Robert Flitney - 30/09/2021
; ----------------------------------------

.text
.align 2

.global _main
_main:
    str     lr, [sp, #-16]!

    adrp    X19, board@PAGE
    add     X19, X19, board@PAGEOFF

    mov     X0, X19
    bl      makeBoard   ;   makeBoard(&board)

    mov     X0, X19
    bl      printBoard

    ldr     lr, [sp], #16
    ret

.data
board:
    .skip 100