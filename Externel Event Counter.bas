
'
' no need of pullup/pulldown resistor simply connect a switch between T0 and Vcc
'
$regfile = "m16def.dat"
$crystal = 16000000

Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcd = 16 * 2

Config Timer0 = Counter , Edge = Rising

'no effect of rising or falling edge counter always incremented at rising edge
'
Config Porta = Output
Dim Var As Byte
Tcnt0 = Var = 0
Cls

Wait 5
Var = Tcnt0
'Do
'Var = Tcnt0
Lcd Var
Wait 5
If Var = 10 Then
Porta = 255
End If
Cls
'Loop
End