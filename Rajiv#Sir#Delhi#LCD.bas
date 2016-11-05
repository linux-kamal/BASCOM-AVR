$regfile = "m8def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Db4 = Portc.3 , Db5 = Portc.2 , Db6 = Portc.1 , Db7 = Portc.0 , E = Portc.4 , Rs = Portc.5
Config Lcd = 16 * 2

Config Timer1 = Timer , Prescale = 8
Enable Interrupts

Ultra_echo Alias Pinb.1
Ultra_trigger Alias Portb.2

Config Ultra_trigger = Output

Buzzer1 Alias Portd.0
Buzzer2 Alias Portd.1
Config Buzzer1 = Output
Config Buzzer2 = Output

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

Dim Cm As Word
Dim Inch As Word
Dim Mm As Word

Display On
Cursor Off
Cls
Lcd "ULTRASONIC SENSOR"
Lowerline
Lcd "DISTANCE MESURING TOOL"
Wait 3
Cls
'-------------------------------- Variables Initialization ---------------------
Temp = 0

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

   Cm = Temp / 58

   Mm = Temp * 10
   Mm = Mm / 58

   Inch = Mm * 0.25
   'If Temp > 150 Then
   '   Temp = 0
   'End If
   Locate 1 , 1
   Lcd "CM:" ; Cm ; "  "
   Locate 1 , 10
   Lcd "MM:" ; Mm ; "  "
   Waitms 80

Loop

End
'-------------------------------------------------------------------------------

