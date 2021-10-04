; -------------------------------------
;   printBoard.s
;   Dependencies: print.s, printNum.s
; -------------------------------------

#define END_OF_ROW 128
#define REVEALED 64
#define FLAGGED 32
#define BOMB 16
#define COUNT 15

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
    str     X19, [sp, #-16]!
    str     X20, [sp, #-16]!

    mov     X19, X0                 ;   board(X19) = X0
    mov     X20, #0                 ;   i(X20) = 0
    adrp    X0, header@PAGE
    add     X0, X0, header@PAGEOFF
    bl      print                   ;   print(&header)

    adrp    X0, start@PAGE
    add     X0, X0, start@PAGEOFF
    bl      print                   ;   print(&start)

printBoard_while_start:
    cmp     X20, #64
    bge     printBoard_while_end    ;   while(i < 64){
    ldrb    W0, [X19, X20]
    bl      printCell               ;       printCell(board(X19) + i(X20))

    adrp    X0, seperator@PAGE
    add     X0, X0, seperator@PAGEOFF
    bl      print                   ;       print(&seperator)

    and     X0, X20, #7
    cmp     X0, #7
    bne     notEOR                  ;       if(i(X20) & 7 == 7){
    
    adrp    X0, E_O_R@PAGE
    add     X0, X0, E_O_R@PAGEOFF
    bl      print                   ;           print(&E_O_R)

    cmp     X20, #60                ;           if(i(X20) < 60)
    bge     notEOR

    adrp    X0, start@PAGE
    add     X0, X0, start@PAGEOFF
    bl      print                   ;               print(&start)
notEOR:                             ;       }
    add     X20, X20, #1            ;       i(X20)++

    b       printBoard_while_start
printBoard_while_end:               ;   }
    adrp    X0, header@PAGE
    add     X0, X0, header@PAGEOFF
    bl      print                   ;   print(&header)

    ldr     X20, [sp], #16
    ldr     X19, [sp], #16
    ldr     lr, [sp], #16
    ret

; ----------------------------------------------------------
;   printCell
;   Input:
;       X0 - cell
;   Output:
;       None
;   Side effects:
;       Representation of cell state is printed to stdout
;   Destroys:
; ----------------------------------------------------------
printCell:
    str     lr, [sp, #-16]!

    mov     X3, X0                  ;   cell(X3) = X0

    ; and     X0, X3, #COUNT
    ; cmp     X0, #0
    ; beq     revealed

    and     X0, X3, #FLAGGED
    cmp     X0, #0
    beq     notFlagged              ;   if(cell(X3) & FLAGGED != 0){
    adrp    X0, flag@PAGE
    add     X0, X0, flag@PAGEOFF
    bl      print                   ;       print(&flag)
    b       printCell_return        ;       return
notFlagged:                         ;   }
    and     X0, X3, #REVEALED
    cmp     X0, #0
    bne     revealed                ;   if(cell(X3) & REVEALED = 0){
    adrp    X0, hidden@PAGE
    add     X0, X0, hidden@PAGEOFF
    bl      print                   ;       print(&hidden)
    b       printCell_return        ;       return
revealed:                           ;   }
    and     X0, X3, #BOMB
    cmp     X0, #0
    beq     notBomb                 ;   if(cell(X3) & BOMB != 0){
    adrp    X0, bomb@PAGE
    add     X0, X0, bomb@PAGEOFF
    bl      print                   ;       print(&bomb)
    b       printCell_return        ;       return
notBomb:                            ;   }
    and     X0, X3, #COUNT
    bl      printNum                ;   printNum(cell & 15)

printCell_return:
    ldr     lr, [sp], #16
    ret

.data
header:
    .asciz "+-----------------+\n"

start:
    .asciz "| "

seperator:
    .asciz " "

hidden:
    .asciz " "

flag:
    .asciz "F"

bomb:
    .asciz "*"

E_O_R:
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