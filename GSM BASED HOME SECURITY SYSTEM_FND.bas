
$regfile = "m16def.dat"
$crystal = 8000000
Config Timer0 = Timer , Prescale = 64
On Ovf0 Timer0_isr
Enable Interrupts
Enable Timer0

Config Portb.5 = Output

Config Portd.1 = Output                                     'en1
Config Portd.3 = Output                                     'IN12
Config Portd.4 = Output                                     'EN11
Config Portd.5 = Output                                     'IN11

Config Portd.1 = Output                                     'EN2
Config Portd.6 = Output                                     'IN21
Config Portd.7 = Output                                     'IN22

Ir_sensor Alias Pind.2

Up Alias Pind.1
Down Alias Pind.0

Seven_seg_port Alias Portc
Config Seven_seg_port = Output
Ctrl_port Alias Porta

Config Porta.4 = Output                                     'Enables Right Display
Config Porta.5 = Output                                     'Enables Middle Display
Config Porta.6 = Output                                     'Enables Left Display
Config Porta.7 = Output

Declare Sub Convert_to_array(byval Value As Word)

'-------------------------------------------------------------------------------
Dim Disp_count As Byte
Dim _data As Byte
Dim Numbers(11) As Byte
Dim Count As Word
Dim Array(4) As Byte
Dim Temp As Word
'-------------------------------- Variables Initialization ---------------------
Count = 1
Disp_count = 0
_data = 16
Temp = 0

Portd.1 = 1                                                 'EN1
Portd.4 = 1                                                 'EN2

Portd.3 = 0
Portd.5 = 0

Portd.6 = 0
Portd.7 = 0

Portb.5 = 0

'We can put these numbers as Data Table ,then we have to use Lookup from table

Numbers(1) = &H14                                           '0
Numbers(2) = &HD7                                           '1
Numbers(3) = &H4C                                           '2
Numbers(4) = &H45                                           '3
Numbers(5) = &H87                                           '4
Numbers(6) = &H25                                           '5
Numbers(7) = &H24                                           '6
Numbers(8) = &H57                                           '7
Numbers(9) = &H04                                           '8
Numbers(10) = &H05                                          '9
'Numbers(11) = &H                                          '-

'To access these locations---->>>> index+1
'-------------------------------------------------------------------------------

Start Timer0
'Pwm1b = 1023
'Pwm1a = 1023

Do
   Temp = Ir_sensor
   '(
   If Ir_sensor = 0 Then
      Array(1) = 5
      Array(2) = 1
      Array(3) = 1
      Array(4) = 1
      Portd.3 = 1
      Portd.5 = 0
      Portd.6 = 1
      Portd.7 = 0
      Wait 3
      Portd.3 = 0
      Portd.5 = 0
      Portd.6 = 0
      Portd.7 = 0
   Else
      Array(1) = 5
      Array(2) = 0
      Array(3) = 0
      Array(4) = 0
   End If
')
      Call Convert_to_array(temp)
      If Temp = 0 Then
         Portb.5 = 1
         Wait 4
         Portb.5 = 0
      Else
         Portb.5 = 0
      End If
      'Wait 2
      'Call Convert_to_array(50)
      'Wait 2
Loop

End
'-------------------------------------------------------------------------------

Timer0_isr:
   Dim Var As Byte
   If Disp_count > 3 Then
      Disp_count = 0
      _data = 16
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
