; -----------
;   modify.s
; -----------

#define END_OF_ROW 128
#define REVEALED 64
#define FLAGGED 32
#define BOMB 16
#define COUNT 15

.text
.align 2

.global modify
.global ripple

; ------------
;   modify
;   Input:
;       X0 - pointer to board
;       X1 - column
;       X2 - row
;       X3 - modification
; ------------
modify:
    str     lr, [sp, #-16]!
    str     X19, [sp, #-16]!
    str     X20, [sp, #-16]!
    str     X21, [sp, #-16]!
    str     X22, [sp, #-16]!

    mov     X19, X0             ;   board(X19) = arg0
    mov     X20, X1             ;   col(X20) = arg1
    mov     X21, X2             ;   row(X21) = arg2
    mov     X22, X3             ;   change(X22) = arg3

    add     X0, X20, X21, lsl 3
    ldrb    W9, [X19, X0]       ;   cell(W9) = board(X19)[col(X20) + (row(X21) << 3)]
    
    cmp     X22, 'f'
    beq     flag
    cmp     X22, 'F'
    beq     flag
    b       noFlag
flag:                           ;   if(change(X22) == 'f' || change(X22) == 'F'){
    eor     W9, W9, #FLAGGED    ;       cell(W9) ^= FLAGGED
noFlag:                         ;   }
    cmp     X22, 'r'
    beq     reveal
    cmp     X22, 'R'
    beq     reveal
    b       noReveal
reveal:                         ;   if(change(X22) == 'r' || change(X22) == 'R'){
    orr     W9, W9, #REVEALED   ;       cell(W9) |= REVEALED
noReveal:                       ;   }
    strb    W9, [X19, X0]       ;   board[col + (row << 3)] = cell(W9)

    ldr     X22, [sp], #16
    ldr     X21, [sp], #16
    ldr     X20, [sp], #16
    ldr     X19, [sp], #16
    ldr     lr, [sp], #16
    ret

; -----------------------------
;   ripple
;   Input:
;       X0 - pointer to board
; -----------------------------

ripple:

    mov     X9, X0              ;   board(X9) = arg0

repeat:
    mov     X10, #0             ;   repeat(X10) = 0
    mov     X11, #0             ;   y(X11) = 0
ripple_while1_start:
    cmp     X11, #8
    bge     ripple_while1_end   ;   while(y(X11) < 8){
    mov     X12, #0             ;       x(X12) = 0
ripple_while2_start:
    cmp     X12, #8
    bge     ripple_while2_end   ;       while(x(X12) < 8){
    add     X0, X12, X11, lsl #3
    ldrb    W13, [X9, X0]       ;           cell(X13) = board(X9)[x(X12) + (y(X11) << 3)]

    and     X0, X13, #REVEALED
    cmp     X0, #0
    beq     skipCell
    and     X0, X13, #COUNT
    cmp     X0, #0
    bne     skipCell            ;           if(cell(X13) & REVEALED != 0 && cell(X13) & COUNT = 0){
    
    mov     X14, #-1            ;               dy(X14) = -1
    cmp     X11, #0
    bne     ripple_while3_start
    add     X14, X14, #1        ;               if(y(X11) == 0) dy(X14)++
ripple_while3_start:
    cmp     X14, #2
    bge     ripple_while3_end
    add     X0, X11, X14
    cmp     X0, #8
    bge     ripple_while3_end   ;               while(dy(X14) < 2 && y(X11) + dy(X14) < 8){
    
    mov     X15, #-1            ;                   dx(X15) = -1
    cmp     X12, #0
    bne     ripple_while4_start
    add     X15, X15, #1        ;                   if(x(X12) == 0) dx(X15)++
ripple_while4_start:
    cmp     X15, #2
    bge     ripple_while4_end
    add     X0, X12, X15
    cmp     X0, #8
    bge     ripple_while4_end   ;                   while(dx(X15) < 2 && x(X12) + dx(X15) < 8){
    
    add     X0, X12, X15
    add     X1, X11, X14
    add     X2, X0, X1, lsl #3
    ldrb    W13, [X9, X2]       ;                       cell(X13) = board(X9)[(x(X12) + dx(X15)) + ((y(X11) + dy(X14)) << 3)]

    and     X0, X13, #BOMB
    cmp     X0, #0
    bne     dontReveal          ;                       if(cell(X13) & BOMB == 0){
    and     X0, X13, #REVEALED
    cmp     X0, #0
    bne     alreadyRevealed     ;                           if(cell(X13) & REVEALED == 0){
    mov     X10, #1             ;                               repeat(X10) = 1
alreadyRevealed:                ;                           }
    orr     X13, X13, #REVEALED ;                           cell(X13) |= REVEALED
    strb    W13, [X9, X2]       ;                           board(X9)[(x(X12) + dx(X15)) + ((y(X11) + dy(X14)) << 3)] = cell(X13)
dontReveal:                     ;                       }
    add     X15, X15, #1        ;                       dx(X15)++

    b       ripple_while4_start
ripple_while4_end:              ;                   }
    add     X14, X14, #1        ;                   dy(X14)++
    b       ripple_while3_start
ripple_while3_end:              ;               }
skipCell:                       ;           }
    add     X12, X12, #1        ;       x(X12)++
    b       ripple_while2_start
ripple_while2_end:              ;       }
    add     X11, X11, #1        ;   y(X11)++
    b       ripple_while1_start
ripple_while1_end:              ;   }

    cmp     X10, #0             ;   if(repeat(X10) != 0){
    bne     repeat              ;       repeat
                                ;   }

    ret