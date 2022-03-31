;	Функция расчета арксинуса
;
;	Функция принимает адрес параметра через вершину стека и 
;	возвращает результат через вершину стека сопроцессора
;
;	Использован метод разложения в ряд Маклорена как самый простой
;	и устойчивый в указанном диапазоне значений
;
;[1]		k
;[2]		k^3 / 6
;[3]		3*k^5 / (2*4*5)
;[4]		(3*5)*k^7 / (2*4*6*7)
;[5]		(3*5*7)*k^9 / (2*4*6*8*9)
;[6]		(3*5*7*9)*k^11 / (2*4*6*8*10*11)
;[7]		(3*5*7*9*11)*k^13 / (2*4*6*8*10*12*13)
;[8]		(3*5*7*9*11*13)*k^15 / (2*4*6*8*10*12*14*15)
;	Метод позволяет расчитывать функцию при входных значениях
;	[-0.9; 0.9] с точностью до тысячных
;
.686p
.model flat, c
.data
	oddfact dd 0
	evnfact dd 0
	temp dd 0
.code
asm_arcsin proc near c public a:dword
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
	
	mov eax, 2
	mov ebx, 3
	mul ebx
	mov temp, eax 
	fild temp

	fdiv
	fadd				
; ----- a^5 -----		
	fld a				
	mov ecx, 4
	cycl2:
		fld a
		fmul
		loop cycl2
	
	mov eax, 3
	mov temp, eax
	fild temp
	fmul

	mov eax, 2
	mov ebx, 4
	mul ebx
	mov oddfact, eax
	inc ebx
	mul ebx
	mov temp, eax
	fild temp
	fdiv
	
	fadd				
; ----- a^7 -----
	fld a				
	mov ecx, 6
	cycl3:
		fld a
		fmul
		loop cycl3
	
	mov eax, 3
	mov ebx, 5
	mul ebx
	mov evnfact, eax
	mov temp, eax
	fild temp
	fmul

	mov eax, oddfact
	mov ebx, 6
	mul ebx
	mov oddfact, eax
	inc ebx
	mul ebx
	mov temp, eax
	fild temp
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
	
	mov eax, evnfact
	mov ebx, 7
	mul ebx
	mov evnfact, eax
	mov temp, eax
	fild temp
	fmul

	mov eax, oddfact
	mov ebx, 8
	mul ebx
	mov oddfact, eax
	inc ebx
	mul ebx
	mov temp, eax
	fild temp
	fdiv

	fadd
; ----- a^11 -----
	fld a				
	mov ecx, 10
	cycl5:
		fld a
		fmul
		loop cycl5
	
	mov eax, evnfact
	mov ebx, 9
	mul ebx
	mov evnfact, eax
	mov temp, eax
	fild temp
	fmul
	
	mov eax, oddfact
	mov ebx, 10
	mul ebx
	mov oddfact, eax
	inc ebx
	mul ebx
	mov temp, eax
	fild temp
	fdiv

	fadd

; ----- a^13 -----
	fld a				
	mov ecx, 12
	cycl6:
		fld a
		fmul
		loop cycl6
	
	mov eax, evnfact
	mov ebx, 11
	mul ebx
	mov evnfact, eax
	mov temp, eax
	fild temp
	fmul
	
	mov eax, oddfact
	mov ebx, 12
	mul ebx
	mov oddfact, eax
	inc ebx
	mul ebx
	mov temp, eax
	fild temp
	fdiv

	fadd

; ----- a^15 -----
	fld a				
	mov ecx, 14
	cycl7:
		fld a
		fmul
		loop cycl7
	
	mov eax, evnfact
	mov ebx, 13
	mul ebx
	mov evnfact, eax
	mov temp, eax
	fild temp
	fmul
	
	mov eax, oddfact
	mov ebx, 14
	mul ebx
	mov oddfact, eax
	inc ebx
	mul ebx
	mov temp, eax
	fild temp
	fdiv

	fadd

	ret
asm_arcsin endp
end