$regfile = "m16def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Db4 = Portb.5 , Db5 = Portb.4 , Db6 = Portb.3 , Db7 = Portb.2 , E = Portb.6 , Rs = Portb.7
Config Lcd = 16 * 2

Relay Alias Portc.0
Led1 Alias Portd.0
Led2 Alias Portd.1
Led3 Alias Portd.2

Config Relay = Output
Config Led1 = Output
Config Led2 = Output
Config Led3 = Output

Config Adc = Single , Prescaler = Auto
Start Adc

Config Timer0 = Timer , Prescale = 1024
On Ovf0 Timer0_isr
Enable Timer0
Disable Interrupts

Dim Timer0_count1 As Byte
Dim Timer0_count2 As Byte
Dim Ct_read As Word
Dim Unit_count_rate As Byte
Dim I As Word
Dim Unit_availble As Byte

Relay = 0
Display On
Cursor Off
Cls
Lcd "POWER THEFT DETECTION"
Lowerline
Lcd "USING ENERGY METER"
Wait 3
Cls
Relay = 1
Enable Interrupts

Do
' 100W         CT VAL 30 - 40
' 100+100W     CT VAL 70 - 120
' 200W         CT VAL 70 - 120
' 100+200W     CT VAL 130 - 170
' 100+100+200W CT VAL 130 - 170

Lable:
   Ct_read = Getadc(0)

   Select Case Ct_read
      ' 100W
      Case 10 To 60 :
         Unit_count_rate = 142
         Locate 1 , 9
         Lcd "LOAD:" ; "100W"
      '200W
      Case 70 To 120 :
         Unit_count_rate = 71
         Locate 1 , 9
         Lcd "LOAD:" ; "200W"
      '300W
      Case 130 To 170 :
         Unit_count_rate = 47
         Locate 1 , 9
         Lcd "LOAD:" ; "300W"
      '400W
      Case 200 To 1023 :
         Unit_count_rate = 35
         Locate 1 , 9
         Lcd "LOAD:" ; "400W"
      Case 0 :
         Unit_count_rate = 0
         Locate 1 , 9
         Lcd "LOAD:" ; "  0W"
   End Select

   Locate 1 , 1
   Lcd "CT:" ; Ct_read ; "  "
   Locate 2 , 1
   If Ct_read = 0 Then Lcd "LOAD:OFF"
   If Ct_read <> 0 Then Lcd "LOAD:ON "
   If Ct_read >= 185 Then Lcd "LOAD:OL "
   Locate 2 , 9
   Lcd "UNIT:" ; Unit_availble ; "   "
   If Unit_count_rate <> 0 Then
      Do
         If I = Unit_count_rate Then
            Led1 = 1
            Waitms 50
            Led1 = 0
            Exit Do
         Elseif I > Unit_count_rate Then
            Led1 = 1
            Waitms 50
            Led1 = 0
            Exit Do
         End If
         Goto Lable
      Loop
      I = 0
      Unit_availble = Unit_availble + 1
   End If
   '------------------------------------------------------------
   Waitms 100
Loop

Timer0_isr:
   If Timer0_count1 > 12 Then
      Toggle Led3
      Timer0_count1 = 0
   End If

   If Timer0_count2 > 2 Then
      Incr I
      Timer0_count2 = 0
   End If

   Incr Timer0_count1
   Incr Timer0_count2
Return