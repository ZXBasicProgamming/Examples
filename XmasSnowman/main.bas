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
dim ss(flakes) as ubyte ' snow speed
dim n as ubyte

' set up snow 

for n=0 to flakes

	sx(n)=rnd*31
	sy(n)=rnd*23
	ss(n)=1+rnd*3
	
next

while inkey$=""

	for n=0 to flakes
	
		'sa(n)=sx(n)	' save x pos
		
		t=sy(n)
		u=sx(n)
		
		sb(n)=t ' save y pos

		t=t+ss(n)
		
		if t>22 then 
			t=0 : u=rnd*32
		END if
		
		print at t,u;paper 7;" "
		Print at sb(n),u;paper 0;" "
		
		sy(n)=t : sx(n)=u
	
	next 

wend

end
 