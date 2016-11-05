
$regfile = "m16def.dat"
$crystal = 8000000
$baud = 9600

Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcd = 20 * 4

On Urxc Lable


Config Portc.6 = Output
Config Portc.7 = Output
Config Portd.6 = Output

Declare Sub Sendsms(mob As String , Buffer As String)
Declare Sub Readsms(byval Index As Byte)
Declare Sub Delsms()
Declare Sub Check_network()
Declare Sub Check_service_provider()

' ARRAY OF 5 MOBILE NUMBERS
Dim Mobile_number(5) As String * 13
Dim Send_sms_buffer As String * 20

Dim Msgbuffer As String * 100
Dim Smsbuffer As String * 50
Dim Getbyte As Byte
Dim Msgarray(150) As String * 1

Dim Main_byte As Byte
Dim Buffer As String * 200
Dim Gpsbuffer As String * 50
Dim Tempbuffer As String * 13


Dim Comma_flag1 As Word
Dim Comma_flag2 As Word
Dim Comma_flag3 As Word
Dim Main_flag As Word
Dim Ring_flag As Word
Dim Call_flag As Word
Dim Sms_flag As Word
Dim Coat_start As Word
Dim Coat_end As Word
Dim Double_coats As String * 1
Dim Carriage_return As String * 1
Dim Line_feed As String * 1
Dim Sms_index As Byte

Dim Once_send_flag As Bit
Dim No_career_flag As Word
Dim Sms_mobile_num_buff As String * 13

Dim Lcd_counter As Byte
Dim Index_counter As Byte
'Dim Lcd_20x4_line1_buff As String * 16
'Dim Lcd_20x4_line2_buff As String * 20
'Dim Lcd_20x4_line3_buff As String * 20


'Dim Recv_sms_lf_cr As Byte

'Mobile_number(1) = "+919997088674"
'Mobile_number(2) = "+918865814788"
'Mobile_number(3) = "+918006445238"
'Mobile_number(4) = "+917830688489"

Lcd_counter = 1
Index_counter = 1
Double_coats = Chr(34)
Carriage_return = Chr(13)
Line_feed = Chr(10)



' AT+CSMINS? TO CHECK WEATHER SIM INSETED OR NOT


'---------------------------- MAIN STARTS HERE ---------------------------------
Cursor Off
Cls
Locate 2 , 8
Lcd "GSM BASED"
Locate 3 , 1
Lcd "NOTICE BOARD DISPLAY"
Locate 4 , 1
Lcd "FOR COLLEGE/INSTITUTE"
Wait 5
Cls
Print "AT"

'(
Do
   Main_byte = Waitkey()
   If Chr(main_byte) = "O" Or Chr(main_byte) = "K"then
      Exit Do
   Elseif Chr(main_byte) = "A" Or Chr(main_byte) = "T"then
      Lcd "   NO MODEM   "
      Lowerline
      Lcd "   DETECTED   "
   End If
Loop
')

Print "ATE0" ; Chr(13) ; Chr(10)                            ' echo off
Waitms 100
Print "AT+CMGF =1" ; Chr(13) ; Chr(10)
Waitms 100

Call Check_network()
Waitms 100
Call Check_service_provider()
Waitms 100
Call Delsms()
Waitms 100
Print "AT+CNMI=2,1,0,0,0"
Waitms 100
Print "AT+CLIP=1"
Waitms 200

'Buffer = "hello"
'Call Sendsms(mobile_number(2) , Buffer )
'Buffer = ""
'Wait 1
'Call Sendsms( "+918865814788" , "with +91 again")
'Call Sendsms(mobile_number(4) , "hello")

Cls
'Array_counter = 1
'Local_array_counter = 0
Main_flag = 0
Once_send_flag = 0
'Recv_sms_lf_cr = 0

Enable Interrupts
Enable Urxc

Do

   'If Main_flag > 0 Or Sms_flag > 0 Then
   If Main_flag > 0 Then
      Locate 2 , 5
      Lcd "Calling...      "

      Delchars Tempbuffer , Double_coats
      Delchars Tempbuffer , Double_coats
      Delchars Tempbuffer , ","

      'Calling_number = Tempbuffer

      Locate 3 , 1
      Lcd Tempbuffer ; "   "
      'Call Sendsms( Tempbuffer, "hello")   'mobile num would be print again and again but send sms only once
      Buffer = ""
      Wait 2
      Cls
      Main_flag = 0

      'when no career detected then reset this flag

      If Once_send_flag = 0 Then
         Send_sms_buffer = ""
         Send_sms_buffer = "SYSTEM IS UP"
         'Call Sendsms(tempbuffer , Send_sms_buffer )
         Once_send_flag = 1
         Send_sms_buffer = ""
      End If

      'Else
      'Locate 1 , 1
      'Lcd "   WAITING FOR  "
      'Locate 2 , 1
      'Lcd "   CALL OR SMS   "


   End If

   If Sms_flag > 0 Then

      Locate 2 , 5
      Lcd "Got A SMS "
      Waitms 1000
      Locate 2 , 1
      Smsbuffer = ""
      Smsbuffer = Buffer
      Delchars Smsbuffer , Double_coats
      Delchars Smsbuffer , Double_coats
      Delchars Smsbuffer , ","
      Delchars Smsbuffer , Line_feed
      Delchars Smsbuffer , Carriage_return

      Lcd Smsbuffer ; "  "

      'Array_counter = 1
      Buffer = ""
      'Sms_flag = 0
      Sms_index = Val(smsbuffer)
      Smsbuffer = ""
      'Lcd Sms_index ; "   "
      'Wait 5
      'Cls

      Disable Interrupts
      Disable Urxc
      Call Readsms(sms_index)
      Enable Interrupts
      Enable Urxc
      Call Delsms()
   End If

Loop

End



Sub Check_network()
   Dim Network_byte As Byte
   Dim Network_count As Byte
   Dim Count As Byte

Tryagain:
   Count = 0
   Network_count = 1
   Print "AT+CREG?"

   For Network_count = 1 To 15

      Network_byte = Waitkey()
      If Chr(network_byte) = "," Then
         Count = 1
      Elseif Count = 1 Then
         Exit For
      End If
   Next Network_count
   'Lcd Chr(network_byte)
   Network_byte = Network_byte - 48                         '48 ASCII VALUE OF ZERO , doing this because SELECT CASE does not allow chr(temp_byte)
   Cls
   Select Case Network_byte
      Case 0 :
               Locate 2 , 5
               Lcd "Not Registered"
               Wait 1
               Goto Tryagain
      Case 1 :
               Locate 2 , 5
               Lcd "Registered Home"
               Locate 3 , 1
               Lcd "    Network"
               Wait 2
      Case 2 :
               Locate 2 , 5
               Lcd "Not Registered"
               Locate 3 , 1
               Lcd "Searching N/W"
               Wait 1
               Goto Tryagain
      Case 3 :
               Locate 2 , 5
               Lcd "Registration"
               Locate 3 , 1
               Lcd "   Denied"
               Wait 1
               Goto Tryagain
      Case 4 :
               Locate 2 , 5
               Lcd "Unknown"
               Wait 1
               Goto Tryagain
      Case 5 :
               Locate 2 , 5
               Lcd "Registered"
               Locate 3 , 1
               Lcd "Roaming"
               Wait 1
      Case Else :
               Locate 2 , 5
               Lcd "Unknown Result"
               Locate 3 , 1
               Lcd "Reset Processor"
               Do
                  'end less loop
               Loop
   End Select

End Sub

Sub Check_service_provider()
   Dim Operator_byte As Byte
   Dim Operator_count As Byte
   Dim Operator_flag As Bit
   Print "AT+CSPN?"
   Cls
   Locate 3 , 1
   Operator_flag = 0
   For Operator_count = 1 To 25
      Operator_byte = Waitkey()
      If Operator_byte = 34 Then
         Toggle Operator_flag
      Elseif Operator_flag = 1 Then
         Lcd Chr(operator_byte)
      End If
   Next Operator_count
   Wait 2
End Sub


Sub Sendsms(mob As String , Buffer As String)
   'Enter Text Mode
   Print "AT+CMGF=1" ; Chr(13) ; Chr(10)
   Waitms 200
   Cls
   Lcd "Sending SMS"
   Lowerline
   Lcd Mob
   Wait 1

   Print "AT+CMGS=" ; Chr(34) ; Mob ; Chr(34) ; Chr(13) ; Chr(10)
   Waitms 200

   'Print Buffer ; Chr(10) ; "Thanks" ; Chr(26)
   Print Buffer ; Chr(26)

   Lcd " SENT"
   Wait 2
   Buffer = ""
   Cls
End Sub

Sub Delsms()
   'Locate 2 , 5
   'Lcd "Deleting All SMS"
   Print "AT+CMGF=1" ; Chr(13) ; Chr(10)
   Waitms 200
   Print "AT+CMGDA=" ; Chr(34) ; "DEL ALL" ; Chr(34)
   Wait 1
   'Print "AT+CMGD=1"
   'Waitms 200
   'Locate 3 , 1
   'Lcd "All SMS Deleted"
   'Wait 1
   'Cls
End Sub


Sub Readsms(byval Index As Byte)

   Dim Flag As Byte
   Dim Var As Byte
   Dim I As Word
   Dim Lf As Byte , Cr As Byte
   Dim _min As Byte , _max As Byte , Count_quotes As Byte

   Lcd_counter = 1
   Index_counter = 1
   'If Recv_sms_lf_cr = 0 Then
   Lf = 1
   Cr = 1
   'Else
      'Lf = 0
      'Cr = 0
   'End If
   Count = 1
   Flag = 0
   Var = 0

   _min = 0
   _max = 0
   Count_quotes = 0
   Sms_mobile_num_buff = ""

   'Locate 2 , 5                                             'I was not resetting this flag again and again
   'Lcd "Reading SMS..."
   'Enter Text Mode
   Print "AT+CMGF=1" ; Chr(13) ; Chr(10)
   Waitms 200
   Locate 3 , 1
   Msgbuffer = ""

   Select Case Index

   Case 1 : Print "AT+CMGR=1" ; Chr(13) ; Chr(10)
   Case 2 : Print "AT+CMGR=2" ; Chr(13) ; Chr(10)
   Case 3 : Print "AT+CMGR=3" ; Chr(13) ; Chr(10)
   Case 4 : Print "AT+CMGR=4" ; Chr(13) ; Chr(10)
   Case 5 : Print "AT+CMGR=5" ; Chr(13) ; Chr(10)
   Case 6 : Print "AT+CMGR=6" ; Chr(13) ; Chr(10)
   Case 7 : Print "AT+CMGR=7" ; Chr(13) ; Chr(10)
   Case 8 : Print "AT+CMGR=8" ; Chr(13) ; Chr(10)
   Case 9 : Print "AT+CMGR=9" ; Chr(13) ; Chr(10)
   Case 10 : Print "AT+CMGR=10" ; Chr(13) ; Chr(10)
   Case 11 : Print "AT+CMGR=11" ; Chr(13) ; Chr(10)
   Case 12 : Print "AT+CMGR=12" ; Chr(13) ; Chr(10)
   Case 13 : Print "AT+CMGR=13" ; Chr(13) ; Chr(10)
   Case 14 : Print "AT+CMGR=14" ; Chr(13) ; Chr(10)
   Case 15 : Print "AT+CMGR=15" ; Chr(13) ; Chr(10)
   Case 16 : Print "AT+CMGR=16" ; Chr(13) ; Chr(10)
   Case 17 : Print "AT+CMGR=17" ; Chr(13) ; Chr(10)
   Case 18 : Print "AT+CMGR=18" ; Chr(13) ; Chr(10)
   Case 19 : Print "AT+CMGR=19" ; Chr(13) ; Chr(10)
   Case 20 : Print "AT+CMGR=20" ; Chr(13) ; Chr(10)
   Case 21 : Print "AT+CMGR=21" ; Chr(13) ; Chr(10)
   Case 22 : Print "AT+CMGR=22" ; Chr(13) ; Chr(10)
   Case 23 : Print "AT+CMGR=23" ; Chr(13) ; Chr(10)
   Case 24 : Print "AT+CMGR=24" ; Chr(13) ; Chr(10)
   Case 25 : Print "AT+CMGR=25" ; Chr(13) ; Chr(10)

   End Select

   Do
      If Flag > 0 Then
         Exit Do
      End If
      Getbyte = Waitkey()
      Msgarray(count) = Chr(getbyte)
      Msgbuffer = Msgbuffer + Chr(getbyte)
      Flag = Instr(msgbuffer , "OK")
      Incr Count
   Loop
   Cls
   'Lcd Count
   'Wait 2
   'Cls
   Msgbuffer = ""
   If Count > 10 Then

      For I = 0 To Count
         Var = Msgarray(i)
         If Var = 10 Then
            Incr Lf
         End If
         If Var = 13 Then
            Incr Cr
         End If

         If Lf >= 5 Then
            If Var = 13 Then
               Exit For
            End If
            If Var <> 10 Then

               Msgbuffer = Msgbuffer + Msgarray(i)


               If Lcd_counter <= 16 Then
                  Index_counter = Lcd_counter + 4
                  Locate 2 , Index_counter
               Elseif Lcd_counter > 16 And Lcd_counter <= 36 Then
                  Index_counter = Lcd_counter - 16
                  Locate 3 , Index_counter
               Elseif Lcd_counter > 36 Then
                  Index_counter = Lcd_counter - 36
                  Locate 4 , Index_counter
               End If
               Incr Lcd_counter

               Lcd Msgarray(i)

            End If
         End If
         '------------------ This segment will extract M NUM -------------------
         If Var = 34 Then
            Incr Count_quotes
            If Count_quotes = 3 Then
               _min = I                                     'To include +91 in mobile number
               _max = I + 14
            End If
         Else
            If I > _min And I < _max Then
               'Lcd Chr(var)
               Sms_mobile_num_buff = Sms_mobile_num_buff + Chr(var)
            End If
         End If
      Next I
   Else
      Msgbuffer = "OK"                                      'No sms at this location
   End If

   '----------------------------------------------------------------------------

   'Lcd_20x4_line1_counter = Len(msgbuffer)









   '----------------------------------------------------------------------------
   'Cls
   'Locate 2 , 5
   'Lcd Msgbuffer


   '(
   Locate 2 , 5
   Lcd "SENDER"
   Locate 3 , 1
   Lcd Sms_mobile_num_buff
   Wait 4
   Cls
')
   'Recv_sms_lf_cr = 1
   Sms_flag = 0
End Sub


Lable:

   Main_byte = Inkey()

'-------------------------------------------------------------------------------
   Buffer = Buffer + Chr(main_byte)

'-------------------------------------------------------------------------------
   Ring_flag = Instr(buffer , "RING")
   If Ring_flag > 0 Then
      Main_flag = 0
      Buffer = ""
      'Tempbuffer = ""
      Ring_flag = 0
      'Array_counter = 1
   End If
   Call_flag = Instr(buffer , "+CLIP: ")

   If Call_flag > 0 Then
      Buffer = ""
      'Tempbuffer = ""
      Call_flag = 0
      'Array_counter = 1
      Main_flag = 1
   End If

   Comma_flag1 = Instr(buffer , "+91")
   Comma_flag2 = Instr(buffer , ",")

   If Comma_flag1 > 0 Then
      If Comma_flag2 > 0 Then
         Tempbuffer = Buffer
         Buffer = ""
         Comma_flag1 = 0
         Comma_flag2 = 0
      End If
   End If

   No_career_flag = Instr(buffer , "NO CARRIER")
   If No_career_flag > 0 Then
      Once_send_flag = 0
      Main_flag = 0
      Buffer = ""
   End If
'-------------------------------------------------------------------------------
   'Sms_flag = Instr(buffer , "+CMTI:")
   Sms_flag = Instr(buffer , "SM")
   If Sms_flag > 0 Then
      Comma_flag3 = Instr(buffer , ",")
   End If
   If Comma_flag3 > 0 Then
   Buffer = ""
   Comma_flag3 = 0
   End If

Return