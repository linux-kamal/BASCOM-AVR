$regfile = "m8def.dat"
$crystal = 8000000

'Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
'Config Lcd = 16 * 2

Buzzer Alias Portd.0
Relay Alias Portd.6
Enable_display Alias Portd.7
7_segment_display Alias Portb

Top Alias Pinc.5
Bottom Alias Pinc.2

Led1 Alias Portd.1
Led2 Alias Portd.2
Led3 Alias Portd.3
Led4 Alias Portd.4

Config Led1 = Output
Config Led2 = Output
Config Led3 = Output
Config Led4 = Output

Config 7_segment_display = Output
Config Enable_display = Output
Config Buzzer = Output
Config Relay = Output

Config Top = Input
Config Bottom = Input


Dim 7_segment_data(13) As Byte
Dim Count As Word
Dim For_loop_count As Byte
Count = 0
For_loop_count = 0
7_segment_data(1) = &HE0                                    'EMPTY
7_segment_data(2) = &HE1                                    'FULL
7_segment_data(3) = &HBF                                    'DP
7_segment_data(4) = &H04
7_segment_data(5) = &H
7_segment_data(6) = &H
7_segment_data(7) = &H
7_segment_data(8) = &H
7_segment_data(9) = &H
7_segment_data(10) = &H
7_segment_data(11) = &H
7_segment_data(12) = &H
7_segment_data(13) = &H


Set Enable_display
Reset Led1
Reset Led2
Reset Led3
Reset Led4
Do

Lable:
   If Bottom = 1 Then
      'Pump on
      Reset Led1
      Set Led4
      7_segment_display = 7_segment_data(1)
      Set Relay

      While Bottom = 1
         Set Led4
         Set Buzzer
         Set Enable_display
         Waitms 500
         Reset Led4
         Reset Buzzer
         Reset Enable_display
         Waitms 500
         Incr Count
         If Count > 15 Then
            Reset Relay
            For For_loop_count = 4 To 8
               If Bottom = 0 Then Exit For
               Set Enable_display
               Set Led3
               7_segment_display = 7_segment_data(3)
               Wait 1
               Reset Enable_display
               Reset Led3
               Wait 1
            Next For_loop_count
            Count = 0
            Goto Lable
         End If
      Wend

      Set Led4
      Set Enable_display
      Count = 0

   Elseif Top = 0 And Bottom = 0 Then
      'pump off
      Set Enable_display
      Reset Buzzer
      Reset Relay
      7_segment_display = 7_segment_data(2)
      Set Led1
      Reset Led4
   End If

Loop