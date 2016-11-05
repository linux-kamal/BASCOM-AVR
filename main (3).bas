' This code is intentionally written for a final year engineering project
' ==================== Accident Prevention System ======================

$regfile = "m8def.dat"
$crystal = 8000000
'$baud = 9600
'====================== All Neccessary Configurations ==================
Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcd = 16 * 2
Buzzer Alias Portd.0
Signal Alias Portd.2
Led Alias Portc.5
Config Buzzer = Output
Config Signal = Input
Config Led = Output
'====================== Variable Declarations Here =====================
Dim Count As Word
Dim Pulses As Word , Periods As Word
Dim I As Byte

'======================    Main Section Of Code    =====================
Led = 1
Cls
Cursor Off Noblink
Lcd "Accident Prevention System"
Wait 1
For I = 1 To 45
  Shiftlcd Left
  Waitms 300
Next
Wait 1
Cls
Do

   If Pind.2 = 0 Then
      '"Eye OPen"
      Lcd "Drive Safe"
   End If
   If Pind.2 = 1 Then
      'Lcd "Eye Close"

      Incr Count
      Lcd "Count Start " ; Count

   Elseif Pind.2 = 0 Then
      'Lcd "Eye Open"
      Count = 0

   End If
   If Count >= 10 And Count < 20 Then
      'Set Buzzer
      Cls
      Lcd "Wake Up !!!"
      Pulses = 10 : Periods = 20000
      Sound Buzzer , Pulses , Periods

   Elseif Count >= 20 And Count < 25 Then
      'Set Buzzer
      Cls
      Lcd "Wake Up....!!!"
      Lowerline
      Lcd "Wake up.....!!!"
      Pulses = 10 : Periods = 60000
      Sound Buzzer , Pulses , Periods

   Elseif Count >= 25 And Count < 26 Then
      Set Buzzer
      Cls
      Lcd "Imidiately Call"
      Lowerline
      Lcd "108"
      Wait 5
      Reset Buzzer
      'Cls
      End

   Elseif Count < 10 And Count > 30 Then
      Lcd "Drive Safe !!!"
      Reset Buzzer
   Else
      Reset Buzzer

   End If

   Lowerline
   'Lcd "COUNT= " ; Count
   Waitms 300
   Cls
Loop
End