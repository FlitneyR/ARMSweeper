; ----------------------------------------------
;   printBoard.s - Robert Flitney - 30/09/2021
; ----------------------------------------------

.text
.align 2

.global printBoard
; ----------------------------------------------------------
;   printBoard
;   Input:
;       X0 - pointer to board
;   Output:
;       None
;   Side effects:
;       Representation of board state is printed to stdout
;   Destroys:
; ----------------------------------------------------------
printBoard:
    str     lr, [sp, #-16]!

    

    ldr     lr, [sp], #16
    ret