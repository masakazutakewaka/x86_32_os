       BOOT_LOAD equ 0x7c00         ; where boot probram is loaded
			 ORG BOOT_LOAD                ; tell assembla where this program is loaded

entry:
       jmp ipl        ; Initial Program Loader;

     ; BPB(BIOS Parameter Block)
		   times 90 - ($ - $$) db 0x90  ; 0x90 -> NOP

ipl: ; IPL
       cli                     ; disable interruption

			 mov ax, 0x0000
			 mov ds, ax
			 mov es, ax
			 mov ss, ax
			 mov sp, BOOT_LOAD

			 sti                     ; enable inerruption

       mov [BOOT.DRIVE], dl    ; store boot drive

			 mov ah, 0x0E            ; tele type 1 charactor output
       mov al, 'A'             ; charactor to output
			 mov bx, 0x0000          ; page number & color
			 int 0x10                ; video BIOS call

       jmp $                   ; infinte loop

ALIGN 2, db 0
BOOT:                 ; info related to boot drive
.DRIVE: dw 0          ; drive number

       times 510 - ($ - $$) db 0x00
       db 0x55, 0xAA
