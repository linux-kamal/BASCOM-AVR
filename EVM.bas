$regfile = "m16def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Rs = Portb.0 , E = Portb.1 , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5
Config Lcd = 16 * 2


Led1 Alias Portc.3
Led2 Alias Portc.4
Led3 Alias Portc.5
Led4 Alias Portc.6
Led5 Alias Portc.7


Buzzer Alias Portc.1

Button1 Alias Pina.0
Button2 Alias Pina.1
Button3 Alias Pina.2
Button4 Alias Pina.3
Button5 Alias Pina.4

Result Alias Pina.6
Init Alias Pina.7

Config Led1 = Output
Config Led2 = Output
Config Led3 = Output
Config Led4 = Output
Config Led5 = Output
Config Buzzer = Output

Config Porta = Input
Config Portd = Input

Dim E1 As Word , E2 As Word , E3 As Word , E4 As Word , E5 As Word
Dim Result_array(5) As Word
Dim Winner As Word
Dim Index As Word
Dim Password_1 As String * 5
Dim Password_2 As String * 5
Dim Buffer As String * 5
Dim Count As Byte
Buffer = ""

Password_1 = "25316"
Password_2 = "15974"

Winner = 0
E1 = 0
E2 = 0
E3 = 0
E4 = 0
E5 = 0

Cls
Porta = 255
Portd = 255
Portc.0 = 1
Reset Buzzer
Display On
Cursor Off
Lcd "ELECTRONIC VOTING"
Lowerline
Lcd "  MACHINE 2016  "
Wait 3
Cls
Do
   Locate 1 , 1
   Lcd "  Press Button  "

   If Button1 = 0 Then
      Incr E1
      Set Led1
      Set Buzzer
      Cls
      Lcd "Vote For E1"
      While Init = 1
      Wend
      Cls

   Elseif Button2 = 0 Then
      Incr E2
      Set Led2
      Set Buzzer
      Cls
      Lcd "Vote For E2"
      While Init = 1
      Wend
      Cls
   Elseif Button3 = 0 Then
      Incr E3
      Set Led3
      Set Buzzer
      Cls
      Lcd "Vote For E3"
      While Init = 1
      Wend
      Cls
   Elseif Button4 = 0 Then
      Incr E4
      Set Led4
      Set Buzzer
      Cls
      Lcd "Vote For E4"
      While Init = 1
      Wend
      Cls
   Elseif Button5 = 0 Then
      Incr E5
      Set Led5
      Set Buzzer
      Cls
      Lcd "Vote For E5"
      While Init = 1
      Wend
      Cls
   Else
      Reset Led1
      Reset Led2
      Reset Led3
      Reset Led4
      Reset Led5
      Reset Buzzer
   End If

'----------------- SEE RESULT ----------------------------------
   If Result = 0 Then

      Cls
      While Result = 0
      Wend
      Do
      Locate 1 , 1
      Lcd "ENTER PASSWORD"

      If Pind.0 = 0 Then
      Count = Count + 1
      Locate 2 , Count
      Lcd "1"
      While Pind.0 = 0
      Wend
      Buffer = Buffer + "1"
   Elseif Pind.2 = 0 Then
      Count = Count + 1
      Locate 2 , Count
      Lcd "2"
      While Pind.2 = 0
      Wend
      Buffer = Buffer + "2"
   Elseif Pind.4 = 0 Then
      Count = Count + 1
      Locate 2 , Count
      Lcd "3"
      While Pind.4 = 0
      Wend
      Buffer = Buffer + "3"
   Elseif Pind.1 = 0 Then
      Count = Count + 1
      Locate 2 , Count
      Lcd "4"
      While Pind.1 = 0
      Wend
      Buffer = Buffer + "4"
   Elseif Pind.3 = 0 Then
      Count = Count + 1
      Locate 2 , Count
      Lcd "5"
      While Pind.3 = 0
      Wend
      Buffer = Buffer + "5"
   Elseif Pind.5 = 0 Then
      Count = Count + 1
      Locate 2 , Count
      Lcd "6"
      While Pind.5 = 0
      Wend
      Buffer = Buffer + "6"
   Elseif Pinc.0 = 0 Then
      Count = Count + 1
      Locate 2 , Count
      Lcd "7"
      While Pinc.0 = 0
      Wend
      Buffer = Buffer + "7"
   Elseif Pind.7 = 0 Then
      Count = Count + 1
      Locate 2 , Count
      Lcd "8"
      While Pind.7 = 0
      Wend
      Buffer = Buffer + "8"
   Elseif Pind.6 = 0 Then
      Count = Count + 1
      Locate 2 , Count
      Lcd "9"
      While Pind.6 = 0
      Wend
      Buffer = Buffer + "9"
   End If

   If Count = 5 Then
      Cls
      If Buffer = Password_1 Or Buffer = Password_2 Then
         Lcd " Password Match "
         Lowerline
         Lcd "     Found      "
         Wait 2
         Cls
         Count = 0
         Buffer = ""
         Exit Do
      Else

         Lcd Buffer
         Lowerline
         Lcd "Try Again"
         Wait 3
         Cls
         Count = 0
         Buffer = ""
      End If

   End If
Waitms 200
Loop

      Result_array(1) = E1
      Result_array(2) = E2
      Result_array(3) = E3
      Result_array(4) = E4
      Result_array(5) = E5

      Max(result_array(1) , Winner , Index)

      Cls

      If E1 = E2 And E2 = E3 And E3 = E4 And E4 = E5 Then
         Lcd "No winner"
      Else
         Lcd "Winner Is :->>>"
         Lowerline
         Lcd "E" ; Index ; " Vote Count=" ; Winner
         E1 = 0
         E2 = 0
         E3 = 0
         E4 = 0
         E5 = 0
      End If
      Wait 5
      Cls
   End If
   Waitms 100
Loop

End