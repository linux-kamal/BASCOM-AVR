'(
   Vp =(V sec rms x 1.414) - 1.4 V
   Vp=(120x1.414)-1.4V
   Vp = 168.28 V

   From the equation

   Vdc av = 2 Vp/pi
   Vdc av = 2 308.28 Vp/pi
   Vdc Av = 98.12 V
')

$regfile = "m16def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcd = 16 * 2

Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc

Dim Adc_reading As Word

Cls
Lcd "HELLO"
Wait 5
Cls



Do

   Adc_reading = Getadc(0)
   Cls
   Lcd Adc_reading
   Waitms 500

Loop