model small
.stack 100h
.data
	message1 db "######################### ASCII Table (from 32 to 255) #########################$"
	message2 db "################################################################################$"
	num db 3 dup (0)
.code 
.286 
org	100h
start:    
	mov ax, @data
	mov ds, ax
	
	mov ah, 9h				; Заголовок таблицы
	mov dx, offset message1
	int 21h
	
	mov al, 1				; Номер элемента таблицы. Для вывода на экран используется BCD формат
	mov num[2], al
	mov al, 3
	mov num[1], al
	mov al, 0
	mov num[0], al
	xor dh, dh
	xor cx, cx
	mov dl, 20h
	mov ah, 2h
	int 21h
cout:
	cmp dl, 20h				; Завершение при переполнении (не выводить код >255)
	jb quit
	int 21h					; Вывод символа таблицы
	mov bl, dl
	mov dl, 20h
	int 21h
	mov dl, bl
	inc dl
	push dx
	
	mov al, num[2]			; Вычисление номера элемента таблицы
	inc al
	aaa
	mov num[2], al 
	
	mov al, num[1]	
	adc al, 0
	aaa
	mov num[1], al
	
	mov al, num[0]
	adc al, 0
	aaa
	mov num[0], al
	
	mov ah, 2h				; Вывод номера элемента
	mov al, num[0]
	add al, 30h
	mov dl, al
	xor al, al
	int 21h
	mov al, num[1]
	add al, 30h
	mov dl, al
	xor al, al
	int 21h
	mov al, num[2]
	add al, 30h
	mov dl, al
	xor al, al
	int 21h
	
	xor dl, dl				; Разделительный пробел
	int 21h
	
	inc cx
	cmp cx, 13				; Для достижения удобочитаемости таблица выводится в 13 столбцов
	jne again
	xor cx, cx
	mov dl, 0ah
	int 21h
	mov dl, 0dh
	int 21h
	mov dl, 20h
	int 21h
again:
	pop dx
	jmp cout
quit:
	mov dl, 0ah
	int 21h
	mov dl, 0dh
	int 21h
	mov ah, 9h
	mov dx, offset message2
	int 21h
	mov ax, 4c00h			; Код выхода из программы
	int 21h
end start 



