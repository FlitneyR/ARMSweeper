; ---------------------------------------------
;   makeBoard.s - Robert Flitney - 30/09/2021
; ---------------------------------------------

.text
.align 2

.global makeBoard
; ----------------------------------------------------
;   makeBoard
;   Input:
;       R0 - pointer to board
;   Output:
;       None
;   Side effects:
;       board gets initialised to pseudorandom state
;   Destroys:
; ----------------------------------------------------
makeBoard:
    str     lr, [sp, #-16]!



    ldr     lr, [sp], #16
    ret