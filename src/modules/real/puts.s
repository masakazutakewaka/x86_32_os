; void puts(str); str -> address of string. 0x00 is the end of a string

puts:
    ; stackframe
											; 4 -> str
											; 2 -> IP
			push bp         ; 0
			mov bp, sp

		; store registers
			push ax
			push bx
			push si

		; get arg
		  mov si, [bp + 4]

    ; start function
			mov ah, 0x0E            ; tele type 1 charactor output
			mov bx, 0x0000          ; page number & color

			cld                     ; DF = 0; increment address

.L10:
      lodsb                  ; AL = [SI]; SI += 1(byte)

      cmp al, 0
			je .E10

			int 0x10                ; video BIOS call
			jmp .L10

.E10:
    ; return regisgters
		  pop bx
			pop ax

		; discard stackframe
		  mov sp, bp
			pop bp

			ret


