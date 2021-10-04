; -------------------------------------------
;   main.s
;   Dependencies:
;       makeBoard.s, printBoard.s
;       printNum.s, remDiv.s, readInt.s
;       INTerp.s
; -------------------------------------------

.text
.align 2

.global _main
_main:
    cmp     X0, #2
    beq     goodArgs

    adrp    X0, badArgs@PAGE
    add     X0, X0, badArgs@PAGEOFF
    bl      print
    b       exit

goodArgs:

    ldr     X0, [X1, #8]
    bl      INTerp
    mov     X20, X0

    adrp    X19, board@PAGE
    add     X19, X19, board@PAGEOFF
                        ;   &board(X19) = &board

    mov     X0, X20
    bl      random
    mov     X20, X0     ;   seed(X20) = random(seed(X20))

    mov     X0, X19
    mov     X1, X20
    bl      makeBoard   ;   makeBoard(&board(X19), seed(X20))

main_loop:
    mov     X0, X19
    bl      ripple

    mov     X0, X19
    bl      printBoard

    mov     X0, X19
    bl      checkGameOver
    cmp     X0, #1
    bne     noWin

    adrp    X0, winMsg@PAGE
    add     X0, X0, winMsg@PAGEOFF
    bl      print
    b       exit
noWin:
    cmp     X0, #-1
    bne     noLose

    adrp    X0, loseMsg@PAGE
    add     X0, X0, loseMsg@PAGEOFF
    bl      print
    b       exit
noLose:

    bl      getInput
    mov     X3, X2
    mov     X2, X1
    mov     X1, X0
    mov     X0, X19
    bl      modify

    b       main_loop

exit:
    mov     X0, #0
    mov     X16, #1
    svc     0       ;   exit(0)


.data
board:
    .skip 64

badArgs:
    .asciz "Invalid args\n"

winMsg:
    .asciz "Congrats! You win!\n"

loseMsg:
    .asciz "Bad luck, you lose\n"