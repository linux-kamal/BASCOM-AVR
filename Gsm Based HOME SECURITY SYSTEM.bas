$regfile = "m16def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Db4 = Porta.2 , Db5 = Porta.3 , Db6 = Porta.4 , Db7 = Porta.5 , E = Porta.1 , Rs = Porta.0
Config Lcd = 16 * 2

Config Portd.7 = Output
Config Portc.2 = Output
Sensor Alias Pind.0

Portd.7 = 0
Portc.2 = 0


Cls
Display On
Cursor Off

Lcd "   GSM BASED  "
Lowerline
Lcd "SECURITY SYSTEM"
Wait 3
Cls
'Portd.7 = 1

Do
   If Sensor = 1 Then
      Locate 1 , 1
      Lcd "SECURITY OK   "

   Elseif Sensor = 0 Then
      Cls
      Lcd "SECURITY BREAK"
      Lowerline
      Lcd "START CALLING..."
      Portc.2 = 1
      Wait 3
      Portc.2 = 0
      Cls
   End If

Loop