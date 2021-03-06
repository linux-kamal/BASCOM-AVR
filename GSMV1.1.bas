'===============================================================================
' Author :  Kamal Babu
' Date   :  03-07-14
' Purpose:  This code was intentionally written for GSM (SIM900) Modem testing.
'===============================================================================

$regfile = "m16def.dat"
$crystal = 16000000
$baud = 9600

Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcd = 16 * 2

'========================== Variables ==========================================
Dim Getbyte As Word
Dim Checkbyte As Byte
Dim Mobile_number As String * 10
Dim Msgbuffer As String * 100
Dim Msgarray(200) As String * 1
Dim I As Byte
Dim Flag As Bit
Dim Var As Byte

'Enter your mobile number here , this is mine.
Mobile_number = "8865814788"
'========================= Subroutines =========================================
Declare Sub Sendmsg()
Declare Sub Recvmsg()


'======================= Main Starts here ======================================
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

'Call Sendmsg()
'Wait 1
Call Recvmsg()




'Wait 2
Cls
Lcd "out of loop"
Wait 1
Cls

Flag = 0

For I = 0 To 150
   'If I = 111 Then
   'Lowerline
   'End If
   If Flag = 1 Then
      Lcd Msgarray(i)
   End If

   Var = Msgarray(i)
   ' Let's check when we get first Line Feed character.
   ' our msg will start from that location.
   If Var = 10 Then
      ' when controller get first Lf, set the flag bit so that controller can start reading msg content.
      Flag = 1
   End If




   'Lcd Var ; " "
Next I
'Lcd Msgbuffer
Do
' Implement timers or anything else to clear the lcd after a certain time
Loop

End


Sub Sendmsg()
   Lcd "Sending Msg ..."
   ' Enter Text Mode
   Print "AT+CMGF =1" ; Chr(13) ; Chr(10)
   Wait 1
   Lowerline
   Print "AT+CMGS=" ; Chr(34) ; Mobile_number ; Chr(34) ; Chr(13) ; Chr(10)
   Waitms 200
   Print "Message From GSM Modem" ; Chr(10) ; "Thanks" ; Chr(26)
   'Wait 1
End Sub

Sub Recvmsg()
   Dim Count As Word
   Dim Cr As Word
   Dim Lf As Word
   Count = 0

   Lcd "Receiving Msg ..."
   Lowerline
   'Enter Text Mode
   Print "AT+CMGF =1" ; Chr(13) ; Chr(10)
   Wait 1

   Print "AT+CMGR=1" ; Chr(13) ; Chr(10)
   'Waitms 200
   Cls
   Do
      If Count = 120 Then
         'Lowerline
         'Elseif Count = 30 Then
         Exit Do
      End If
      'Checkbyte = Ischarwaiting()
      'If Checkbyte = 1 Then
         Getbyte = Waitkey()
         Msgarray(count) = Chr(getbyte)
         Msgbuffer = Msgbuffer + Chr(getbyte)

         'Lcd Msgarray(count)
         Incr Count
      'End If
   Loop
End Sub