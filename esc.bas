$regfile = "m16def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Db4 = Porta.2 , Db5 = Porta.3 , Db6 = Porta.4 , Db7 = Porta.5 , E = Porta.1 , Rs = Porta.0
Config Lcd = 16 * 2


Config Servos = 1 , Servo1 = Portb.5 , Reload = 10
Config Portb = Output
Enable Interrupts
Servo(1) = 10
Config Portd.7 = Output

Cls

Lcd "hello"
Wait 2
Cls

Dim I As Word

I = 0
Portd.7 = 0
Do

   If I >= 175 Then
      I = 0
      Cls
      Lcd "START FROM 0 AGAIN"
      Wait 1
      Portd.7 = 1
      Wait 5
      Portd.7 = 0
      Wait 1
      Cls
   End If

  Servo(1) = I

  Locate 1 , 4
  Lcd I ; "  "
  I = I + 5
  Wait 1

Loop
