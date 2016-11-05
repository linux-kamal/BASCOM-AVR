$regfile = "m8def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Db4 = Portc.2 , Db5 = Portc.3 , Db6 = Portc.4 , Db7 = Portc.5 , E = Portc.1 , Rs = Portc.0
Config Lcd = 16 * 2



Pump_off_led Alias Portd.2
Pump_on_led Alias Portd.3
Moisture_sensor Alias Pinb.0
Relay Alias Portb.1

Config Pump_off_led = Output
Config Pump_on_led = Output
Config Relay = Output

Cls
Lcd "SOLAR POWER AUTO"
Lowerline
Lcd "IRRIGATION SYSTM"
Wait 4
Cls

Do
   If Moisture_sensor = 1 Then

      'Set Pump_on_led
      'Reset Pump_off_led
      Locate 1 , 1
      Lcd "PUMP OFF"
      Reset Relay
      Wait 1
   Else
      'Reset Pump_on_led
      'Set Pump_off_led
      Locate 1 , 1
      Lcd "PUMP ON "
      Set Relay
      Wait 1
   End If

Loop

End