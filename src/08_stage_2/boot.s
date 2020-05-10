       BOOT_LOAD equ 0x7c00         ; where boot probram is loaded
			 ORG BOOT_LOAD                ; tell assembla where this program is loaded


;*********************************************************
;               macro
;*********************************************************
%include "../include/macro.s"


;*********************************************************
;               entry point
;*********************************************************

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


;*********************************************************
;               display string
;*********************************************************
       cdecl puts, .s0


;*********************************************************
;               load next 512 bytes
;               Sector load: AH = 0x02, INT = 0x13
;*********************************************************
				 mov ah, 0x02              ;
				 mov al, 1                 ; 1 sector -> 4096 bits -> 512 bytes
				 mov cx, 0x0002            ; cylinder = 0, sector = 2
				 mov dh, 0x00              ; head = 0
				 mov dl, [BOOT.DRIVE]      ; drive

				 mov bx, 0x7C00 + 512      ; offset
				 int 0x13

.10Q:    jnc .10E                  ; if(CF) - CF = BIOS(0x13, 0x02) success(0) or not(1)
.10T:    cdecl puts, .e0
				 call reboot
.10E:

				 jmp stage_2


;*********************************************************
;               data
;*********************************************************
.s0    db "Booting...", 0x0A, 0x0D, 0    ; 0x0A = LF, 0x0D = CR
.e0    db "Error:sector read", 0

ALIGN 2, db 0
BOOT:                 ; info related to boot drive
.DRIVE: dw 0          ; drive number


;*********************************************************
;               modules
;*********************************************************
%include "../modules/real/puts.s"
%include "../modules/real/reboot.s"


;*********************************************************
;               boot flag(first 512 byte)
;*********************************************************
       times 510 - ($ - $$) db 0x00
       db 0x55, 0xAA


;*********************************************************
;               2nd stage of boot job
;*********************************************************
stage_2: cdecl puts, .s0

         jmp $              ; end of procedure

.s0 db "2nd Stage..", 0x0A, 0x0D, 0


;*********************************************************
;               padding to make this program 8,000 bytes
;*********************************************************
         times (1024 * 8) - ($ - $$) db 0
