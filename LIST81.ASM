model compact
.stack 256h
.data
	list dw 12345, 7500, 830, 500, 1300, 1230, 1900, 600, 1400, 2000, 1000, 0, 0, 0, 0
	lngt db 10
	elmt db 0, 0, 0, 0, 0
	num  dw 0
	ms1 db 0dh, 0ah, "<Finder> Type num: $"
	ms2 db 0dh, 0ah, "<Finder> No match $"
	ms3 db 0dh, 0ah, "<Finder> Position  $"
	ms4 db 0dh, 0ah, "<Insrtr> Type num: $"
	ms5 db 0dh, 0ah, "<Insrtr> Position : $"
	ms6 db 0dh, 0ah, "<Insrtr> Num inserted $"
	ms7 db 0dh, 0ah, "Amount of elements: $"
	ms8 db 0dh, 0ah, "<LstOut> List: $"
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
		mov ax, list[bx]
		;mov ax, dword ptr[list + bx]
		push bx
		call NumtoBCD
		pop bx
		inc bx
		inc bx
		push bx
		push cx
		call Cout
		pop cx
		pop bx
		mov dx, offset ms9
		mov ah, 9h				
		int 21h
		xor ax, ax
	loop outlist
	ret
ListOut endp	
	
Insert proc
	mov dx, offset ms4		
	mov ah, 9h				
	int 21h			
	call GetNum
	call BCDtoNum
	mov num, ax
	mov dx, offset ms5		
	mov ah, 9h				
	int 21h	
	call GetNum
	call BCDtoNum
	mov ah, lngt		
	cmp al, ah	
	jl Swap
	mov al, ah
	
	Swap:
	mov dl, 2
	mul dl
	mov bl, al
	xor bh, bh
	mov ax, num
	
	mov list[bx], ax
	
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
			mov ax, list[bx]
			inc bx
			inc bx
			mov dx, list[bx]
			cmp ax, dx
			jl nxt_iter
			mov list[bx], ax
			dec bx
			dec bx
			mov list[bx], dx
			inc bx
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
		cmp ax, list[bx]
		je goback
		inc bx
		inc bx
	loop look
	cmp cx, 0
	jne goback
	cmp ax, list[bx]
	jne no_match
	
	goback:
	mov ax, bx
	mov dl, 2
	div dl
	call NumtoBCD
	mov dx, offset ms3
	mov ah, 9h				
	int 21h
	call Cout
	ret
	
	no_match:
	push ax
	mov ah, 0
	mov elmt[2], ah
	mov elmt[1], ah
	mov ah, 13
	mov elmt[0], ah
	pop ax
	call Cout
	ret
Find endp

elmtToNull proc
	xor ax, ax
	mov byte ptr[elmt + 4], al
	mov byte ptr[elmt + 3], al
	mov byte ptr[elmt + 2], al
	mov byte ptr[elmt + 1], al
	mov byte ptr[elmt], al
	ret
elmtToNull endp

GetNum proc
	call elmtToNull
	mov cx, 5
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
	cmp cx, 5
	je nonum
	mov bx, 4
	mov ax, 5
	sub ax, cx
	mov cx, ax
StackRet:
	pop ax	
	mov byte ptr[elmt + bx], al
	dec bx
	loop StackRet
	ret
nonum:
	xor al, al
	mov elmt[0], al
	ret
GetNum endp

NumtoBCD proc
	xor dx, dx
	mov bx, 10
	div bx
	mov elmt[4], dl
	xor dx, dx
	div bx
	mov elmt[3], dl
	xor dx, dx
	div bx
	mov elmt[2], dl
	xor dx, dx
	div bx
	mov elmt[1], dl
	mov elmt[0], al
	ret
NumtoBCD endp

BCDtoNum proc
	xor ah, ah
	mov al, elmt[0]
	mov dx, 10000
	mul dx
	mov bx, ax
	xor ah, ah
	mov al, elmt[1]
	mov dx, 1000
	mul dx
	add bx, ax
	xor ah, ah
	mov al, elmt[2]
	mov dx, 100
	mul dx
	add bx, ax
	xor ah, ah
	mov al, elmt[3]
	mov dx, 10
	mul dx
	add bx, ax
	xor ah, ah
	mov al, elmt[4]
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
	mov cx, 5
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
