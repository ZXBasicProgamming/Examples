' ----------------------------------------------------------------
' This file is released under the GPL v3 License
' 
' Copyleft (k) 2008
' by Jose Rodriguez-Rosa (a.k.a. Boriel) <http://www.boriel.com>
'
' Use this file as a template to develop your own library file
'
' Replace <NAME> with your desired identifier. I.e. for PAUSE
' use __LIBRARY_PAUSE__ (see pause.bas code)
'
' Suggestions:
' 	* Be methodic. Use something MEANINGFUL
'	* Use *long* names to avoid collision with other developers.
'	  Names can be as long as you want, and are only used 3 times.
' ----------------------------------------------------------------

#ifndef __LIBRARY_EPLOT__

REM Avoid recursive / multiple inclusion

#define __LIBRARY_EPLOT__

REM Put your code here.

' ----------------------------------------------------------------
' function EPLOT (x , y )
' 
' Parameters: 
'     x 0-255
'     y 0-191
'
' Returns:
'     Plots at x, y
' ----------------------------------------------------------------
sub eplot(byval row as ubyte, byval col as ubyte)

	asm

    PROC
    ;LOCAL __EPLOT_END
	
	ld e, (ix+7)
    ld d, (ix+5)

	ld a,7
	  and d
	  ld b,a
	  inc b
	  ld a,e
	  rra
	  scf
	  rra
	  or a
	  rra
	  ld l,a
	  xor e
	  and 248
	  xor e
	  ld h,a
	  ld a,d
	  xor l
	  and 7
	  xor d
	  rrca
	  rrca
	  rrca
	  ld l,a
	  ld a,1
	PLOTBIT:
	  rrca
	  djnz PLOTBIT
	  xor (hl)
	  ld (hl),a
	;ret	
	;__EPLOT_END:
    ENDP 

    end asm


end sub

' ----------------------------------------------------------------
' function EOPLOT (x , y )
' 
' Parameters: 
'     x 0-255
'     y 0-191
'
' Returns:
'     Plots off at x, y
' ----------------------------------------------------------------

sub eoplot(byval row as ubyte, byval col as ubyte)

	asm

    PROC
    ;LOCAL __EOPLOT_END
	
	ld e, (ix+7)
    ld d, (ix+5)

	ld a,7
	  and d
	  ld b,a
	  inc b
	  ld a,e
	  rra
	  scf
	  rra
	  or a
	  rra
	  ld l,a
	  xor e
	  and 248
	  xor e
	  ld h,a
	  ld a,d
	  xor l
	  and 7
	  xor d
	  rrca
	  rrca
	  rrca
	  ld l,a
	  ld a,1
	EPLOTBIT:
		rrca
	  djnz EPLOTBIT
	  or (hl)
	  ld (hl),0
	  ;ret	
	;__EOPLOT_END:
    ENDP 

    end asm


end sub


#endif

