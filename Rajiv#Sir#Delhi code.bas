$regfile = "m8def.dat"
$crystal = 8000000

Config Timer1 = Timer , Prescale = 8
'Config Timer0 = Timer , Prescale = 64
'On Ovf0 Timer0_isr
Enable Interrupts
'Enable Timer0

Ultra_echo Alias Pinb.1
Ultra_trigger Alias Portb.2

Buzzer1 Alias Portd.0
Buzzer2 Alias Portd.1
Config Buzzer1 = Output
Config Buzzer2 = Output

Config Ultra_trigger = Output
Config Ultra_echo = Input

Config Portd.5 = Output
Config Portd.6 = Output
Config Portd.7 = Output

Dim Temp As Word

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

   'Call Convert_to_array(temp)


   '58 free=5.8cm
   '63 play free=6.3cm

   '70 first
   '75 second
   '80 third
   If Temp >= 70 And Temp <= 79 Then                        'change values for fisrt led 1
      Reset Portd.5
      Set Portd.6
      Set Portd.7
      Sound Buzzer1 , 5 , 5000
      Sound Buzzer2 , 5 , 5000

   Elseif Temp >= 80 And Temp <= 83 Then                    'change values for fisrt led 2
      Reset Portd.5
      Reset Portd.6
      Set Portd.7
      Sound Buzzer1 , 5 , 30000
      Sound Buzzer2 , 5 , 30000


   Elseif Temp >= 84 Then                                   'change values for fisrt led 3
      Reset Portd.5
      Reset Portd.6
      Reset Portd.7
      Sound Buzzer1 , 5 , 65000
      Sound Buzzer2 , 5 , 30000

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

End