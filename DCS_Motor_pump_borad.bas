$regfile = "m8def.dat"
$crystal = 8000000
$baud = 9600

On Urxc Lable
Enable Interrupts
Enable Urxc


Pump Alias Portd.4
Sensor Alias Pinc.5
Sensor = 0
Portc.5 = 0

Config Pump = Output

Dim Char As Byte

Do
   If Pinc.5 = 1 Then
      Print "F"

   End If
Loop


Lable:
   Char = Inkey()

   If Chr(char) = "O" Then
      Reset Pump

   Elseif Chr(char) = "S" Then
      Set Pump

   End If

Return
