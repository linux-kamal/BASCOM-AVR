$regfile = "m8def.dat"
$crystal = 8000000

Config Timer1 = Timer , Prescale = 8
'Config Timer0 = Timer , Prescale = 64
'On Ovf0 Timer0_isr
Enable Interrupts
'Enable Timer0

'Config Adc = Single , Prescaler = Auto , Reference = Avcc
'Start Adc

Ultra_echo Alias Pinb.1
Ultra_trigger Alias Portb.2

Buzzer1 Alias Portd.0
Buzzer2 Alias Portd.1
Config Buzzer1 = Output
Config Buzzer2 = Output

Config Ultra_trigger = Output
Config Ultra_echo = Input

Config Portd.0 = Output                                     'Enables Right Display
Config Portd.1 = Output                                     'Enables Middle Display
Config Portd.2 = Output                                     'Enables Left Display
Config Portd.3 = Output

Config Portd.5 = Output
Config Portd.6 = Output
Config Portd.7 = Output

Dim Temp As Word
Dim Adc_val As Word
Dim Temp2 As Single

Dim Flag1 As Byte
Dim Flag2 As Byte


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
   Temp = Temp * 10
   Temp = Temp / 58
   If Temp > 150 Then
      Temp = 0
   End If

   If Temp >= 70 And Temp <= 79 And Flag1 = 0 And Flag2 = 0 Then

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
      Temp = Temp * 10
      Temp = Temp / 58
      If Temp > 150 Then Temp = 0
      If Temp >= 70 And Temp <= 79 And Flag1 = 0 And Flag2 = 0 Then
         Set Portd.5
         Set Portd.6
         Reset Portd.7
         'Sound Buzzer , 5 , 5000
      End If

   Elseif Temp >= 80 And Temp <= 83 And Flag1 = 0 Then
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
      Temp = Temp * 10
      Temp = Temp / 58
      If Temp > 150 Then Temp = 0
      If Temp >= 80 And Temp <= 83 And Flag1 = 0 Then
         Set Portd.5
         Reset Portd.6
         Set Portd.7
         Flag2 = 1
         Sound Buzzer1 , 5 , 30000
         Sound Buzzer2 , 5 , 30000
      End If

   Elseif Temp >= 84 Then
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
      Temp = Temp * 10
      Temp = Temp / 58
      If Temp > 150 Then Temp = 0
      If Temp >= 86 Then
         Reset Portd.5
         Set Portd.6
         Set Portd.7
         Flag2 = 0
         Sound Buzzer1 , 5 , 65000
         Sound Buzzer2 , 5 , 30000
      End If

   Elseif Temp <= 72 Then
      Flag2 = 0

   Elseif Temp <= 65 Then
      Set Portd.5
      Set Portd.6
      Set Portd.7
      Reset Buzzer1
      Reset Buzzer2

   Elseif Temp = 0 Then
      Set Portd.5
      Set Portd.6
      Set Portd.7
      Reset Buzzer1
      Reset Buzzer2


   End If
   Waitms 40

Loop