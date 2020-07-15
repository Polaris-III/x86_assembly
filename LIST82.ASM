model compact
.stack 256h
.data
;	--------[	 0	  ] [ 	   1	  ] [	  2     ] [	 	 3	    ] [	   4    ] [    5    ][    6    ]
	list db 123, 13, 30, 110, 200, 230, 100, 173, 100, 200, 150, 170, 40, 10, 130, 76, 19, 4, 45, 53, 19
	lngt db 7
	elmt db 0, 0, 0
	num  db 0, 0, 0
	ms1 db 0dh, 0ah, "[Searching] Type num(less 256)[1]: $"
	ms2 db 0dh, 0ah, "[Searching] No match $"
	ms3 db 0dh, 0ah, "[Searching] This num have position $"
	ms4 db 0dh, 0ah, "[Inserting] Type num(less 256)[1]:  $"
	ms5 db 0dh, 0ah, "[Inserting] Type prefered position: $"
	ms6 db 0dh, 0ah, "[Inserting] Number inserted $"
	ms7 db 0dh, 0ah, ""
	ms8 db 0dh, 0ah, "[ConsolOut] Elements total: $"
	ms9 db " $"
	ms10 db 0dh, 0ah,"[Inserting] Type num(less 256)[2]:  $"
	ms11 db 0dh, 0ah,"[Inserting] Type num(less 256)[3]:  $"
	ms12 db 0dh, 0ah,"[Searching] Type num(less 256)[2]: $"
	ms13 db 0dh, 0ah,"[Searching] Type num(less 256)[3]: $"
	ms14 db "_$"
	ms15 db 0dh, 0ah, "$"
	ms16 db 0dh, 0ah, "[Bubblesrt] Compare highest bytes only. Processing...$"
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
	xor ax, ax
	mov al, lngt
	call NumtoBCD
	call Cout
	mov dx, offset ms15
	mov ah, 9h				
	int 21h
	xor bx, bx
	outlist:
		call elmtToNull
		mov al, list[bx]
		push bx
		call NumtoBCD
		call Cout
		mov dx, offset ms14
		mov ah, 9h				
		int 21h
		pop bx
		inc bx
		call elmtToNull
		mov al, list[bx]
		push bx
		call NumtoBCD
		call Cout
		mov dx, offset ms14
		mov ah, 9h				
		int 21h
		pop bx
		inc bx
		call elmtToNull
		mov al, list[bx]
		push bx
		call NumtoBCD
		call Cout
		pop bx
		inc bx
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
	mov num[0], al
	call elmtToNull
	mov dx, offset ms10
	mov ah, 9h
	int 21h
	call GetNum
	call BCDtoNum
	mov num[1], al
	call elmtToNull
	mov dx, offset ms11
	mov ah, 9h
	int 21h
	call GetNum
	call BCDtoNum
	mov num[2], al
	
	mov dx, offset ms5		
	mov ah, 9h				
	int 21h	
	call GetNum
	call BCDtoNum
	mov ah, lngt		
	cmp al, ah	
	jl Swap
	dec ah
	mov al, ah
	
	Swap:
	mov dl, 3
	mul dl
	mov bl, al
	xor bh, bh
	mov al, num[0]
	mov list[bx], al
	inc bx
	mov al, num[1]
	mov list[bx], al
	inc bx
	mov al, num[2]
	mov list[bx], al
	
	mov dx, offset ms6
	mov ah, 9h				
	int 21h					
	xor ax, ax
	ret
Insert endp

BubbleSort proc
	mov dx, offset ms16
	mov ah, 9h				
	int 21h
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
			add bx, 3
			mov ah, list[bx]
			cmp al, ah
			jb nxt_iter
			mov list[bx], al
			sub bx, 3
			mov list[bx], ah
			inc bx
			mov al, list[bx]
			add bx, 3
			mov ah, list[bx]
			mov list[bx], al
			sub bx, 3
			mov list[bx], ah
			inc bx
			mov al, list[bx]
			add bx, 3
			mov ah, list[bx]
			mov list[bx], al
			sub bx, 3
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
	call GetNum
	call BCDtoNum
	mov num[0], al
	call elmtToNull
	mov dx, offset ms12
	mov ah, 9h
	int 21h
	call GetNum
	call BCDtoNum
	mov num[1], al
	call elmtToNull
	mov dx, offset ms13
	mov ah, 9h
	int 21h
	call GetNum
	call BCDtoNum
	mov num[2], al
	
	mov al, num[0]
	xor ch, ch
	mov cl, lngt
	xor bx, bx
	mov dx, 3
	clc
	look:
		cmp al, list[bx]
		je gonext
		add bx, dx
	loop look
	
	cmp al, list[bx]
	jne no_match
	gonext:
	push bx
	inc bx
	mov al, num[1]
	cmp al, list[bx]
	jne n_m
	inc bx
	mov al, num[2]
	cmp al, list[bx]
	jne n_m
	
	goback:
	pop bx
	mov al, bl
	mov dl, 3
	div dl
	call NumtoBCD
	mov dx, offset ms3
	mov ah, 9h				
	int 21h
	call Cout
	ret
	
	n_m:
	pop bx
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
	mov byte ptr[elmt + 2], al
	mov byte ptr[elmt + 1], al
	mov byte ptr[elmt], al
	ret
elmtToNull endp

GetNum proc
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
	cmp cx, 3
	je nonum
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
nonum:
	xor al, al
	mov elmt[0], al
	ret
GetNum endp

NumtoBCD proc
	xor dx, dx
	mov bx, 10
	div bl
	mov elmt[2], ah
	xor ah, ah
	div bl
	mov elmt[1], ah
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
	push cx
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
	pop cx
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
	pop cx
	ret
	no_match_message:
	mov dl, offset ms2
	mov ah, 9h				
	int 21h
	pop cx
	ret
Cout endp

end main
