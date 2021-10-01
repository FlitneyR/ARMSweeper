; -------------------------------------
;   printBoard.s
;   Dependencies: print.s, printNum.s
; -------------------------------------

#define END_OF_ROW 128
#define REVEALED 64
#define FLAGGED 32
#define BOMB 16

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
;   printCell
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

    mov     X3, X0                  ;   cell(X3) = X0

    and     X0, X3, #HIDDEN
    cmp     X0, #0
    bne     revealed                ;   if(cell(X3) & REVEALED = 0){
    adrp    X0, hidden@PAGE
    add     X0, X0, hidden@PAGEOFF
    bl      print                   ;       print(&hidden)
    b       printCell_return        ;       return
revealed:                           ;   }
    and     X0, X3, #FLAGGED
    cmp     X0, #0
    beq     notFlagged              ;   if(cell(X3) & FLAGGED != 0){
    adrp    X0, flag@PAGE
    add     X0, X0, flag@PAGEOFF
    bl      print                   ;       print(&flag)
    b       printCell_return        ;       return
notFlagged                          ;   }
    and     X0, X3, #BOMB
    cmp     X0, #0
    beq     notBomb                 ;   if(cell(X3) & BOMB != 0){
    adrp    X0, bomb@PAGE
    add     X0, X0, bomb@PAGEOFF
    bl      print                   ;       print(&bomb)
    b       printCell_return        ;       return
notBomb:                            ;   }
    and     X0, X3, #15
    bl      printNum                ;   printNum(cell & 15)

printCell_return:
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

flag:
    .asciz "F"

bomb:
    .asciz "B"

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