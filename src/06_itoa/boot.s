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
;               display numbers
;*********************************************************
       cdecl itoa, 8086, .s1, 8, 10, 0b0001      ; 8086
       cdecl puts, .s1

       cdecl itoa, 8086, .s1, 8, 10, 0b0011      ; +8086
       cdecl puts, .s1

       cdecl itoa, -8086, .s1, 8, 10, 0b0001     ; -8086
       cdecl puts, .s1

       cdecl itoa, -1, .s1, 8, 10, 0b0001        ; -1
       cdecl puts, .s1

       cdecl itoa, -1, .s1, 8, 10, 0b0000        ; 65535
       cdecl puts, .s1

       cdecl itoa, -1, .s1, 8, 16, 0b0000        ; FFFF
       cdecl puts, .s1

       cdecl itoa, 12, .s1, 8, 2, 0b0100         ; 00001100
       cdecl puts, .s1

       jmp $                   ; infinte loop


;*********************************************************
;               data
;*********************************************************
.s0    db "Booting...", 0x0A, 0x0D, 0    ; 0x0A = LF, 0x0D = CR
.s1    db "        ", 0x0A, 0x0D, 0    ; 0x0A = LF, 0x0D = CR

ALIGN 2, db 0
BOOT:                 ; info related to boot drive
.DRIVE: dw 0          ; drive number


;*********************************************************
;               modules
;*********************************************************
%include "../modules/real/puts.s"
%include "../modules/real/itoa.s"


;*********************************************************
;               boot flag(first 512 byte)
;*********************************************************
       times 510 - ($ - $$) db 0x00
       db 0x55, 0xAA
