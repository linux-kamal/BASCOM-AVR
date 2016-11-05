$regfile = "m8def.dat"
$crystal = 8000000


Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcd = 16 * 2
Config Timer0 = Timer , Prescale = 64
On Ovf0 Timer0_isr
Enable Interrupts
Enable Timer0
Config Adc = Single , Prescaler = Auto , Reference = Avcc

Start Adc

Config Portc.0 = Output                                     'Enables Right Display
Config Portc.1 = Output                                     'Enables Middle Display
Config Portc.2 = Output                                     'Enables Left Display

Ctrl_port Alias Portc
Seven_seg_port Alias Portd
Config Seven_seg_port = Output
'-------------------------------------------------------------------------------

Declare Sub Convert_to_array(byval Value As Word)

'-------------------------------------------------------------------------------
Dim Disp_count As Byte
Dim _data As Byte
Dim Numbers(10) As Byte
Dim Count As Word
Dim Array(3) As Byte
Dim Temp As Word
Dim Adc_val As Word
'-------------------------------- Variables Initialization ---------------------
Count = 1
Disp_count = 0
_data = 1
Temp = 0
' We can put these numbers as Data Table ,then we have to use Lookup from table

Numbers(1) = &H3F                                           '0
Numbers(2) = &H06                                           '1
Numbers(3) = &H5B                                           '2
Numbers(4) = &H4F                                           '3
Numbers(5) = &H66                                           '4
Numbers(6) = &H6D                                           '5
Numbers(7) = &H7D                                           '6
Numbers(8) = &H07                                           '7
Numbers(9) = &H7F                                           '8
Numbers(10) = &H6F                                          '9


'To access these locations---->>>> index+1
'-------------------------------------------------------------------------------

Cls
Lcd "7 Segment Test"
Waitms 300
Cls
Start Timer0


Do


   Adc_val = Getadc(0)
   Temp = Adc_val
   Call Convert_to_array(temp)
   'Incr Temp
   Cls
   Lcd Adc_val
   Waitms 500

Loop

End
'-------------------------------------------------------------------------------

Timer0_isr:
   Dim Var As Byte
   If Disp_count > 2 Then
      Disp_count = 0
      _data = 1
   End If
   ' Use NOT whenever you want to send logic zero to select 7-segment display
   'Portd = Not _data
   Ctrl_port = _data
   Shift _data , Left , 1

   If Count > 3 Then
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
   For I = 1 To 3
      Index = 4 - I
      Array(index) = Value Mod 10
      Value = Value / 10
   Next I
End Sub