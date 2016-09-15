Check D28B04B1
Auto 8224

# Run-time Variables

Var x: NumFOR = 12, 12, 1, 20, 2
Var y: NumFOR = 156, 144, 12, 40, 2

# End Run-time Variables

   1 REM by Uwe Geiken
   2 REM https://www.facebook.com/groups/ZXBasic/permalink/1749115045352768/
  10 PRINT "f(x)=x^2 in the normal x-domain": PRINT "The x-distance is equal.": GO SUB 100
  20 FOR x=-12 TO 12: LET y=x*x: PLOT 128+x*10,y: NEXT x
  30 PAUSE 0: CLS : PRINT "f(x)=x^2 in the y-domain": PRINT "Now the y-distance is equal.": GO SUB 100
  40 FOR y=0 TO 144 STEP 12: LET x=SQR y: PLOT 128+x*10,y: PLOT 128-x*10,y: NEXT y
  50 GO TO 9999
 100 PLOT 0,0: DRAW 255,0: PLOT 128,0: DRAW 0,155: RETURN
