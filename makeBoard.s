; --------------------------
;   makeBoard.s
;   Dependencies: random.s
; --------------------------

#define END_OF_ROW 128
#define REVEALED 64
#define FLAGGED 32
#define BOMB 16

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
    orr     X22, X22, #REVEALED
    strb    W22, [X19, X21]
                                    ;       board(X19)[i(X21)] = cell(X22)
    add     X21, X21, #1            ;       i(21)++
    b       makeBoard_while_start
makeBoard_while_end:                ;   }

    mov     X0, X19
    bl      setCounts

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
    and     X2, X1, #12
    cmp     X2, #0
    bne     notBomb         ;   if(seed & 12 != 0){
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

    ;   board(X9) = X0
    ;   y(X10) = 0
    ;   while(y(X10) < 8){
    ;       x(X11) = 0
    ;       while(x(X11) < 8){
    ;           cell(X12) = board[x(X11) + y(X10) << 3]
    ;           dy(X13) = -1
    ;           if(y == 0)
    ;               dy++
    ;           while(dy(X13) + y(X10) < 8){
    ;               dx(X14) = -1
    ;               if(x == 0)
    ;                   dx++
    ;               while(dx(X14) + x < 8){
    ;                   dcell(X15) = board[x(X11) + dx(X14) + (y(X10) + dy(X13)) << 3]
    ;                   if(dcell(X15) & BOMB != 0)
    ;                       cell(X12)++
    ;                   dx++
    ;               }
    ;               dy++
    ;           }
    ;           board[x(X11) + y(X10) << 3] = cell(X12)
    ;           x++
    ;       }
    ;       y++
    ;   }

    ret