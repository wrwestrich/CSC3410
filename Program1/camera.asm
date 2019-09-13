;Camera Transformation
;Author:	Will Westrich
;Date:		9/9/2018

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:WORD

INCLUDE debug.h
INCLUDE sqrt.h

.STACK 4096

.DATA
E_x			WORD ?
E_y			WORD ?
E_z			WORD ?
A_x			WORD ?
A_y			WORD ?
A_z			WORD ?
v_up_x		WORD ?
v_up_y		WORD ?
v_up_z		WORD ?
u_x			WORD ?
u_y			WORD ?
u_z			WORD ?
v_x			WORD ?
v_y			WORD ?
v_z			WORD ?
n_x			WORD ?
n_y			WORD ?
n_z			WORD ?
u_norm		WORD ?
v_norm		WORD ?
n_norm		WORD ?
string		BYTE 6 DUP (?), 0
string_norm	BYTE 2 DUP (?), 0
string_x	BYTE "Enter the x-coordinate of the camera ", 0
string_y	BYTE "Enter the y-coordinate of the camera ", 0
string_z	BYTE "Enter the z-coordinate of the camera ", 0
string_E	BYTE "eyepoint:    ", 0
string_A	BYTE "look at point:    ", 0
string_v_up	BYTE "up direction:    ", 0
comma		BYTE ',', 0
par_o		BYTE '(', 0
par_c		BYTE ')', 0
slash		BYTE '/', 0

output_triplet	MACRO	x, y, z
					output carriage	;This is how I did output before
					output par_o	;you talked about it in class.
					itoa string, x	;It's probably garbage, but it works
					output string	;and I'm too lazy to rewrite it
					output comma
					itoa string, y
					output string
					output comma
					itoa string, z
					output string
					output par_c
					output carriage
				ENDM
				
output_norm		MACRO	x_n, y_n, z_n, norm
					output par_o	;Same deal as the crud above
					itoa string, x_n
					output string
					output slash
					itoa string, norm
					output string+3
					output comma
					itoa string, y_n
					output string
					output slash
					itoa string, norm
					output string+3
					output comma
					itoa string, z_n
					output string
					output slash
					itoa string, norm
					output string+3
					output par_c
				ENDM
				
get_component	MACRO	string1, string2, comp
					output string1
					output string2
					input string, 8
					atoi string
					mov comp, ax
					output carriage
				ENDM
				
dot				MACRO	x1, y1, z1, x2, y2, z2
					mov ax, x1
					imul x2
					mov bx, ax
					
					mov ax, y1
					imul y2
					mov cx, ax
					
					mov ax, z1
					imul z2
					
					add ax, bx
					add ax, cx
				ENDM
.CODE
_start:
	;Get E vector components
	get_component string_x, string_E, E_x
	
	get_component string_y, string_E, E_y
	
	get_component string_z, string_E, E_z
	
	output_triplet E_x, E_y, E_z
	
	;Get A vector components
	get_component string_x, string_A, A_x
	
	get_component string_y, string_A, A_y
	
	get_component string_z, string_A, A_z
	
	output_triplet A_x, A_y, A_z
	
	;Get v_up vector components
	get_component string_x, string_v_up, v_up_x
	
	get_component string_y, string_v_up, v_up_y
	
	get_component string_z, string_v_up, v_up_z
	
	output_triplet v_up_x, v_up_y, v_up_z
	
	
	;Calculate n
	mov ax, E_x
	sub ax, A_x
	mov n_x, ax
	
	mov ax, E_y
	sub ax, A_y
	mov n_y, ax
	
	mov ax, E_z
	sub ax, A_z
	mov n_z, ax
	
	
	;Calculate dot products for v
	dot v_up_x, v_up_y, v_up_z, n_x, n_y, n_z
	mov bx, -1
	imul bx
	mov u_x, ax
	
	dot n_x, n_y, n_z, n_x, n_y, n_z
	mov u_y, ax
	
	;Calculate v components
	mov ax, n_x
	imul u_x
	mov bx, ax
	mov ax, v_up_x
	imul u_y
	add ax, bx
	mov v_x, ax
	
	
	mov ax, n_y
	imul u_x
	mov bx, ax
	mov ax, v_up_y
	imul u_y
	add ax, bx
	mov v_y, ax
	
	
	mov ax, n_z
	imul u_x
	mov bx, ax
	mov ax, v_up_z
	imul u_y
	add ax, bx
	mov v_z, ax
	
	;Calculate u
	mov ax, v_z
	imul n_y
	mov bx, ax
	mov ax, v_y
	imul n_z
	sub ax, bx
	mov u_x, ax
	
	
	mov ax, v_x
	imul n_z
	mov bx, ax
	mov ax, v_z
	imul n_x
	sub ax, bx
	mov u_y, ax
	
	
	mov ax, v_y
	imul n_x
	mov bx, ax
	mov ax, v_x
	imul n_y
	sub ax, bx
	mov u_z, ax
	
	;Calculate lengths of n, v, and u
	dot n_x, n_y, n_z, n_x, n_y, n_z
	sqrt ax
	mov n_norm, ax
	
	dot v_x, v_y, v_z, v_x, v_y, v_z
	sqrt ax
	mov v_norm, ax
	
	dot u_x, u_y, u_z, u_x, u_y, u_z
	sqrt ax
	mov u_norm, ax
	
	;Output ordered triplets in normal form
	output carriage
	
	mov string_norm, 'u'
	mov string_norm+1, ':'
	output string_norm
	output carriage
	output_norm u_x, u_y, u_z, u_norm
	output carriage
	
	mov string_norm, 'v'
	mov string_norm+1, ':'
	output string_norm
	output carriage
	output_norm v_x, v_y, v_z, v_norm
	output carriage
	
	mov string_norm, 'n'
	mov string_norm+1, ':'
	output string_norm
	output carriage
	output_norm n_x, n_y, n_z, n_norm
	output carriage

	
	INVOKE ExitProcess, 0

PUBLIC _start

END