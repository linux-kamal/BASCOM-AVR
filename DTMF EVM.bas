$regfile = "m16def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Db4 = Portc.2 , Db5 = Portc.3 , Db6 = Portc.4 , Db7 = Portc.5 , E = Portc.1 , Rs = Portc.0
Config Lcd = 16 * 2

Config Portd = Output
Config Porta.3 = Output
Config Porta.0 = Input
Config Portb = Input

Dim E1 As Byte
Dim E2 As Byte
Dim E3 As Byte
Dim E4 As Byte
Dim E5 As Byte

Dim Ee1 As Eram Byte
Dim Ee2 As Eram Byte
Dim Ee3 As Eram Byte
Dim Ee4 As Eram Byte
Dim Ee5 As Eram Byte


Dim Password_count As Byte
Dim Password_match_count As Byte
Dim Pinb_var As Byte


Cls
Cursor Off
Lcd "TEST"
Set Porta.3
Password_count = 0
Pinb_var = 0
Password_match_count = 0
E1 = Ee1
E2 = Ee2
E3 = Ee3
E4 = Ee4
E5 = Ee5

Do

   Locate 1 , 1
   Lcd "   DTMF VOTING  "
   Locate 2 , 1
   Lcd "     MACHINE    "

   If Pinb.0 = 0 And Pinb.1 = 0 And Pinb.2 = 0 And Pinb.3 = 1 Then
      '1


      Incr E1
      Ee1 = E1
      Locate 1 , 1
      Lcd "  Thankyou for  "
      Locate 2 , 1
      Lcd "    Voting E1   "
      Reset Porta.3
      Portd.3 = 1
      Do
      Loop Until Pina.0 = 1

      If Pina.0 = 1 Then
         Do
         Loop Until Pina.0 = 0
      End If
      Set Porta.3
      Portd.3 = 0
      Cls
   Elseif Pinb.0 = 0 And Pinb.1 = 0 And Pinb.2 = 1 And Pinb.3 = 0 Then
      '2
      Incr E2
      Ee2 = E2
      Locate 1 , 1
      Lcd "  Thankyou for  "
      Locate 2 , 1
      Lcd "    Voting E2   "
      Reset Porta.3
      Portd.2 = 1
      Do
      Loop Until Pina.0 = 1

      If Pina.0 = 1 Then
         Do
         Loop Until Pina.0 = 0
      End If
      Set Porta.3
      Portd.2 = 0
      Cls

   Elseif Pinb.0 = 0 And Pinb.1 = 0 And Pinb.2 = 1 And Pinb.3 = 1 Then
      '3
      Incr E3
      Ee3 = E3
      Locate 1 , 1
      Lcd "  Thankyou for  "
      Locate 2 , 1
      Lcd "    Voting E3   "
      Reset Porta.3
      Portd.1 = 1
      Do
      Loop Until Pina.0 = 1

      If Pina.0 = 1 Then
         Do
         Loop Until Pina.0 = 0
      End If
      Set Porta.3
      Portd.1 = 0
      Cls

   Elseif Pinb.0 = 0 And Pinb.1 = 1 And Pinb.2 = 0 And Pinb.3 = 0 Then
      '4
      Incr E4
      Ee4 = E4
      Locate 1 , 1
      Lcd "  Thankyou for  "
      Locate 2 , 1
      Lcd "    Voting E4   "
      Reset Porta.3
      Portd.0 = 1
      Do
      Loop Until Pina.0 = 1

      If Pina.0 = 1 Then
         Do
         Loop Until Pina.0 = 0
      End If
      Set Porta.3
      Portd.0 = 0
      Cls

   Elseif Pinb.0 = 0 And Pinb.1 = 1 And Pinb.2 = 0 And Pinb.3 = 1 Then
      '5
      Incr E5
      Ee5 = E5
      Locate 1 , 1
      Lcd "  Thankyou for  "
      Locate 2 , 1
      Lcd "    Voting E5   "
      Reset Porta.3
      Portd.4 = 1
      Do
      Loop Until Pina.0 = 1

      If Pina.0 = 1 Then
         Do
         Loop Until Pina.0 = 0
      End If
      Set Porta.3
      Portd.4 = 0
      Cls

   End If

   If Pinb = 227 Then
      '#
      Locate 1 , 1
      Lcd " ENTER PASSWORD "
      Locate 2 , 1
      Lcd "                 "

      Password_match_count = 0
      Do
         Pinb_var = Pinb
         Do
         Loop Until Pinb_var <> Pinb
         Locate 2 , 1
         Pinb_var = Pinb
         Lcd Pinb_var ; "    " ; Password_match_count
         '3
         If Password_match_count = 0 And Pinb_var = 252 Then
            Incr Password_match_count
         End If
         '3
         If Password_match_count = 0 And Pinb_var = 236 Then
            Incr Password_match_count
         End If
         '2
         If Password_match_count = 1 And Pinb_var = 228 Then
            Incr Password_match_count
         End If
         '4
         If Password_match_count = 2 And Pinb_var = 226 Then
            Incr Password_match_count
         End If
         '1
         If Password_match_count = 3 And Pinb_var = 248 Then
            Incr Password_match_count
         End If
         '1
         If Password_match_count = 3 And Pinb_var = 232 Then
            Incr Password_match_count
         End If

         If Pinb = 253 Then
            Exit Do
         End If
      Loop



   If Password_match_count = 4 Then
      Cls
      Locate 1 , 1
      Lcd "ACCESS GRANTED "
      Password_match_count = 0
      Wait 2
      Locate 1 , 1
      Lcd "E1" ; " " ; "E2" ; " " ; "E3" ; " " ; "E4" ; " " ; "E5"
      Locate 2 , 1
      Lcd E1 ; "  " ; E2 ; "  " ; E3 ; "  " ; E4 ; "  " ; E5
      Wait 5
      E1 = 0
      E2 = 0
      E3 = 0
      E4 = 0
      E5 = 0
      Ee1 = E1
      Ee2 = E2
      Ee3 = E3
      Ee4 = E4
      Ee5 = E5

   Elseif Password_match_count < 4 Then
      Cls
      Locate 1 , 1
      Lcd " ACCESS DENIED "
      Password_match_count = 0
      Reset Porta.3
      Wait 3
      Set Porta.3

   End If
   End If

   Waitms 200


Loop