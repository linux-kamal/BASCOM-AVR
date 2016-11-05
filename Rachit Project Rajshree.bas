$regfile = "m8def.dat"
$crystal = 8000000

Sensor Alias Pinb.0
Buzzer Alias Portb.1


Reset Buzzer

Do
   If Sensor = 1 Then
      Set Buzzer
      Do
      Loop
   Else
      Reset Buzzer
   End If

Loop