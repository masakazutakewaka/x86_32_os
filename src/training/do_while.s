mov cx, 5
.L: nop
   loop .L ;loop substract 1 from CX, and jump to offset in the operand if CX != 0
