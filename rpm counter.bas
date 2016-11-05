$regfile = "m16def.dat"
$crystal = 16000000

Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcd = 16 * 2

Config Timer1 = Pwm , Pwm = 10 , Compare A Pwm = Clear Up , Prescale = 1 , Compare B Pwm = Clear Up
Enable Compare1a
Enable Compare1b

'Config Timer2 = Timer , Prescale = 1024
'On Timer2 Timer2_isr
'Enable Timer2


'Config Int0 = Falling
'Enable Interrupts
'Enable Int0
'On Int0 Intr Nosave


M11 Alias Portc.2
M12 Alias Portc.3
M21 Alias Portc.4
M22 Alias Portc.5

En1 Alias Portd.4
En2 Alias Portd.5

Config En1 = Output
Config En2 = Output
' right motor
Config M11 = Output
Config M12 = Output
'left motor
Config M21 = Output
Config M22 = Output

'Config Portd.2 = Input

Dim Count As Byte
Dim Tim2_count As Byte
Dim Speed As Word
Count = 0
Tim2_count = 0
Speed = 400
'Set En1
'Set En2
Pwm1a = 0
Pwm1b = 0

Set M11
Set M21
Cls
Lcd "test lcd"
Wait 2
Cls


Do

   If Pina.7 = 1 Then
      While Pina.7 = 1
      Wend
      Speed = Speed + 5
      Locate 1 , 1
      Lcd Speed
   End If
   If Pina.6 = 1 Then
      While Pina.6 = 1
      Wend
      Speed = Speed - 5
      Locate 1 , 1
      Lcd Speed
   End If
   Pwm1a = Speed
   Pwm1b = Speed
Loop

End

Intr:

   Incr Count

Return

Timer2_isr:
   Incr Tim2_count
   If Tim2_count = 6 Then
      Tim2_count = 0
      Locate 1 , 1
      Tim2_count = Count * 60
      Lcd Tim2_count
      Count = 0
   End If
Return