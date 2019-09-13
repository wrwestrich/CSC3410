;Compute b
;Author:	Will Westrich
;Date:		10/24/18

.386
.MODEL FLAT

INCLUDE debug.h

PUBLIC compute_b_proc

; variables
points_addr	EQU [ebp+12]
n			EQU [ebp+10]
m			EQU [ebp+8]

.CODE

compute_b_proc		PROC	NEAR32

		push ebp
		mov ebp, esp
		push ebx
		push ecx
		
		mov ebx, points_addr
		mov ecx, 0
		mov cx, n
		cmp cx, m
		je base_case
		
		;Recursively compute first term of numerator
		inc WORD PTR m
		push ebx
		push WORD PTR n
		push WORD PTR m
		call compute_b_proc
		
		;Recursively compute second term of numerator
		dec WORD PTR m
		dec WORD PTR n
		push ebx
		push WORD PTR n
		push WORD PTR m
		call compute_b_proc
		inc WORD PTR n
		
		;Subtract terms in numerator
		fsub
		
		;Calculate denominator
		mov cx, n
		shl cx, 3
		add ebx, ecx
		fld REAL4 PTR [ebx]
		sub ebx, ecx
		
		mov cx, m
		shl cx, 3
		add ebx, ecx
		fld REAL4 PTR [ebx]
		
		fsub
		
		;Divide
		fdiv
		
		jmp done
		
		base_case:
		mov cx, n
		shl cx, 3
		add cx, 4
		add ebx, ecx
		fld REAL4 PTR [ebx]
		
		done:
		
		pop ecx
		pop ebx
		mov esp, ebp
		pop ebp
		ret 8

compute_b_proc		ENDP

END