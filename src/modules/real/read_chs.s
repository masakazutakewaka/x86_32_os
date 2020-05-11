; read_chs(drive, sect, dst);
;          drive   address of struc drive
;          sect    number of sectors to read
;          dst     address to put what's read

read_chs:
;*********************************************************
;                 stackframe
;*********************************************************
                                    ;  8 -> dst
                                    ;  6 -> sect
                                    ;  4 -> parameter buffer; what's that?
                                    ;  2 -> IP
       push bp
			 mov bp, sp

			 push 3                       ; retry = 3
			 push 0                       ; sector count = 0


;*********************************************************
;                 store registers
;*********************************************************
       push bx
			 push cx
			 push dx
			 push es
			 push si


;*********************************************************
;                 start function
;*********************************************************
       mov si, [bp + 4]             ; SI = parameter buffer; what's that?


;*********************************************************
;                 configurate CX(optimize for BIOS call)
;*********************************************************
       mov ch, [si + drive.cyln + 0]      ; CH = cylinder number(bottom byte); why + 0?
       mov cl, [si + drive.cyln + 1]      ; CH = cylinder number(upper byte); why + 1?
			 shl cl, 6                          ; CL <<= 6; shift to leftest 2 bits so that sector number can use the rest of 6
			 or cl, [si + drive.sect]           ; CL |= sector number; using "or" not to lose 2bits which is already there


;*********************************************************
;                 read sector
;                 Sector load: AH = 0x02, INT = 0x13
;                 output: CF = 0,1; success or failure
;                         AH = status code
;                         AL = number of sectors read
;*********************************************************
       mov dh, [si + drive.head]          ; DH = head number
			 mov dl, [si + 0]                   ; DL = drive number; why not drive.no?
			 mov ax, 0x0000
			 mov es, ax                         ; ES = 0x000; not sure why this is set as ES is referred by DI
			 mov bx, [bp + 8]                   ; BX = dst; offset

.10L:                                     ; do {
       mov ah, 0x02                       ; BIOS call for sector load: AH = 0x02, INT = 0x13
		   mov al, [bp + 6]                   ; number of sectors to read

			 int 0x13                           ; BIOS call for sector load: AH = 0x02, INT = 0x13
		   jnc .11E                           ; if(CF) { // CF = BIOS(0x13, 0x02) success(0) or not(1)

			 mov al, 0                          ;   reset AL; AL = sectors to read
			 jmp .10E                           ;   break; // don't retry if CF == 1
			                                    ; }
.11E:
       cmp al, 0                          ; if (a sector was read) {
			 jne .10E                           ;   break;
                                          ; }
			 mov ax,0                           ; ret = 0; set return value. AH = status code, AL = sectors read
			 dec word [bx - 2]                  ; retry--;
			 jnz .10L                           ; } while(retry);
.10E:
       mov ah, 0                           ; reset status code


;*********************************************************
;                 return registers
;*********************************************************
       pop si
			 pop es
			 pop dx
			 pop cx
			 pop bx


;*********************************************************
;                 discard stackframe
;*********************************************************
       mov sp, bp
			 pop bp
			 ret
