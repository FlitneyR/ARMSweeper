; ----------------------------------------
;   main.s - Robert Flitney - 30/09/2021
; ----------------------------------------

.text
.align 2

.global _main
_main:
    str     lr, [sp, #-16]!

    ldr     lr, [sp], #16
    ret

.data
board:
    .skip 100