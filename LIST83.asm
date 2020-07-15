model compact
.stack 256h
.data
;	--------[		0		][ 	 	 1		 ][		  2 	  ][	   3	   ][	   4 	  ]
	list dw 12345, 7500, 830, 500, 1200, 1230, 1900, 600, 1400, 2000, 1000, 500, 40, 670, 1230
	lngt db 5
	elmt db 0, 0, 0, 0, 0
	num  dw 0, 0, 0
	ms1 db 0dh, 0ah, "<Finder> Num 1 / 3: $"
	ms2 db 0dh, 0ah, "<Finder> No match $"
	ms3 db 0dh, 0ah, "<Finder> Position:  $"
	ms4 db 0dh, 0ah, "<Insrtr> Num 1 / 3: $"
	ms5 db 0dh, 0ah, "<Insrtr> Position : $"
	ms6 db 0dh, 0ah, "<Insrtr> Num inserted $"
	ms7 db 0dh, 0ah, "Amount of elements: $"
	ms8 db 0dh, 0ah, "<LstOut> List: $"
	ms9 db " $"
	ms10 db 0dh, 0ah, "<Insrtr> Num 2 / 3: $"
	ms11 db 0dh, 0ah, "<Insrtr> Num 3 / 3: $"
	ms12 db 0dh, 0ah, "<Finder> Num 2 / 3: $"
	ms13 db 0dh, 0ah, "<Finder> Num 3 / 3: $"
	ms14 db "_$"
	ms15 db 0dh, 0ah, "$"
	ms16 db 0dh, 0ah, "<Sort> High dword comp only. Processing...$"
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
	mov dx, offset ms15
	mov ah, 9h				
	int 21h
	outlist:
		call elmtToNull
		mov ax, list[bx]
		push bx
		call NumtoBCD
		call Cout
		mov dx, offset ms14
		mov ah, 9h				
		int 21h
		pop bx
		inc bx
		inc bx
		mov ax, list[bx]
		push bx
		call NumtoBCD
		call Cout
		mov dx, offset ms14
		mov ah, 9h				
		int 21h
		pop bx
		inc bx
		inc bx
		mov ax, list[bx]
		push bx
		call NumtoBCD
		call Cout
		pop bx
		inc bx
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
	mov num[0], ax
	call elmtToNull
	mov dx, offset ms10
	mov ah, 9h
	int 21h
	call GetNum
	call BCDtoNum
	mov num[2], ax
	call elmtToNull
	mov dx, offset ms11
	mov ah, 9h
	int 21h
	call GetNum
	call BCDtoNum
	mov num[4], ax
	
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
	mov dl, 6
	mul dl
	mov bl, al
	xor bh, bh
	mov ax, num[0]
	mov list[bx], ax
	inc bx
	inc bx
	mov ax, num[2]
	mov list[bx], ax
	inc bx
	inc bx
	mov ax, num[4]
	mov list[bx], ax
	
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
			mov ax, list[bx]
			add bx, 6
			mov dx, list[bx]
			cmp ax, dx
			jl nxt_iter
			mov list[bx], ax
			sub bx, 6
			mov list[bx], dx
			add bx, 8
			mov ax, list[bx]
			sub bx, 6
			mov dx, list[bx]
			mov list[bx], ax
			add bx, 6
			mov list[bx], dx
			add bx, 2
			mov ax, list[bx]
			sub bx, 6
			mov dx, list[bx]
			mov list[bx], ax
			add bx, 6
			mov list[bx], dx
			sub bx, 4
			nxt_iter:
		loop incycle
		pop cx
	loop outcycle
	ret
BubbleSort endp

FindSpecial proc

FindSpecial endp

Find proc
	mov dx, offset ms1		; Приглашение ко вводу
	mov ah, 9h				
	int 21h					
	call GetNum
	call BCDtoNum
	mov num[0], ax
	call elmtToNull
	mov dx, offset ms12
	mov ah, 9h
	int 21h
	call GetNum
	call BCDtoNum
	mov num[2], ax
	call elmtToNull
	mov dx, offset ms13
	mov ah, 9h
	int 21h
	call GetNum
	call BCDtoNum
	mov num[4], ax
	
	mov ax, num[0]
	xor ch, ch
	mov cl, lngt
	xor bx, bx
	mov dx, 6
	clc
	look:
		cmp ax, list[bx]
		je gonext
		add bx, dx
	loop look
	;cmp cx, 0
	;jne goback
	
	cmp ax, list[bx]
	jne no_match
	gonext:
	push bx
	inc bx
	inc bx
	mov ax, num[2]
	cmp ax, list[bx]
	jne n_m
	inc bx
	inc bx
	mov ax, num[4]
	cmp ax, list[bx]
	jne n_m
	
	goback:
	pop bx
	mov ax, bx
	mov dl, 6
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
	push cx
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
