' This code is intentionally written for a final year engineering project
' ==================== Home Automation =====================

$regfile = "m8def.dat"
$crystal = 8000000
$baud = 9600
'====================== All Neccessary Configurations ===============
Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcd = 16 * 2
Devices Alias Portd
'Config Devices = Output
Config Portd.5 = Output
Config Portd.6 = Output
Config Portd.7 = Output
Upper_relay Alias Portd.5
Lower_relay Alias Portd.6
Transister Alias Portd.7

Config Adc = Single , Prescaler = Auto
Start Adc
Deflcdchar 0 , 12 , 18 , 18 , 12 , 32 , 32 , 32 , 32
'===================== variables =========================
Dim Ser_data As Byte
Dim Check As Byte
Dim Send As Byte
Dim Lm35 As Word
Dim I As Byte
Dim Lm35_prev As Word
Cursor Off Noblink
Cls
Lcd "A Project On Home Automation"
Wait 1
For I = 1 To 40
  Shiftlcd Left
  Waitms 300
Next
Wait 1
Do
   ' ADC reading will range from 0-1023 (10-bit ADC)
   ' we are more interested in calculating step size (5/1024 = 4.88 mv)
   ' lm35 increment 1 degree celceuss/10 mv
   ' our ADC will increment at every 4.88mv
   ' in 10 mv ADC our incremet 2 times ,so we need to devide it by 2

   Lm35 = Getadc(0)
   Lm35 = Lm35 / 2
   Cls
   Lcd "Temprature " ; Lm35 ; " " ; Chr(0) ; "C"
   'If Lm35 <> Lm35_prev Then
   Print Lm35
   'End If
   'Lm35_prev = Lm35
   Lowerline
   'Lcd
   Waitms 350
   If Ischarwaiting() = 1 Then
      Ser_data = Inkey()
      If Chr(ser_data) = "a"then
         Set Upper_relay
      Elseif Chr(ser_data) = "b"then
         Reset Upper_relay

      Elseif Chr(ser_data) = "c"then
         Set Lower_relay
      Elseif Chr(ser_data) = "d"then
         Reset Lower_relay

      Elseif Chr(ser_data) = "e"then
         Set Transister
      Elseif Chr(ser_data) = "f"then
         Reset Transister
      Else
         Reset Upper_relay
         Reset Lower_relay
         Reset Transister
      End If
   End If

Loop
End