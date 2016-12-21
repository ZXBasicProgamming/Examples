#include <eplot.bas>
#include <putchars.bas>

border 0
paper 0
ink 7 
cls

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

' set up snow 

for n=0 to flakes

	sx(n)=rnd*255
	sy(n)=rnd*191
	ss(n)=1+rnd*3
	
next

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

	f=f+1
	
	if f=1
	
		paintData(8,6,16,18,@snowman1)
	
	elseif f=6
	
		paint(12,6,8,2,7)
		paintData(8,8,17,16,@snowman2)
	
	end if 

	if f>10 THEN 
		f = 0 
	END IF 	
	

wend

end


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