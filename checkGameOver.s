; -------------------
;   checkGameOver.s
; -------------------

#define END_OF_ROW 128
#define REVEALED 64
#define FLAGGED 32
#define BOMB 16
#define COUNT 15

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

    mov     X9, X0                      ;   board(X9) = arg0(X0)
    mov     X10, #0                     ;   i(X10) = 0
    mov     X11, #1                     ;   allFound(X11) = 1
checkGameOver_while_start:
    cmp     X10, #64
    bge     checkGameOver_while_end     ;   while(i(X10) < 64){
    ldrb    W12, [X9, X10]              ;       cell(W12) = board(X9)[i(X10)]
    and     X0, X12, #BOMB
    cmp     X0, #0
    beq     notBomb                     ;       if(cell(X12) & BOMB != 0){
    and     X0, X12, #REVEALED
    cmp     X0, #0
    beq     notRevealed                 ;           if(cell(X12) & REVEALED != 0){
    mov     X0, #-1
    ret                                 ;               return -1
notRevealed:                            ;           }
    and     X0, X12, #FLAGGED
    cmp     X0, #0
    bne     notFlagged                  ;           if(cell(X12) & FLAGGED = 0){
    mov     X11, #0                     ;               allFound(X11) = 0
notFlagged:                             ;           }
notBomb:                                ;       }
    add     X10, X10, #1                ;       i(X10)++
    b       checkGameOver_while_start
checkGameOver_while_end:                ;   }
    mov     X0, X11
    ret                                 ;   return allFound(X11)
