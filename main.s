; -------------------------------------------
;   main.s
;   Dependencies:
;       makeBoard.s, printBoard.s
;       printNum.s, remDiv.s, readInt.s
;       INTerp.s
; -------------------------------------------

.text
.align 2

.global _main
_main:
    str     lr, [sp, #-16]!

    adrp    X19, board@PAGE
    add     X19, X19, board@PAGEOFF

    adrp    X0, seedPrompt@PAGE
    add     X0, X0, seedPrompt@PAGEOFF
    bl      print
    bl      readInt
    mov     X1, X0
    mov     X0, X19
    bl      makeBoard   ;   makeBoard(&board)

    mov     X0, X19
    bl      printBoard

    ldr     lr, [sp], #16
    ret

.data
board:
    .skip 100

seedPrompt:
    .asciz "Enter a seed for this game: "