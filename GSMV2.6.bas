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

'Enter your mobile number here , this is mine.
Mobile_number = "8865814788"
'========================= Subroutines =========================================

Declare Sub Sendmsg()
Declare Sub Recvmsg()
Declare Sub Delmsg()

'----------------------- Main Starts here --------------------------------------
Cls
Lcd "Gsm Sim 900"
Wait 1
Cls
' echo off
Print "ATE0" ; Chr(13) ; Chr(10)
Wait 1
Print "AT"                                                  '; Chr(13) ; Chr(10)
Wait 1
Print "AT+CREG?"
Wait 1
'Enter Text Mode
Print "AT+CMGF =1" ; Chr(13) ; Chr(10)
Wait 1

'Call Sendmsg()
'Wait 1
'Call Delmsg()
Print "AT+CMGDA=" ; Chr(34) ; "DEL ALL" ; Chr(34)
Wait 2

'----------------------- Do Loop starts here -----------------------------------
Do
   Call Recvmsg()

   Lf = 0
   Msgbuffer = ""

   If Count > 10 Then                                       'till 8 we are getting into this condition
      For I = 0 To Count
         Var = Msgarray(i)
         ' some times msg is not getting read properly so delete msg only when we read msg correctly

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

   If Msgbuffer = "OK" Then
      Locate 1 , 4
      Lcd "Waiting For"
      Locate 2 , 6
      Lcd "Message"

   Else
      Cls
      Lcd Msgbuffer
      If Msgbuffer = "Led on" Then
         Portc = 255
         Lowerline
         'Lcd Msgbuffer
      Elseif Msgbuffer = "Led off" Then
         Portc = 0
         Lowerline
         'Lcd Msgbuffer
      End If
      Wait 3
      Call Delmsg()
   End If
   Wait 2
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
   Print "AT+CMGF =1" ; Chr(13) ; Chr(10)
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
   'Cls                                                      'I was not resetting this flag again and again
   'Lcd "Receiving Msg ..."
   'Lowerline
   Print "AT+CMGR=1" ; Chr(13) ; Chr(10)
   Msgbuffer = " "
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
   Lcd "Deleting Msg ..."
   Print "AT+CMGD=1"
   'Print "AT+CMGDA=" ; Chr(34) ; "DEL ALL" ; Chr(34)
   Waitms 500
   Lowerline
   Lcd "Msg Deleted ..."
   Wait 1
   Cls
End Sub