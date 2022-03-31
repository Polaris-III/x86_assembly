;
;	Функция asm_cos рассчитывает косинус через ряд Маклорена
;   Функция simplest_cos использует fcos
;
;	
.686p
.model flat, c
.data
	x dd 0
	F4 dd 24
	F6 dd 720
	F8 dd 40320
	F10 dd 3628800
.code
	asm_cos proc near c public k:dword
		finit				; Инициализация сопроцессора

		mov eax, k
		mov x, eax

		fld1

		fld x				; - x^2 / 2
		fld x
		fmul
		fld1
		fld1
		fadd
		fdiv
		fchs
		fadd

		fld x				;   x^4 / 4!
		fld x
		fmul
		fld x
		fmul
		fld x
		fmul
		fild F4
		fdiv
		fadd

		fld x				; - x^6 / 6!
		fld x
		fmul
		fld x
		fmul
		fld x
		fmul
		fld x
		fmul
		fld x
		fmul
		fild F6
		fdiv
		fchs
		fadd

		fld x				;   x^8 / 8!
		fld x
		fmul
		fld x
		fmul
		fld x
		fmul
		fld x
		fmul
		fld x
		fmul
		fld x
		fmul
		fld x
		fmul
		fild F8
		fdiv
		fadd

		fld x				; - x^10 / 10!
		fld x
		fmul
		fld x
		fmul
		fld x
		fmul
		fld x
		fmul
		fld x
		fmul
		fld x
		fmul
		fld x
		fmul
		fld x
		fmul
		fld x
		fmul
		fild F10
		fdiv
		fchs
		fadd

		ret
	asm_cos endp

	simplest_cos proc near c public k:dword
		finit				
		mov eax, k
		mov x, eax
		
		fld x
		fcos

		ret
	simplest_cos endp
end