$regfile = "m16def.dat"
$crystal = 16000000
$baud = 9600

Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcd = 16 * 2

Dim Var As Byte , Count As Byte
Cls

Lcd "Test program"
Wait 1

Print "ATE0" ; Chr(13) ; Chr(10)
Wait 1
Print "AT+CNMI=2,1,0,0,0"
Do

   Var = Waitkey()
   If Count > 9 Then
      Lcd Chr(var)
   End If
   Incr Count



Loop

End


'AT+CMGDA =? PAGE 141

'AT+CLCC=1 GIVES CURRENT CALLER NUMBER