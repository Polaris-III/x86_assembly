;   Расчитывает sinh через ряд Маклорена до 13 порядка
;	
;	Методика члена ряда:
;	 Расчет x в степени i в сопроцессоре
;	 Расчет факториала i в аккумуляторе, копирование в память и перенос из памяти в st(0)
;	 Деление st(1) на st(0)
;
;	Программа написана для masm, входящего в состав Microsoft VS
.686p
.model flat, c
.data
	factorial dd 0
.code
asm_sinh proc near c public a:dword
	finit				

	xor ecx, ecx	
		
	fld a
; ----- a^3 -----
	fld a				
	mov ecx, 2
	cycl1:
		fld a
		fmul
		loop cycl1
	
	mov ecx, 3
	mov eax, 1
	fct1:
		mul ecx
		loop fct1
	mov factorial, eax 
	fild factorial

	fdiv
	fadd				
; ----- a^5 -----		
	fld a				
	mov ecx, 4
	cycl2:
		fld a
		fmul
		loop cycl2
	mov eax, 5
	
	mov ecx, 5
	mov eax, 1
	fct2:
		mul ecx
		loop fct2
	mov factorial, eax 
	fild factorial

	fdiv
	fadd				
; ----- a^7 -----
	fld a				
	mov ecx, 6
	cycl3:
		fld a
		fmul
		loop cycl3
	mov eax, 7
	
	mov ecx, 7
	mov eax, 1
	fct3:
		mul ecx
		loop fct3
	mov factorial, eax 
	fild factorial

	fdiv
	fadd				
; ----- a^9 -----
	fld a				
	mov ecx, 8
	cycl4:
		fld a
		fmul
		loop cycl4
	mov eax, 9
	
	mov ecx, 9
	mov eax, 1
	fct4:
		mul ecx
		loop fct4
	mov factorial, eax 
	fild factorial

	fdiv
	fadd
; ----- a^11 -----
	fld a				
	mov ecx, 10
	cycl5:
		fld a
		fmul
		loop cycl5
	mov eax, 11
	
	mov ecx, 11
	mov eax, 1
	fct5:
		mul ecx
		loop fct5
	mov factorial, eax 
	fild factorial

	fdiv
	fadd
; ----- a^13 -----
	fld a				
	mov ecx, 12
	cycl6:
		fld a
		fmul
		loop cycl6
	mov eax, 13
	
	mov ecx, 13
	mov eax, 1
	fct6:
		mul ecx
		loop fct6
	mov factorial, eax 
	fild factorial

	fdiv
	fadd

	ret
asm_sinh endp
end