$regfile = "m16def.dat"
$crystal = 8000000
Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcd = 16 * 2

Sensor1 Alias Pind.0
Sensor2 Alias Pind.1
Button1 Alias Pind.2
Button2 Alias Pind.3


En2 Alias Portd.4
En1 Alias Portd.5
In11 Alias Portc.0
In12 Alias Portc.1

In21 Alias Portc.2
In22 Alias Portc.3

Config Portc = Output
Config En1 = Output
Config En2 = Output


Config Sensor1 = Input
Config Sensor2 = Input


Cls

Lcd "MultiLayer Car"
Lowerline
Lcd "Parking System"
Wait 3
Cls


'Set En2
'UP
Reset In21
Set In22


Do
   If Button1 = 1 Then
      Set En2
      'DOWN
      Set In21
      Reset In22
   Else
      Reset En2
      'DOWN
      Reset In21
      Reset In22
   End If



   If Button2 = 1 Then
      Set En2
      'UP
      Reset In21
      Set In22

   If Sensor1 = 0 And Sensor2 = 1 Then
      Wait 70
      Reset En2
      Reset In21
      Reset In22
   Elseif Sensor1 = 0 And Sensor2 = 0 Then
      Wait 70
      Reset En2
      Reset In21
      Reset In22


   Elseif Sensor2 = 0 And Sensor1 = 1 Then
      Wait 101
      Reset En2
      Reset In21
      Reset In22

   End If
   End If


   If Sensor2 = 1 Then
      Locate 2 , 1
      Lcd "P2:OCCUPED"
   Else
      Locate 2 , 1
      Lcd "P2:EMPTY  "

   End If

   If Sensor1 = 1 Then
      Locate 1 , 1
      Lcd "P1:OCCUPED"
   Else
      Locate 1 , 1
      Lcd "P1:EMPTY  "
   End If
   Waitms 300

Loop

