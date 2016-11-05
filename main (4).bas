$regfile = "m16def.dat"                                     'ATMEGA 32 MICROCONTROLLER
$crystal = 16000000

Config Lcdpin = Pin , Rs = Portb.0 , E = Portb.1 , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5       'LCD PIN DECLARATION
Config Lcd = 16 * 2
Config Adc = Single , Prescaler = Auto
Start Adc
Config Timer1 = Pwm , Pwm = 10 , Compare A Pwm = Clear Up , Prescale = 1 , Compare B Pwm = Clear Up
Enable Compare1a
Enable Compare1b

M11 Alias Portc.2
M12 Alias Portc.3
M21 Alias Portc.4
M22 Alias Portc.5

' right motor
Config M11 = Output
Config M12 = Output
'left motor
Config M21 = Output
Config M22 = Output

Dim Ls As Word , Cs As Word , Rs As Word
Declare Sub Forward(byval Lspeed As Word , Byval Rspeed As Word)
Declare Sub Backward(byval Lspeed As Word , Byval Rspeed As Word)
Declare Sub Lefty(byval Lspeed As Word , Byval Rspeed As Word)
Declare Sub Righty(byval Lspeed As Word , Byval Rspeed As Word)
Declare Sub Halt()

Cls

Do
   Rs = Getadc(0)
   Cs = Getadc(1)
   Ls = Getadc(2)
   Lcd Ls ; " " ; Cs ; " " ; Rs
   Waitms 300
   Cls
   If Cs >= 900 Then
      Call Forward(1000 , 800)
   Elseif Rs >= 900 Then
      Call Righty(1000 , 800)
   Elseif Ls >= 900 Then
      Call Lefty(1000 , 800)
   Else
      Lcd "Seeking for Light Source"
      Call Forward(1000 , 800)
      Wait 1
      Call Righty(1000 , 800)
      Wait 1
      Call Lefty(1000 , 800)
      Wait 1
      Call Backward(1000 , 800)
      Wait 1
      Cls
   End If

Loop

End

Sub Forward(byval Lspeed As Word , Byval Rspeed As Word)

   Pwm1a = Lspeed
   Pwm1b = Rspeed
   Set M11
   Reset M12
   Reset M21
   Set M22

End Sub

Sub Backward(byval Lspeed As Word , Byval Rspeed As Word)

   Pwm1a = Lspeed
   Pwm1b = Rspeed
   Reset M11
   Set M12
   Set M21
   Reset M22

End Sub

Sub Lefty(byval Lspeed As Word , Byval Rspeed As Word)
   Pwm1a = Lspeed
   Pwm1b = Rspeed
   Set M11
   Reset M12
   Set M21
   Reset M22

End Sub

Sub Righty(byval Lspeed As Word , Byval Rspeed As Word)
   Pwm1a = Lspeed
   Pwm1b = Rspeed
   Reset M11
   Set M12
   Reset M21
   Set M22

End Sub

Sub Halt()
   Pwm1a = 0
   Pwm1b = 0
End Sub