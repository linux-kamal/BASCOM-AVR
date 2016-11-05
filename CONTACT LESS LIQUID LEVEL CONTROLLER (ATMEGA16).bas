
$regfile = "m16def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcd = 16 * 2

Config Timer1 = Timer , Prescale = 8

Enable Interrupts

_echo Alias Pinc.1
_trigger Alias Portc.2


Config _trigger = Output
Config _echo = Input

Dim Temp As Word
Dim Cm_distance As Word
Dim Inch_distance As Word
'-------------------------------- Variables Initialization ---------------------
Temp = 0
Cm_distance = 0
Inch_distance = 0
'-------------------------------------------------------------------------------
Cls
Do

   Set _trigger
   Waitus 10
   Reset _trigger
   'Cls
   'Lcd "waiting for high edge"
   Bitwait _echo , Set
   Timer1 = 0
   Start Timer1

   Bitwait _echo , Reset
   Stop Timer1
   Temp = Timer1

   Temp = Temp / 58

   Locate 1 , 1
   Lcd Temp ; " CM"
   Waitms 300

Loop

End
'-------------------------------------------------------------------------------