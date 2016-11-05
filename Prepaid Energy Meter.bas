$regfile = "m16def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Db4 = Portc.3 , Db5 = Portc.2 , Db6 = Portc.1 , Db7 = Portc.0 , E = Portc.4 , Rs = Portc.5
Config Lcd = 16 * 2
Config Adc = Single , Prescaler = Auto
Start Adc

Config Timer0 = Timer , Prescale = 1024
On Ovf0 Timer0_isr
Enable Timer0
Enable Interrupts

Declare Sub Recharge()

Keypad Alias Portd
Config Keypad = Input

'One Alias Pind.0
One Alias Pind.1
Two Alias Pind.2
Three Alias Pind.3
Four Alias Pind.4
Activation Alias Pind.5

Relay Alias Portd.7
Buzzer Alias Portd.6
Config Buzzer = Output
Config Relay = Output

Config Porta.5 = Output
Config Porta.4 = Output
Config Porta.3 = Output
Config Porta.2 = Output

Dim Timer0_count As Byte

Dim Eram_10_1 As Eram Word , Eram_10_2 As Eram Word , Eram_10_3 As Eram Word , Eram_10_4 As Eram Word , Eram_10_5 As Eram Word
Dim Eram_20_1 As Eram Word , Eram_20_2 As Eram Word , Eram_20_3 As Eram Word , Eram_20_4 As Eram Word , Eram_20_5 As Eram Word
Dim Eram_50_1 As Eram Word , Eram_50_2 As Eram Word , Eram_50_3 As Eram Word , Eram_50_4 As Eram Word , Eram_50_5 As Eram Word
Dim Eram_100_1 As Eram Word , Eram_100_2 As Eram Word , Eram_100_3 As Eram Word , Eram_100_4 As Eram Word , Eram_100_5 As Eram Word

Dim 10_1 As Word , 10_2 As Word , 10_3 As Word , 10_4 As Word , 10_5 As Word
Dim 20_1 As Word , 20_2 As Word , 20_3 As Word , 20_4 As Word , 20_5 As Word
Dim 50_1 As Word , 50_2 As Word , 50_3 As Word , 50_4 As Word , 50_5 As Word
Dim 100_1 As Word , 100_2 As Word , 100_3 As Word , 100_4 As Word , 100_5 As Word

Dim Count As Byte
Dim Array(7) As Byte , Array_index As Byte
Dim Recharge_pass As String * 7

'Take Array of Strings
Dim Recharge_10(5) As String * 7
Dim Recharge_20(5) As String * 7
Dim Recharge_50(5) As String * 7
Dim Recharge_100(5) As String * 7

Dim Balance As Word
Dim Eram_balance As Eram Word
Dim Bal_count As Word
Dim Ct_read As Word
Dim V_read As Word
Dim Activation_count As Word

Dim Balance_deduct As Word
Dim Timer_balance_deduct As Word
Dim I As Word
Dim J As Word

Timer_balance_deduct = 0
Balance_deduct = 0
Activation_count = 0
Recharge_10(1) = "4213124"
Recharge_10(2) = "4121341"
Recharge_10(3) = "4131411"
Recharge_10(4) = "4423122"
Recharge_10(5) = "4342222"

Recharge_20(1) = "1113212"
Recharge_20(2) = "1312212"
Recharge_20(3) = "1222111"
Recharge_20(4) = "1222312"
Recharge_20(5) = "3311114"

Recharge_50(1) = "3422441"
Recharge_50(2) = "3324144"
Recharge_50(3) = "3144244"
Recharge_50(4) = "3234444"
Recharge_50(5) = "3243443"

Recharge_100(1) = "2422241"
Recharge_100(2) = "2314141"
Recharge_100(3) = "2124243"
Recharge_100(4) = "2234141"
Recharge_100(5) = "2243343"


'PULL DOWN THE PORTD
Keypad = 0
Bal_count = 0
'Eram_balance = 17
If Eram_balance = 65535 Then
   Balance = 17
   Eram_balance = Balance
End If
Balance = Eram_balance
Set Buzzer

10_1 = Eram_10_1
10_2 = Eram_10_2
10_3 = Eram_10_3
10_4 = Eram_10_4
10_5 = Eram_10_5

20_1 = Eram_20_1
20_2 = Eram_20_2
20_3 = Eram_20_3
20_4 = Eram_20_4
20_5 = Eram_20_5

50_1 = Eram_50_1
50_2 = Eram_50_2
50_3 = Eram_50_3
50_4 = Eram_50_4
50_5 = Eram_50_5

100_1 = Eram_100_1
100_2 = Eram_100_2
100_3 = Eram_100_3
100_4 = Eram_100_4
100_5 = Eram_100_5


Cursor Off
Cls

Lcd " PREPAID ENERGY "
Lowerline
Lcd "     METER"
Wait 3
Cls

Do
Lable:
   If Balance = 0 Then
      Reset Buzzer
      Wait 1
      Set Buzzer

      Reset Relay
      Set Porta.2
   Elseif Balance > 0 And Balance <= 15 Then
      Reset Buzzer
      Waitms 200
      Set Buzzer
      Set Relay
      'Wait 2
      Set Porta.2
   Elseif Balance > 15 Then
      Set Buzzer
      Waitms 200
      Set Relay
      Reset Porta.2
   End If

   If Activation = 1 Then
      Set Porta.4
      While Activation = 1
      Wend
      Call Recharge()
      Reset Porta.4
   End If

   V_read = Getadc(0)
   Ct_read = Getadc(1)
   Locate 1 , 1
   Lcd "BAL:" ; Balance ; "  " ; "LOAD:"

   If Ct_read = 0 Then
      Lcd "OFF"
   Elseif Ct_read > 0 Then
      Lcd "ON "
   End If

   Locate 2 , 1
   Lcd "CT:" ; Ct_read ; "    "

   If V_read <> 0 Then
      V_read = V_read / 2
      V_read = V_read - 36
   End If
   Locate 2 , 12
   Lcd "V:" ; V_read ; "  "

   Select Case Ct_read
      ' 100W
      Case 10 To 249 :
         Balance_deduct = 143

      '200W
      Case 250 To 449 :
         Balance_deduct = 95
      '300W
      Case 450 To 600 :
         Balance_deduct = 48
      Case 0 :
         Balance_deduct = 0

   End Select


   'Wait 1
   'DEDUCT BALANCE
   If Bal_count = 2000 And Ct_read > 100 Then
      Decr Balance
      Eram_balance = Balance
      Bal_count = 0
   End If


   If Balance_deduct <> 0 Then
      Do
         If I = Balance_deduct Then
            Exit Do
         Elseif I > Balance_deduct Then
            Exit Do
         End If

         Waitms 1000
         Incr I
         Goto Lable
      Loop
      I = 0
      Balance = Balance - 1
      Eram_balance = Balance
   End If
   Wait 1
Loop

End


Sub Recharge()
   Activation_count = 0
   Set Porta.4
   Cls
   Lcd "Recharge"
   Lowerline
   Count = 1
   Array_index = 1
   Recharge_pass = ""
   For Count = 1 To 7
      While One = 0 And Two = 0 And Three = 0 And Four = 0  'WAIT TILL ANY KEY PRESSED
         Incr Activation_count

         If Activation = 1 Or Activation_count > 6000 Then  'EXIT ANY TIME FROM RECHARGE SEGMENT
            While Activation = 1
            Wend
            Reset Porta.4
            Exit For
         End If
         Waitms 5
         'Locate 2 , 10
         'Lcd Activation_count

      Wend

      Set Porta.3
      Reset Buzzer                                          'KEY CONFIRMATION LED
      If One = 1 Then
         Array(array_index) = 1
         Recharge_pass = Recharge_pass + Chr(49)
         Lcd "1"
      Elseif Two = 1 Then
         Array(array_index) = 2
         Recharge_pass = Recharge_pass + Chr(50)
         Lcd "2"
      Elseif Three = 1 Then
         Array(array_index) = 3
         Recharge_pass = Recharge_pass + Chr(51)
         Lcd "3"
      Elseif Four = 1 Then
         Array(array_index) = 4
         Recharge_pass = Recharge_pass + Chr(52)
         Lcd "4"
      End If
      Incr Array_index
      Waitms 400                                            'wait is added to reduce key debouncing
      While One = 1 Or Two = 1 Or Three = 1 Or Four = 1     'INFINITE LOOP UNTIL KEY RELEASED
      Wend
      Reset Porta.3
      Set Buzzer                                            'KEY CONFIRMATION LED
   Next Count

   '--------------- Rupees 10 Recharge ---------------------
   If Recharge_pass = Recharge_10(1) And 10_1 = 65535 Then
      Cls
      Lcd "RS. 10 RECHARGE"
      Recharge_10(1) = "0"
      10_1 = 0
      Eram_10_1 = 10_1
      Balance = Balance + 10
      Eram_balance = Balance
      Reset Buzzer
      Wait 2
      Cls
      Set Buzzer
   Elseif Recharge_pass = Recharge_10(2) And 10_2 = 65535 Then
      Cls
      Lcd "RS. 10 RECHARGE"
      Recharge_10(2) = "0"
      10_2 = 0
      Eram_10_2 = 10_2
      Balance = Balance + 10
      Eram_balance = Balance
      Reset Buzzer
      Wait 2
      Cls
      Set Buzzer
   Elseif Recharge_pass = Recharge_10(3) And 10_3 = 65535 Then
      Cls
      Lcd "RS. 10 RECHARGE"
      Recharge_10(3) = "0"
      10_3 = 0
      Eram_10_3 = 10_3
      Balance = Balance + 10
      Eram_balance = Balance
      Reset Buzzer
      Wait 2
      Cls
      Set Buzzer
   Elseif Recharge_pass = Recharge_10(4) And 10_4 = 65535 Then
      Cls
      Lcd "RS. 10 RECHARGE"
      Recharge_10(4) = "0"
      10_4 = 0
      Eram_10_4 = 10_4
      Balance = Balance + 10
      Eram_balance = Balance
      Reset Buzzer
      Wait 2
      Cls
      Set Buzzer
   Elseif Recharge_pass = Recharge_10(5) And 10_5 = 65535 Then
      Cls
      Lcd "RS. 10 RECHARGE"
      Recharge_10(5) = "0"
      10_5 = 0
      Eram_10_5 = 10_5
      Balance = Balance + 10
      Eram_balance = Balance
      Reset Buzzer
      Wait 2
      Cls
      Set Buzzer
   '--------------- Rupees 20 Recharge ---------------------
   Elseif Recharge_pass = Recharge_20(1) And 20_1 = 65535 Then
      Cls
      Lcd "RS. 20 RECHARGE"
      Recharge_20(1) = "0"
      20_1 = 0
      Eram_20_1 = 20_1
      Balance = Balance + 20
      Eram_balance = Balance
      Reset Buzzer
      Wait 2
      Cls
      Set Buzzer
   Elseif Recharge_pass = Recharge_20(2) And 20_2 = 65535 Then
      Cls
      Lcd "RS. 20 RECHARGE"
      Recharge_20(2) = "0"
      20_2 = 0
      Eram_20_2 = 20_2
      Balance = Balance + 20
      Eram_balance = Balance
      Reset Buzzer
      Wait 2
      Cls
      Set Buzzer
   Elseif Recharge_pass = Recharge_20(3) And 20_3 = 65535 Then
      Cls
      Lcd "RS. 20 RECHARGE"
      Recharge_20(3) = "0"
      20_3 = 0
      Eram_20_3 = 20_3
      Balance = Balance + 20
      Eram_balance = Balance
      Reset Buzzer
      Wait 2
      Cls
      Set Buzzer
   Elseif Recharge_pass = Recharge_20(4) And 20_4 = 65535 Then
      Cls
      Lcd "RS. 20 RECHARGE"
      Recharge_20(4) = "0"
      20_4 = 0
      Eram_20_4 = 20_4
      Balance = Balance + 20
      Eram_balance = Balance
      Reset Buzzer
      Wait 2
      Cls
      Set Buzzer
   Elseif Recharge_pass = Recharge_20(5) And 20_5 = 65535 Then
      Cls
      Lcd "RS. 20 RECHARGE"
      Recharge_20(5) = "0"
      20_5 = 0
      Eram_20_5 = 20_5
      Balance = Balance + 20
      Eram_balance = Balance
      Reset Buzzer
      Wait 2
      Cls
      Set Buzzer
   '--------------- Rupees 50 Recharge ---------------------
   Elseif Recharge_pass = Recharge_50(1) And 50_1 = 65535 Then
      Cls
      Lcd "RS. 50 RECHARGE"
      Recharge_50(1) = "0"
      50_1 = 0
      Eram_50_1 = 50_1
      Balance = Balance + 50
      Eram_balance = Balance
      Reset Buzzer
      Wait 2
      Cls
      Set Buzzer
   Elseif Recharge_pass = Recharge_50(2) And 50_2 = 65535 Then
      Cls
      Lcd "RS. 50 RECHARGE"
      Recharge_50(2) = "0"
      50_2 = 0
      Eram_50_2 = 50_2
      Balance = Balance + 50
      Eram_balance = Balance
      Reset Buzzer
      Wait 2
      Cls
      Set Buzzer
   Elseif Recharge_pass = Recharge_50(3) And 50_3 = 65535 Then
      Cls
      Lcd "RS. 50 RECHARGE"
      Recharge_50(3) = "0"
      50_3 = 0
      Eram_50_3 = 50_3
      Balance = Balance + 50
      Eram_balance = Balance
      Reset Buzzer
      Wait 2
      Cls
      Set Buzzer
   Elseif Recharge_pass = Recharge_50(4) And 50_4 = 65535 Then
      Cls
      Lcd "RS. 50 RECHARGE"
      Recharge_50(4) = "0"
      50_4 = 0
      Eram_50_4 = 50_4
      Balance = Balance + 50
      Eram_balance = Balance
      Reset Buzzer
      Wait 2
      Cls
      Set Buzzer
   Elseif Recharge_pass = Recharge_50(5) And 50_5 = 65535 Then
      Cls
      Lcd "RS. 50 RECHARGE"
      Recharge_50(5) = "0"
      50_5 = 0
      Eram_50_5 = 50_5
      Balance = Balance + 50
      Eram_balance = Balance
      Reset Buzzer
      Wait 2
      Cls
      Set Buzzer
   '--------------- Rupees 100 Recharge ---------------------
   Elseif Recharge_pass = Recharge_100(1) And 100_1 = 65535 Then
      Cls
      Lcd "RS. 100 RECHARGE"
      Recharge_100(1) = "0"
      100_1 = 0
      Eram_100_1 = 100_1
      Balance = Balance + 100
      Eram_balance = Balance
      Reset Buzzer
      Wait 2
      Cls
      Set Buzzer
   Elseif Recharge_pass = Recharge_100(2) And 100_2 = 65535 Then
      Cls
      Lcd "RS. 100 RECHARGE"
      Recharge_100(2) = "0"
      100_2 = 0
      Eram_100_2 = 100_2
      Balance = Balance + 100
      Eram_balance = Balance
      Reset Buzzer
      Wait 2
      Cls
      Set Buzzer
   Elseif Recharge_pass = Recharge_100(3) And 100_3 = 65535 Then
      Cls
      Lcd "RS. 100 RECHARGE"
      Recharge_100(3) = "0"
      100_3 = 0
      Eram_100_3 = 100_3
      Balance = Balance + 100
      Eram_balance = Balance
      Reset Buzzer
      Wait 2
      Cls
      Set Buzzer
   Elseif Recharge_pass = Recharge_100(4) And 100_4 = 65535 Then
      Cls
      Lcd "RS. 100 RECHARGE"
      Recharge_100(4) = "0"
      100_4 = 0
      Eram_100_4 = 100_4
      Balance = Balance + 100
      Eram_balance = Balance
      Reset Buzzer
      Wait 2
      Cls
      Set Buzzer
   Elseif Recharge_pass = Recharge_100(5) And 100_5 = 65535 Then
      Cls
      Lcd "RS. 100 RECHARGE"
      Recharge_100(5) = "0"
      100_5 = 0
      Eram_100_5 = 100_5
      Balance = Balance + 100
      Eram_balance = Balance
      Reset Buzzer
      Wait 2
      Cls
      Set Buzzer

   Else
      Cls
      Lcd "  RECHARGE NOT  "
      Lowerline
      Lcd "      FOUND     "
      Reset Buzzer
      Wait 5
      Cls
      Set Buzzer
   End If
   Reset Porta.4


End Sub

Timer0_isr:
   If Timer0_count > 15 Then
      Toggle Porta.5
      Timer0_count = 0
      Incr Bal_count
   End If
   Incr Timer0_count
   '(
   If Timer_balance_deduct = Balance_deduct And Balance_deduct <> 0 Then
      Decr Balance
      Eram_balance = Balance
      Timer_balance_deduct = 0
      Balance_deduct = 0
   End If
   Incr Timer_balance_deduct
   Locate 2 , 10
   Lcd Timer_balance_deduct ; " " ; Balance_deduct
')

Return