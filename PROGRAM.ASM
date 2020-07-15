model small
.stack 100h
.data
	message db "Beeper$"
	beep db 07h
.code
main:
	mov ax, @data			;адрес сегмента данных в ax
	mov ds, ax				;затем в ds
	mov dx, offset message	;адрес строки в dx
	mov ah, 9h				;dos-команда вывода на консоль
	int 21h					;прерывание
	xor ax, ax				;очистка регистра ax
	mov ah, 07h				;dos-команда ввода с клавиатуры
	int 21h
	cmp al, 1bh				;сравнение кода введенного символа	
	jne sbell				;с кодом esc и условный переход
	mov dl, beep				;код bell
	mov ah, 02h				;dos-команда обмена с консолью
	int 21h
sbell:
	mov dl, beep
	mov ah, 02h
	int 21h
	jne main
exit:
	mov ax, 4c00h
	int 21h
end main

