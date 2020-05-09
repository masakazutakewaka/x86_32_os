reboot:
         cdecl puts, .s0


;*********************************************************
;               wait for input
;*********************************************************
.10L:    mov ah, 0x10     ; input : AH = 0x10, INT 0x16 -> AL = input
         int 0x16

				 cmp al, ' '       ; ZF == 0;
				 jne .10L         ; while(!ZF);

				 cdecl puts, .s1


;*********************************************************
;               reboot
;*********************************************************
				 int 0x19         ; BIOS(0x19) -> reboot

.s0 db 0x0A, 0x0D, "Push SPACE key to reboot...", 0
.s1 db 0x0A, 0x0D, 0x0A, 0x0D, 0
