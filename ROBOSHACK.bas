$regfile = "m8def.dat"
$crystal = 12000000

'Config Lcdpin = Pin , Db4 = Portb.4 , Db5 = Portb.5 , Db6 = Portb.6 , Db7 = Portb.7 , E = Portb.2 , Rs = Portb.1
'Config Lcd = 16 * 2

Config Timer1 = Pwm , Pwm = 10 , Compare A Pwm = Clear Up , Compare B Pwm = Clear Up , Prescale = 8

Config Portc = Output

Sensor_left Alias Pind.0
Sensor_centre Alias Pind.1

In11 Alias Portc.0
In12 Alias Portc.1
In21 Alias Portc.2
In22 Alias Portc.3

Pwm1a = 0                                                   'right
Pwm1b = 0                                                   'left

Do

   If Sensor_left = 1 And Sensor_centre = 0 Then
      'Forward
      Pwm1a = 500
      Pwm1b = 1000

      Set In11
      Reset In12

      Reset In21
      Set In22
   Elseif Sensor_left = 0 And Sensor_centre = 0 Then
      'Move towards Wall
      Pwm1a = 1000
      Pwm1b = 500

      Set In11
      Reset In12

      Reset In21
      Reset In22
   Elseif Sensor_left = 1 And Sensor_centre = 1 Then
      ' Right
      Pwm1a = 1000
      Pwm1b = 1000
      Reset In11
      Set In12
      Reset In21
      Set In22
      Waitms 200

   End If
Loop