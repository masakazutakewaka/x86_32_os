; void memcpy(dist, src, size);

memcpy:
                    ; size
										; src
										; dist
										; EIP
        push ebp     ; 0 -> EBP[0]
				mov ebp, esp  ; ----

      ; store registers
			  push ecx
				push esi
				push edi

			; copy per byte
			  cld              ; CLear Direction flag. 0 means incremental
				mov edi, [ebp + 8]
				mov esi, [ebp + 12]
				mov ecx, [ebp + 16]

				rep movsb         ; while (*EDI++ = *ESI++);

      ; return registers
			  pop edi
				pop esi
				pop ecx

      ; discard stqckframe, and return to EIP
			  mov esp, ebp
				pop ebp
				ret
