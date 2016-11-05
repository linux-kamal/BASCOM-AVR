$regfile = "m8def.dat"
$crystal = 8000000
$baud = 9600

Config Lcdpin = Pin , Db4 = Portb.3 , Db5 = Portb.2 , Db6 = Portb.1 , Db7 = Portb.0 , E = Portb.4 , Rs = Portb.5
Config Lcd = 16 * 2

Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc

Config Portd.7 = Output
Config Portd.6 = Output

Config Portb.6 = Output
Config Portb.7 = Output

Dim Temp As Word
Dim _recv As Byte

Display On
Cursor Blink
Portd.7 = 0
Cls
Lcd "PROJECT GOVT."
Lowerline
Lcd "POLY. RAMPUR"
Wait 3
Cls

Lcd "SHAIL RAJ YADAV"
Wait 3
Cls
Lcd "ANIL KUSHWAHA"
Wait 3
Cls
Lcd "VISHAL KR. YADAV"
Wait 3
Cls
Lcd "  TEMPRATURE   "
Lowerline
Lcd "CONTROLLER 2016"
Wait 3
Cls

Do
   Temp = Getadc(0)
   Temp = Temp / 2
   Locate 1 , 1
   Lcd "TEMPRATURE: " ; Temp ; "   "


   If Temp > 20 And Temp < 35 Then
      Portd.7 = 1
      Locate 2 , 1
      Lcd "LOAD ON "
   Elseif Temp > 50 Then
      Portd.7 = 0
      Locate 2 , 1
      Lcd "LOAD OFF"
   End If
   Waitms 200

Loop

Do

   _recv = Waitkey()

   If Chr(_recv) = "A" Then
      Set Portd.7
   Elseif Chr(_recv) = "a" Then
      Reset Portd.7
   Elseif Chr(_recv) = "B" Then
      Set Portd.6
   Elseif Chr(_recv) = "b" Then
      Reset Portd.6

   Elseif Chr(_recv) = "C" Then
      Set Portb.6
   Elseif Chr(_recv) = "c" Then
      Reset Portb.6
   Elseif Chr(_recv) = "D" Then
      Set Portb.7
   Elseif Chr(_recv) = "d" Then
      Reset Portb.7

   End If

Loop

