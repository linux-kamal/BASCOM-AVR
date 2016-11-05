' PORTD.4-----------> PWM CHANNEL --> EN1
' PORTD.5-----------> PWM CHANNEL --> EN2

' PORTC.2-----------> MOTOR CHANNEL
' PORTC.3-----------> MOTOR CHANNEL
' PORTC.4-----------> MOTOR CHANNEL
' PORTC.5-----------> MOTOR CHANNEL

$regfile = "m16def.dat"
$crystal = 16000000

Config Timer1 = Pwm , Pwm = 8 , Compare A Pwm = Clear Up , Compare B Pwm = Clear Down , Prescale = 1
Config Lcdpin = Pin , Rs = Portb.0 , E = Portb.1 , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5
Config Lcd = 16 * 2

Enable Compare1a
Enable Compare1b
Enable Interrupts

Config Portd = Output
Config Portc = Output

Dim Var As Byte
Var = 0
'Set Portd.4
'Set Portd.4

Cls
   Set Portc.2
   Reset Portc.3

   Set Portc.4
   Reset Portc.5
   Wait 1
Lcd "hello"
Wait 1
Cls
Do

   Pwm1a = Var
   Pwm1b = Var
   Incr Var
   If Var > 255 Then
      Var = 0
   End If
   Locate 1 , 1
   Lcd Var
   Wait 1 w

Loop

End