$regfile = "m8def.dat"
$crystal = 8000000
$baud = 9600


Load1 Alias Portd.2
Load2 Alias Portd.3
Load3 Alias Portd.4
Load4 Alias Portb.6

Config Load1 = Output
Config Load2 = Output
Config Load3 = Output
Config Load4 = Output

Dim Char As Byte

Do
   If Ischarwaiting() = 1 Then
      Char = Inkey()
      If Chr(char) = "U" Then
         Set Load1
         Set Load2
      Elseif Chr(char) = "B" Then
         Reset Load1
         Reset Load2

      Elseif Chr(char) = "L" Then
         Reset Load2
         Set Load1

      Elseif Chr(char) = "R" Then
         Reset Load1
         Set Load2
      Elseif Chr(char) = "C" Then
         Reset Load1
         Reset Load2
      Elseif Chr(char) = "P" Then
         Set Load3
         Reset Load4
         Waitms 400
         Reset Load3
         Reset Load4

      Elseif Chr(char) = "D" Then
         Reset Load3
         Set Load4
         Waitms 400
         Reset Load3
         Reset Load4

      End If

   End If

Loop