;int memcmp(src0, src1, size); if same, 0. if not, -1

memcmp: 
         push bp
				 mov bp, sp

				 push bx
				 push cx
				 push dx
				 push si
				 push di

      ; compare per byte
			  cld
			  mov si, [bp + 4]  ; src0
				mov di, [bp + 6]  ; src1
				mov cx, [bp + 8]  ; size

				repe cmpsb        ; ZF == 0 if all same
				jnz .10F
				mov ax, 0
				jmp .10E

.10F:
        mov ax, -1
.10E:
				pop di
				pop si
				pop dx
				pop cx
				pop bx

				mov sp, bp
				pop bp
				ret
