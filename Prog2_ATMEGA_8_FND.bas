$regfile = "m8def.dat"
$crystal = 8000000

Config Timer0 = Timer , Prescale = 64
On Ovf0 Timer0_isr
Enable Interrupts
Enable Timer0

Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc


_ok_menu Alias Pinc.2
_up Alias Pinc.4
_down Alias Pinc.3

' To find Temprature use this method
'http://embedded-lab.com/blog/digital-temperature-meter-using-an-lm35-temperature-sensor/


Config Portd.0 = Output
Config Portd.1 = Output
Config Portd.2 = Output
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

Dim Eram_temp_byte As Eram Byte
Dim Temp_byte As Byte
'-------------------------------- Variables Initialization ---------------------
Count = 1
Disp_count = 0
_data = 1
Temp = 0
Temp_byte = Eram_temp_byte

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
'-------------------------------------------------------------------------------
Portc.2 = 1
Portc.3 = 1
Portc.4 = 1
Start Timer0

Do

   If _ok_menu = 0 Then
      While _ok_menu = 0
      Wend
      Do
         If _up = 0 Then
            While _up = 0
            Wend
            Incr Temp_byte
         End If

         If _down = 0 Then
            While _down = 0
            Wend
            Decr Temp_byte
         End If
         If _ok_menu = 0 Then
            While _ok_menu = 0
            Wend
            Eram_temp_byte = Temp_byte
            Exit Do
         End If
         Waitms 50
      Loop
   End If
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
   Ctrl_port = _data
   If Count > 4 Then
      Count = 1
   End If
   Var = Array(count)
   Var = Var + 1
   Seven_seg_port = Numbers(var)
   Shift _data , Left , 1
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