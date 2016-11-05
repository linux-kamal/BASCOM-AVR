$regfile = "m16def.dat"
$crystal = 16000000
$baud = 9600

Config Lcdpin = Pin , Db4 = Portc.3 , Db5 = Portc.2 , Db6 = Portc.1 , Db7 = Portc.0 , E = Portc.4 , Rs = Portc.5
Config Lcd = 20 * 4

Config Porta = Input


Do
   Print "PIN A.0 = " ; Pina.0
   Waitms 250
   Print "PIN A.1 = " ; Pina.1
   Waitms 250
Loop


'(
Cls
'Locate 1 , 4
'Lcd "hello"
Wait 2
Locate 2 , 5
Lcd "hello"
Lcd " hi"
Wait 2
Lcd " test"
Locate 3 , 2
Lcd "hello"
Wait 2
Locate 4 , 2
Lcd "hello"

Wait 3
Locate 2 , 8
Lcd "kamal"
Wait 3
Cls

')




Do
Loop