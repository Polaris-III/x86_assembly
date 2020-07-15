model compact
.stack 256h
.data
	list db 123, 75, 83, 5, 13, 123, 19, 6, 14, 2, 1, 0, 0, 0, 0
	lngt db 10
	elmt db 0, 0, 0
	num  db 0
	ms1 db 0dh, 0ah, "Type a number you want to find: $"
	ms2 db 0dh, 0ah, "No match $"
	ms3 db 0dh, 0ah, "This element have number $"
	ms4 db 0dh, 0ah, "Type a number you want to insert(less 256): $"
	ms5 db 0dh, 0ah, "Type a position: $"
	ms6 db 0dh, 0ah, "Number inserted $"
	ms7 db 0dh, 0ah, "Amount of elements: $"
	ms8 db 0dh, 0ah, "List: $"
	ms9 db " $"
.code
main:
	mov ax, @data				
	mov ds, ax
	
	call ListOut
	call Find
	call Insert
	call ListOut
	call BubbleSort
	call ListOut
exit:
	mov ax, 4c00h
	int 21h
ListOut proc
	xor ch, ch
	xor bx, bx
	mov cl, lngt
	mov dx, offset ms8	
	mov ah, 9h				
	int 21h
	outlist:
		call elmtToNull
		xor ah, ah
		mov al, list[bx]
		push bx
		call NumtoBCD
		pop bx
		inc bx
		push bx
		push cx
		call Cout
		pop cx
		pop bx
		mov dx, offset ms9
		mov ah, 9h				
		int 21h
	loop outlist
	ret
ListOut endp	
	
Insert proc
	mov dx, offset ms4		
	mov ah, 9h				
	int 21h			
	call GetNum
	call BCDtoNum
	mov num, al
	mov dx, offset ms5		
	mov ah, 9h				
	int 21h	
	call GetNum
	call BCDtoNum
	mov ah, lngt		
	cmp al, ah			
	jl Swap
	mov al, ah
	;xor ch, ch			; Нереализованные наработки добавления нового(с расширением массива) элемента
	;mov cl, lngt		; Заморожено в связи с трудностями возврата значений из стека
	;mov bx, cx
	;sub cl, al
	
	;xor ah, ah
	;mov dl, cl
	;ToStack:
	;	mov al, list[bx]
	;	push ax
	;	dec bx
	;loop ToStack
	;inc bx
	;mov al, num
	;mov list[bx], al
	;xor ch, ch
	;mov cl, dl
	;FromStack:
	;	pop ax
	;	mov list[bx], al
	;	inc bx	
	;loop FromStack
	Swap:
	mov bl, al
	xor bh, bh
	mov al, num
	mov list[bx], al
	
	mov dx, offset ms6
	mov ah, 9h				
	int 21h					
	xor ax, ax
	ret
Insert endp

BubbleSort proc
	xor ch, ch
	mov cl, lngt
	dec cl
	outcycle:
		xor bx, bx
		push cx
		xor ch, ch
		mov cl, lngt
		dec cl
		incycle:
			mov al, list[bx]
			inc bx
			mov ah, list[bx]
			cmp al, ah
			jl nxt_iter
			mov list[bx], al
			dec bx
			mov list[bx], ah
			inc bx
			nxt_iter:
		loop incycle
		pop cx
	loop outcycle
	ret
BubbleSort endp

Find proc
	mov dx, offset ms1		; Приглашение ко вводу
	mov ah, 9h				
	int 21h					
	xor ax, ax
	call GetNum
	call BCDtoNum
	
	xor ch, ch
	mov cl, lngt
	xor bx, bx
	clc
	look:
		cmp al, list[bx]
		je goback
		inc bx
	loop look
	cmp cx, 0
	jne goback
	cmp al, list[bx]
	jne no_match
	
	goback:
	mov ax, bx
	call NumtoBCD
	mov dx, offset ms3
	mov ah, 9h				
	int 21h
	call Cout
	ret
	
	no_match:
	mov ah, 0
	mov elmt[2], ah
	mov elmt[1], ah
	mov ah, 13
	mov elmt[0], ah
	call Cout
	ret
Find endp

elmtToNull proc
	xor ax, ax
	mov byte ptr[elmt + 2], al
	mov byte ptr[elmt + 1], al
	mov byte ptr[elmt], al
	ret
elmtToNull endp

GetNum proc
	;xor ax, ax
	;mov byte ptr[elmt + 2], al
	;mov byte ptr[elmt + 1], al
	;mov byte ptr[elmt], al
	call elmtToNull
	mov cx, 3
Input:
	push cx
	call GetSym
	pop cx
	cmp al, 0dh
	je RetFromStack
	xor ah, ah
	push ax
	loop Input
RetFromStack:					; Возврат числа из стека
	mov bx, 2
	mov ax, 3
	sub ax, cx
	mov cx, ax
StackRet:
	pop ax	
	mov byte ptr[elmt + bx], al
	dec bx
	loop StackRet
	ret
GetNum endp

NumtoBCD proc
	mov bx, 10
	div bl
	mov elmt[2], ah
	xor ah, ah
	div bl
	mov elmt[1], ah
	xor ah, ah
	mov elmt[0], al
	ret
NumtoBCD endp

BCDtoNum proc
	xor ah, ah
	mov al, elmt[0]
	mov dx, 100
	mul dx
	mov bx, ax
	xor ah, ah
	mov al, elmt[1]
	mov dx, 10
	mul dx
	add bx, ax
	xor ah, ah
	mov al, elmt[2]
	add bx, ax
	mov ax, bx
	ret
BCDtoNum endp

GetSym proc 					
Again:
	mov ah, 08h
	int 21h
	
	cmp al, 0dh
	je Back
	cmp al, '0'
	jb Again
	cmp al, '9'
	ja Again
	jmp SymEcho
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

Cout proc
	xor bx, bx
	mov cx, 3
	mov ah, 2h
TillZero:						; Старшие нули выводить не обязательно
	mov dl, elmt[bx]
	cmp dl, 0
	jne Print
	inc bx
	loop TillZero
	cmp cx, 0
	jne Print
	mov ah, 2h
	mov dl, 30h
	int 21h
	ret
Print:							
	cmp	elmt[0], 13	
	je no_match_message
prt:				
	mov ah, 2h
	mov dl, elmt[bx]
	add dl, 30h
	int 21h
	inc bx
	loop prt
	ret
	no_match_message:
	mov dl, offset ms2
	mov ah, 9h				
	int 21h
	ret
Cout endp

end main
