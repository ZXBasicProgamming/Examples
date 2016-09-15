Check B2581875
Auto 8224

# Run-time Variables

Var s: Num = 0
Var x: Num = 32.8571429
Var y: Num = 137.1428572
Var steps: Num = 16.8
Var spacing: Num = 5
Var x1: Num = 90
Var y1: Num = 80
Var x2: Num = 30
Var y2: Num = 140
Var ox: Num = 30
Var oy: Num = 140
Var xdif: Num = -60
Var ydif: Num = 60
Var axd: Num = 60
Var ayd: Num = 60
Var linl: Num = 84
Var xstep: Num = -3.57142857
Var ystep: Num = 3.5714286
Var i: NumFOR = 17, 16.8, 1, 100, 2

# End Run-time Variables

  10 LET steps=20: LET spacing=5: LET s=0
  20 LET x1=90: LET y1=80: PLOT x1,y1
  30 LET x2=30: LET y2=140: PLOT x2,y2
  40 LET ox=x2: LET oy=y2
  50 LET xdif=x2-x1: LET ydif=y2-y1: LET axd=ABS (x1-x2): LET ayd=ABS (y1-y2)
  60 LET linl=INT SQR ((axd^2)+(ayd^2))
  70 LET steps=linl/spacing
  80 LET xstep=xdif/steps
  90 LET ystep=ydif/steps
 100 FOR i=0 TO steps
 110 LET x=x1+(xstep*i)
 120 LET y=y1+(ystep*i)
 130 PLOT x,y
 140 NEXT i
