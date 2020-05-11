%macro cdecl 1-*.nolist
  %rep %0 -1 
	  push %{-1:-1}      ; last arg
		%rotate -1         ; rotate to right ->
	%endrep
	%rotate -1           ; return args to as it used be

	call %1

	%if 1 < %0
		add sp, (__BITS__ >> 3) * (%0 - 1)     ;dump stqck (16(2byte) or 32(4byte)) * (number of args)
	%endif
%endmacro


struc drive
     .no     resw   1   ; drive number
     .cyln   resw   1   ; cylinder
     .head   resw   1   ; head
     .sect   resw   1   ; sector
endstruc
