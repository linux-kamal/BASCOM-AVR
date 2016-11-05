$regfile = "m16def.dat"
$crystal = 8000000
$baud = 9600
'----------------------------------------------------------------------------------------------------------------
Config Lcdpin = Pin , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7 , E = Porta.1 , Rs = Porta.0
Config Lcd = 16 * 2

Dim Recv As Byte

On Urxc Lable
Enable Interrupts
Enable Urxc
Cls


Lcd "HELLO"
Wait 1
Cls

Do

   NOP
Loop

Lable:


   Recv = Inkey()

   Lcd Recv


Return
