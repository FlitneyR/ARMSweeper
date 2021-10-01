; -------------------------------------------
;   readInt.s - Robert Flitney - 30/09/2021
;   Dependencies: INTerp.s
; -------------------------------------------

.text
.align 2

.extern INTerp

.global readInt
; ------------------------------------------------------
;   readInt
;   Input:
;       None
;   Output:
;       X0 - numeric value of number entered via stdin
; ------------------------------------------------------
readInt:
    str     lr, [sp, #-16]!
    str     X19, [sp, #-16]!
    str     X20, [sp, #-16]!


    adrp    X19, buff@PAGE
    add     X19, X19, buff@PAGEOFF
    adrp    X20, buffEnd@PAGE
    add     X20, X20, buffEnd@PAGEOFF

    mov     X0, #1
    mov     X1, X19
    sub     X2, X20, X19
    mov     X16, #3
    svc     0

    mov     X0, X19
    bl      INTerp      ;   num(X0) = INTerp(&buff)


    ldr     X20, [sp], #16
    ldr     X19, [sp], #16
    ldr     lr, [sp], #16
    ret

.data

buff:
    .skip 32

buffEnd: