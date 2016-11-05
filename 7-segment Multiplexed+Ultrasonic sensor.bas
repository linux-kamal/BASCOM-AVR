
$regfile = "m8def.dat"
$crystal = 8000000

Config Timer1 = Timer , Prescale = 8

Config Timer0 = Timer , Prescale = 64
On Ovf0 Timer0_isr
Enable Interrupts
Enable Timer0

'Config Adc = Single , Prescaler = Auto , Reference = Avcc
'Start Adc
Ultra_echo Alias Portc.1
Ultra_trigger Alias Portc.2
Buzzer Alias Portc.5

Config Ultra_trigger = Output
Config Ultra_echo = Input

Config Buzzer = Output

Config Portd.0 = Output                                     'Enables Right Display
Config Portd.1 = Output                                     'Enables Middle Display
Config Portd.2 = Output                                     'Enables Left Display
Config Portd.3 = Output

Config Portc.4 = Output
Config Portc.3 = Output
Config Portc.0 = Output

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

Start Timer0
'Array(1) = 2
'Array(2) = 6
'Array(3) = 5
'Array(4) = 8
Temp = 0
'Do
 '  Toggle Buzzer
'   Waitms 1000
'Loop
Do


   Set Ultra_trigger
   Waitus 10
   Reset Ultra_trigger
   'Cls
   'Lcd "waiting for high edge"
   Bitwait Pinc.1 , Set
   Timer1 = 0
   Start Timer1

   Bitwait Pinc.1 , Reset
   Stop Timer1
   Temp = Timer1

   Temp = Temp * 10

   Temp = Temp / 58

   Call Convert_to_array(temp)
   Waitms 400
   '58 free=5.8cm
   '63 play free=6.3cm

   '70 first
   '75 second
   '80 third


   If Temp > 100 Then
      Temp = 0
   End If

   If Temp >= 70 And Temp <= 74 Then
      Reset Portc.0
      Reset Portc.3
      Toggle Portc.4
      Sound Buzzer , 5 , 5000

   Elseif Temp >= 75 And Temp <= 79 Then
      Reset Portc.4
      Reset Portc.0
      Toggle Portc.3
      Sound Buzzer , 5 , 30000
   Elseif Temp >= 80 Then
      Reset Portc.4
      Reset Portc.3
      Toggle Portc.0
      Sound Buzzer , 5 , 65000
   Elseif Temp <= 63 Then
      Reset Portc.4
      Reset Portc.3
      Reset Portc.0
      Reset Buzzer
   Elseif Temp = 0 Then
      Reset Portc.4
      Reset Portc.3
      Reset Portc.0
      Reset Buzzer

   End If

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