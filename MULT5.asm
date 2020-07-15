model small
.stack 100h
.data
	message1 db "Term 1: $"
	message2 db 0dh, 0ah, "Term 2: $"
	message3 db 0dh, 0ah, "Amount: $"
	l_byte_ptr db 19
	A db 11 dup(0)
	B db 11 dup(0)
	temp  db 10 dup(0)
	F db 21 dup(0)
;
;	Представление числа в памяти:
;	0-9 - цифры*
;	10  - знак
;
;	[0	 1	 2	 3	 4	 5	 6	 7	 8	 9	 10]	
;	num num num num num num num num num num sign
;	
;	Формат хранения - неупакованный BCD
;	*В числе-результате 20 цифр
;
;	Метки:
;	NegX 			- добавление знака минус
;	inputX 			- познаковый ввод и запись в стек
;	RetFromStackX	- возврат цифры из стека
;	 StackRetX		- в цикле
;	multiplication	- умножение
;	 mult			- в цикле
;	 TotheResult	- суммирование временной ячейки с результатом
;	Mssg			- вывод сообщения	
;	TillZero		- подготовка к выводу числа
;	Print			- вывод числа
;	 prt			- в цикле
;	GetSym			- функция получения символа
;
;	Как происходит ввод:
;	 Ожидается первый символ
;	  Если "-", то сохраняем в X[10] и эхаем на консоль этот символ
;	  Если не цифра, то ожидаем повторно
;	  Если цифра, то уменьшаем итератор до 9, сохраняем в стек и эхаем
;	 Ожидается второй и дальнейшие
;	  Если цифра, то сохраняем в стек, уменьшаем итератор и эхаем
;	  Если не цифра, то ожидаем повторно(то же касается и "-")
;	  Если "Enter", то ввод завершается
;	 Число ограничено десятью символами, поэтому при вводе десятого значащего символа
;	 ввод будет завершен 
;	Ввод завершается, символы из стека фиксируются в памяти
;
;	Как происходит умножение:
;	 Умножается каждый символ первого на один символ второго числа
;	  Результат фиксируется в цепочке-посреднике
;	 Посредник суммируется с цепочкой-результатом с учетом разрядного смещения
;	
;	Как происходит вывод:
;	 Вывод на консоль не осуществляется пока не найден первый ненулевой символ
;	  Если ненулевых нет, выводится "0"
;	 Выводится знак "-", если он сохранен
;	 Выводится число
;
;	Знак результирующего числа определяется знаками введенных чисел:
;	 Если знаки равны, то число положительное
;	 Если не равны, то в F[20] фиксируется "-"
;
.code
main:
	mov ax, @data				
	mov ds, ax						
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
	mov A[10], 2dh
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
	mov byte ptr[A + bx], al
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
	mov B[10], 2dh
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
	mov byte ptr[B + bx], al
	dec bx
	loop StackRet2
	
; ############################# Умножение
	mov cx, 10
	mov dh, 9 
multiplication:
	push cx
	mov bx, 9
	mov cx, 10
	xor dl, dl
	xor ax, ax
	clc
mult:
	push bx
	xor bh, bh
	mov bl, dh
	mov al, B[bx]
	pop bx
	mul A[bx]
	aam
	adc al, dl
	aaa
	mov temp[bx], al
	mov dl, ah
	dec bx
	loop mult
	dec dh
	
	mov cx, 10
	mov bx, 9
	clc
ToTheResult:
	mov al, temp[bx]
	push bx
	mov bl, l_byte_ptr
	adc al, F[bx]
	aaa
	mov dl, ah
	mov F[bx], al
	dec bx
	mov l_byte_ptr, bl
	pop bx
	dec bx
	
	loop ToTheResult
	
	mov al, l_byte_ptr
	add al, 9
	mov l_byte_ptr, al
	
	pop cx
	loop multiplication
	
	mov cx, 10
	mov bx, 10
; ############################# Выясняем знаки введенных чисел
	mov al, A[10]
	cmp al, B[10]
	je Mssg
	mov F[20], 2dh

; ############################# Вывод результата на консоль	
Mssg:
	mov dx, offset message3		; Заголовок результата
	mov ah, 9h				
	int 21h					
	xor ax, ax
	
	xor bx, bx
	mov cx, 20
	mov ah, 02h
TillZero:						; Пропускаем старшие нули
	mov dl, F[bx]
	cmp dl, 0
	jne Print
	inc bx
	loop TillZero
	cmp cx, 0
	jne Print
	mov dl, 30h
	int 21h
	jmp exit
Print:							; Вывод числа
	mov al, F[20]
	cmp al, 2dh
	jne prt
	mov dl, al
	int 21h
prt:							
	mov dl, F[bx]
	add dl, 30h
	int 21h
	inc bx
	loop prt
	
EXIT:
	mov ax, 4c00h
	int 21h
	
GetSym proc 					; Познаковый ввод
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

