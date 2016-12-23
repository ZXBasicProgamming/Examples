#include <eplot.bas>
#include <putchars.bas>
#include <memcopy.bas>

SUB zx7Unpack(source as uinteger, dest AS uinteger)
	ASM 
		push ix
		push bc
	
		push de
		push af
		
		;push hl
		
		LD L, (IX+4)
		LD H, (IX+5)
		LD E, (IX+6)
		LD D, (IX+7)
		
		
		;push ix	
    call dzx7_turbo
		
		pop ix
		;pop iy
		pop hl
		pop de
		pop af
		pop bc
		jp 56
		ret
				
		dzx7_turbo:
        ld      a, $80
dzx7s_copy_byte_loop:
        ldi                             ; copy literal byte
dzx7s_main_loop:
        call    dzx7s_next_bit
        jr      nc, dzx7s_copy_byte_loop ; next bit indicates either literal or sequence

; determine number of bits used for length (Elias gamma coding)
        push    de
        ld      bc, 0
        ld      d, b
dzx7s_len_size_loop:
        inc     d
        call    dzx7s_next_bit
        jr      nc, dzx7s_len_size_loop

; determine length
dzx7s_len_value_loop:
        call    nc, dzx7s_next_bit
        rl      c
        rl      b
        jr      c, dzx7s_exit           ; check end marker
        dec     d
        jr      nz, dzx7s_len_value_loop
        inc     bc                      ; adjust length

; determine offset
        ld      e, (hl)                 ; load offset flag (1 bit) + offset value (7 bits)
        inc     hl
        defb    $cb, $33                ; opcode for undocumented instruction "SLL E" aka "SLS E"
        jr      nc, dzx7s_offset_end    ; if offset flag is set, load 4 extra bits
        ld      d, $10                  ; bit marker to load 4 bits
dzx7s_rld_next_bit:
        call    dzx7s_next_bit
        rl      d                       ; insert next bit into D
        jr      nc, dzx7s_rld_next_bit  ; repeat 4 times, until bit marker is out
        inc     d                       ; add 128 to DE
        srl	d			; retrieve fourth bit from D
dzx7s_offset_end:
        rr      e                       ; insert fourth bit into E

; copy previous sequence
        ex      (sp), hl                ; store source, restore destination
        push    hl                      ; store destination
        sbc     hl, de                  ; HL = destination - offset - 1
        pop     de                      ; DE = destination
        ldir
dzx7s_exit:
        pop     hl                      ; restore source address (compressed data)
        jr      nc, dzx7s_main_loop
dzx7s_next_bit:
        add     a, a                    ; check next bit
        ret     nz                      ; no more bits left?
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
        ret
	END ASM 
end sub

border 0
paper 0
ink 7 
cls

'pause 0

'SUB setupmusic()
	
	memcopy(@Ints, $FCFC, 30)
	zx7Unpack(@ayplay,49152)
	memcopy(@music, 51310, 1564)
	randomize usr 49152
	randomize USR @IMStart

'END SUB 



const flakes as ubyte=50

dim sx(flakes) as ubyte	' snow x
dim sy(flakes) as ubyte ' snow y
dim sa(flakes) as ubyte	' old snow x
dim sb(flakes) as ubyte ' old snow y
dim si(flakes) as ubyte ' snow index
dim ss(flakes) as byte ' snow speed
dim n as ubyte
dim p as ubyte
dim f as ubyte
dim a as ubyte
dim ct as uinteger 
dim fr, tr as ubyte
' set up snow 

for n=0 to flakes

	sx(n)=rnd*255
	sy(n)=rnd*191
	ss(n)=1+rnd*3
	
next

'setupmusic()

'memcopy(@merry, 16384, 6144)

FUNCTION ti AS float

	RETURN 256 * PEEK(23673) + PEEK (23672)
	
	'RETURN INT((65536 * PEEK (23674) + 256 * PEEK(23673) + PEEK (23672)))
	
END FUNCTION



paint(2,6,28,12,0)
putChars(2,6,28,12,@merry2)

i=0
for x=2 to 29
	for i=0 to 7
	paint(x,6,1,6,i)
	paint(28-x,12,1,6,i)
	pause 1
	next 	
next 

pause 200 

for n=0 to 7

	paint(2,6,28,12,7-n)
	
	pause 1
	
next 

pause 5 : cls 

while inkey$=""

	for n=0 to flakes

		'sa(n)=sx(n)	' save x pos
		
		t=sy(n)
		u=sx(n)
		
		eoplot(u,t)
		
		sb(n)=t ' save y pos	
	
		t=t+ss(n)

		if t>190 then 
			t=0 : u=rnd*255 
		END if

		if ss(n)>2 then 
			u=u+2
			
			IF u>250 THEN 
				u=0
			END IF 
			
			ELSE 
			u=u+1
			
			IF u>250 THEN 
				u=0
			END IF 
			
		END if

		eplot(u,t)
		
		sy(n)=t : sx(n)=u
	
	next 

	ct=ti()

	OUT 65533,9: LET a=IN 65533:
	
	if ct>800
	
	if a<20 THEN 

		paint(12,6,8,2,7)
		paintData(8,8,17,16,@snowman2)
		
		else 
		
		paintData(8,6,16,18,@snowman1)
		
	
	END IF 

	end if 

	if ct>800
	
		if a<20 then 

			if fr>=0 AND fr<=3 THEN 
				paintdata(9,0,14,5,@hoattr) ' w=14 
				tr=0
			elseif fr=4 THEN 
				paintdata(1,0,29,5,@merryattr) ' w=29
				tr=0
			elseif fr=5 THEN 
				paintdata(4,0,23,5,@xmasattr)	' w=23
				tr=0
			elseif fr=6 THEN 
				paintdata(13,0,5,5,@loveattr) ' w=5
				tr=0
			elseif fr=7 THEN 
				paintdata(11,0,11,5,@urattr)	' w=11
				tr=0
			elseif fr>=8 and fr<=12 THEN 
				paintdata(0,0,31,6,@sinclairattr)	' w=31
				tr=0
			END IF 
			
			else 
			
				paint(0,0,31,6,7)
				if tr=0 then
					fr=fr+1
					tr=1
				end if 
				
		END IF 

		if fr>=12 then 
			fr=1
		end if 
		
	end if 

wend

end

Ints:
	asm
								di                  ; disable interrupts
                push af             ; save all std regs
                push bc
                push de
                push hl
                push ix             ; save ix & iy
                push iy
                ex af, af'          ; and shadow af
                push af
								; This is what we call every frame - this is the playroutine+3 to play the song
                call 49157       ; play the current tune

                pop af
									ex af, af'          ; restore af
                pop iy
                pop ix              ; restore ix & iy
                pop hl
                pop de
                pop bc
                pop af              ; restore all std regs
                ei                  ; enable interrupts
                ;ret                 ; done
                jp 56
	END asm

IMStart:
	asm
							; this code creates a 256 byte vector table at $FE00, then sets IM2
								di
                ld hl, $FE00
                ld de, $FE01
                ld bc, 256
                ld a, h
                ld i, a
                ld a, $FC
                ld (hl), a
                ldir
                im 2
                ei
                ret       
	END asm

IMOff:
	ASM 		
		DI
		IM 1
		EI
		RET
	END ASM 


ayplay:
	asm
		incbin "vt49152.bin.zx7"
	END asm

music:
	asm
		incbin "jingle.pt3"
	END asm

hoattr:
ASM 
; attribute blocks at pixel position (y=0):

defb 55
defb 55
defb 7
defb 55
defb 55
defb 7
defb 7
defb 31
defb 23
defb 55
defb 7
defb 7
defb 55
defb 55

; attribute blocks at pixel position (y=8):

defb 31
defb 55
defb 7
defb 31
defb 55
defb 7
defb 31
defb 23
defb 7
defb 31
defb 55
defb 7
defb 31
defb 55

; attribute blocks at pixel position (y=16):

defb 31
defb 23
defb 23
defb 23
defb 23
defb 7
defb 31
defb 23
defb 7
defb 31
defb 23
defb 7
defb 31
defb 23

; attribute blocks at pixel position (y=24):

defb 31
defb 23
defb 7
defb 31
defb 23
defb 7
defb 31
defb 23
defb 7
defb 31
defb 23
defb 7
defb 7
defb 7

; attribute blocks at pixel position (y=32):

defb 31
defb 31
defb 7
defb 31
defb 31
defb 7
defb 7
defb 31
defb 23
defb 23
defb 7
defb 7
defb 31
defb 23
end asm 

merryattr:
asm
; attribute block at pixel position (0,0):

defb 55, 7, 7, 7, 55, 7, 55, 55, 31, 55, 55, 7, 55

; attribute block at pixel position (104,0):

defb 55, 55, 55, 7, 7, 55, 55, 55, 55, 7, 7, 55, 55

; attribute block at pixel position (208,0):

defb 7, 55, 55

; attribute block at pixel position (0,8):

defb 31, 55, 7, 23, 55, 7, 31, 23, 7, 7, 7, 7, 31

; attribute block at pixel position (104,8):

defb 23, 7, 31, 55, 7, 31, 23, 7, 31, 55, 7, 31, 55

; attribute block at pixel position (208,8):

defb 7, 31, 55

; attribute block at pixel position (0,16):

defb 31, 23, 23, 23, 23, 7, 31, 23, 23, 23, 7, 7, 31

; attribute block at pixel position (104,16):

defb 23, 23, 23, 7, 7, 31, 23, 23, 23, 7, 7, 31, 23

; attribute block at pixel position (208,16):

defb 23, 23, 23

; attribute block at pixel position (0,24):

defb 31, 23, 7, 31, 23, 7, 31, 23, 7, 7, 7, 7, 31

; attribute block at pixel position (104,24):

defb 23, 7, 31, 23, 7, 31, 23, 7, 31, 23, 7, 7, 7

; attribute block at pixel position (208,24):

defb 7, 31, 23

; attribute block at pixel position (0,32):

defb 31, 31, 7, 31, 31, 7, 31, 31, 31, 31, 31, 7, 31

; attribute block at pixel position (104,32):

defb 31, 7, 31, 31, 7, 31, 31, 7, 31, 31, 7, 7, 31

; attribute block at pixel position (208,32):

defb 31, 31, 7
end asm 

xmasattr:
asm
defb 55, 7, 7, 7, 55, 7, 55, 7, 7, 7, 55, 7, 7, 55, 55, 55, 7, 7, 7, 55, 55, 55

; attribute block at pixel position (176,0):

defb 55

; attribute block at pixel position (0,8):

defb 31, 55, 7, 23, 55, 7, 31, 55, 7, 23, 55, 7, 31, 23, 7, 31, 23, 7, 55, 31, 7, 7

; attribute block at pixel position (176,8):

defb 7

; attribute block at pixel position (0,16):

defb 7, 23, 23, 23, 7, 7, 31, 23, 23, 23, 23, 7, 31, 23, 23, 31, 23, 7, 7, 23, 23, 23

; attribute block at pixel position (176,16):

defb 7

; attribute block at pixel position (0,24):

defb 31, 23, 7, 31, 23, 7, 31, 23, 7, 31, 23, 7, 31, 23, 7, 31, 23, 7, 7, 7, 7, 23

; attribute block at pixel position (176,24):

defb 31

; attribute block at pixel position (0,32):

defb 31, 7, 7, 7, 31, 7, 31, 31, 7, 31, 31, 7, 31, 31, 7, 31, 31, 7, 31, 31, 31, 31

; attribute block at pixel position (176,32):

defb 7
end asm

loveattr:
'width =5
asm
defb 7, 23, 7, 23, 7
defb 23, 23, 23, 23, 23
defb 23, 23, 23, 23, 23
defb 7, 23, 23, 23, 7
defb 7, 7, 23, 7, 7
end asm 

urattr:
' width = 11
ASM 
defb 55, 55, 7, 55, 55, 7, 55, 55, 55, 55, 7
defb 55, 23, 7, 55, 23, 7, 31, 23, 7, 31, 55
defb 31, 23, 7, 31, 23, 7, 31, 23, 23, 23, 7
defb 31, 23, 23, 31, 23, 7, 31, 23, 7, 31, 23
defb 7, 31, 31, 31, 7, 7, 31, 31, 7, 31, 31
END ASM 

sinclairattr:
ASM 
defb 7, 63, 63, 7, 63, 63, 63, 7, 63, 63, 7, 7, 7, 63, 63, 7, 63, 7, 7, 7, 7, 63
defb 7, 7, 63
defb 63, 63, 7, 63, 63, 7
defb 63, 7, 7, 7, 7, 63, 7, 7, 63, 7, 63, 7, 63, 7, 7, 7, 63, 7, 7, 7, 63, 7, 63
defb 7, 7
defb 63, 7, 7, 63, 7, 63
defb 63, 63, 7, 7, 7, 63, 7, 7, 63, 7, 63, 7, 63, 7, 7, 7, 63, 7, 7, 7, 63, 63, 63
defb 7, 7
defb 63, 7, 7, 63, 63, 7
defb 7, 63, 63, 7, 7, 63, 7, 7, 63, 7, 63, 7, 63, 7, 7, 7, 63, 7, 7, 7, 63, 7, 63
defb 7, 7
defb 63, 7, 7, 63, 7, 63
defb 7, 7, 63, 7, 7, 63, 7, 7, 63, 7, 63, 7, 63, 7, 7, 7, 63, 7, 7, 7, 63, 7, 63
defb 7, 7
defb 63, 7, 7, 63, 7, 63
defb 63, 63, 7, 7, 63, 63, 63, 7, 63, 7, 63, 7, 7, 63, 63, 7, 7, 63, 63, 7, 63, 7
defb 63, 7, 63
defb 63, 63, 7, 63, 7, 63
END ASM 
	
merry2:
asm
; ASM data file from a ZX-Paintbrush picture with 224 x 96 pixels (= 28 x 12 characters)

; block based output of pixel data - each block contains 8 x 104 pixels

; block at pixel position (0,0):

defb 196, 230, 227, 243, 177, 153, 152, 140, 132, 134, 130, 131, 137, 137, 136, 136
defb 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136
defb 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0
defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

; block at pixel position (8,0):

defb 96, 32, 48, 16, 152, 136, 204, 198, 102, 99, 51, 49, 25, 152, 140, 196, 70, 98
defb 51, 49, 153, 152, 140, 140, 134, 134, 131, 155, 153, 152, 152, 152, 152, 152
defb 152, 152, 152, 152, 152, 152, 152, 152, 152, 152, 0, 0, 0, 0, 0, 4, 6, 3, 3
defb 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 3, 0, 0

; block at pixel position (16,0):

defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 128, 192, 192, 96, 96, 48, 48, 24, 152
defb 140, 196, 102, 98, 51, 49, 25, 152, 140, 204, 70, 0, 0, 0, 0, 0, 0, 0, 0, 0
defb 0, 0, 0, 0, 0, 0, 0, 0, 34, 99, 49, 25, 152, 140, 198, 102, 99, 49, 25, 24, 12
defb 12, 6, 3, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 3, 6, 4, 12, 24, 25, 49
defb 99, 102, 198, 204, 136, 24, 17, 0, 0

; block at pixel position (24,0):

defb 0, 0, 0, 0, 0, 1, 1, 3, 3, 6, 6, 12, 12, 24, 17, 49, 35, 98, 70, 204, 140, 152
defb 25, 49, 51, 34, 6, 132, 140, 200, 120, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
defb 0, 0, 0, 0, 0, 0, 16, 24, 152, 140, 196, 102, 99, 51, 17, 24, 140, 204, 198
defb 98, 48, 48, 25, 137, 131, 198, 102, 76, 8, 25, 49, 51, 98, 198, 204, 140, 24
defb 49, 51, 99, 102, 196, 140, 152, 25, 49, 99, 102, 198, 140, 136, 0, 0

; block at pixel position (32,0):

defb 51, 99, 102, 198, 204, 140, 152, 25, 49, 51, 98, 70, 204, 140, 152, 24, 48, 48
defb 96, 104, 200, 200, 136, 136, 8, 8, 8, 136, 136, 136, 136, 136, 136, 136, 136
defb 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 3
defb 2, 6, 140, 140, 152, 49, 51, 99, 70, 204, 140, 152, 25, 49, 99, 102, 198, 140
defb 152, 25, 49, 35, 98, 198, 140, 141, 24, 48, 48, 102, 194, 195, 129, 129, 0, 0
defb 0, 0, 0, 0, 0

; block at pixel position (40,0):

defb 24, 56, 56, 120, 88, 216, 152, 136, 24, 8, 24, 8, 152, 136, 152, 136, 152, 136
defb 152, 136, 152, 136, 152, 136, 152, 136, 152, 136, 152, 136, 152, 136, 152, 136
defb 152, 136, 152, 136, 152, 136, 152, 136, 152, 136, 0, 0, 0, 0, 0, 34, 102, 198
defb 140, 152, 25, 49, 99, 102, 198, 140, 136, 24, 49, 51, 99, 198, 204, 140, 24
defb 48, 48, 96, 64, 204, 140, 134, 35, 51, 49, 24, 140, 140, 198, 102, 99, 49, 25
defb 152, 140, 198, 102, 99, 49, 17, 0, 0

; block at pixel position (48,0):

defb 49, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51
defb 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51
defb 51, 51, 51, 51, 0, 0, 0, 0, 0, 17, 51, 99, 70, 204, 140, 152, 16, 48, 96, 96
defb 192, 128, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 128, 192, 96
defb 96, 48, 24, 152, 140, 198, 70, 99, 51, 49, 24, 136, 0, 0

; block at pixel position (56,0):

defb 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51
defb 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51
defb 51, 51, 51, 51, 0, 0, 0, 0, 0, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
defb 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
defb 131, 195, 194, 0, 0

; block at pixel position (64,0):

defb 255, 170, 0, 0, 255, 0, 0, 255, 255, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 0, 0
defb 255, 255, 0, 0, 255, 255, 0, 0, 0, 0, 0, 0, 0, 0, 255, 128, 0, 255, 255, 128
defb 0, 0, 255, 0, 0, 0, 0, 0, 0, 152, 140, 204, 198, 102, 35, 49, 17, 24, 8, 12
defb 6, 38, 51, 51, 49, 49, 48, 48, 50, 50, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51
defb 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 34, 0, 0

; block at pixel position (72,0):

defb 255, 170, 0, 0, 255, 0, 0, 255, 255, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 0, 0
defb 192, 192, 0, 0, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 255, 255, 0, 0
defb 0, 255, 0, 0, 0, 0, 0, 128, 192, 192, 96, 96, 48, 48, 24, 152, 140, 204, 70
defb 102, 35, 49, 25, 152, 140, 204, 198, 102, 99, 51, 49, 25, 24, 12, 4, 38, 34
defb 35, 33, 33, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 0, 0

; block at pixel position (80,0):

defb 240, 160, 0, 0, 240, 0, 0, 240, 240, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 240, 0, 0, 240, 240, 0, 0, 0, 240, 0, 0
defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 128, 192, 65, 97
defb 35, 51, 24, 152, 140, 204, 198, 102, 35, 51, 49, 25, 136, 0, 0, 0, 0, 0, 0, 0
defb 0, 0, 0, 0, 0, 0, 0

; block at pixel position (88,0):

defb 127, 122, 96, 96, 103, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102
defb 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102
defb 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 0, 0, 0, 0, 0, 0
defb 0, 0, 1, 1, 3, 2, 6, 4, 12, 24, 25, 49, 51, 99, 102, 198, 204, 136, 24, 25, 49
defb 35, 102, 70, 196, 140, 24, 27, 51, 163, 227, 195, 3, 3, 3, 3, 3, 3, 3, 3, 3
defb 3, 3, 3, 0, 0

; block at pixel position (96,0):

defb 255, 170, 0, 0, 255, 0, 0, 63, 127, 96, 96, 99, 103, 102, 102, 102, 102, 102
defb 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102
defb 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 0, 0, 0, 0, 0, 64, 196, 140
defb 152, 24, 17, 51, 99, 102, 198, 204, 140, 152, 27, 51, 35, 99, 67, 195, 131, 147
defb 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51
defb 51, 51, 51, 34, 0, 0

; block at pixel position (104,0):

defb 255, 170, 0, 0, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 0, 0, 0, 127, 255
defb 0, 0, 127, 127, 0, 0, 255, 255, 0, 0, 255, 127, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
defb 0, 0, 0, 0, 0, 0, 0, 32, 96, 224, 224, 224, 160, 32, 32, 32, 32, 32, 32, 32
defb 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32
defb 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 0, 0

; block at pixel position (112,0):

defb 255, 175, 0, 0, 255, 3, 0, 248, 254, 7, 1, 240, 252, 6, 3, 3, 3, 3, 254, 252
defb 0, 3, 255, 252, 0, 1, 255, 252, 0, 1, 255, 255, 153, 137, 204, 204, 68, 102
defb 102, 34, 51, 51, 19, 25, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 3, 3, 6, 6, 4, 12, 12, 24, 25, 17
defb 51, 51, 98, 102, 102, 204, 140, 0, 0

; block at pixel position (120,0):

defb 0, 224, 112, 28, 14, 195, 227, 49, 24, 140, 196, 230, 98, 34, 51, 51, 51, 34
defb 98, 102, 198, 140, 28, 56, 113, 227, 135, 14, 56, 240, 240, 144, 152, 152, 140
defb 204, 204, 100, 102, 102, 35, 51, 19, 153, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1
defb 3, 3, 2, 6, 4, 12, 12, 8, 25, 25, 17, 51, 35, 98, 102, 68, 204, 140, 152, 153
defb 17, 51, 51, 34, 102, 102, 196, 204, 140, 152, 25, 17, 51, 35, 98, 102, 68, 196
defb 0, 0

; block at pixel position (128,0):

defb 0, 0, 0, 0, 0, 0, 0, 128, 192, 192, 96, 96, 96, 32, 32, 32, 32, 32, 96, 96, 96
defb 96, 192, 192, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128
defb 0, 0, 0, 0, 0, 34, 115, 243, 209, 153, 152, 140, 12, 4, 38, 98, 99, 67, 193
defb 137, 137, 152, 16, 48, 48, 34, 102, 102, 68, 204, 140, 152, 152, 16, 48, 55
defb 103, 96, 96, 207, 197, 128, 128, 191, 63, 0, 0, 0, 0, 0, 0, 0

; block at pixel position (136,0):

defb 255, 234, 192, 128, 143, 140, 140, 136, 140, 136, 140, 136, 140, 136, 140, 136
defb 140, 136, 140, 136, 140, 136, 140, 136, 140, 136, 140, 136, 140, 136, 140, 136
defb 140, 136, 140, 136, 140, 136, 140, 136, 140, 136, 140, 136, 0, 0, 0, 0, 0, 32
defb 51, 17, 153, 152, 140, 204, 196, 102, 102, 34, 51, 49, 17, 153, 136, 140, 204
defb 68, 102, 98, 51, 51, 17, 25, 25, 8, 12, 12, 6, 246, 242, 3, 3, 249, 81, 0, 0
defb 254, 254, 0, 0, 0, 0, 0, 0, 0

; block at pixel position (144,0):

defb 255, 170, 0, 0, 255, 0, 0, 255, 255, 192, 128, 143, 143, 136, 136, 136, 136
defb 136, 137, 137, 136, 136, 137, 137, 136, 136, 137, 137, 136, 136, 137, 137, 136
defb 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 128
defb 128, 128, 192, 192, 64, 96, 96, 48, 48, 16, 152, 136, 140, 204, 68, 102, 102
defb 35, 51, 49, 25, 153, 136, 204, 204, 70, 102, 98, 51, 51, 17, 153, 152, 140, 204
defb 196, 102, 102, 34, 51, 49, 17, 0, 0

; block at pixel position (152,0):

defb 255, 170, 0, 0, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 0, 0, 0, 255, 255
defb 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 3, 3, 1, 1, 1, 0, 0, 0, 0, 0
defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
defb 0, 0, 0, 0, 128, 128, 192, 192, 64, 96, 96, 48, 48, 16, 152, 152, 140, 204, 196
defb 102, 102, 34, 51, 49, 17, 153, 0, 0

; block at pixel position (160,0):

defb 254, 175, 0, 0, 252, 15, 1, 224, 252, 14, 3, 225, 248, 12, 12, 4, 4, 12, 252
defb 240, 1, 7, 254, 248, 0, 3, 255, 248, 0, 3, 255, 254, 54, 51, 51, 145, 153, 137
defb 200, 204, 76, 68, 102, 102, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 3, 6, 6, 6, 4, 12
defb 12, 12, 12, 12, 12, 4, 6, 6, 2, 3, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
defb 0, 0, 1, 0, 4, 14, 3, 129, 128, 0, 0

; block at pixel position (168,0):

defb 0, 128, 224, 112, 24, 140, 198, 227, 115, 49, 25, 136, 204, 204, 68, 68, 68
defb 204, 204, 136, 153, 25, 49, 99, 199, 142, 28, 56, 112, 224, 224, 96, 32, 48
defb 48, 48, 152, 152, 136, 204, 204, 68, 102, 102, 0, 0, 0, 0, 3, 15, 60, 112, 193
defb 135, 140, 24, 49, 99, 103, 70, 204, 204, 204, 204, 204, 204, 70, 102, 99, 49
defb 24, 142, 135, 193, 112, 60, 15, 3, 0, 0, 0, 0, 7, 1, 16, 28, 15, 192, 240, 60
defb 15, 128, 224, 126, 15, 0

; block at pixel position (176,0):

defb 6, 2, 3, 1, 1, 0, 0, 0, 0, 128, 128, 128, 192, 192, 192, 192, 192, 192, 192
defb 192, 128, 128, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
defb 0, 0, 0, 0, 0, 31, 255, 128, 0, 63, 255, 128, 0, 63, 255, 128, 0, 63, 127, 192
defb 192, 192, 192, 127, 31, 0, 192, 255, 21, 0, 128, 255, 0, 0, 252, 255, 15, 0
defb 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255

; block at pixel position (184,0):

defb 102, 38, 51, 19, 153, 137, 204, 76, 102, 38, 51, 51, 17, 25, 8, 12, 4, 6, 2
defb 3, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
defb 0, 0, 128, 252, 31, 3, 128, 252, 31, 1, 128, 252, 15, 3, 224, 248, 0, 0, 0, 0
defb 240, 252, 15, 3, 224, 248, 14, 7, 227, 241, 24, 12, 140, 196, 68, 68, 196, 204
defb 140, 24, 113, 227, 135, 14, 60, 240, 129, 7, 62, 240, 128

; block at pixel position (192,0):

defb 64, 96, 32, 48, 16, 152, 200, 204, 68, 102, 34, 51, 17, 153, 136, 204, 68, 102
defb 32, 48, 17, 153, 139, 194, 70, 100, 44, 56, 57, 25, 17, 17, 17, 17, 17, 17, 17
defb 17, 17, 17, 17, 17, 17, 17, 0, 0, 0, 0, 0, 128, 224, 112, 28, 12, 192, 224, 0
defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 192, 96, 48, 48, 24, 152, 136, 204, 204
defb 204, 76, 68, 204, 204, 204, 140, 152, 24, 48, 48, 96, 192, 128, 0, 0, 0, 0

; block at pixel position (200,0):

defb 0, 0, 1, 1, 1, 3, 2, 6, 4, 12, 8, 25, 17, 179, 34, 102, 68, 204, 200, 153, 17
defb 51, 34, 38, 100, 204, 200, 153, 153, 17, 19, 19, 19, 19, 19, 19, 19, 19, 19
defb 19, 19, 19, 19, 19, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
defb 0, 0, 0, 0, 0, 0, 0

; block at pixel position (208,0):

defb 204, 200, 153, 145, 51, 34, 102, 100, 76, 200, 153, 153, 19, 50, 38, 102, 68
defb 204, 136, 152, 16, 48, 32, 96, 64, 192, 128, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0
defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
defb 0, 0, 0, 0, 0, 0, 0

; block at pixel position (216,0):

defb 204, 136, 152, 16, 48, 32, 96, 64, 192, 128, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0
defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
END ASM

snowman1:
	ASM 
	; attribute blocks at pixel position (y=0):

		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=8):

		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=16):

		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 07h
		defb 3Fh
		defb 3Fh
		defb 07h
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=24):

		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=32):

		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 37h
		defb 37h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=40):

		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=48):

		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 37h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=56):

		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 07h
		defb 00h
		defb 00h
		defb 37h
		defb 37h

		; attribute blocks at pixel position (y=64):

		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 07h
		defb 07h
		defb 00h
		defb 37h
		defb 00h
		defb 37h

		; attribute blocks at pixel position (y=72):

		defb 37h
		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=80):

		defb 00h
		defb 37h
		defb 37h
		defb 37h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=88):

		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=96):

		defb 00h
		defb 00h
		defb 00h
		defb 07h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=104):

		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=112):

		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=120):

		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=128):

		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=136):

		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 00h	
	END ASM 

snowman2:
	ASM 
	
	
			
				; attribute blocks at pixel position (y=0):

		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=8):

		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=16):

		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 07h
		defb 3Fh
		defb 3Fh
		defb 07h
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=24):

		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=32):

		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 37h
		defb 37h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=40):

		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 07h
		defb 07h
		defb 07h
		defb 00h

		; attribute blocks at pixel position (y=48):

		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 07h
		defb 07h
		defb 07h
		defb 00h

		; attribute blocks at pixel position (y=56):

		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 07h
		defb 00h
		defb 37h
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=64):

		defb 07h
		defb 07h
		defb 07h
		defb 07h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 07h
		defb 07h
		defb 00h
		defb 00h
		defb 37h
		defb 37h
		defb 00h

		; attribute blocks at pixel position (y=72):

		defb 37h
		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 37h
		defb 00h
		defb 37h
		defb 00h

		; attribute blocks at pixel position (y=80):

		defb 00h
		defb 37h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=88):

		defb 00h
		defb 00h
		defb 37h
		defb 37h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=96):

		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=104):

		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=112):

		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=120):

		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 00h

		; attribute blocks at pixel position (y=128):

		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 3Fh
		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 00h
		defb 00h
		END ASM    