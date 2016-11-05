$regfile = "m16def.dat"
$crystal = 8000000

En2 Alias Portd.4
En1 Alias Portd.5

In11 Alias Portc.0
In12 Alias Portc.1

In21 Alias Portc.2
In22 Alias Portc.3

Config Portb = Input
Config Portc = Output
Config Portd = Output

Dim Flag As Bit
Flag = 0


Do

   If Pinb.0 = 0 And Pinb.1 = 0 And Pinb.2 = 1 And Pinb.3 = 0 Then
      ' 2 Forward
      Set En1
      Set En2
      Set In11
      Reset In12
      Set In21
      Reset In22

   Elseif Pinb.0 = 1 And Pinb.1 = 0 And Pinb.2 = 0 And Pinb.3 = 0 Then
      ' 8 Backward
      Set En1
      Set En2
      Reset In11
      Set In12
      Reset In21
      Set In22

   Elseif Pinb.0 = 0 And Pinb.1 = 1 And Pinb.2 = 0 And Pinb.3 = 0 Then
      ' 4 Left
      Set En1
      Set En2
      Set In11
      Reset In12
      Reset In21
      Set In22

   Elseif Pinb.0 = 0 And Pinb.1 = 1 And Pinb.2 = 1 And Pinb.3 = 0 Then
      ' 6 Right
      Set En1
      Set En2
      Reset In11
      Set In12
      Set In21
      Reset In22

   Elseif Pinb.0 = 0 And Pinb.1 = 1 And Pinb.2 = 0 And Pinb.3 = 1 Then
      ' 5 Start/Stop
      If Flag = 0 Then
         Reset En1
         Reset En2
         Flag = 1
      Else
         Flag = 0
         Set En1
         Set En2
      End If
   Else

      Reset En1
      Reset En2

   End If



Loop

End