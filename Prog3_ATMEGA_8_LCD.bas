$regfile = "m8def.dat"
$crystal = 8000000

Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc

Config Lcdpin = Pin , Db4 = Portb.0 , Db5 = Portb.1 , Db6 = Portb.2 , Db7 = Portb.3 , E = Portb.7 , Rs = Portb.6
Config Lcd = 16 * 2

Cls
Display On
Cursor Blink
Lcd "hello"

Do

   nop





Loop

