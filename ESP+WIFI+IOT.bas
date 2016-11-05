$regfile = "m16def.dat"
$crystal = 8000000
$baud = 9600
'----------------------------------------------------------------------------------------------------------------
Config Lcdpin = Pin , Rs = Portb.5 , E = Portb.4 , Db4 = Portb.3 , Db5 = Portb.2 , Db6 = Portb.1 , Db7 = Portb.0
Config Lcd = 16 * 2
Config Watchdog = 2048
'----------------------------------------------------------------------------------------------------------------
Declare Sub Read_data()
Declare Sub Send_data()
Declare Sub Check_ok_error()
Declare Sub Connect_to_server()
'----------------------------------------------------------------------------------------------------------------
Dim Recv As Byte
Dim Value As Word
Dim Flag As Bit
Flag = 0
'----------------------------------------------------------------------------------------------------------------
Cls
Lcd "IOT"
Wait 1
Cls
Lable1:
Print "ATE0" ; Chr(13) ; Chr(10);
Start Watchdog
Call Check_ok_error()
Stop Watchdog
'-------------------------------

Print "AT+CWQAP" ; Chr(13) ; Chr(10);
Start Watchdog
Call Check_ok_error()
Stop Watchdog
Wait 1


'-------------------------------

Lable2:
Cls
Lcd "CONNECT TO wifi "
Wait 1
Print "AT+CWJAP_CUR=" ; Chr(34) ; "wifi" ; Chr(34) ; "," ; Chr(34) ; "password" ; Chr(34)
Do
   Recv = Waitkey()
   Lcd Chr(recv)

   If Chr(recv) = "1" Then                                  'IF COMMAND FAIL THEN WE GET----> AT+CWJAP:1
      Cls
      Lcd "WIFI CONNECTION"
      Lowerline
      Lcd "     FAILURE    "
      Wait 10
      Goto Lable2
   Elseif Chr(recv) = "D" Then                              'IF SUCCESSFULL THEN WE GET----> WIFI CONNECTED
      Cls
      Lcd "WIFI CONNECTED"
      Wait 1
      Cls
      Exit Do
   Elseif Chr(recv) = "P" Then                              'IF SUCCESSFULL THEN WE GET----> WIFI CONNECTED
      Cls
      Lcd "GOT IP"
      Wait 1
      Cls
      Exit Do
   End If

Loop
'------------------------------------------------------
Print "AT+CIPCLOSE"
Wait 2
Do
   '------------------------------------------------------
   'link is not valid
   Call Connect_to_server()
   '------------------------------------------------------
   If Flag = 1 Then
      Call Send_data()
      Toggle Flag
   '------------------------------------------------------
   Elseif Flag = 0 Then
      Call Read_data()
      Toggle Flag
   End If
   '------------------------------------------------------
Loop
'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Sub Check_ok_error()
   Do
      Recv = Waitkey()
      Lcd Chr(recv)
      If Chr(recv) = "K" Then
         Waitms 100
         Exit Do
      Elseif Chr(recv) = "R" Then
      Waitms 100
      Goto Lable1
      End If
   Loop
End Sub


Sub Send_data()
Lable3:
'------------------------------
Print "AT+CIPSEND=" ; "50"
Do
   Recv = Waitkey()
   Lcd Chr(recv)
   If Chr(recv) = ">" Then Exit Do
Loop
Cls
' busy SEND OK CLOSED
' busy CLOSED SEND FAIL
'44 BYTES TILL =
Value = Rnd(9)
Lcd "SENDING: " ; Value
Wait 1
Print "GET /update?api_key=KBSFYGL0FTUULHSB&field3=" ; 50
'Waitms 100
'Print "GET /update?api_key=KBSFYGL0FTUULHSB&field1=" ; Value

'54 BYTES TILL =
'Print "GET http://visent.in/kamal/setvariablevalue.php?value=" ; Value
'Waitms 100
'Print "GET http://visent.in/kamal/setvariablevalue.php?value=21";
'Print "HELLO"

Print "AT+CIPCLOSE"

Cls
Start Watchdog
Do
      Recv = Waitkey()
      Lcd Chr(recv)

      If Chr(recv) = "+" Or Chr(recv) = ":" Or Chr(recv) = "y" Then
         Stop Watchdog
         Cls
         Lcd "Data Sent Success"
         Wait 1
         Exit Do
      Elseif Chr(recv) = "F" Then
         Stop Watchdog
         Cls
         Lcd "Data Sent Failure"
         Wait 5
         Goto Lable3
'(
      Elseif Chr(recv) = "E" Then
         Cls
         Lcd "Data Sent Failure"
         Wait 5
         Goto Lable3
')
      End If
Loop
Stop Watchdog
End Sub

Sub Read_data()
Dim Flags As Bit
Cls
Lcd "FETCHING VALUE"
Wait 1
Cls
Print "AT+CIPSEND=" ; "33"
Do
   Recv = Waitkey()
   Lcd Chr(recv)
   If Chr(recv) = ">" Then Exit Do
Loop

'Print "GET http://visent.in/kamal/getbuttonvalue.php"

Print "GET /channels/83645/fields/3/last"
Cls
Lcd "sent cmd"
Wait 1
Print "AT+CIPCLOSE"
Cls
Do

   Recv = Waitkey()
   Lcd Chr(recv)

Loop
'------------------------------
Do

   Recv = Waitkey()
   Lcd Chr(recv)
   If Flags = 1 Then
      Cls
      Lcd "BUTTON VALUE:" ; Chr(recv)
      Flags = 0
      Wait 3
      Exit Do
   End If
   If Chr(recv) = ":" Then Flags = 1
Loop

End Sub

Sub Connect_to_server()
'------------------------------
Lcd "Connect To Server"
Wait 1
Cls
Print "AT+CIPSTART=" ; Chr(34) ; "TCP" ; Chr(34) ; "," ; Chr(34) ; "api.thingspeak.com" ; Chr(34) ; "," ; "80"

'Print "AT+CIPSTART=" ; Chr(34) ; "TCP" ; Chr(34) ; "," ; Chr(34) ; "www.visent.in" ; Chr(34) ; "," ; "80"

'1)IF CONNECTED THE WE'LL GET---> CONNECT OK [K]
'2)IF CONNECTED THE WE'LL GET---> DNS Fail  (if I missed w in www) [l]
'IF CONNECTED THE WE'LL GET---> LINK type ERR  (if I missed C in TCP)
'IF CONNECTED THE WE'LL GET---> LINK type ERR  (if I missed C in TCP)
'IF I MISSED CHR(34) BEFORE DOMAIN NAME ----> IP ERROR
'3)IF TRIED TO CONNECT AT WRONG PORT NUMBER ----> ERROR CLOSE [L]
Start Watchdog
Do
   Recv = Waitkey()
   Lcd Chr(recv)
   If Chr(recv) = "K" Then
      Stop Watchdog
      Cls
      Lcd "CONNECTED"
      Wait 1
      Cls
      Exit Do
   Elseif Chr(recv) = "l" Then
      Stop Watchdog
      Cls
      Lcd "DNS FAIL"
      Wait 2
      Cls
      Goto Lable3
      Exit Do
   Elseif Chr(recv) = "L" Then
      Stop Watchdog
      Cls
      Lcd "ERROR CLOSE"
      Print "AT+CIPCLOSE"
      Wait 5
      Cls
      Goto Lable3
      Exit Do
   End If
Loop
Stop Watchdog
End Sub