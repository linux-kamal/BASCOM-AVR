$regfile = "m16def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcd = 16 * 2

Config Portc.7 = Output
Config Portc.6 = Output
Config Portd.6 = Output

Dim Var As Byte
Var = 0

Cursor Off
Cls
Lcd "AUTO TRANSFORMER"
Lowerline
Lcd "    STARTER     "
Wait 4
Cls
Reset Portd.6
Set Portc.7
For Var = 0 To 10
   Locate 1 , 1
   Lcd "REDUCED VOLTAGE"
   Locate 2 , 1
   Lcd "MODE : " ; Var
   Wait 1

Next Var
Set Portd.6
Wait 1
Reset Portd.6
Cls
Locate 1 , 1
Lcd "FULL VOLTAGE"
Locate 2 , 1
Lcd "MODE : ###"

Set Portc.6

Do


Loop

End