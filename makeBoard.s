; --------------------------
;   makeBoard.s
;   Dependencies: random.s
; --------------------------

#define END_OF_ROW 128
#define REVEALED 64
#define FLAGGED 32
#define BOMB 16
#define COUNT 15

.text
.align 2

.global makeBoard
.global makeCell
.global setCounts

; ----------------------------------------------------
;   makeBoard
;   Input:
;       X0 - pointer to board
;       X1 - seed
;   Output:
;       None
;   Side effects:
;       board gets initialised to pseudorandom state
;   Destroys:
; ----------------------------------------------------
makeBoard:
    str     lr, [sp, #-16]!
    str     X19, [sp, #-16]!
    str     X20, [sp, #-16]!
    str     X21, [sp, #-16]!
    str     X22, [sp, #-16]!
    

    mov     X19, X0                 ;   board(X19) = X0
    mov     X20, X1                 ;   seed(X20) = X1
    mov     X21, #0                 ;   i(X21) = 0
makeBoard_while_start:
    cmp     X21, #64
    bge     makeBoard_while_end
                                    ;   while(i(X21) < 64){
    mov     X0, X20
    bl      random
    mov     X20, X0                 ;       seed(X20) = random(seed(X20))
    bl      makeCell
    mov     X22, X0                 ;       cell(X22) = makeCell(seed(X20))
    and     X0, X21, #7
    cmp     X0, #7
    bne     notEOR                  ;       if(i(X21) % 8 == 7){
    orr     X22, X22, #END_OF_ROW
                                    ;           cell(X22) |= END_OF_ROW
notEOR:                             ;       }
    ; orr     X22, X22, #REVEALED     ;     //  cell(X22) |= REVEALED
    strb    W22, [X19, X21]
                                    ;       board(X19)[i(X21)] = cell(X22)
    add     X21, X21, #1            ;       i(21)++
    b       makeBoard_while_start
makeBoard_while_end:                ;   }

    mov     X0, X19
    bl      setCounts

    ldr     X22, [sp], #16
    ldr     X21, [sp], #16
    ldr     X20, [sp], #16
    ldr     X19, [sp], #16
    ldr     lr, [sp], #16
    ret

; ---------------------
;   makeCell
;   Input:
;       X0 - seed
;   Output:
;       X0 - new cell
;   Destroys: X1, X2
; ---------------------
makeCell:
    
    mov     X1, X0          ;   seed(X1) = X0
    mov     X0, #0          ;   cell(X0) = 0
    and     X2, X1, #31
    cmp     X2, #5
    bge     notBomb         ;   if(seed & 31 < 5){
    ORR     X0, X0, #BOMB   ;       cell |= BOMB
notBomb:                    ;   }

    ret

; -----------------------------------------
;   setCounts
;   Input:
;       X0 - pointer to board
;   Output:
;       None
;   Side effects:
;       Board cell counts will be updated
; -----------------------------------------
setCounts:

    mov     X9, X0                  ;   board(X9) = X0
    mov     X10, #0                 ;   y(X10) = 0
setCounts_while1_start:
    cmp     X10, #8
    bge     setCounts_while1_end    ;   while(y(X10) < 8){
    mov     X11, #0                 ;       x(X11) = 0
setCounts_while2_start:
    cmp     X11, #8
    bge     setCounts_while2_end    ;       while(x(X11) < 8){
    add     X0, X11, X10, lsl #3
    ldrb    W12, [X9, X0]           ;           cell(X12) = board(X9)[x(X11) + y(X10) << 3]
    mov     X13, #-1                ;           dy(X13) = -1
    cmp     X10, #0                 ;           if(y(X10) == 0)
    bne     setCounts_while3_start
    add     X13, X13, #1            ;               dy(X13)++
setCounts_while3_start:
    cmp     X13, #2
    bge     setCounts_while3_end
    add     X0, X13, X10
    cmp     X0, #8
    bge     setCounts_while3_end    ;           while(dy(X13) < 2 && dy(13) + y(X10) < 8){
    mov     X14, #-1                ;               dx(X14) = -1
    cmp     X11, #0                 ;               if(x(X11) == 0)
    bne     setCounts_while4_start
    add     X14, X14, #1            ;                   dx(X14)++
setCounts_while4_start:
    cmp     X14, #2
    bge     setCounts_while4_end
    add     X0, X14, X11
    cmp     X0, #8
    bge     setCounts_while4_end    ;               while(dx(X14) < 2 && dx(X14) + x(X11) < 8){
    add     X0, X11, X14
    add     X1, X10, X13
    add     X0, X0, X1, lsl #3
    ldrb    W15, [X9, X0]           ;                   dcell(X15) = board(X9)[x(X11) + dx(X14) + (y(X10) + dy(X13)) << 3]
    add     X14, X14, #1            ;                   dx(X14)++
    and     X0, X15, #BOMB
    cmp     X0, #0                  ;                   if(dcell(X15) & BOMB != 0)
    beq     setCounts_while4_start
    add     X12, X12, #1            ;                       cell(X12)++
    b       setCounts_while4_start
setCounts_while4_end:               ;               }
    add     X13, X13, #1            ;               dy(X13)++
    b       setCounts_while3_start
setCounts_while3_end:               ;           }
    add     X0, X11, X10, lsl #3
    strb    W12, [X9, X0]           ;           board(X9)[x(X11) + y(X10) << 3] = cell(X12)
    add     X11, X11, #1            ;           x(X11)++
    b       setCounts_while2_start
setCounts_while2_end:               ;       }
    add     X10, X10, #1            ;       y(X10)++
    b       setCounts_while1_start
setCounts_while1_end:               ;   }

    ret