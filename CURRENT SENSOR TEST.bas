$regfile = "m16def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Db4 = Portc.3 , Db5 = Portc.2 , Db6 = Portc.1 , Db7 = Portc.0 , E = Portc.4 , Rs = Portc.5
Config Lcd = 16 * 2
Config Adc = Single , Prescaler = Auto
Start Adc

Dim Value As Word

Do
   Value = Getadc(0)
   Cls
   Lcd "ADC:" ; Value
   Wait 1

Loop