; -------------------------------------------
;   printNum.s - Robert Flitney - 27/9/2021
;   Dependencies: remDiv.s
; -------------------------------------------

.text
.align 2
.global printNum

; ------------------------------------------
;   printNum
;       Input:
;           X0 = num
;       Output:
;           prints num as a base 10 string
;       Destroys:
;           X0, X1, X2, X16
; ------------------------------------------

printNum: ; X0 = num
    str     lr, [sp, #-16]! ; push lr

    cmp     X0, #10
    blt     printNum_skip   ; if(X0(in) >= 10) {
    mov     X1, #10         ;   X1(10) = 10
    bl      remDiv          ;   X0(rem), X1(div) = remDiv(X0(in), X1(10))
    str     X0, [sp, #-16]! ;   push X0(rem)
    mov     X0, X1          ;   X0(div) = X1(div)
    bl      printNum        ;   printNum(X0(div))
    ldr     X0, [sp], #16   ;   pop X0(rem)
printNum_skip:              ; }
    adrp    X1, digits@PAGE         ; find page
    add     X1, X1, digits@PAGEOFF  ; add string offset in page
    add     X1, X1, X0              ; add char offset in string

    mov     X0, #1  ; stdout
    mov     X2, #1  ; 1 char
    mov     X16, #4
    svc     0               ; putchar('0' + X0(in/rem))

    ldr     lr, [sp], #16   ; pop lr
    ret                     ; return


.data

digits:
    .ascii "0123456789"
