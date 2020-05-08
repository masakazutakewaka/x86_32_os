; void itoa(num, buff, sise, radix, flag);
;           num   -> number to convert
;           buff  -> address of buffer to store
;           size  -> size of buffer to store
;           radix -> radix. fundamental number
;           flags -> B0: treat value as signed var
;                    B1: add sign +/-
;                    B2: fill with 0

itoa:
;*********************************************************
;                 stackframe
;*********************************************************
                                    ; 12 -> flag
                                    ; 10 -> radix
                                    ;  8 -> size
                                    ;  6 -> buff
                                    ;  4 -> num
                                    ;  2 -> IP
       push bp
			 mov bp, sp


;*********************************************************
;                 store registers
;*********************************************************
       push ax
       push bx
       push cx
       push dx
       push si
       push di


;*********************************************************
;                 get args
;*********************************************************
       mov ax, [bp + 4]             ; val  = num
       mov si, [bp + 6]             ; dst  = buffer address
       mov cx, [bp + 8]             ; size = buffer size

			 mov di, si                   ; DI = tail of buffer
			 add di, cx                   ; DI = dst + size
			 dec di                       ; last index = dst + size - 1

			 mov bx, word [bp + 12]       ; flags


;*********************************************************
; decide it is singed or not, then set to display sign if value is smaller than 0
;*********************************************************
      test bx, 0b0001              ; if(flags & 0x01) B0: treat value as signed var
.10Q: je .10E                      ; {
      cmp ax, 0                    ;   if(AX < 0)
.12Q: jge .12E                     ;   {
      or bx, 0b0010                ;     flags ||= 0x02; B1: display sign +/-
.12E:                              ;   }
.10E:                              ; }


;*********************************************************
; see if sign is set to be displayed, then then add + or -
;*********************************************************
      test bx, 0b0010              ; if(flags & 0x02) B1: add sign +/-
.20Q: je .20E                      ; {
      cmp ax, 0                    ;   if(AX < 0)
.22Q:  jge .22F                    ;   {
	    neg ax                       ;     val *= -1;
			mov [si], byte '-'           ;     *dst = '-';
			jmp .22E                     ;   } else {
.22F: mov [si], byte '+'           ;     *dst = '+';
                                   ;   }
.22E: dec cx                       ;   size--; because sign uses 1 byte
.20E:                              ; }


;*********************************************************
; convert to ASCII, iterate each number by dividing AX(num) by radix till AX is zero
;*********************************************************
			mov bx, [bp + 10]            ; radix

.30L: mov dx, 0
      div bx                       ; div(16bit) -> AX = DX:AX(32bit) / BX, DX = DX:AX(32bit) % BX

			mov si, dx                   ; probably DX can't be used as index. need some research
			mov dl, byte [.ascii + si]    ; DL = ASCII[DX];

			mov [di], dl                 ; *dst = DL; (DI = dst + size at first iteration)
			dec di                       ; dst--;

			cmp ax, 0
			loopnz .30L                  ; while(AX);
.30E:


;*********************************************************
; fill empty bytes
;*********************************************************
			cmp cx, 0
.40Q: je .40E
      mov al, ' '
			cmp [bp + 12], word 0b0100   ; if(flags & 0x04) | specifing "word" because the left operand is memory address(type is ambiguous)
.42Q: jne .42E
      mov al, '0'

.42E: std                          ; DF = 1;(-)
      rep stosb                    ; while(--CX) *DI-- = AL;
.40E:


;*********************************************************
; return registers
;*********************************************************
      pop di
			pop si
			pop dx
			pop cx
			pop bx
			pop ax


;*********************************************************
; discard stackframe
;*********************************************************
      mov sp, bp
			pop bp
			ret

.ascii db "0123456789ABCDEF"        ; convertion table
