; -------------------
;   checkGameOver.s
; -------------------

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

    ;   y = 0
    ;   while(y < 8){
    ;       x = 0
    ;       while(x < 8){
    ;           cell = board[x + y << 3]
    ;           if(cell && BOMB != 0){
    ;               if(cell && REVEALED != 0){
    ;                   return -1
    ;               }
    ;           }
    ;       }
    ;   }
    ;   return 1

    ret