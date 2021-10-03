; -----------
;   input.s
; -----------

.text
.align 2

.global getInput

; ------------
;   getInput
;   Output:
;       X0 - column to be changed
;       X1 - row to be changed
;       X2 - change to be made
; ------------
getInput:

    ret

.data

columnPrompt:
    .asciz "Which column would you like to change? "

rowPrompt:
    .asciz "Which row would you like to change? "

changePrompt:
    .asciz "What would you like to do? "
