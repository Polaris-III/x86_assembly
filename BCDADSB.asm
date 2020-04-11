model small
.stack 100h
.data
	message1 db "Type first term: $"
	message2 db 0dh, 0ah, "Type second term: $"
	message3 db 0dh, 0ah, "Amount: $"
	term1 db 11 dup(0)
	term2 db 11 dup(0)
	reslt db 12 dup(0)
;
;	Число в памяти:
;	0-9 - цифры*
;	10  - знак
;
;	0	1	2	3	4	5	6	7	8	9	10	
;	num num num num num num num num num num sign
;	
;	Формат хранения - неупакованный BCD
;	*В числе-результате 11 цифр
;
;
;	Метки:
;	NegX 			- добавление знака минус
;	inputX 			- познаковый ввод и запись в стек
;	RetFromStackX	- возврат цифры из стека
;	 StackRetX		- в цикле
;	addiction		- сложение
;	 addict			- в цикле
;	sub_preparing	- подготовка к вычитанию
;	 maxis			- сравнение чисел
;	  next_step		- переход к следующей итерации сравнения
;	  term1_greater - завершает цикл и выясняет знак первого
; 	 swap			- если первое меньше второго, то их стоит обменять
;	  sw			- в цикле
;	substraction	- вычитание
;	 substract		- в цикле
;	Mssg			- вывод сообщения	
;	TillZero		- подготовка к выводу числа
;	Print			- вывод числа
;	 prt			- в цикле
;	GetSym			- функция получения символа
;

.code
main:
	mov ax, @data				; адрес сегмента данных в ax
	mov ds, ax					; затем в ds
	
	mov dx, offset message1		; Приглашение ко вводу
	mov ah, 9h				
	int 21h					
	xor ax, ax				

; Ввод первого числа
	mov cx, 11
	call GetSym
	cmp al, 0fdh				; Сохраняем знак минус, если он введен
	je Neg1
	dec cx
	dec cx
	xor ah, ah
	push ax
	jmp input1
Neg1:
	dec cx
	mov term1[10], 2dh
input1:							; Вызов функции чтения и запись в стек
	call GetSym
	cmp al, 0dh
	je RetFromStack1
	xor ah, ah
	push ax
	loop input1
	
RetFromStack1:					; Возврат числа из стека
	mov bx, 9
	mov ax, 10
	sub ax, cx
	mov cx, ax
StackRet1:
	pop ax	
	mov byte ptr[term1 + bx], al
	dec bx
	loop StackRet1
	
	mov dx, offset message2		; Приглашение ко вводу
	mov ah, 9h				
	int 21h					
	xor ax, ax				

; ############################# Ввод второго числа	
	mov cx, 11
	call GetSym
	cmp al, 0fdh
	je Neg2						; Сохраняем знак минус, если он введен
	dec cx
	dec cx
	xor ah, ah
	push ax
	jmp input2
Neg2:
	dec cx
	mov term2[10], 2dh
input2:
	call GetSym
	cmp al, 0dh
	je RetFromStack2
	xor ah, ah
	push ax
	loop input2
	
RetFromStack2:
	mov bx, 9
	mov ax, 10
	sub ax, cx
	mov cx, ax
StackRet2:
	pop ax	
	mov byte ptr[term2 + bx], al
	dec bx
	loop StackRet2
	
	mov al, term1[10] 
	cmp al, term2[10]
	jne sub_preparing
; ############################# Суммирование
addiction:
	mov cx, 10
	mov bx, 9
addict:
	mov al, term1[bx]
	adc al, term2[bx]
	aaa
	inc bx
	mov reslt[bx], al
	dec bx
	dec bx
	
	loop addict
	adc reslt[0], 0
	jmp Mssg
; ############################# Обмен первого и второго слагаемых
swap:
	mov cx, 10
	xor bx, bx
sw:
	mov al, term1[bx]
	mov ah, term2[bx]
	mov term1[bx], ah
	mov term2[bx], al
	inc bx
	loop sw
	
	mov al, term2[10]
	cmp al, 2dh
	jne substraction
	mov reslt[11], 2dh
	jmp substraction
; ############################# Вычитание
sub_preparing:
	mov cx, 10
	xor bx, bx
maxis:	
	inc bx
	mov al, term1[bx]
	cmp al, term2[bx]
	jb swap
	je next_step
	jnb term1_greater
next_step:
	loop maxis
term1_greater:
	mov al, term1[10]
	cmp al, 2dh
	jne substraction
	mov reslt[11], al
	
substraction:	
	mov cx, 10
	mov bx, 9
	
	clc
substract:
	mov al, term1[bx]
	sbb al, term2[bx]
	aas
	inc bx
	mov reslt[bx], al
	dec bx
	dec bx
	loop substract
Mssg:
	mov dx, offset message3		; Заголовок результата
	mov ah, 9h				
	int 21h					
	xor ax, ax
	
	xor bx, bx
	mov cx, 11
	mov ah, 02h
	
TillZero:						; Старшие нули выводить не обязательно
	mov dl, reslt[bx]
	cmp dl, 0
	jne Print
	inc bx
	loop TillZero
	cmp cx, 0
	jne Print
	mov dl, 30h
	int 21h
	jmp exit
Print:							; Нули закончились, будем выводить
	mov al, reslt[11]
	cmp al, 2dh
	jne prt
	mov dl, al
	int 21h
prt:							
	mov dl, reslt[bx]
	add dl, 30h
	int 21h
	inc bx
	loop prt
	
EXIT:
	mov ax, 4c00h
	int 21h
	
GetSym proc 					; Функция познакового ввода. Ожидает клавиатуру
Again:
	mov ah, 08h
	int 21h
	
	cmp al, 2dh
	je NegChar
	cmp al, 0dh
	je Back
	cmp al, '0'
	jb Again
	cmp al, '9'
	ja Again
	jmp SymEcho
NegChar:
	cmp cx, 11
	jne Again
SymEcho:
	push dx
	mov ah, 02h
	mov dl, al
	int 21h
	pop dx
	sub al, 30h
Back:
	ret
GetSym endp

end main

