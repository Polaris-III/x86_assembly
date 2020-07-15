model small
.stack 100h
.data
	message db "Beeper$"
	tone dw 2651
.code
main:
	mov ax, @data			;адрес сегмента данных в ax
	mov ds, ax				;затем в ds
	mov dx, offset message	;адрес строки в dx
	mov ah, 9h				;dos-команда вывода на консоль
	int 21h					;прерывание
input:
	xor ax, ax				;очистка регистра ax
	mov ah, 07h				;dos-команда ввода с клавиатуры
	int 21h
	push ax
	in al, 61h
	or al, 3
	out 61h, al
	mov cx, 0ffffh
	mov ax, tone
	out 42h, al
	xchg al, ah
	out 42h, al
	pop ax
	cmp al, 0dh				;сравнение кода введенного символа	
	je exit					;с кодом enter и условный переход
briefly:
	nop
	loop briefly
	in al, 61h
	and al, 0fch
	out 61h, al
	jmp input
exit:
	mov cx, 10
widely:
	push cx
	mov cx, 0ffffh
briefly2:
	nop
	loop briefly2
	pop cx
	loop widely
	in al, 61h
	and al, 0fch
	out 61h, al
	mov ax, 4c00h
	int 21h
end main

