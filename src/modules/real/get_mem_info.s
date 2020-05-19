; void get_mem_info(void);
get_mem_info:
;*********************************************************
; store registers
;*********************************************************
		push eax
		push ebx
		push ecx
		push edx
		push si
		push di
		push bp            ; it doesn't affect BP's role as a central place because this function doesn't take a single arg, meaning a stackframe is not built(BP doesn't have that role)


;*********************************************************
; INT 0x15 system memory map
;   AX    -> 0xE820
;   EBX   -> index(0 at first)
;   ES:DI -> address to store
;   ECX   -> number of bytes to write
;   EDX   -> 0x534D4150 == 'SMAP'
;
;   CF    -> success:0, failure:1
;   EAX   -> 0x543D4150 == 'SMAP'
;   EAX   -> number of bytes written
;   EBX   -> index(last data if 0)
;*********************************************************
    mov bp, 0                  ; line number
		mov ebx, 0
.10L:                          ; do {
    mov eax, 0x0000E820
		mov ecx, E820_RECORD_SIZE
		mov edx, 'PAMS'            ; SMAP
		mov di, .b0                ; ES:DI = buffer

		int 0x15

    ; by comparing we can see if the command is supported
		cmp eax, 'PAMS'            ; if(EAX != 'SMAP')
		je .12E                    ; {
		jmp .10E                   ;   break;
		                           ; }
    ; see if command succeeded
.12E:                          ; if(CF)
		jnc .14E                   ; {
		jmp .10E                   ;   break;
.14E:                          ; }

    cdecl put_mem_info, di     ; display memory info for 1 record

    ; get address of ACPI data
		mov eax, [di + 16]         ; EAX = record type
		cmp eax, 3                 ; if(EAX == 3) //ACPI data
		jne .15E                   ; {

		mov eax, [di + 0]          ;   EAX = base address
		mov [ACPI_DATA.adr], eax   ;   ACPI_DATA.adr = EAX

		mov eax, [di + 8]          ;   EAX = length
		mov [ACPI_DATA.len], eax   ;   ACPI_DATA.len = EAX

    ; wait for a user's input at every 8 lines
    cmp ebx, 0                 ; if(EBX != 0) // EBX == 0 means the final data
		jz .16E                    ; {

    inc bp                     ;   lines++
		and bp, 0x07               ;   lines &= 0x07 // 1000(8) & 0111(7)
		jnz .16E                   ;   if(lines == 0)
		                           ;   {
		cdecl puts, .s2            ;     // display "interrupt" message

		mov ah, 0x10               ;     // wait for user input
		int 0x16                   ;     // AL = BIOS(0x16, 0x10)
    cdecl puts, .s3            ;     // delete "interrupt" message

.16E:                          ;   }

.s2: db " <more...>", 0
.s3: db 0x0D, "          ", 0x0D, 0

    cmp ebx, 0
		jne .10L                   ; }
.10E:                          ; while(EBX != 0)

ALIGN 4, db 0
.b0: times E820_RECORD_SIZE db 0
;*********************************************************
; WIP return registers
;*********************************************************
      pop bp
      pop es
			pop si
			pop bx
			pop ax


puts_mem_info:
;*********************************************************
;                 stackframe
;*********************************************************
                                    ; BP + 4 -> buffer address
                                    ; BP + 2 -> IP (return address)
     push bp                        ; BP + 0 -> BP (original address)
     mov bp, sp


;*********************************************************
; store registers
;*********************************************************
     push bx
		 push si


;*********************************************************
; get argument
;*********************************************************
