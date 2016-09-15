Check 48156B5E
Auto 8224

# Run-time Variables

Var x: Num = 2
Var d: Num = 0
Var c: Num = 3
Var cd: Num = 0

# End Run-time Variables

   1 BORDER 0: PAPER 0: CLS
  10 LET x=0: LET d=0: LET c=1: LET cd=0
  20 IF d=0 THEN LET x=x+1: IF x=32-7 THEN LET d=1
  30 IF d=1 THEN LET x=x-1: IF x=0 THEN LET d=0
  40 IF cd=0 THEN LET c=c+1: IF c=8 THEN LET cd=1
  50 IF cd=1 THEN LET c=c-1: IF c<1 THEN LET cd=0: LET c=1
  70 PRINT AT 21,x; PAPER c;"       "
  80 PRINT AT 21,32-x-7; PAPER c;"       "
  90 RANDOMIZE USR 3280
 100 PAUSE 1
 120 GO TO 20
