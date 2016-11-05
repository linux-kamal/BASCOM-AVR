$regfile = "m16def.dat"
$crystal = 16000000



Config Portd = Output
Dim Var As Word
Dim Count As Byte
Var = 1
Count = 0

'(
Do
   Waitms 100
   Portd = Var
   If Var <= 255 Then
      Var = Var * 2
      Var = Var + 1
   End If
   If Var > 255 Then
      Var = 1
   End If

Loop
')

Do
   If Count = 8 Then
      Var = 1
      Count = 0
   End If
   Portd = Var
   '  last parameter is number of shifts to be perform at a time,  if we wrote 7
   '  then var will get 7 times shifted result so either left this parameter blank or pass 1 to that place .

   Shift Var , Left
   Waitms 300
   Incr Count
Loop

End