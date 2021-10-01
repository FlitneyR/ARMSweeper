; ------------
;   random.s
; ------------

.text
.align 2

.global random

; ---------------------
;   random
;   Input:
;       X0 - seed
;   Output:
;       X0 - new seed
;   Destroys: X0, X1
; ---------------------

random:

    lsl     X1, X0, #13
    eor     X0, X0, X1
    lsr     X1, X0, #7
    eor     X0, X0, X1
    lsl     X1, X0, #17
    eor     X0, X0, X1

    ret