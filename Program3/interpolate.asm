;Interpolate
;Author:	Will Westrich
;Date:		10/24/18

.386
.MODEL FLAT

INCLUDE debug.h
INCLUDE compute_b.h

PUBLIC interpolate_proc

; variables
points_addr		EQU [ebp+14]
x				EQU [ebp+10]
degree			EQU [ebp+8]
temp			EQU [ebp-2]

.CODE

interpolate_proc	PROC	NEAR32

		push ebp
		mov ebp, esp
		pushw 0
		push ecx
		push edx
		pushf
		
		;Outer loop to get all terms needed in formula
		mov ecx, 0
		mov edx, 0
		mov cx, degree
		while_outer:
		
			cmp cx, 0
			je done_outer
			
			mov temp, cx
			compute_b DWORD PTR points_addr, WORD PTR temp, WORD PTR 0
			
			;First inner loop gets (x-xn) terms
			mov dx, cx
			while_inner:
			
				cmp dx, 0
				je done_inner
			
				fld REAL4 PTR x
				dec dx
				shl dx, 3
				add ebx, edx
				fld REAL4 PTR [ebx]
				sub ebx, edx
				shr dx, 3
				fsub
			
				jmp while_inner
			
			done_inner:
			
			;Second inner loop multiplies recently calculated terms
			mov dx, cx
			while_mult:
			
				cmp dx, 0
				je done_mult
			
				fmul
			
				dec dx
				jmp while_mult
			
			done_mult:
			
			dec cx
			jmp while_outer
		
		done_outer:
		
		;After all terms are on the stack, add them together
		fld REAL4 PTR [ebx+4]		;push b0 onto stack. Other loops did not process this
		mov cx, degree
		while_add:
		
			cmp cx, 0
			je done_add
			
			fadd
			
			dec cx
			jmp while_add
		
		done_add:
		
		popf
		pop edx
		pop ecx
		mov esp, ebp
		pop ebp
		ret 10

interpolate_proc	ENDP

END