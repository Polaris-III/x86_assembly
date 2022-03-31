;
;	Функция asm_cot использует рассчитывает котангенс через ряд Маклорена
;   Функция sin_div_cos еще проще - используется деление косинуса на синус.
;
;	Для работы с вещественными числами задействуются только регистры сопроцессора. 
;	
.686p
.model flat, c
.data
	x dd 0
	AN dd 3
	BN dd 45
	CN dd 945
	DN dd 4725
	UN dd 2
.code
	asm_cot proc near c public k:dword
		finit				; Инициализация сопроцессора

		mov eax, k
		mov x, eax

		fld1				;   1 / x
		fld k
		fdiv

		fld k				;  -x / 3
		fild AN
		fdiv
		fchs
		fadd

		fld k				; -2x / 45
		fld k
		fmul
		fld k
		fmul
		fild BN
		fdiv
		fchs
		fadd

		fld k				; -2x^5/945
		fld k
		fmul
		fld k
		fmul
		fld k
		fmul
		fld k
		fmul
		fild UN
		fmul
		fild CN
		fdiv
		fchs
		fadd

		fld k				; -2x^7/4725
		fld k
		fmul
		fld k
		fmul
		fld k
		fmul
		fld k
		fmul
		fld k 
		fmul
		fld k
		fmul
		fild UN
		fmul
		fild DN
		fdiv
		fchs
		fadd

		ret
	asm_cot endp

	cos_div_sin proc near c public k:dword
		finit				
		mov eax, k
		mov x, eax
		
		fld x
		fsincos
		fxch
		fdiv

		ret
	cos_div_sin endp
end