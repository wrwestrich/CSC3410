;Interpolate Driver
;Author:	Will Westrich
;Date:		10/24/18

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:WORD

INCLUDE debug.h
INCLUDE float.h
INCLUDE sort_points.h
INCLUDE interpolate.h
INCLUDE compute_b.h

.STACK 4096

.DATA
points			REAL4 40 DUP(?)
x				REAL4 ?
result			REAL4 ?
tol				REAL4 0.0001
num_points		WORD 0
degree			WORD ?
input1			BYTE "Enter the x-coordinate of the desired interpolated y.", CR, LF, 0
input2			BYTE "Enter the degree of the interpolating polynomial.", CR, LF, 0
input3			BYTE "You may enter up to 20 points, one at a time.", CR, LF, 0
quit			BYTE "Input q to quit.", CR, LF, 0
result_string	BYTE "The result: ", 0


.CODE
_start:

	;Get x-value to be interpolated
	output input1
	input text, 8
	atof text, x
	
	;Get degree
	output input2
	input text, 8
	atoi text
	mov degree, ax
	
	;Get data points to be used in calculation
	output input3
	output quit
	mov ecx, 0
	mov cl, 40
	lea ebx, points
	while_input:
	
		cmp text, 'q'
		je done_input
		cmp cl, 0
		je done_input
		
		input text, 8
		atof text, REAL4 PTR [ebx]
		
		add ebx, 4
		inc num_points
		dec cl
		jmp while_input
	
	done_input:
	
	;mov ax, num_points
	shr num_points, 1
	
	;Sort and display array of points
	sort_points points, x, tol, num_points
	print_points points, num_points
	output carriage
	
	;Interpolate points
	interpolate points, x, degree, result
	
	;Display result
	output result_string
	ftoa result, WORD PTR 4, WORD PTR 9, text
	output text
	output carriage

	INVOKE ExitProcess, 0
	
PUBLIC _start

END