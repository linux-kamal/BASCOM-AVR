$regfile = "m16def.dat"
$crystal = 8000000

'====================== All Neccessary Configurations ===============
Config Lcdpin = Pin , Rs = Portb.0 , E = Portb.1 , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5
Config Lcd = 16 * 2


' echo
Config Portd.2 = Input
Config Porta.6 = Output






Do

   if pind.2=0 then
   Porta.6 = 1

   'Waitms 300
   Porta.6 = 0
   'Waitms 300


Loop

