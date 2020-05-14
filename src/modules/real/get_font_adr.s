; void get_font_adr(adr);
;    adr -> address of font address
get_font_adr:
                       ; 4 -> address of font address
											 ; 2 -> IP
		push bp
		mov bp, sp

		push ax
		push bx
		push si
		push es
		push bp            ; why it doesn't affect BP's role as a central place?


;*********************************************************
;                 get args
;*********************************************************
		mov si, [bp + 4]    ; dst = address of font address


;*********************************************************
;                 get font address
;*********************************************************
		mov ax, 0x1130      ;BIOS service to get font address
		mov bh, 0x06        ; 8 x 16 fond(vga/mcga). How does 6 represent 8 x 16?
		int 10h             ; ES:BP = FONT ADDRESS


;*********************************************************
;                 store font address
;*********************************************************
		mov [si + 0], es    ; dst[0] = segment
		mov [si + 2], bp    ; dst[1] = offset


;*********************************************************
; return registers
;*********************************************************
      pop bp
      pop es
			pop si
			pop bx
			pop ax


;*********************************************************
; discard stackframe
;*********************************************************
      mov sp, bp
			pop bp
			ret
