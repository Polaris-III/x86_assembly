model small
.stack 256h
.data
	list db 123, 75, 83, 5, 13, 123, 19, 6, 14, 2, 1, 0, 0, 0, 0
	lngt dw 10
	elmt db 0, 0, 0
	rslt db 0, 0, 0
	ms1 db 0dh, 0ah, "Type a number you want to find: $"
	ms2 db 0dh, 0ah, "No match $"
	ms3 db 0dh, 0ah, "This element have number $"
	mss db 0dh, 0ah, ""
.code
main:
	mov ax, @data				
	mov ds, ax
	
	mov dx, offset ms1		; Приглашение ко вводу
	mov ah, 9h				
	int 21h					
	xor ax, ax
	
	mov cx, 3
Input:
	call GetSym
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
	
	call Find
	
	call Cout
exit:
	mov ax, 4c00h
	int 21h
Sort proc
	mov cx, lngt
	compare:
		push cx
		mov cx, lngt
		incompare:
			
		loop incompare
		pop cx
	loop compare
Sort endp
	
Find proc
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
	
	mov cx, lngt
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
	mov bx, 10
	div bl
	mov rslt[2], ah
	xor ah, ah
	div bl
	mov rslt[1], ah
	xor ah, ah
	mov rslt[0], al
	jmp return
	no_match:
	mov ah, 0
	mov rslt[2], ah
	mov rslt[1], ah
	mov ah, 13
	mov rslt[0], ah
	return:
	ret
Find endp
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
	;mov dl, elmt[bx]
	mov dl, rslt[bx]
	cmp dl, 0
	jne Print
	inc bx
	loop TillZero
	cmp cx, 0
	jne Print
	mov dx, offset ms3
	mov ah, 9h				
	int 21h
	mov ah, 2h
	mov dl, 30h
	int 21h
	jmp exit
Print:							
	cmp	rslt[0], 13	
	je no_match_message
	mov dx, offset ms3
	mov ah, 9h				
	int 21h
prt:				
	;mov dl, elmt[bx]
	mov ah, 2h
	mov dl, rslt[bx]
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

