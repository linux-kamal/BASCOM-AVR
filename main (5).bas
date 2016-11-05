$regfile = "m8def.dat"
$crystal = 8000000

'====================== All Neccessary Configurations ===============
Config Lcdpin = Pin , Rs = Portb.0 , E = Portb.1 , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5
Config Lcd = 16 * 2

' trigger
Config Portc.4 = Output
' echo
Config Portc.5 = Input

'Config Int1 = Rising
'On Int1 Mylable Nosave
'Enable Int1
'Enable Interrupts
Config Timer1 = Timer , Prescale = 8

Dim Distance As Word , Count As Word
Dim I As Byte

Cursor Off Noblink
Cls
Lcd "Ultrasonic Based Distance Measurement"
Wait 1
For I = 1 To 40
  Shiftlcd Left
  Waitms 300
Next
Wait 1
Cls
Lcd "Range 2cm  -  4m "
Wait 3
Cls
'Set Portd.2
'Waitus 15
Do
   Set Portc.4
   Waitus 10
   Reset Portc.4
   'Cls
   'Lcd "waiting for high edge"
   Bitwait Pinc.5 , Set
   Timer1 = 0
   Start Timer1

   'Pulsein Count , Pinc , 0 , 0
   'Cls
   'Lcd "got high"
   'Lowerline
   'Lcd "count = " ; Count
   'Wait 1
   ' wait for falling edge
   Bitwait Pinc.5 , Reset
   Stop Timer1
   Count = Timer1
   ' 1 increment will take 0.125 us
   'Count = Count * 0.125
   'If Count < 130 Then
    '  Cls
     ' Lcd "Unable To Measure"
      'Lowerline
      'Lcd "Below 2 cm"
      'Waitms 300
   'Else
      Distance = Count / 58
      Cls
      Lcd "Distance " ; Distance ; " cm"
      Lowerline
      Distance = Count / 148
      'Lcd Count
      Lcd "Distance " ; Distance ; " inch"
      Waitms 300
   'End If
   'Lowerline
   'Lcd "falling edge found"
   'Lcd "count = " ; Count
   'Wait 1
   'Lowerline
   'Lcd Count
   'Set Portd.3
Loop
End



Mylable:

   Lcd "got high"
   Waitus 200
   Cls

Return