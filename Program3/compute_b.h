; compute_b.h
; Author:	Will Westrich
; Date:		10/24/18

.NOLIST
.386

EXTERN compute_b_proc : Near32

compute_b			MACRO points_array_addr, n, m

						push points_array_addr
						push n
						push m
						call compute_b_proc
											
					ENDM

.NOLISTMACRO
.LIST