;Vankin's Mile
;Author:	Will Westrich
;Date:		9/25/18

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:WORD

INCLUDE debug.h

.STACK 4096

.DATA
matrix			WORD 100 DUP(?)	; Allows maximum size of 10x10 matrix
num_row			BYTE ?
num_col			BYTE ?
matrix_size		BYTE ?
result_string	BYTE 1 DUP(?), 0
matrix_string	BYTE 6 DUP(?), 0


getElement		MACRO	matrix_name, row, col, loc ; row and col start at 1
					local while_row, done
					
					push ecx
					push eax

					lea ebx, matrix_name
					mov eax, 0
				
					; Add offset to move to correct row
					mov cl, row
					dec cl
					mov al, num_col
					shl al, 1
				
					while_row:
						cmp cl, 0
						je done
					
						add ebx, eax
						dec cl
						jmp while_row
					done:
				
					; Add offset to move to correct column
					mov al, col
					dec al
					shl al, 1
					add ebx, eax
					
					pop eax
				
					mov loc, [ebx]
					
					pop ecx
				ENDM
			
setElement		MACRO	matrix_name, row, col, loc ; row and col start at 1
					local while_row, done
					
					push ecx
					push eax

					lea ebx, matrix_name
					mov eax, 0
				
					; Add offset to move to correct row
					mov cl, row
					dec cl
					mov al, num_col
					shl al, 1
				
					while_row:
						cmp cl, 0
						je done
					
						add ebx, eax
						dec cl
						jmp while_row
					done:
				
					; Add offset to move to correct column
					mov al, col
					dec al
					shl al, 1
					add ebx, eax
				
					pop eax
				
					mov [ebx], loc
					
					pop ecx
				ENDM
			
output_matrix	MACRO	matrix_name, row, col
					local while_output1, while_output2, end_output1, end_output2
					
					lea ebx, matrix_name
					mov cl, row
					while_output1:
						cmp cl, 0
						je end_output1
		
						mov ch, col
						while_output2:
							cmp ch, 0
							je end_output2
			
							itoa matrix_string, [ebx]
							output matrix_string
							add ebx, 2
			
							dec ch
							jmp while_output2
						end_output2:
		
						output carriage
						dec cl
						jmp while_output1
					end_output1:
					output carriage
				ENDM
.CODE
_start:

	;Get row number from input
	input matrix_string, 8
	atoi matrix_string
	mov num_row, al
	
	;Get column number from input
	input matrix_string, 8
	atoi matrix_string
	mov num_col, al
	mul num_row
	mov matrix_size, al		;Get total number of elements
	
	;Get input for matrix
	lea ebx, matrix			;Get array address
	mov ecx, 0				;Set up counter
	mov cl, matrix_size		;Get number of iterations
	while_input:
		cmp cl, 0
		je end_input
		
		input matrix_string, 8		;Set array value
		atoi matrix_string
		mov [ebx], ax
		add ebx, 2					;Move to next element
		
		dec cl
		jmp while_input
	end_input:
	
	
	output_matrix matrix, num_row, num_col
	
	;Solve bottom row
	mov cl, num_row		;cl = row counter
	mov ch, num_col		;ch = column counter
	while_bottom_row:
		getElement matrix, cl, ch, dx	;Store current element
		dec ch							;Go to next element
		cmp ch, 0
		je end_bottom_row				;If next element doesn't exist, exit
		
		cmp dx, 0
		jle while_bottom_row			;If previous <= 0, current doesn't change
		
		getElement matrix, cl, ch, ax	;Get new current element
		add ax, dx
		setElement matrix, cl, ch, ax	;Set new current element
		
		jmp while_bottom_row
	end_bottom_row:
	
	;Solve remaining rows
	mov ch, num_col
	dec cl
	while_solve:
		cmp cl, 0
		je end_solve
		
		inc cl
		getElement matrix, cl, ch, dx	;Get bottom element of right end element
		dec cl
		cmp dx, 0
		jle no_add
		
		getElement matrix, cl, ch, ax	;Add bottom if > 0
		add ax, dx
		setElement matrix, cl, ch, ax
		no_add:
		
		while_solve2:
			getElement matrix, cl, ch, dx	;Get right element
			dec ch
			cmp ch, 0
			je end_solve2
			
			inc cl
			getElement matrix, cl, ch, ax	;Get bottom element
			dec cl
			cmp dx, ax						;Compare right to bottom
			jl add_bottom					;Default right in equal cases
			
			getElement matrix, cl, ch, ax	;Add right element if >= bottom element
			add ax, dx
			setElement matrix, cl, ch, ax
			jmp done_add
			
			add_bottom:
			getElement matrix, cl, ch, dx	;Add bottom element if bottom > right
			add ax, dx
			setElement matrix,cl, ch, ax
			
			done_add:
			jmp while_solve2
		end_solve2:
		
		dec cl
		mov ch, num_col
		jmp while_solve
	end_solve:
	
	output_matrix matrix, num_row, num_col
	
	
	;Generate string showing optimal path from (1,1)
	mov cl, 1	;Row
	mov ch, 1	;Col
	while_string:
		cmp cl, num_row					;Exit if either row or col is exceeded
		jg end_string
		cmp ch, num_col
		jg end_string
		
		inc ch
		cmp ch, num_col					;Skip getting element if out of bounds
		jg skip_right
		
		getElement matrix, cl, ch, dx	;Get right element if in bounds
		dec ch
		jmp skip_skip_right
		
		skip_right:						;Set to 0 if out of bounds
		mov dx, 0
		dec ch
		skip_skip_right:
		
		
		inc cl
		cmp cl, num_row					;Skip getting element if out of bounds
		jg skip_down
		
		getElement matrix, cl, ch, ax	;Get bottom element if in bounds
		dec cl
		jmp skip_skip_down
		
		skip_down:						;Set to 0 if out of bounds
		mov ax, 0
		dec cl
		skip_skip_down:
		
		
		cmp dx, ax						;Compare right to bottom
		jl go_down						;Default right when equal
		
		mov result_string, 'r'			;Display 'r' if right >= bottom
		output result_string
		inc ch
		jmp done_move
		
		go_down:
		mov result_string, 'd'			;Display 'd' if bottom > right
		output result_string
		inc cl
		
		done_move:
		jmp while_string
	end_string:
	
	output carriage
	output carriage

	INVOKE ExitProcess, 0
	
PUBLIC _start

END