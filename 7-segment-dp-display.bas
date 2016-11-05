
'--------------------------HARDWARE INITIALIZATION------------------------------

$regfile = "m16def.dat"                                     'ATMEGA 32 MICROCONTROLLER
$crystal = 16000000                                         '16MHz CRYSTAL
$baud = 9600

Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0       'LCD PIN DECLARATION
Config Lcd = 16 * 2

Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc

Dim _byte As Byte
Dim _single As Single
Dim _string As String * 3
Dim Array(7) As Byte
Dim Index As Byte
Dim Begin_index As Byte
Dim End_index As Byte
Dim Dp_place As Byte
Dim Second_array(7) As Byte
Dim Count As Byte
Dp_place = 0

Cls
Do

   'Fusing(s , "#.##")

   Count = 1

   _byte = Getadc(0)
   _single = 4.8 * _byte
   Locate 1 , 1
   Lcd _single

   If _single < 10 Then
      _string = Fusing(_single , "#.##")
      Begin_index = 5
      End_index = 3
      Dp_place = 1
   Elseif _single < 100 Then
      _string = Fusing(_single , "##.#")
      Begin_index = 5
      End_index = 2
      Dp_place = 2
   Elseif _single > 999 Then
      _string = Fusing(_single , "##.#")
      Begin_index = 7
      End_index = 2
      Dp_place = 4
   Elseif _single > 99 And _single < 1000 Then
      _string = Fusing(_single , "###.#")
      Begin_index = 6
      End_index = 2
      Dp_place = 3
   End If

   Str2digits _string , Array(1)
   Locate 2 , 1
   Lcd Dp_place

'The code below used to print decimal point on the LCD by finding the location of dp
   For Index = Begin_index To End_index Step -1
      If Array(index) <> 254 Then
         Second_array(count) = Array(index)
         'Lcd Array(index) ; " "
      Else
         Second_array(count) = "."
         'Lcd ". "
      End If

      'Lcd Second_array(count)
      Array(index) = 0
      Incr Count
   Next

   'Lcd "       "

Loop
