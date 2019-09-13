; Interpolate.h
; Author:	Will Westrich
; Date:		10/24/18

.NOLIST
.386

EXTERN interpolate_proc : Near32

interpolate			MACRO points_array, x, degree, result

						push ebx
						
						lea ebx, points_array
						push ebx
						push x
						push degree
						call interpolate_proc
						
						pop ebx
						
						fstp result

					ENDM
					
.NOLISTMACRO
.LIST