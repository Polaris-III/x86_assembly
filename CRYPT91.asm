model compact
.stack 256h
.data
	tabl db 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
	list db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	cryp db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	tbln db 10
	lsln db 10
	elmt db 0, 0, 0
	num  db 0
	
	ms1 db 0dh, 0ah, "Type list:    $"
	ms2 db 0dh, 0ah, "No match $"
	ms3 db 0dh, 0ah, "Crypt table:  $"
	ms4 db 0dh, 0ah, "Crypted list: $"
	ms5 db 0dh, 0ah, "Crypting...$"
	ms6 db 0dh, 0ah, "Decrypting...$"
	ms8 db 0dh, 0ah, "List:         $"
	ms9 db " $"
.code
main:
	mov ax, @data				
	mov ds, ax	
	
	call TablOut
	call GetList
	call ListOut
	call Crypt
	call CrypOut
	call Decrypt
	call ListOut
exit:
	mov ax, 4c00h
	int 21h
	
ListOut proc
	xor ch, ch
	xor bx, bx
	mov cl, lsln
	mov dx, offset ms8	
	mov ah, 9h				
	int 21h
	call Cout
	ret
ListOut endp	

Crypt proc
	mov dx, offset ms5
	mov ah, 9h				
	int 21h
	mov cx, 10
	xor bx, bx
	cr:
		push cx
		push bx
		mov al, list[bx]
		call SearchTabl
		pop bx
		mov cryp[bx], al
		pop cx
		inc bx
	loop cr
	ret
Crypt endp

Decrypt proc
	mov dx, offset ms6
	mov ah, 9h				
	int 21h
	mov cx, 10
	xor bx, bx
	xor ax, ax
	dcr:
		mov dl, cryp[bx]
		push bx
		mov bl, dl
		mov al, tabl[bx]
		pop bx
		mov list[bx], al
		inc bx
	loop dcr
	ret
Decrypt endp

SearchTabl proc
	mov cx, 10
	xor bx, bx
	look:
		mov ah, tabl[bx]
		cmp al, ah
		je return
		inc bx
		loop look
	return:
	mov al, bl
	ret
SearchTabl endp

GetList proc
	mov dx, offset ms1
	mov ah, 9h				
	int 21h
	mov cx, 10
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
	cmp cx, 10
	je nonum
	mov bx, 9
	mov ax, 10
	sub ax, cx
	mov cx, ax
StackRet:
	pop ax	
	mov byte ptr[list + bx], al
	dec bx
	loop StackRet
	ret
	nonum:
	xor al, al
	mov list[0], al
	ret
GetList endp

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
	mov dx, offset ms9
	mov ah, 9h				
	int 21h
	pop dx
	sub al, 30h
	Back:
	ret
GetSym endp

Cout proc
	xor bx, bx
	mov cx, 10
	mov ah, 2h
prt:				
	mov ah, 2h
	mov dl, list[bx]
	add dl, 30h
	int 21h
	inc bx
	mov dx, offset ms9
	mov ah, 9h				
	int 21h
	loop prt
	ret
Cout endp

CrypOut proc
	mov dx, offset ms4
	mov ah, 9h				
	int 21h
	xor bx, bx
	xor cx, cx
	mov cl, lsln
	mov ah, 2h
prtcryp:				
	mov ah, 2h
	mov dl, cryp[bx]
	add dl, 30h
	int 21h
	inc bx
	mov dx, offset ms9
	mov ah, 9h				
	int 21h
	loop prtcryp
	ret
CrypOut endp

TablOut proc
	mov dx, offset ms3
	mov ah, 9h				
	int 21h
	xor bx, bx
	xor cx, cx
	mov cl, tbln
prttabl:				
	mov ah, 2h
	mov dl, tabl[bx]
	add dl, 30h
	int 21h
	inc bx
	mov dx, offset ms9
	mov ah, 9h				
	int 21h
	loop prttabl
	ret
TablOut endp

end main
