$regfile = "m8def.dat"
$crystal = 4000000

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

Config Portd.6 = Input

Ctrl_port Alias Portd
Seven_seg_port Alias Portb
Buzzer Alias Portc.5
Relay Alias Portc.4

Config Seven_seg_port = Output
Config Buzzer = Output
Config Relay = Output

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
Dim Relay_flag As Bit

'-------------------------------- Variables Initialization ---------------------
Count = 1
Disp_count = 0
_data = 1
Temp = 0
Relay_flag = 0
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
'Array(3) = 4
'Array(4) = 1


Temp = 0
Set Buzzer


Do

   Adc_val = Getadc(0)

   Adc_val = Adc_val / 2
   Temp = Adc_val

   Call Convert_to_array(temp)

   Wait 1

   If Temp > 70 Then
      Reset Buzzer

      Reset Relay

   Elseif Temp < 50 Then
      Set Buzzer

      Set Relay
   End If

   If Pind.6 = 1 Then
      If Relay_flag = 0 Then
         Set Relay
         Relay_flag = 1
      Elseif Relay_flag = 1 Then
         Reset Relay
         Relay_flag = 0
      End If

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
   I = 1
   For I = 1 To 4
      Index = 5 - I
      Array(index) = Value Mod 10
      Value = Value / 10
   Next I
End Sub