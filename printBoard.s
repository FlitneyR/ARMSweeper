; ----------------------------------------------
;   printBoard.s - Robert Flitney - 30/09/2021
;   Dependencies: print.s
; ----------------------------------------------

#define END_OF_ROW 128

.text
.align 2

.extern print

.global printBoard
.global printCell

; ----------------------------------------------------------
;   printBoard
;   Input:
;       X0 - pointer to board
;   Output:
;       None
;   Side effects:
;       Representation of board state is printed to stdout
;   Destroys:
; ----------------------------------------------------------
printBoard:
    str     lr, [sp, #-16]!

    ;   board = X0
    ;   print(&header)
    ;   print(&start)
    ;   while(*board != -1){
    ;       printCell(board)
    ;       print(&seperator)
    ;       if(*board & END_OF_ROW){
    ;           print(&EOR)
    ;       }
    ;   }
    ;   print(&header)

    ldr     lr, [sp], #16
    ret

; ----------------------------------------------------------
;   printBoard
;   Input:
;       X0 - pointer to cell
;   Output:
;       None
;   Side effects:
;       Representation of cell state is printed to stdout
;   Destroys:
; ----------------------------------------------------------
printCell:
    str     lr, [sp, #-16]!

    ;   print(hidden)

    ldr     lr, [sp], #16
    ret

.data
header:
    .asciz "+---------------------+\n"

start:
    .asciz "| "

seperator:
    .asciz " "

hidden:
    .asciz "#"

EOR:
    .asciz "|\n"

;+---------------------+
;| # # # # # # # # # # |
;| # # # # # # # # # # |
;| # # # # # # # # # # |
;| # # # # # # # # # # |
;| # # # # # # # # # # |
;| # # # # # # # # # # |
;| # # # # # # # # # # |
;| # # # # # # # # # # |
;| # # # # # # # # # # |
;| # # # # # # # # # # |
;| # # # # # # # # # # |
;+---------------------+