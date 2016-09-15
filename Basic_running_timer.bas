Check AF7B9A37
Auto 8224

# Run-time Variables

Var c: Num = 58.7
Var d: Num = 167
Var t: Num = 1
Var b: Num = 2
Var ti: Num = 221204
Var n: NumFOR = 11, 10, 1, 30, 8
Var o: NumFOR = 0, 40, 5, 40, 2
Var x: NumFOR = 62, 86, 13, 50, 2
Var l: NumFOR = 6, 6, 1, 70, 2

# End Run-time Variables

  10 LET ti=65536*PEEK 23674+256*PEEK 23673+PEEK 23672
  15 REM your program
 100 LET ti=65536*PEEK 23674+256*PEEK 23673+PEEK 23672-ti
 110 PRINT #1;AT 0,0;"Duration: ";ti/50;" s"
 120 PAUSE 0
