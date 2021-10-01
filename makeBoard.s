; --------------------------
;   makeBoard.s
;   Dependencies: random.s
; --------------------------

#define END_OF_ROW 128
#define BOMB 16

.text
.align 2

.global makeBoard
.global makeCell

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

    ;   board = X0
    ;   seed = X1
    ;   i = 0
    ;   while(i < 100){
    ;       seed = random(seed)
    ;       board[i] = makeCell(seed)
    ;       if(i % 8 == 0){
    ;           board |= END_OF_ROW
    ;       }
    ;   }

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
    beq     notBomb         ;   if(seed & 12 != 0){
    ORR     X0, X0, #BOMB   ;       cell |= BOMB
notBomb:                    ;   }

    ret