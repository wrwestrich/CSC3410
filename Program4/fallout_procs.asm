; Fallout Procs
; Author:	WIll Westrich
; Date:		11/6/18

.386
.MODEL FLAT

INCLUDE debug.h

len			EQU [ebp+16]
source_str	EQU [ebp+12]
dest_str	EQU [ebp+8]

.CODE
PUBLIC match_proc
match_proc		PROC	NEAR32
	
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ecx
	
	mov esi, source_str
	mov edi, dest_str
	mov ax, 0
	mov ecx, len
	sub ecx, 2
	
	while_match:
		
		repne cmpsb
		
		cmp cx, 0
		jle done_match
		
		itoa text, cx
		output text
		output carriage
		
		inc ax
		
		jmp while_match
		
	done_match:
	
	jne done
	
	dec esi
	dec edi
	mov cl, [esi]
	cmp cl, [edi]
	jne done
	inc ax
	
	done:
	
	pop ecx
	pop edi
	pop esi
	mov esp, ebp
	pop ebp
	ret 10
	
match_proc	ENDP

PUBLIC swap_proc
swap_proc		PROC	NEAR32
	
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ecx
	push edx
	
	mov esi, source_str
	mov edi, dest_str
	mov edx, 0
	mov ecx, 0
	mov cx, len
	
	while_store:
	
		cmp cx, 0
		je done_store
	
		mov dl, BYTE PTR [edi]
		push dx
		inc edi
	
		dec ecx
		jmp while_store
	
	done_store:
	
	mov edi, dest_str
	mov cx, len
	rep movsb
	
	mov cx, len
	dec cx
	mov esi, source_str
	
	;Have to inc len # of times instead of adding len to esi
	;No idea why but it doesn't work
	while_test:
	
		cmp cx, 0
		je done_test
		
		inc esi
		
		dec cx
		jmp while_test
	
	done_test:
	
	mov cx, len
	while_load:
	
		cmp ecx, 0
		je done_load
		
		pop dx
		mov BYTE PTR [esi], dl
		dec esi
		
		dec ecx
		jmp while_load
	
	done_load:
	
	pop edx
	pop ecx
	pop edi
	pop esi
	mov esp, ebp
	pop ebp
	ret 10
	
swap_proc	ENDP

END