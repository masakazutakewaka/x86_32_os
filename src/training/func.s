;int func_16(int x, int y);

func_16: ; args x and y are pushed by caller, which makes SP = 4

         ; stackframe
                     ; 6 -> y
                     ; 4 -> x
                     ; 2 -> IP instruction pointer, where the next instruction(retunn address) is stored
         push bp     ; 0 -> BP[0]
				 mov bp, sp  ; ----
				 sub sp, 2   ; -2 -> short i;
				 push 0      ; -4 -> short j;

				 ;content
				 mov [bp - 2], word 10 ; i = 10
				 mov [bp - 4], word 20 ; j = 20

				 mov ax, [bp + 4]      ; address x
				 add ax, [bp + 6]      ; address y

				 mov ax, 1             ; return 1

				 ;discard stackframe
				 mov sp, bp            ; discard local vars
				 pop bp                ; return BP
				 ret                   ; return to IP
