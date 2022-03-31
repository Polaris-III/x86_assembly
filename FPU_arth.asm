.686p
.model flat, c
.data
	division dd 0
.code
	asm_arth proc near c public a:dword
		finit		
		
		xor ecx, ecx	
		
		fld a
	; ----- a^3 -----
		fld a				
		mov ecx, 2
		cycl1:
			fld a
			fmul
			loop cycl1
		mov eax, 3
		mov division, eax
		fild division
		fdiv
		fadd				
		
	; ----- a^5 -----		
		fld a				
		mov ecx, 4
		cycl2:
			fld a
			fmul
			loop cycl2
		mov eax, 5
		mov division, eax
		fild division
		fdiv
		fadd	
		
	; ----- a^7 -----
		fld a				
		mov ecx, 6
		cycl3:
			fld a
			fmul
			loop cycl3
		mov eax, 7
		mov division, eax
		fild division
		fdiv
		fadd		
		
	; ----- a^9 -----
		fld a				
		mov ecx, 8
		cycl4:
			fld a
			fmul
			loop cycl4
		mov eax, 9
		mov division, eax
		fild division
		fdiv
		fadd
		
	; ----- a^11 -----
		fld a				
		mov ecx, 10
		cycl5:
			fld a
			fmul
			loop cycl5
		mov eax, 11
		mov division, eax
		fild division
		fdiv
		fadd
		
	; ----- a^13 -----
		fld a				
		mov ecx, 12
		cycl6:
			fld a
			fmul
			loop cycl6
		mov eax, 13
		mov division, eax
		fild division
		fdiv
		fadd
		
	; ----- a^15 -----
		fld a				
		mov ecx, 14
		cycl7:
			fld a
			fmul
			loop cycl7
		mov eax, 15
		mov division, eax
		fild division
		fdiv
		fadd
		
	; ----- a^17 -----
		fld a				
		mov ecx, 16
		cycl8:
			fld a
			fmul
			loop cycl8
		mov eax, 17
		mov division, eax
		fild division
		fdiv
		fadd	
		
		ret
	asm_arth endp
end