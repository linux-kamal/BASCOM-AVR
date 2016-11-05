$regfile = "m16def.dat"
$crystal = 8000000
$baud = 9600

On Urxc Lable
Enable Interrupts
Enable Urxc

Config Lcdpin = Pin , Db4 = Portc.2 , Db5 = Portc.3 , Db6 = Portc.4 , Db7 = Portc.5 , E = Portc.1 , Rs = Portc.0
Config Lcd = 16 * 2

Config Porta = Input
Config Portd.2 = Output
Config Portd.3 = Input
Config Portd.7 = Output

Cursor Off
Cls
Lcd "   DISTRIBUTED  "
Lowerline
Lcd " CONTROL SYSTEM "
Reset Portd.7
Wait 4
Cls

Dim Char As Byte
Dim Pump_flag As Bit
Dim Boiler_flag As Bit
Pump_flag = 0
Boiler_flag = 0



Set Portd.7


Do
   If Pina.1 = 1 And Pump_flag = 0 Then
      Print "S"
      Pump_flag = 1
      Locate 1 , 1
      Lcd "                  "
      Locate 2 , 1
      Lcd "PUMP ON "
      Reset Portd.7
      Do
      Loop Until Pina.1 = 0
      Set Portd.7
   Elseif Pina.1 = 1 And Pump_flag = 1 Then
      Print "O"
      Pump_flag = 0
      Locate 1 , 1
      Lcd "                  "
      Locate 2 , 1
      Lcd "PUMP OFF"
      Reset Portd.7
      Do
      Loop Until Pina.1 = 0
      Set Portd.7
   End If

   If Pina.5 = 1 Then
      If Boiler_flag = 0 Then
         Portd.2 = 1
         Locate 1 , 1
         Lcd "BOILER HEATER ON "
         Wait 1
         Portd.2 = 0
         Boiler_flag = 1
         Reset Portd.7
         Wait 1
         Set Portd.7

      Elseif Boiler_flag = 1 Then
         Portd.2 = 1
         Locate 1 , 1
         Lcd "BOILER HEATER OFF"
         Wait 1
         Portd.2 = 0
         Boiler_flag = 0
         Reset Portd.7
         Wait 1
         Set Portd.7
      End If
      Do
      Loop Until Pina.5 = 0
   End If

   If Pind.3 = 1 Then
      Locate 1 , 1
      'Lcd "BOILER HEATER ON "
   Elseif Pind.3 = 0 Then
      Locate 1 , 1
      'Lcd "BOILER HEATER OFF"
   End If
Loop

Lable:
   Char = Inkey()

   If Chr(char) = "F" Then
      Locate 1 , 1
      Lcd "CONTAINER FULL "
      Locate 2 , 1
      Lcd "PUMP OFF"
      Print "O"
      Pump_flag = 0
   End If

Return