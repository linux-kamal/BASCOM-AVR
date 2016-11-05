$regfile = "m16def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7 , E = Porta.3 , Rs = Porta.2
Config Lcd = 16 * 2
Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc

Config Portd.7 = Output

Deflcdchar 0 , 4 , 14 , 21 , 4 , 4 , 4 , 4 , 4              ' Arrow UP
Deflcdchar 1 , 4 , 4 , 4 , 4 , 4 , 21 , 14 , 4              ' Arrow DOWN
Deflcdchar 2 , 14 , 10 , 14 , 32 , 32 , 32 , 32 , 32

Dim Readbyte(50) As Word
Dim Avragevalue As Word
Dim Temprature As Single
Dim I As Byte
Dim Duty As Word

Cls
Cursor Off
Lcd "Hello"

Tccr2.3 = 1
Tccr2.6 = 1
Tccr2.5 = 1
Tccr2.0 = 1
'Tccr2.1 = 1
'Tccr2.2 = 1
Ocr2 = 0


Do
   For I = 1 To 50
      Readbyte(i) = Getadc(0)
      Waitus 100
   Next I

   Avragevalue = 0
   For I = 1 To 50
      Avragevalue = Avragevalue + Readbyte(i)
   Next I

   Avragevalue = Avragevalue / 50
   Temprature = Avragevalue * 0.49



   'Temprature = Temprature * 10
   Locate 2 , 1
   Lcd Fusing(temprature , "#.##") ; Chr(2) ; "C"

   Locate 1 , 15
   Lcd Chr(0)
   Locate 2 , 15
   Lcd Chr(1)
   Waitms 200

   Do
      Ocr2 = Duty
      Incr Duty
      If Duty > 255 Then Duty = 0
      Waitms 20
   Loop
Loop
End

Myisr:



Return
