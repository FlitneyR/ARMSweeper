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
    str     lr, [sp, #-16]!
    str     X19, [sp, #-16]!
    str     X20, [sp, #-16]!
    str     X21, [sp, #-16]!

tryAgain:

    adrp    X0, columnPrompt@PAGE
    add     X0, X0, columnPrompt@PAGEOFF
    bl      print       ;   print(columnPrompt)
    bl      readInt
    mov     X19, X0     ;   col(X19) = readInt()

    cmp     X0, #0
    blt     invalidInput
    cmp     X0, #9
    bgt     invalidInput

    adrp    X0, rowPrompt@PAGE
    add     X0, X0, rowPrompt@PAGEOFF
    bl      print       ;   print(rowPrompt)
    bl      readInt
    mov     X20, X0     ;   row(X20) = readInt()

    cmp     X0, #0
    blt     invalidInput
    cmp     X0, #9
    bgt     invalidInput


    adrp    X0, changePrompt@PAGE
    add     X0, X0, changePrompt@PAGEOFF
    bl      print       ;   print(changePrompt)

    mov     X0, #1
    adrp    X1, buffer@PAGE
    add     X1, X1, buffer@PAGEOFF
    mov     X2, #32
    mov     X16, #3
    svc     0           ; read(STDIN, &buffer, 32)

    adrp    X0, buffer@PAGE
    add     X0, X0, buffer@PAGEOFF
    ldrb    W21, [X0]

    cmp     X21, 'f'
    beq     validInput
    cmp     X21, 'F'
    beq     validInput
    cmp     X21, 'r'
    beq     validInput
    cmp     X21, 'R'
    beq     validInput

    b       invalidInput

validInput:

    mov     X0, X19
    mov     X1, X20
    mov     X2, X21

    ldr     X21, [sp], #16
    ldr     X20, [sp], #16
    ldr     X19, [sp], #16
    ldr     lr, [sp], #16
    ret

invalidInput:
    adrp    X0, invalidMsg@PAGE
    add     X0, X0, invalidMsg@PAGEOFF
    bl      print
    b       tryAgain


.data

buffer:
    .skip 32

columnPrompt:
    .asciz "Which column would you like to change? "

rowPrompt:
    .asciz "Which row would you like to change? "

changePrompt:
    .asciz "What would you like to do? "

invalidMsg:
    .asciz "That input is invalid\n"
