$regfile = "m16def.dat"
$crystal = 16000000
$baud = 2400

Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcd = 16 * 2

Dim Var As Byte
Dim Count_upper_line As Byte
Dim Count_lower_line As Byte
Count_upper_line = 0
Count_lower_line = 0
Cls
Lcd "RF Test"
Wait 1
Cls
'Print "Hello This is a RF Modules Test"
Do

   'Print "Hello This is a RF Modules Test"
   'Lcd "Waiting"
   Var = Waitkey()

   If Var >= 48 And Var <= 57 Or Var >= 65 And Var <= 90 Or Var >= 97 And Var <= 122 Or Var = 32 Then
      Incr Count_upper_line
      If Count_upper_line = 16 Then
         Lowerline
      End If
      If Count_upper_line = 32 Then
         Cls
         Count_upper_line = 0
      End If
      'Locate 1 , 1
      Lcd Chr(var)
      'Lcd "Sent Data"
      'Wait 1
      'Cls
   End If
Loop