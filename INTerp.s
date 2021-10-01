; ------------------------------------------
;   INTerp.s - Robert Flitney - 27/9/2021
;   Dependencies: remDiv.s
; ------------------------------------------

.text
.align 2

.global INTerp
; -------------------------------------------
;   INTerp
;       Input:
;           X0 - pointer to string
;       Output:
;           X0 - value of string in base 10
;       Destroys:
;           X1, X2
; -------------------------------------------
INTerp:
    str     lr, [sp, #-16]! ; push lr

    mov     X1, #0
INTerp_loop_start:
    ldrb    W2, [X0]
    sub     X2, X2, '0'
    
    cmp     X2, #0
    blt     INTerp_loop_end
    cmp     X2, #9
    bgt     INTerp_loop_end

    add     X1, X1, X1, lsl #2 ; X1 += X1 * 4
    lsl     X1, X1, #1         ; X1 *= 2

    add     X1, X1, X2
    add     X0, X0, #1
    b       INTerp_loop_start
INTerp_loop_end:
    mov     X0, X1

    ldr     lr, [sp], #16   ; pop lr
    ret                     ; return