$regfile = "m16def.dat"
$crystal = 8000000
$baud = 9600
Config Lcdpin = Pin , Db4 = Portc.3 , Db5 = Portc.2 , Db6 = Portc.1 , Db7 = Portc.0 , E = Portc.4 , Rs = Portc.5
Config Lcd = 16 * 2
Config Timer0 = Timer , Prescale = 1024
On Ovf0 Timer0_isr

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
Print "AT+CIPSTART=" ; Chr(34) ; "TCP" ; Chr(34) ; "," ; Chr(34) ; "www.visent.in" ; Chr(34) ; "," ; "80"
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
   Print "AT+CIPSEND=57"
Elseif Send_val >= 10 And Send_val < 100 Then
   Print "AT+CIPSEND=58"
Elseif Send_val >= 100 And Send_val < 1000 Then
   Print "AT+CIPSEND=59"
End If
'----------------------------------------------------------------------------------------------------------
'Print "AT+CIPSEND=58"
Do
   Var = Waitkey()
   'Lcd Chr(var)
   If Chr(var) = ">" Then Exit Do
Loop
'----------------------------------------------------------------------------------------------------------
Print "GET http://visent.in/kamal/setvariablevalue.php?value=" ; Send_val
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


'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Jump3:
Print "AT+CIPSTART=" ; Chr(34) ; "TCP" ; Chr(34) ; "," ; Chr(34) ; "www.visent.in" ; Chr(34) ; "," ; "80"
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
      Goto Jump3
   End If
Loop
'----------------------------------------------------------------------------------------------------------
Print "AT+CIPSEND=53"
Do
   Var = Waitkey()
   Lcd Chr(var)
   If Chr(var) = ">" Then Exit Do
Loop
'----------------------------------------------------------------------------------------------------------
Cls
Locate 1 , 1
Lcd "FETCHING DATA:"
Print "GET http://visent.in/kamal/getbuttonvalue.php?cmd=1"
Do
   Var = Waitkey()
   If Chr(var) = "K" Then Exit Do                           ' SEND OK

   If Chr(var) = "R" Then Exit Do                           ' ERROR
Loop

Do
   Var = Waitkey()
   'Lcd Chr(var)
   If Chr(var) = "1" Then
      Locate 2 , 1
      Lcd "BUTTON VALUE:1"
      Porta.7 = 1
   Elseif Chr(var) = "0" Then
      Locate 2 , 1
      Lcd "BUTTON VALUE:0"
      Porta.7 = 0
   End If
   If Chr(var) = "D" Then Exit Do                           'SERVER CLOSED
Loop
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Jump4:
Print "AT+CIPSTART=" ; Chr(34) ; "TCP" ; Chr(34) ; "," ; Chr(34) ; "www.visent.in" ; Chr(34) ; "," ; "80"
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
      Goto Jump4
   End If
Loop
'----------------------------------------------------------------------------------------------------------
Print "AT+CIPSEND=53"
Do
   Var = Waitkey()
   Lcd Chr(var)
   If Chr(var) = ">" Then Exit Do
Loop
'----------------------------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------------------------
Cls
Locate 1 , 1
Lcd "FETCHING DATA:"
Print "GET http://visent.in/kamal/getbuttonvalue.php?cmd=2"
Do
   Var = Waitkey()
   If Chr(var) = "K" Then Exit Do                           ' SEND OK

   If Chr(var) = "R" Then Exit Do                           ' ERROR
Loop

Do
   Var = Waitkey()
   'Lcd Chr(var)
   If Chr(var) = "1" Then
      Locate 2 , 1
      Lcd "BUTTON VALUE:1"
      Portd.7 = 1
   Elseif Chr(var) = "0" Then
      Locate 2 , 1
      Lcd "BUTTON VALUE:0"
      Portd.7 = 0
   End If
   If Chr(var) = "D" Then Exit Do                           'SERVER CLOSED
Loop
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Goto Jump

Cls
Do
   Locate 1 , 1
   Lcd "STUCK IN DO LOOP"
Loop
'----------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------
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
               Lcd "Not Registered"
               Wait 1
               Goto Tryagain
      Case 1 :
               Lcd "Registered Home"
               Lowerline
               Lcd "    Network"
               Wait 2
      Case 2 :
               Lcd "Not Registered"
               Lowerline
               Lcd "Searching N/W"
               Wait 1
               Goto Tryagain
      Case 3 :
               Lcd "Registration"
               Lowerline
               Lcd "   Denied"
               Wait 1
               Goto Tryagain
      Case 4 :
               Lcd "Unknown"
               Wait 1
               Goto Tryagain
      Case 5 :
               Lcd "Registered"
               Lowerline
               Lcd "Roaming"
               Wait 1
      Case Else :
               Lcd "Unknown Result"
               Lowerline
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

   Cls
   Operator_flag = 0
   Print "AT+CSPN?"
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
'==========================================================================================================
Timer0_isr:
'Disable Timer0
Disable Interrupts
Jump2:
Print "AT+CIPSTART=" ; Chr(34) ; "TCP" ; Chr(34) ; "," ; Chr(34) ; "www.visent.in" ; Chr(34) ; "," ; "80"
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
      Goto Jump2
   End If
Loop
'----------------------------------------------------------------------------------------------------------
Print "AT+CIPSEND=47"
Do
   Var = Waitkey()
   Lcd Chr(var)
   If Chr(var) = ">" Then Exit Do
Loop
'----------------------------------------------------------------------------------------------------------
Cls
Print "GET http://visent.in/kamal/getbuttonvalue.php"
Do
   Var = Waitkey()
   If Chr(var) = "K" Then Exit Do                           ' SEND OK
   If Chr(var) = "R" Then Exit Do                           ' ERROR
Loop

Do
   Var = Waitkey()
   'Lcd Chr(var)
   If Chr(var) = "1" Then
      Lcd "BUTTON VALUE:1"
   Elseif Chr(var) = "0" Then
      Lcd "BUTTON VALUE:0"
   End If
   If Chr(var) = "D" Then Exit Do                           'SERVER CLOSED
Loop
Waitms 100
Return