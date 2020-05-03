    mov cx, 0
.L: cmp cx, 5
    jge .E
		nop
		inc cx
		jmp .L
.E:
