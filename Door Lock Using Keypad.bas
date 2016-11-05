$regfile = "m16def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcd = 16 * 2

Config Portd.0 = Output
Config Portd.2 = Output

Config Porta.0 = Output
Config Porta.1 = Output


Dim Count As Byte
Count = 0

Dim Password_1 As String * 5
Dim Password_2 As String * 5

Password_1 = "98371"
Password_2 = "89792"

Dim Buffer As String * 5
Buffer = ""

Cls
Lcd "Door lock System"
Wait 3
Cls

Portc.3 = 1
Portc.5 = 1
Portc.7 = 1
Portc.2 = 1
Portc.4 = 1
Portc.6 = 1
Portc.1 = 1
Portd.7 = 1
Portd.5 = 1
Portc.0 = 1
Portd.4 = 1
Portd.6 = 1

Do
   Locate 1 , 1
   Lcd " Enter Password "


   If Pinc.3 = 0 Then
      Count = Count + 1
      Locate 2 , Count
      Lcd "1"
      While Pinc.3 = 0
      Wend
      Buffer = Buffer + "1"
   Elseif Pinc.5 = 0 Then
      Count = Count + 1
      Locate 2 , Count
      Lcd "2"
      While Pinc.5 = 0
      Wend
      Buffer = Buffer + "2"
   Elseif Pinc.7 = 0 Then
      Count = Count + 1
      Locate 2 , Count
      Lcd "3"
      While Pinc.7 = 0
      Wend
      Buffer = Buffer + "3"
   Elseif Pinc.2 = 0 Then
      Count = Count + 1
      Locate 2 , Count
      Lcd "4"
      While Pinc.2 = 0
      Wend
      Buffer = Buffer + "4"
   Elseif Pinc.4 = 0 Then
      Count = Count + 1
      Locate 2 , Count
      Lcd "5"
      While Pinc.4 = 0
      Wend
      Buffer = Buffer + "5"
   Elseif Pinc.6 = 0 Then
      Count = Count + 1
      Locate 2 , Count
      Lcd "6"
      While Pinc.6 = 0
      Wend
      Buffer = Buffer + "6"
   Elseif Pinc.1 = 0 Then
      Count = Count + 1
      Locate 2 , Count
      Lcd "7"
      While Pinc.1 = 0
      Wend
      Buffer = Buffer + "7"
   Elseif Pind.7 = 0 Then
      Count = Count + 1
      Locate 2 , Count
      Lcd "8"
      While Pind.7 = 0
      Wend
      Buffer = Buffer + "8"
   Elseif Pind.5 = 0 Then
      Count = Count + 1
      Locate 2 , Count
      Lcd "9"
      While Pind.5 = 0
      Wend
      Buffer = Buffer + "9"
   Elseif Pinc.0 = 0 Then
      Count = Count + 1
      Locate 2 , Count
      Lcd "*"
      While Pinc.0 = 0
      Wend
      Buffer = Buffer + "*"
   Elseif Pind.4 = 0 Then
      Count = Count + 1
      Locate 2 , Count
      Lcd "0"
      While Pind.4 = 0
      Wend
      Buffer = Buffer + "0"
   Elseif Pind.6 = 0 Then
      Count = Count + 1
      Locate 2 , Count
      Lcd "#"
      While Pind.6 = 0
      Wend
      Buffer = Buffer + "#"
   End If


   If Count = 5 Then

      Cls
      If Buffer = Password_1 Or Buffer = Password_2 Then
         Lcd " Password Match "
         Lowerline
         Lcd "     Found      "
         Reset Portd.0
         Set Portd.2
         '----------------
            Set Porta.0
            Reset Porta.1
            Waitms 50
            Reset Porta.0
            Reset Porta.1
         '----------------
         Wait 4
         Reset Portd.2
         Reset Portd.0
         '----------------
            Reset Porta.0
            Set Porta.1
            Waitms 50
            Reset Porta.0
            Reset Porta.1
         '----------------

      Else
         Lcd Buffer
         Lowerline
         Lcd "Try Again"
         Reset Portd.2
         Set Portd.0
         Wait 4
         Reset Portd.2
         Reset Portd.0
      End If


      Cls
      Count = 0
      Buffer = ""
   End If
   Waitms 400
Loop