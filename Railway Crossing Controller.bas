$regfile = "m16def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Db4 = Porta.2 , Db5 = Porta.3 , Db6 = Porta.4 , Db7 = Porta.5 , E = Porta.1 , Rs = Porta.0
Config Lcd = 16 * 2

Sensor1 Alias Pinb.0
Sensor2 Alias Pind.0

Config Portd.3 = Output                                     'led
Config Portd.5 = Output                                     'led

Config Portd.6 = Output                                     'relay
Config Portd.7 = Output                                     'relay

Config Portc.0 = Output                                     'buzzer

Display On
Cursor Blink
Cls
Lcd "Railway Crossing"
Lowerline
Lcd "Controller  2016"
Wait 5
Cls
Set Portc.0
Do

   Locate 1 , 1
   Lcd "Barrier Opened"

   If Sensor1 = 1 Then
      Locate 1 , 1
      Lcd "Barrier Closed"
      Locate 2 , 1
      Lcd "Train Arrived"

      Reset Portc.0                                         'buzzer on
      Set Portd.3                                           'red led on
      Reset Portd.5                                         'green led off
      While Sensor1 = 1
      Wend
      Set Portc.0                                           'buzzer off
      '----CLOSE BARRIER---------
      Set Portd.6
      Reset Portd.7
      Waitms 80
      Reset Portd.6
      Reset Portd.7
      '-------------
      Do
         If Sensor2 = 1 Then Exit Do
      Loop

      While Sensor2 = 1

      Wend
      '----OPEN BARRIER---------
      Locate 1 , 1
      Lcd "Barrier Opened"
      Locate 2 , 1
      Lcd "Train Passed "
      Reset Portd.6
      Set Portd.7
      Waitms 80
      Reset Portd.6
      Reset Portd.7
      '-------------
      Reset Portd.3                                         'red led off
      Set Portd.5                                           'green led on
      Wait 1
   End If


   If Sensor2 = 1 Then
      Locate 1 , 1
      Lcd "Barrier Closed"
      Locate 2 , 1
      Lcd "Train Arrived"
      Reset Portc.0
      While Sensor2 = 1
      Wend
      Set Portc.0
      Set Portd.3                                           'red led on
      Reset Portd.5                                         'green led off
      '----CLOSE BARRIER---------
      Set Portd.6
      Reset Portd.7
      Waitms 80
      Reset Portd.6
      Reset Portd.7
      '-------------
      Do
         If Sensor1 = 1 Then Exit Do
      Loop
      While Sensor1 = 1
      Wend
      '----OPEN BARRIER---------
      Locate 1 , 1
      Lcd "Barrier Opened"
      Locate 2 , 1
      Lcd "Train Passed "
      Reset Portd.6
      Set Portd.7
      Waitms 80
      Reset Portd.6
      Reset Portd.7
      Reset Portd.3                                         'red led off
      Set Portd.5
      Wait 1                                                'green led on
      '-------------
   End If
   Waitms 100
Loop