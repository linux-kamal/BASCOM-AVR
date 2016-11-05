$regfile = "m16def.dat"                                     'MCU WE ARE USING
$crystal = 8000000                                          'MCU RUNNING ON INTERNEL CRYSTAL @ 8MHZ
$baud = 9600

Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc

Open "comb.0:9600,8,n,1" For Output As #2

Dim Value As Word
Dim Val2 As Single


Do

   Value = Getadc(1)
   Val2 = Value * 4.9
   Val2 = Val2 / 1000

   Print #2 , Val2
   Waitms 500

Loop
