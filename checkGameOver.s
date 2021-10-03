; -------------------
;   checkGameOver.s
; -------------------

.text
.align 2

.global checkGameOver

; -----------------------------------------------
;   checkGameOver
;   Input:
;       X0 - pointer to board
;   Output:
;       X0 - 1 if win, -1 if lose, 0 if neither
; -----------------------------------------------
checkGameOver:
    mov     X0, #1
    ret