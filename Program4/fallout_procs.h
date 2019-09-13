; Fallout Procs Header
; Author:	Will Westrich
; Date:		11/20/18

.NOLIST
.386

EXTERN match_proc : NEAR32
EXTERN swap_proc : NEAR32

match			MACRO string1, string2, len, xtra	;Returns value in ax
					
					IFB<string1>
						.ERR<missing "string1" operand in match>
					ELSEIFB<string2>
						.ERR<missing "string2" operand in match>
					ELSEIFB<len>
						.ERR<missing "len" operand in match>
					ELSEIFNB<xtra>
						.ERR<extra operand(s) in match>
					ELSE
					
						push ebx
					
							push len
							push string1
							push string2
							call match_proc
					
						pop ebx
										
					ENDIF
					
				ENDM

				
swap			MACRO string_dest, string_source, len, xtra
					
					IFB<string1>
						.ERR<missing "string_dest" operand in swap>
					ELSEIFB<string2>
						.ERR<missing "string_source" operand in swap>
					ELSEIFB<len>
						.ERR<missing "len" operand in swap>
					ELSEIFNB<xtra>
						.ERR<extra operand(s) in swap>
					ELSE
							
							push len
							push string_source
							push string_dest
							call swap_proc
					
					ENDIF
					
				ENDM
				
.NOLISTMACRO
.LIST