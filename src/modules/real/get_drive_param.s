; get_drive_param(drive)
;   drive -> address of drive struct
;   returns
;     success  -> other than 0
;     failutre -> 0
get_drive_param:
;                               4 -> parameter buffer; what's that?
;                               2 -> IP
			  push bp
			  mov bp, sp


;*********************************************************
; store registers
;*********************************************************
        push bx
        push cx
        push es
        push si
        push di


;*********************************************************
; start task
;*********************************************************
       mov si, [bp + 4]               ; SI = parameter buffer


;*********************************************************
; Disk Service: fetch drive parameter.
; input: INT = 0x13, AL = 0x08, DL = drive number
; output: CF = status(0,1),
;         AH = return code,
;         CL(7,6) = number of cylinder,
;         CH      = number of cylinder,
;         CL(5~0) = number of sector,
;         DH = number of head,
;         DL = number of drive,
;         ES:DI = address of disk base table
;*********************************************************
			 mov ax, 0                      ; initialize a disk base table pointer. what's that?
			 mov es, ax                     ; ES = 0
			 mov di, ax                     ; DI = 0

			 mov ah, 0x08                   ; AH = 0x08
			 mov dl, [si + drive.no]        ; DL = drive number
			 int 0x13
.10Q:  jc .10F                       ; if(CF==0)
.10T:  mov al, cl                    ; AX = number of sectors
       and ax, 0x3F                  ; only the right 6 bits. 0x3F == 00111111

			 shr cl, 6                     ; CX = number of cylinders; the left 2 bits
			 ror cx, 8                     ; the 2 bits left in CL comes to the right 2 bits of CH, so rotate 8bits
			 inc cx                        ; cylinder size is (address + 1) because cylinder starts from 0

			 movzx bx, dh                  ; BX = number of heads(1 base table) // expand 8bits to 16bits after mov by movzx;
			 inc bx                        ; head size is (address + 1) because head starts from 0

       mov [si + drive.cyln], cx     ; cyln = number of cylinders
       mov [si + drive.head], bx     ; head = number of heads
       mov [si + drive.sect], ax     ; sect = number of sectors

			 jmp .10E

.10F:  mov ax, 0                     ; AX(AH) = 0 = failure
.10E:


;*********************************************************
; return registers
;*********************************************************
       pop di
       pop si
       pop es
       pop cx
       pop bx


;*********************************************************
; discard stackframe
;*********************************************************
       mov sp, bp
			 pop bp

			 ret
