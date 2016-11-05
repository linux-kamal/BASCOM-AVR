$regfile = "m16def.dat"
$crystal = 8000000
$baud = 9600

Config Lcdpin = Pin , Rs = Portb.5 , E = Portb.4 , Db4 = Portb.3 , Db5 = Portb.2 , Db6 = Portb.1 , Db7 = Portb.0
Config Lcd = 16 * 2


Dim Recv As Byte
Cls

Wait 1
Print "ATE1" ; Chr(13) ; Chr(10);
Do

   Recv = Waitkey()
   Lcd Chr(recv)

Loop
Wait 2

Print "AT+CIOBAUD=9600" ; Chr(13) ; Chr(10);

Do


Loop