entry:
       jmp ipl        ; Initial Program Loader;

     ; BPB(BIOS Parameter Block)
		   times 90 - ($ - $$) db 0x90  ; 0x90 -> NOP

ipl: ; IPL
       jmp $

       times 510 - ($ - $$) db 0x00
       db 0x55, 0xAA
