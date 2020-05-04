; void memcpy(dist, src, size);

memcpy:
                    ; size
										; src
										; dist
										; IP
        push bp     ; 0 -> BP[0]
				mov bp, sp  ; ----

      ; store registers
			  push cx
				push si
				push di

			; copy per byte
			  cld              ; CLear Direction flag. 0 means incremental
				mov di, [bp + 4]
				mov si, [bp + 6]
				mov cx, [bp + 8]

				rep movsb         ; while (*DI++ = *SI++);

      ; return registers
			  pop di
				pop si
				pop cx

      ; discard stqckframe, and return to IP
			  mov sp, bp
				pop bp
				ret
