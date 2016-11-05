$regfile = "m8def.dat"
$crystal = 8000000

'====================== All Neccessary Configurations ===============
Config Lcdpin = Pin , Db4 = Portb.4 , Db5 = Portb.5 , Db6 = Portb.6 , Db7 = Portb.7 , E = Portb.1 , Rs = Portb.0
Config Lcd = 16 * 2
Config Adc = Single , Prescaler = Auto
Start Adc
Deflcdchar 0 , 12 , 18 , 18 , 12 , 32 , 32 , 32 , 32
Upper_relay Alias Portd.5
Lower_relay Alias Portd.6
Dc_fan Alias Portd.7

' Your Heater
Config Upper_relay = Output
' Your A.C
Config Lower_relay = Output
'Your DC Fan
Config Dc_fan = Output

'================== Variables declaration ============================
Dim Temprature As Word
Dim I As Byte




Cursor Off Noblink
Cls
Lcd "Temrature Controlled Device Switching"
Wait 1
For I = 1 To 45
  Shiftlcd Left
  Waitms 350
Next
Wait 1
Cls
Do

   Temprature = Getadc(0)
   Temprature = Temprature / 2

   If Temprature > 20 And Temprature <= 25 Then
      ' Normal temprature No need to Drive anything
      Reset Upper_relay
      Reset Lower_relay
      Reset Dc_fan
      Cls
      Lcd "Temprature " ; Temprature ; Chr(0) ; " C"
      Lowerline
      Lcd "It's Normal Weather"
   Elseif Temprature > 25 And Temprature <= 35 Then
      ' Switch on FAN only , Weather is Not too hot
      Reset Upper_relay
      Reset Lower_relay
      Set Dc_fan
      Cls
      Lcd "Temprature " ; Temprature ; Chr(0) ; " C"
      Lowerline
      Lcd "Switch On DC FAN"
   Elseif Temprature > 35 And Temprature <= 40 Then
      'switch on A.C only
      Reset Upper_relay
      Set Lower_relay
      Reset Dc_fan
      Cls
      Lcd "Temprature " ; Temprature ; Chr(0) ; " C"
      Lowerline
      Lcd "Switch On A.C"
    Elseif Temprature > 40 Then
      ' switch on FAN and A.C both , it's too hot
      Set Lower_relay
      Reset Upper_relay
      Set Dc_fan
      Cls
      Lcd "Temprature " ; Temprature ; Chr(0) ; " C"
      Lowerline
      Lcd "A.C & FAN ON"
    Elseif Temprature <= 20 Then
      'switch on heater only , its to cool
      Reset Lower_relay
      Set Upper_relay
      Reset Dc_fan
      Cls
      Lcd "Temprature " ; Temprature ; Chr(0) ; " C"
      Lowerline
      Lcd "Switch On Heater"
    End If



    Wait 1

   '(
   Set Upper_relay
   Wait 2
   Reset Upper_relay
   Set Lower_relay
   Wait 2
   Reset Lower_relay
   Set Dc_fan
   Wait 2
   Reset Dc_fan

')


Loop
End