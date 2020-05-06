;void putc(ch);

putc:
    ; stackframe
											; 4 -> ch
											; 2 -> IP
			push bp         ; 0
			mov bp, sp

		; store registers
			push ax
			push bx

    ; start function
			mov ah, 0x0E            ; tele type 1 charactor output
      mov al, [bp + 4]        ; charactor to output
			mov bx, 0x0000          ; page number & color
			int 0x10                ; video BIOS call

    ; return regisgters
		  pop bx
			pop ax

		; discard stackframe
		  mov sp, bp
			pop bp

			ret
