'===============================================================================
' Author :  Kamal Babu
' Date   :  03-07-14
' Purpose:  This code was intentionally written for GSM (SIM900) Modem testing.
'===============================================================================
' Points to remember while handling GSM ::: .
'
' don't use inkey statement you will miss some characters.
' so better to use waitkey.
' to extract msg content start seeking for Line Feed (10) your msg will start just
' after the line feed.

' Read the meg until you get first carrige return(13) after getting first line feed.

' --------------------------->>>>>>>>>>>>>>>>>>>
'when ever there is no msg the read count is less then and equal to 8

'AT+CREG? ------->>>>>>>> NETWORK REGISTRATION
'AT+COPN ------->>>>>>>> READ OPERATOR NAME
'AT+CSPN? ------->>>>>>>> GET SERVICE PROVIDER NAME


'now i have to extract the mobile number from received message so that
'i would we able to send and receive the messages from GSM modem to
'any number there would not be any boudation of predefined saved number, that you can
'send messages to only predefined number.
'i try to repl resposes to the same number.
'But I will comunicate at different baud rate with the modem so that no buddy
'would be able to steal my code , because his modem would be configured for 9600 baud rate mine for other.



$regfile = "m16def.dat"
$crystal = 16000000
$baud = 9600

Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcd = 16 * 2
Config Portc = Output

'========================== Variables ==========================================
Dim Getbyte As Word
Dim Mobile_number As String * 10
Dim Msgbuffer As String * 200
Dim Msgarray(200) As String * 1
Dim I As Byte
Dim Lf As Byte
Dim Cr As Byte
Dim Var As Byte
Dim Count As Word

Dim Network_byte As Byte
Dim Network_count As Byte

Dim Operator_byte As Byte
Dim Operator_count As Byte
Dim Operator_flag As Bit

Dim Do_loop_var As Byte , Do_loop_counter As Byte
Dim Do_loop_buffer As String * 50
Dim Do_loop_flag As Byte

'Enter your mobile number here , this is mine.
Mobile_number = "8865814788"
'========================= Subroutines =========================================

Declare Sub Sendmsg()
Declare Sub Recvmsg()
Declare Sub Delmsg()

'----------------------- Main Starts here --------------------------------------
Cls
Lcd "Gsm Sim 900"
Wait 2

Print "ATE0" ; Chr(13) ; Chr(10)                            ' echo off
Waitms 500
'---------------------- Deleting All Messages ----------------------------------
Call Delmsg()
'Print "AT"                                                  '; Chr(13) ; Chr(10)
'Wait 1

'------------------- Check SIM Card Registration -------------------------------

Try_agian:                                                  ' Lable to jump again and again until SIM card does't register
Print "AT+CREG?"
'Wait 1
For Network_count = 1 To 15
   Network_byte = Waitkey()
   'If Temp_count = 15 Then
      'Lcd Chr(temp_byte)
   'End If
Next Network_count
Network_byte = Network_byte - 48                            '48 ASCII VALUE OF ZERO , doing this because SELECT CASE does not allow chr(temp_byte)
Cls
Select Case Network_byte
   Case 0 :
            Lcd "Not Registered"
   Case 1 :
            Lcd "Registered Home"
            Lowerline
            Lcd "    Network"
   Case 2 :
            Lcd "Not Registered"
            Lowerline
            Lcd "Searching N/W"
            Wait 2
   Case 3 :
            Lcd "Registration"
            Lowerline
            Lcd "   Denied"
   Case 4 :
            Lcd "Unknown"
   Case 5 :
            Lcd "Registered"
            Lowerline
            Lcd "Roaming"
   Case Else :
            Lcd "Unknown Result"
            Lowerline
            Lcd "Reset Processor"

End Select
If Network_byte = 2 Then
   Goto Try_agian
End If
Wait 5

'------------------------ Check Operator Name ----------------------------------

Print "AT+CSPN?"
Cls
Operator_flag = 0
For Operator_count = 1 To 25
   Operator_byte = Waitkey()
   If Operator_byte = 34 Then
      Toggle Operator_flag
   Elseif Operator_flag = 1 Then
      Lcd Chr(operator_byte)
   End If
Next Operator_count
Wait 1

'--------------------------- Enter Text Mode -----------------------------------

Print "AT+CMGF =1" ; Chr(13) ; Chr(10)
Wait 1

'------------------------ Give Message Indication ------------------------------
Do_loop_counter = 1
'Print "AT+CNMI=2,1,0,0,0"

Wait 2
'(
Cls
Do
   Do_loop_var = Waitkey()
   If Do_loop_counter > 5 And Do_loop_counter < 8 Then
      Lcd Chr(do_loop_var)
   End If
   Incr Do_loop_counter
Loop Until Do_loop_counter = 9
')
'Call Sendmsg()
'Wait 1
'Call Delmsg()
'----------------------- Do Loop starts here -----------------------------------
Do_loop_counter = 0
Cls
Do
  '(
   Do_loop_var = Waitkey()
   'Cls
   If Do_loop_counter = 11 Then
      Lowerline
   End If
   Incr Do_loop_counter
   Lcd Chr(do_loop_var)
   Do_loop_buffer = Do_loop_buffer + Chr(do_loop_var)
   Do_loop_flag = Instr(do_loop_buffer , ",")

')
   'If Do_loop_flag > 0 Then
      Do_loop_flag = 0
      Do_loop_buffer = ""
      Wait 5
      Cls
      Lcd "      Huhh!"
      Lowerline
      Lcd "  Got a Message"

      Call Recvmsg()
      'Waitms 300
      'Call Delmsg()
      'Waitms 300
      Cls
      Lcd "out of loop"
      Wait 10
      Cls
      Lf = 0
      Msgbuffer = ""

      If Count > 10 Then                                    'till 8 we are getting into this condition
         For I = 0 To Count
            Var = Msgarray(i)
            'some times msg is not getting read properly so delete msg only when we read msg correctly

            If Lf >= 3 Then
               If Var = 13 Then
                  Exit For
               End If
               'Lcd Msgarray(i)
               Msgbuffer = Msgbuffer + Msgarray(i)
            End If
            If Var = 10 Then
               Incr Lf
            End If
         Next I
      Else
      Msgbuffer = ""
      Msgbuffer = "OK"
   End If
   'Lowerline
   'Lcd Count
   Lcd Msgbuffer

   If Msgbuffer = "Led on" Then
      Portc = 255
      Call Delmsg()
   Elseif Msgbuffer = "Led off" Then
      Portc = 0
      Call Delmsg()
   Else
      Call Delmsg()
   End If

   Wait 3

'End If

Loop

'----------------------- Do Loop ends here -------------------------------------

End

'------------------------ Main Ends here ---------------------------------------
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
'                     Subroutines Definitions
'-------------------------------------------------------------------------------


'------------------------- SEND Messages ---------------------------------------
Sub Sendmsg()
   Cls
   Lcd "Sending Msg..."
   ' Enter Text Mode
   Print "AT+CMGF=1" ; Chr(13) ; Chr(10)
   Wait 1

   Print "AT+CMGS=" ; Chr(34) ; Mobile_number ; Chr(34) ; Chr(13) ; Chr(10)
   Waitms 200

   Print "Message From GSM Modem" ; Chr(10) ; "Thanks" ; Chr(26)
   Lowerline
   Lcd "message sent"
   Wait 1
End Sub

'------------------------- READ Messages ---------------------------------------
Sub Recvmsg()
   Dim Flag As Byte
   Count = 0
   Flag = 0
   Cls                                                      'I was not resetting this flag again and again
   Lcd "Receiving Msg ..."
   Lowerline
   Msgbuffer = " "
   Print "AT+CMGR=1" ; Chr(13) ; Chr(10)

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

End Sub

'------------------------- Delete Message --------------------------------------
Sub Delmsg()
   Cls
   Lcd "Deleting All Msgs ..."
   'Print "AT+CMGDA=" ; Chr(34) ; "DEL ALL" ; Chr(34)
   'Wait 1
   Print "AT+CMGD=1"
   Waitms 200
   Lowerline
   Lcd "All Msg Deleted ..."
   Wait 1
End Sub