; segment is 0x0000 throught out the program. DS == ES == 0

;*********************************************************
;               macro
;*********************************************************
%include "../include/define.s"
%include "../include/macro.s"

			 ORG BOOT_LOAD                ; tell assembla where this program is loaded

;*********************************************************
;               entry point
;*********************************************************

entry:
       jmp ipl        ; Initial Program Loader;

     ; BPB(BIOS Parameter Block)
		   times 90 - ($ - $$) db 0x90  ; 0x90 -> NOP

ipl: ; IPL
       cli                          ; disable interruption

			 mov ax, 0x0000
			 mov ds, ax
			 mov es, ax
			 mov ss, ax
			 mov sp, BOOT_LOAD

			 sti                          ; enable inerruption

       mov [BOOT + drive.no], dl    ; store boot drive


;*********************************************************
;               display string
;*********************************************************
       cdecl puts, .s0


;*********************************************************
;               load next 512 bytes
;               Sector load: AH = 0x02, INT = 0x13
;*********************************************************
         mov bx, BOOT_SECT -1            ; number of boot sectors left
				 mov cx, BOOT_LOAD + SECT_SIZE   ; next address to load

				 cdecl read_chs, BOOT, bx, cx

         cmp ax, bx                      ; if(AX != BX) // AH = status code(0 if success), AL = number of sectors loaded, BX = number of sectors left to load for boot program
.10Q:    jz .10E
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
BOOT:                      ; info related to boot drive
  istruc drive
	  at drive.no,   dw 0    ; drive number
	  at drive.cyln, dw 0    ; cylinder number
	  at drive.head, dw 0    ; head number
	  at drive.sect, dw 2    ; sector number
  iend


;*********************************************************
;               modules
;*********************************************************
%include "../modules/real/puts.s"
%include "../modules/real/reboot.s"
%include "../modules/real/read_chs.s"


;*********************************************************
;               boot flag(first 512 byte)
;*********************************************************
       times 510 - ($ - $$) db 0x00
       db 0x55, 0xAA


;*********************************************************
; modules(they're put after the first 512 bytes because they're not called in the 1st stage)
;*********************************************************
%include "../modules/real/itoa.s"
%include "../modules/real/get_drive_param.s"


;*********************************************************
;               2nd stage of boot job
;*********************************************************
stage_2: cdecl puts, .s0


;*********************************************************
;               get drive parameter
;*********************************************************
         cdecl get_drive_param, BOOT          ; get_drive_param(DX, BOOT.CYLN); why 2 args?
				 cmp ax, 0                            ; if(AX==0) // get_drive_param set AX to 0 if not succeeded
.10Q:    jne .10E
.10T:    cdecl puts, .e0
         call reboot
.10E:


;*********************************************************
;               display drive info
;*********************************************************
         mov ax, [BOOT + drive.no]            ; AX = boot drive
				 cdecl itoa, ax, .p1, 2, 16, 0b0100
         mov ax, [BOOT + drive.cyln]
				 cdecl itoa, ax, .p2, 4, 16, 0b0100
         mov ax, [BOOT + drive.head]
				 cdecl itoa, ax, .p3, 2, 16, 0b0100
         mov ax, [BOOT + drive.sect]          ; AX = sectors per track
				 cdecl itoa, ax, .p4, 2, 16, 0b0100
				 cdecl puts, .s1                      ; we define 0 as the end of string, so it renders all the way to .p4


;*********************************************************
;               the end of the boot job
;*********************************************************
         jmp $


;*********************************************************
;               data
;*********************************************************
.s0 db "2nd Stage..", 0x0A, 0x0D, 0

.s1 db " Drive:0x"
.p1 db "  , C:0x"
.p2 db "    , H:0x"
.p3 db "  , S:0x"
.p4 db "  ", 0x0A, 0x0D, 0

.e0 db "Can't get drive parameter.", 0


;*********************************************************
; padding to make this program 8,000 bytes
;*********************************************************
         times BOOT_SIZE - ($ - $$) db 0
