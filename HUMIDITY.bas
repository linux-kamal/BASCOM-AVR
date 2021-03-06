

$regfile = "m8def.dat"
$crystal = 8000000

Config Timer0 = Timer , Prescale = 64
On Ovf0 Timer0_isr
Enable Interrupts
Enable Timer0

Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc

Config Portd.0 = Output                                     'Enables Right Display
Config Portd.1 = Output                                     'Enables Middle Display
Config Portd.2 = Output                                     'Enables Left Display
Config Portd.3 = Output

Ctrl_port Alias Portd
Seven_seg_port Alias Portb
Config Seven_seg_port = Output
'-------------------------------------------------------------------------------

Declare Sub Convert_to_array(byval Value As Word)
Declare Sub Single_to_array(byval Value As Single)
'-------------------------------------------------------------------------------
Dim Disp_count As Byte
Dim _data As Byte
Dim Numbers(10) As Byte
Dim Count As Word
Dim Array(7) As Byte
Dim Temp As Word
Dim Adc_val As Word
Dim Single_var As Single

Dim Begin_index As Byte
Dim End_index As Byte
Dim Dp_place As Byte
Dim _string As String * 3
Dim Local_array(7) As Byte
'-------------------------------- Variables Initialization ---------------------
Count = 1
Disp_count = 0
_data = 1
Temp = 0
' We can put these numbers as Data Table ,then we have to use Lookup from table

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
Do


   'Adc_val = Getadc(0)
   'Adc_val = Adc_val * 2
   'Adc_val = Adc_val / 10
   Call Convert_to_array(temp)

   Wait 2
   Incr Temp
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

   Ctrl_port = _data                                        'Used to select the single display at a time

   If Count > 4 Then
      Count = 1
   End If
   Var = Array(count)

   'Access (Index+1) to fetch right value
   Var = Var + 1
   'If Array(var) <> 254 Then
   Seven_seg_port = Numbers(var)

   If _data = Dp_place Then
      Portb.0 = 0
   End If
   Shift _data , Left , 1

   'Else
    '  Portb.0 = 0
   'End If
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