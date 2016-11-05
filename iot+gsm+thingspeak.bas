$regfile = "m16def.dat"
$crystal = 8000000
$baud = 9600
Config Lcdpin = Pin , Db4 = Portc.3 , Db5 = Portc.2 , Db6 = Portc.1 , Db7 = Portc.0 , E = Portc.4 , Rs = Portc.5
Config Lcd = 16 * 2

Config Portd.7 = Output                                     'relay 3
Config Porta.7 = Output                                     'relay 1
'---------------------- Subroutine Declaration ---------------------------------
Declare Sub Check_network()
Declare Sub Check_service_provider()

'------------------------ VARIABLES --------------------------------------------
Dim Var As Byte
Dim Apn(5) As String * 10
Dim Send_val As Word
'-----------------------VARIABLES INITIALIZATION--------------------------------
Apn(1) = "www"
Send_val = 0                                                ' Vodafone IN


'-------------------------------------------------------------------------------
Cls
Lcd "IoT SIM900"
Wait 1
Cls

Print "ATE0" ; Chr(13) ; Chr(10)
Do
   Var = Waitkey()
   If Chr(var) = "K" Then
      Lcd Chr(var)
      Wait 2
      Exit Do
   End If
Loop
'Call Check_network()
'Call Check_service_provider()

'---------------------------------------------
Print "AT+CSTT=" ; Chr(34) ; "www" ; Chr(34) ; Chr(13) ; Chr(10)
Do
   Var = Waitkey()
   Lcd Chr(var)
   If Chr(var) = "K" Then
    Locate 1 , 1
    Lcd "SET APN " ; Apn(1)
     Waitms 100
      Exit Do
   Elseif Chr(var) = "R" Then
      Exit Do
   End If
Loop
Wait 3
Cls
'---------------------------------------------

Print "AT+CIICR" ; Chr(13) ; Chr(10)
Do
   Var = Waitkey()
   If Chr(var) = "K" Then
      Locate 1 , 1
      Lcd Chr(var)
      Exit Do
   Elseif Chr(var) = "R" Then
      Locate 1 , 1
      Lcd Chr(var)
      Wait 1

      Exit Do
   End If
Loop
Wait 2
Cls
'---------------------------------------------
Dim Ip_var As Byte
Ip_var = 0

Wait 1
Print "AT+CIFSR" ; Chr(13) ; Chr(10)
Do
   Var = Waitkey()
   If Chr(var) = "1" Or Ip_var <> 0 Then
      If Ip_var = 11 Then Exit Do
      Lcd Chr(var)
      Ip_var = Ip_var + 1
   End If
   'If Chr(var) = "R" Then Goto Jump
Loop
Lowerline
Lcd "IP ADDRESS"
Wait 1
Cls
'----------------------------------------------------------------------------------------------------------
'Now Timer Could Be Enabled Modem has got IP and Initial Configurations
'Enable Timer0
'Enable Interrupts
'----------------------------------------------------------------------------------------------------------
Jump:
Print "AT+CIPSTART=" ; Chr(34) ; "TCP" ; Chr(34) ; "," ; Chr(34) ; "api.thingspeak.com" ; Chr(34) ; "," ; "80"
'Print "AT+CIPSTART=" ; Chr(34) ; "TCP" ; Chr(34) ; "," ; Chr(34) ; "www.visent.in" ; Chr(34) ; "," ; "80"
Do
   Var = Waitkey()
   Lcd Chr(var)
   If Chr(var) = "K" Or Chr(var) = "R" Then
      Cls
      Exit Do
   End If
Loop

Do
   Var = Waitkey()
   Lcd Chr(var)
   If Chr(var) = "K" Then
      Wait 1
      Cls
      Exit Do
   Elseif Chr(var) = "Y" Then
      Print "AT+CIPCLOSE"
      Wait 3
      Goto Jump
   End If
Loop
Cls
Send_val = Rnd(999)
Locate 1 , 1
Lcd "UPLOADING:" ; Send_val
If Send_val < 10 Then
   Print "AT+CIPSEND=47"
Elseif Send_val >= 10 And Send_val < 100 Then
   Print "AT+CIPSEND=48"
Elseif Send_val >= 100 And Send_val < 1000 Then
   Print "AT+CIPSEND=49"
End If
'----------------------------------------------------------------------------------------------------------
'Print "AT+CIPSEND=58"
Do
   Var = Waitkey()
   'Lcd Chr(var)
   If Chr(var) = ">" Then Exit Do
Loop
'----------------------------------------------------------------------------------------------------------
Print "GET /update?api_key=KBSFYGL0FTUULHSB&field2=" ; Send_val
'SEND OK Value Changed Successfully CLOSED
'Enable Timer0
'Enable Interrupts
Dim Flag As Bit
Flag = 0
Do
   Var = Waitkey()
   'Lcd Chr(var)
   If Chr(var) = "K" And Flag = 0 Then
      Flag = 1
   Elseif Chr(var) = "D" And Flag = 1 Then
      Locate 2 , 1
      Lcd "SENT:" ; Send_val ; " OK"
      Exit Do                                               'SERVER CLOSED
   End If
Loop
Goto Jump

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
