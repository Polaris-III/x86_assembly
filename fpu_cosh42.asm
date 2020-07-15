;
;	������� ������������� ���������� ����� C
;   ����������� ��������������� ������� ����� ��� ���������
;	��� �� �������������� �������, ������� �� 8 ���������
;	
;	����� ������� ����� ����������� � ����������� cmath ������� �� �����
;	��� ������� �������� ������� � ~4.5. ����������� ����� ����������������
;   ��������. 
;	
;	��� ��������� ������ 2 �������� �� 10^-5
;
;	��� ������ � ������������� ������� ������������� ������ �������� ������������. 
;	
.686p
.model flat, c
.data
	x dd 0
.code
	asm_cosh proc near c public k:dword
		finit				; ������������� ������������

		mov eax, k
		mov x, eax

		xor ecx, ecx	
		mov ecx, 2

		fld k				; k^2
		fld k
		fmul

		mov eax, 2
		call factx
		fild x
		fdiv
		
		fld k				; k^4
		mov ecx, 3
		foldx2:
			fld k
			fmul
			loop foldx2
		mov eax, 4
		call factx
		fild x
		fdiv
		fadd				; �������� k^2 � k^4
		
		fld k				; k^6
		mov ecx, 5
		foldx3:
			fld k
			fmul
			loop foldx3
		mov eax, 6
		call factx
		fild x
		fdiv
		fadd				; �������� (k^2 + k^4) � k^6

		fld k				; k^8
		mov ecx, 7
		foldx4:
			fld k
			fmul
			loop foldx4
		mov eax, 8
		call factx
		fild x
		fdiv
		fadd				; �������� (k^2 + k^4 + k^6) � k^8

		fld k				; k^10
		mov ecx, 9
		foldx5:
			fld k
			fmul
			loop foldx5
		mov eax, 10
		call factx
		fild x
		fdiv
		fadd

		fld k				; k^12
		mov ecx, 11
		foldx6:
			fld k
			fmul
			loop foldx6
		mov eax, 12
		call factx
		fild x
		fdiv
		fadd

		fld k				; k^14
		mov ecx, 13
		foldx7:
			fld k
			fmul
			loop foldx7
		mov eax, 14
		call factx
		fild x
		fdiv
		fadd

		fld1
		fadd

		ret
	asm_cosh endp
	
	factx proc
		mov ecx, eax
		push eax
		mov eax, 1
		admul:
			mul ecx
			loop admul
		mov x, eax 
		pop eax
		ret
	factx endp
end