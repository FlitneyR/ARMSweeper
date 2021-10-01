; -----------------------------------------
;   remDiv.s - Robert Flitney - 27/9/2021
; -----------------------------------------

.text
.align 2

.global remDiv

; ----------------------------
;   remDiv
;       Input:
;           X0 - Enumerator
;           X1 - Denominator
;       Output:
;           X0 - E % D
;           X1 - E // D
;       Destroys:
;           X2, X3, X4
; ----------------------------

remDiv: ; X0 <- X0 % X1, X1 <- X0 // X1
    cmp     X1, #0
    beq     remDiv_while3_end

    mov     X2, #1          ; X2(n) = 1
    mov     X3, #0          ; X3(o) = 0
    mov     X4, #1          ; X4(x) = 1

remDiv_while1_start:        ; while(X2(n) <= X1(d)){
    cmp     X2, X1
    bgt     remDiv_while1_end
    
    lsl     X2, X2, #1      ;   X2(n) <<= 1
    
    b       remDiv_while1_start
remDiv_while1_end:          ; }

    lsr      X2, X2, #1     ; X2(n) >>= 1

remDiv_while2_start:        ; while(X1(d) < X0(e)){
    cmp     X1, X0
    bge     remDiv_while2_end

    lsl     X1, X1, #1      ;   X1(d) <<= 1
    lsl     X4, X4, #1      ;   X4(x) <<= 1

    b remDiv_while2_start
remDiv_while2_end:          ; }

remDiv_while3_start:        ; while(X1(d) >= X2(n)){
    cmp     X1, X2
    blt     remDiv_while3_end

    cmp     X1, X0
    bgt     remDiv_if1_skip ;   if(X1(d) <= X0(e)){
    sub     X0, X0, X1      ;       X0(e) -= X1(d)
    add     X3, X3, X4      ;       X3(o) += X4(x)
remDiv_if1_skip:            ;   }
    lsr     X1, X1, #1      ;   X1(d) >>= 1
    lsr     X4, X4, #1      ;   X4(x) >>= 1

    b remDiv_while3_start
remDiv_while3_end:          ; }
    mov     X1, X3

    ret                     ; return
