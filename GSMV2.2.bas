'===============================================================================
' Author :  Kamal Babu
' Date   :  03-07-14
' Purpose:  This code was intentionally written for GSM (SIM900) Modem testing.
'===============================================================================
' Points to remember while handling GSM ::: .
' Extracting your msg from the received string is not a easy task.
' to do so first of all get whole string in a array.
' don't use inkey statement you will miss some characters.
' so better to use waitkey.
' to extract msg content start seeking for Line Feed (10) your msg will start just
' after the line feed.

' Read the meg until you get first carrige return(13) after getting first line feed.

$regfile = "m16def.dat"
$crystal = 16000000
$baud = 9600

Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcd = 16 * 2
'Config Timer0 = Timer , Prescale = 1
'On Ovf0 Timer0_isr
'Enable Timer0
'Enable Interrupts

'Stop Timer0

'========================== Variables ==========================================
Dim Getbyte As Word
Dim Checkbyte As Byte
Dim Mobile_number As String * 10
Dim Msgbuffer As String * 250
Dim Msgarray(200) As String * 1
Dim I As Byte
Dim Lf As Byte
Dim Cr As Byte
Dim Var As Byte
Dim Okbuff As String * 2
Dim Nomsg As Byte
Dim Timeout As Word
Timeout = 0
'Enter your mobile number here , it's mine.
Mobile_number = "8865814788"                                'mobile number here
'========================= Subroutines =========================================
Declare Sub Sendmsg()
Declare Sub Recvmsg()
Declare Sub Delmsg()

'======================= Main Starts here ======================================

'Cls
'Lcd "Sim 900 Reset"
'Wait 1
Cls
Lcd "Initializing"
Lowerline
Lcd "Modem"
'echo off
Print "ATE0" ; Chr(13) ; Chr(10)
Wait 1
Print "AT"                                                  '; Chr(13) ; Chr(10)
Wait 1
Print "AT+CREG?"
Wait 1
Cls
Lcd "Initialization"
Lowerline
Lcd "Done"
'Call Sendmsg()
'Wait 1
'Call Delmsg()
Do

   Call Recvmsg()
   Wait 1
   'Call Delmsg()

   'Cls
   'Lcd "out of loop"
   'Wait 1

   Lf = 0
   For I = 0 To Nomsg
      Var = Msgarray(i)
      If Lf > 3 Then
         If Var = 13 Then
            Exit For
         End If
         Cls
         Lcd Msgarray(i)
         Msgbuffer = Msgbuffer + Msgarray(i)
      End If
   ' Let's check when we get first Line Feed character.
   ' our msg will start from that location.
   If Var = 10 Then
      'when controller get first Lf, set the flag bit so that controller can start reading msg content.
      Incr Lf
   End If
   Next I

   Wait 2

   If Nomsg < 7 Then
      Msgbuffer = ""
      Msgbuffer = "OK"
   End If
   Cls
   Lcd Msgbuffer
   Wait 1

Loop
End

'============================== Send Message ===================================
Sub Sendmsg()
   Cls
   Lcd "Sending Msg ..."
   ' Enter Text Mode
   Print "AT+CMGF =1" ; Chr(13) ; Chr(10)
   Wait 1
   Lowerline
   Print "AT+CMGS=" ; Chr(34) ; Mobile_number ; Chr(34) ; Chr(13) ; Chr(10)
   Waitms 200
   Print "Message From GSM Modem" ; Chr(10) ; "Thanks" ; Chr(26)
   'Wait 1
   Lowerline
   Lcd "Msg Sent"
End Sub

'============================= Receive Message =================================
Sub Recvmsg()
   Dim Count As Word
   Count = 0
   Cls
   Lcd "Reading Msg ..."
   Lowerline
   'Enter Text Mode
   Print "AT+CMGF =1" ; Chr(13) ; Chr(10)
   Waitms 100

   Print "AT+CMGR=1" ; Chr(13) ; Chr(10)
   'Waitms 200

   Do
      ' Even works on every msg , we just has to check "OK"
      ' in every msg.
      If Nomsg > 0 Then
         Exit Do
      End If
      ' if modem is not responding then MCU will stuck over here so we need some sort of timer interrupt
      'Start Timer0
      Getbyte = Waitkey()
      'Stop Timer0

      Msgarray(count) = Chr(getbyte)
      Lcd Msgarray(count)
      Msgbuffer = Msgbuffer + Chr(getbyte)
      Nomsg = Instr(msgbuffer , "OK")
      Incr Count
      'Incr Timeout
   Loop
   '''''''''''''''''''''''''''''''''''''''''
   'make this test flag zero,becouse next time time it will EXIT  DO
   Nomsg = 0


   '''''''''''''''''''''''''''''''''''''''''
   'make empty the buffer
   Msgbuffer = ""
   Lowerline
   Lcd "Msg Read"
End Sub

'============================= Delete Message ==================================
Sub Delmsg()
   Cls
   Lcd "Deleting Msg ..."
   Print "AT+CMGD=1"
   Waitms 200
   '(Print "AT+CMGD=2"
   Waitms 200
   Print "AT+CMGD=3"
   Waitms 200
   Print "AT+CMGD=4"
   Waitms 200
   Print "AT+CMGD=5"
   Waitms 200
   Print "AT+CMGD=6"
   Waitms 200
   Print "AT+CMGD=7"
   Waitms 200
')
   Lowerline
   Lcd "Msg Deleted ..."
End Sub

'======================== Timer0 ISR ===========================================
Timer0_isr:
   Incr Timeout
   'Waitms 10
   If Timeout = 4000 Then
      Cls
      Lcd "TimeOut"
      'jmp 0

   End If
Return