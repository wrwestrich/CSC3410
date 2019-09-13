; Fallout Driver
; Author:	Will Westrich
; Date:		11/6/18

.386
.MODEL Flat

ExitProcess PROTO NEAR32 stdcall, dwExitCode:WORD

INCLUDE debug.h
INCLUDE fallout_procs.h
INCLUDE str_utils.h

.STACK 4096

MAX EQU 25
LEN EQU 13

.DATA
matches			WORD ?
num_words		WORD ?
str_array 		BYTE MAX * LEN DUP(0), 0
input_str		BYTE LEN DUP(?), 0
password_str	BYTE LEN DUP(?), 0
enter_str		BYTE "Enter a string: ", 0
num_str			BYTE "The number of strings entered is ", 0
guess_str		BYTE "Enter the index of the test password (1-based): ", 0
match_str		BYTE "Enter the number of exact character matches: ", 0

move_to_index		MACRO string_addr, i, len
						
						local while_move, end_move
						
						push ax
						
						mov ax, i
						while_move:
							
							cmp ax, 0
							je end_move
							
							add string_addr, len
							
							dec ax
							jmp while_move
							
						end_move:
						
						pop ax
						
					ENDM

.CODE
_start:
	
	output carriage
	mov ecx, MAX
	mov eax, 0
	mov edx, 0
	lea edi, str_array
	
	while_input:
		
		cmp cx, 0
		je done_input
		
		output enter_str
		input input_str, LEN
		output carriage
		
		;Compare input_str to x to see if loop breaks
		cmp input_str, 'x'
		je done_input
		
		;Move input_str to str_array
		cld
		lea esi, input_str
		
		while_copy:
		
			cmp BYTE PTR [esi], 0
			je done_copy
		
			movsb
			
			jmp while_copy
			
		done_copy:
		
		mov BYTE PTR [edi], CR
		inc edi
		
		mov BYTE PTR [edi], LF
		inc edi
				
		dec cx
		inc dx
		jmp while_input
		
	done_input:
	
	;Display number of strings entered
	output carriage
	output num_str
	itoa text, dx
	mov num_words, dx
	output text
	output carriage
	
	mov cx, 4
	
	while_guess:
	
		cmp cx, 0
		je done_guess
	
		;Display all words entered
		output carriage
		output str_array
		
		cmp num_words, 1
		jle done_guess
	
		;Get index of string to test
		output guess_str
		input input_str, LEN
		output input_str
		atoi input_str
		dec ax
		mov dx, ax
		output carriage
	
		;Get number of character matches
		output match_str
		input input_str, LEN
		output input_str
		atoi input_str
		mov matches, ax
		output carriage
		
		;Compare test password with all other passwords
		push cx
		mov cx, LEN
		mov bx, 0	;Record number of swaps performed
		
		;store password being tested
		lea esi, str_array
		move_to_index esi, dx, WORD PTR LEN
		lea edi, password_str
		rep movsb
		
		mov cx, 0
		lea edi, password_str
		while_match:
		
			cmp cx, dx
			je skip
			cmp cx, num_words
			je done_match
			
			;Set new source string (one from list being compared)
			lea esi, str_array
			move_to_index esi, cx, WORD PTR LEN
			
			match esi, edi, WORD PTR LEN
			cmp ax, matches
			jne skip
			
			push edi
			
			lea edi, str_array
			move_to_index edi, bx, WORD PTR LEN
			swap edi, esi, WORD PTR LEN
			inc bx
			
			pop edi
		
			skip:
			inc cx
			jmp while_match
		
		done_match:
		
		mov num_words, bx
		
		;null terminate
		lea esi, str_array
		move_to_index esi, bx, WORD PTR LEN
		mov [esi], BYTE PTR 0
		
		pop cx
		
		dec cx
		jmp while_guess
	
	done_guess:
	
	INVOKE ExitProcess, 0

PUBLIC _start
	
END