$regfile = "m8def.dat"
$crystal = 8000000

Buzzer Alias Portc.5
Relay Alias Portc.4
Sensor Alias Pinc.0

Config Buzzer = Output
Config Relay = Output



'Set Relay
'Set Buzzer

Do
   If Sensor = 0 Then
      Set Buzzer
      Set Relay
      Wait 1
      Reset Relay
      Reset Buzzer
      Waitms 500
   End If

Loop
