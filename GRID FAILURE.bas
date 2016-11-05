$regfile = "m16def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcd = 16 * 2

Config Timer0 = Timer , Prescale = 1024
On Ovf0 Timer0_isr
Enable Timer0

Config Adc = Single , Prescaler = Auto
Start Adc

R_relay Alias Portc.7
Y_relay Alias Portc.6
B_relay Alias Portc.5

Buzzer Alias Portc.4

R_led Alias Portc.3
Y_led Alias Portc.2
B_led Alias Portc.1
Running_led Alias Portc.0


Config R_relay = Output
Config Y_relay = Output
Config B_relay = Output

Config Buzzer = Output

Config R_led = Output
Config Y_led = Output
Config B_led = Output
Config Running_led = Output


Dim Timer0_count As Byte
Dim R_adc As Word
Dim Y_adc As Word
Dim B_adc As Word

Dim R_temp As Word
Dim Y_temp As Word
Dim B_temp As Word

Set Buzzer
Cls
Cursor Off
Lcd "  GRID FAILURE  "
Lowerline
Lcd "PROTECTION SYSTEM"
Wait 3
Cls
Enable Interrupts
Set R_relay
Set Y_relay
Set B_relay
Do
   R_adc = Getadc(2)
   R_adc = R_adc / 4
   R_temp = Getadc(5)
   R_temp = R_temp / 2

   If R_temp < 60 And R_adc > 0 And Y_temp < 60 And Y_adc > 0 And B_temp < 60 And B_adc > 0 Then
      Set Buzzer
   End If

   If R_temp > 60 Or R_adc = 0 Then
      Reset R_relay
      Reset Buzzer
      Reset R_led
   Elseif R_temp < 40 Or R_adc <> 0 Then
      Set R_relay
      Set R_led
   End If

   Cls
   Lcd "R:" ; R_adc
   Locate 1 , 7
   Lcd "F:50"
   Locate 1 , 12
   Lcd "T:" ; R_temp
   Wait 2

   Y_adc = Getadc(3)
   Y_adc = Y_adc / 4
   Y_temp = Getadc(6)
   Y_temp = Y_temp / 2
   If Y_temp > 60 Or Y_adc = 0 Then
      Reset Y_relay
      Reset Buzzer
      Reset Y_led
   Elseif Y_temp < 40 Or Y_adc <> 0 Then
      Set Y_relay
      Set Y_led
   End If

   Cls
   Lcd "Y:" ; Y_adc
   Locate 1 , 7
   Lcd "F:50"
   Locate 1 , 12
   Lcd "T:" ; Y_temp
   Wait 2

   B_adc = Getadc(4)
   B_adc = B_adc / 4
   B_temp = Getadc(7)
   B_temp = B_temp / 2
   If B_temp > 60 Or B_adc = 0 Then
      Reset B_relay
      Reset Buzzer
      Reset B_led
   Elseif B_temp < 40 Or B_adc <> 0 Then
      Set B_relay
      Set B_led
   End If
   Cls
   Lcd "B:" ; B_adc
   Locate 1 , 7
   Lcd "F:50"
   Locate 1 , 12
   Lcd "T:" ; B_temp
   Wait 2

Loop

End

Timer0_isr:

   If Timer0_count > 15 Then
      Toggle Running_led
      Timer0_count = 0
   End If
   Incr Timer0_count

Return