$regfile = "m8def.dat"
$crystal = 8000000

Config Timer1 = Timer , Prescale = 8
'Config Timer0 = Timer , Prescale = 64
'On Ovf0 Timer0_isr
Enable Interrupts
'Enable Timer0

'Config Adc = Single , Prescaler = Auto , Reference = Avcc
'Start Adc

Ultra_echo Alias Pinb.1
Ultra_trigger Alias Portb.2

Buzzer1 Alias Portd.0
Buzzer2 Alias Portd.1
Config Buzzer1 = Output
Config Buzzer2 = Output

Config Ultra_trigger = Output
Config Ultra_echo = Input

Config Portd.0 = Output                                     'Enables Right Display
Config Portd.1 = Output                                     'Enables Middle Display
Config Portd.2 = Output                                     'Enables Left Display
Config Portd.3 = Output

Config Portd.5 = Output
Config Portd.6 = Output
Config Portd.7 = Output

Ctrl_port Alias Portd
Seven_seg_port Alias Portb
Config Seven_seg_port = Output
'-------------------------------------------------------------------------------

Declare Sub Convert_to_array(byval Value As Word)

'-------------------------------------------------------------------------------
Dim Disp_count As Byte
Dim _data As Byte
Dim Numbers(10) As Byte
Dim Count As Word
Dim Array(4) As Byte
Dim Temp As Word
Dim Adc_val As Word
Dim Temp2 As Single

Dim Flag1 As Byte
Dim Flag2 As Byte


'-------------------------------- Variables Initialization ---------------------
Count = 1
Disp_count = 0
_data = 1
Temp = 0



'We can put these numbers as Data Table ,then we have to use Lookup from table

Numbers(1) = &H05                                           '0
Numbers(2) = &HF5                                           '1
Numbers(3) = &H13                                           '2
Numbers(4) = &H91                                           '3
Numbers(5) = &HE1                                           '4
Numbers(6) = &H89                                           '5
Numbers(7) = &H09                                           '6
Numbers(8) = &HD5                                           '7
Numbers(9) = &H01                                           '8
Numbers(10) = &H81                                          '9


'To access these locations---->>>> index+1
'-------------------------------------------------------------------------------

'Start Timer0

'Array(1) = 2
'Array(2) = 6
'Array(3) = 5
'Array(4) = 8
Temp = 0
'Do
 '  Toggle Buzzer
'   Waitms 1000
'Loop

Flag1 = 0
Flag2 = 0
Do


   Set Ultra_trigger
   Waitus 10
   Reset Ultra_trigger
   'Cls
   'Lcd "waiting for high edge"
   Timer1 = 0
   Bitwait Ultra_echo , Set

   Start Timer1
   Bitwait Ultra_echo , Reset
   Stop Timer1
   Temp = Timer1
   Temp = Temp * 10
   Temp = Temp / 58
   If Temp > 150 Then
      Temp = 0
   End If

   'Call Convert_to_array(temp)


   '58 free=5.8cm
   '63 play free=6.3cm

   '70 first
   '75 second
   '80 third
   If Temp >= 70 And Temp <= 79 And Flag1 = 0 And Flag2 = 0 Then       'change values for fisrt led 1

      Set Ultra_trigger
      Waitus 10
      Reset Ultra_trigger
      'Cls
      'Lcd "waiting for high edge"
      Timer1 = 0
      Bitwait Ultra_echo , Set
      Start Timer1
      Bitwait Ultra_echo , Reset
      Stop Timer1
      Temp = Timer1
      Temp = Temp * 10
      Temp = Temp / 58
      If Temp > 150 Then Temp = 0
      If Temp >= 70 And Temp <= 79 And Flag1 = 0 And Flag2 = 0 Then       'change values for fisrt led 1
         Reset Portd.5
         Reset Portd.6
         Set Portd.7
         'Sound Buzzer , 5 , 5000
      End If

   Elseif Temp >= 80 And Temp <= 83 And Flag1 = 0 Then      'change values for fisrt led 2
      Set Ultra_trigger
      Waitus 10
      Reset Ultra_trigger
      'Cls
      'Lcd "waiting for high edge"
      Timer1 = 0
      Bitwait Ultra_echo , Set
      Start Timer1
      Bitwait Ultra_echo , Reset
      Stop Timer1
      Temp = Timer1
      Temp = Temp * 10
      Temp = Temp / 58
      If Temp > 150 Then Temp = 0
      If Temp >= 80 And Temp <= 83 And Flag1 = 0 Then       'change values for fisrt led 2
         Reset Portd.5
         Reset Portd.6
         Set Portd.7
         Flag2 = 1
         Sound Buzzer1 , 5 , 30000
         Sound Buzzer2 , 5 , 30000
      End If

   Elseif Temp >= 84 Then                                   'change values for fisrt led 3
      Set Ultra_trigger
      Waitus 10
      Reset Ultra_trigger
      'Cls
      'Lcd "waiting for high edge"
      Timer1 = 0
      Bitwait Ultra_echo , Set
      Start Timer1
      Bitwait Ultra_echo , Reset
      Stop Timer1
      Temp = Timer1
      Temp = Temp * 10
      Temp = Temp / 58
      If Temp > 150 Then Temp = 0
      If Temp >= 86 Then                                    'change values for fisrt led 3
         Reset Portd.5
         Reset Portd.6
         Set Portd.7
         Flag2 = 0
         Sound Buzzer1 , 5 , 65000
         Sound Buzzer2 , 5 , 30000
      End If

   Elseif Temp <= 72 Then
      Flag2 = 0

   Elseif Temp <= 65 Then
      Reset Portd.5
      Reset Portd.6
      Reset Portd.7
      Reset Buzzer1
      Reset Buzzer2

   Elseif Temp = 0 Then
      Reset Portd.5
      Reset Portd.6
      Reset Portd.7
      Reset Buzzer1
      Reset Buzzer2


   End If

   Waitms 40



Loop

End
'-------------------------------------------------------------------------------

Timer0_isr:
   Dim Var As Byte
   If Disp_count > 3 Then
      Disp_count = 0
      _data = 1
   End If
   ' Use NOT whenever you want to send logic zero to select 7-segment display
   'Portd = Not _data
   Ctrl_port = _data
   Shift _data , Left , 1
   If Count > 4 Then
      Count = 1
   End If
   Var = Array(count)
   'Access (Index+1) to fetch right value
   Var = Var + 1
   Seven_seg_port = Numbers(var)
   Incr Count
   Incr Disp_count
Return

'-------------------------------------------------------------------------------
Sub Convert_to_array(byval Value As Word)
   Dim I As Byte
   Dim Index As Byte
   For I = 1 To 4
      Index = 5 - I
      Array(index) = Value Mod 10
      Value = Value / 10
   Next I
End Sub