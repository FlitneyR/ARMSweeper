; ----------------------------------------
;   print.s - Robert Flitney - 27/9/2021
; ----------------------------------------

.text
.align 2

.global print
.global println

; -----------------------------------
;   print
;       Input:
;           X0 = pointer to string
;       Output:
;           prints string to stdout
;       Destroys:
;           X0, X1, X2, X16
; -----------------------------------

print:
    mov     X1, X0          ; X1 = arg0 = &string
    sub     X2, X1, #1      ; X2 = &string - 1

print_count_loop:
    ldrb    W0, [X2, #1]!   ; X3 = *(++X2)
    cmp     W0, #0          ; if(X3 == 0) break;
    bne     print_count_loop

    sub     X2, X2, X1      ; X2 = X2 - &string = length of string
    mov     X0, #1
    mov     X16, #4         ; X16 = 4 = print
    svc     0               ; print

    ret


; -----------------------------------
;   println
;       Input:
;           None
;       Output:
;           prints a new line to stdout
;       Destroys:
;           X0, X1, X2, X16
; -----------------------------------

println:
    str     lr, [sp, #-16]!
    adrp    X0, newLine@PAGE
    add     X0, X0, newLine@PAGEOFF
    bl      print
    ldr     lr, [sp], #16
    ret

.data

newLine:
    .asciz "\n"