$regfile = "m16def.dat"
$crystal = 16000000

Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcd = 16 * 2

'Config Timer2 = Timer , Prescale = 1024
'On Timer2 Timer2_isr
'Enable Timer2


Config Int0 = Rising
Enable Interrupts
Enable Int0
On Int0 Intr Nosave
'Config Portd.2 = Input
Dim Count As Byte


Cls
Lcd "test lcd"
Wait 1
Cls

Do

   Locate 1 , 1
   Lcd Count

Loop


End

Intr:

   Incr Count

Return

Timer2_isr:


Return