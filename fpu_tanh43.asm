.686p
.model flat, c
.data
	rslt dd 0.0e
.code
	asm_chtan proc near c public k:dword
		finit		;exp-
		fldl2e
		fld k 
		fchs
		fmul
		f2xm1
		fld1
		fadd
		
		fld st(0)	; Дублирование

		fldl2e		;exp+
		fld k 
		fmul
		f2xm1
		fld1
		fadd
		
		fld st(0)   ;0 - exp+, 1 - exp+, 2 - exp-, 3 - exp-

		fxch st(2)  
		fchs
		fadd
		fxch st(2)
		fadd
		
		fdiv
		
		ret
	asm_chtan endp
end