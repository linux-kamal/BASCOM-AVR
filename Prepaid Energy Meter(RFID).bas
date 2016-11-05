$regfile = "m16def.dat"
$crystal = 8000000
$baud = 9600

Config Lcdpin = Pin , Db4 = Portc.3 , Db5 = Portc.2 , Db6 = Portc.1 , Db7 = Portc.0 , E = Portc.4 , Rs = Portc.5
Config Lcd = 16 * 2

Config Adc = Single , Prescaler = Auto
Start Adc

Config Timer0 = Timer , Prescale = 1024
On Ovf0 Timer0_isr
Enable Timer0

Config Watchdog = 2048

Dim _read_char As Byte

Dim Buffer As String * 10
Dim Card_db(10) As String * 10
Dim Emp_name_db(10) As String * 16

Dim Count As Byte
Dim Flag As Bit
Dim Index As Byte
Dim Local_buffer As String * 10
Dim Soft_uart_byte As Byte
Dim String_db As String * 10

Dim Timer0_count As Byte
Dim Adc_reading As Word

Dim User_bal As Word
Dim Eeprom_user_bal As Eram Word

Dim Master_card_bal As Word
Dim Eeprom_master_card_bal As Eram Word

Dim Deduct_bal As Word

Deflcdchar [0] , 10 , 32 , 21 , 21 , 17 , 14 , 32 , 32
Flag = 0
Index = 1
Card_db(1) = "55000E2B86"
Card_db(2) = "55000E209B"
Card_db(3) = "1800890F30"
Card_db(4) = "180089080A"
Card_db(5) = "1800891AB0"
Card_db(6) = "18008926F8"
Card_db(7) = "1800893C8D"

Emp_name_db(1) = "CARD 1"
Emp_name_db(2) = "CARD 2"
Emp_name_db(3) = "CARD 3"
Emp_name_db(4) = "CARD 4"
Emp_name_db(5) = "CARD 5"
Emp_name_db(6) = "CARD 6"
Emp_name_db(7) = "CARD 7"

On Urxc Lable
Enable Interrupts
Enable Urxc
'-------------------------------------------------------------------------------
Led1 Alias Porta.2
Led2 Alias Porta.3
Led3 Alias Porta.4
Led4 Alias Porta.5

Buzzer Alias Portd.6
Relay Alias Portd.7

Config Led1 = Output
Config Led2 = Output
Config Led3 = Output
Config Led4 = Output
Config Buzzer = Output
Config Relay = Output


Deduct_bal = 0
Timer0_count = 0
Cls
Cursor Off
Lcd " PREPAID ENERGY "
Lowerline
Lcd "      METER     "
Wait 3
Cls

User_bal = Eeprom_user_bal
Master_card_bal = Eeprom_master_card_bal
'Master_card_bal = 1000
'User_bal = 0
'Eeprom_master_card_bal = Master_card_bal
'Eeprom_user_bal = User_bal


If Eeprom_user_bal = 65535 Then
   User_bal = 17
   Eeprom_user_bal = User_bal
End If
User_bal = Eeprom_user_bal

If Eeprom_master_card_bal = 65535 Then
   Master_card_bal = 1000
   Eeprom_master_card_bal = Master_card_bal
End If
Master_card_bal = Eeprom_master_card_bal


Reset Led1
Reset Led2
Reset Led3

Set Buzzer
'Set Relay

Do


   If Flag = 1 Then
      Index = 1
      Local_buffer = Buffer
      Cls
      Lcd "CARD BAL:" ; Master_card_bal
      '(
      Lcd Buffer
      Buffer = ""
      Jump:
         Start Watchdog
         Do
            String_db = ""
            String_db = Card_db(index)
            If String_db = Local_buffer Then
               Exit Do
            End If
            Incr Index
         Loop Until Index => 10                             ' increments utill index become 10 MEANS MAX TAG IS 10

         'It's very important to recheck the array from begining INDEX, some times upper check gives wrong index that is 10 ,and which is empty
         If Card_db(index) = "" Then
            Index = 1
            Goto Jump
         End If
         Reset Watchdog
         Stop Watchdog
         If Index = 0 Or Index > 10 Then
            Lcd "No Match Found"
         Else
            Cls
            Lcd Emp_name_db(index)


            If Index = 3 Then
               Master_card_3 = 1
               Lowerline
               Lcd Master_card_bal
            End If
            If Index = 4 And Master_card_3 = 1 Then
               Master_card_3 = 0
               Lowerline
               Lcd User_bal
            End If

            Wait 5
            Buffer = ""
            Flag = 0
            Count = 0
            Cls
         End If
')

         Master_card_bal = Master_card_bal - 10
         Eeprom_master_card_bal = Master_card_bal
         Lcd "RS. 10 ADDED"
         User_bal = User_bal + 10
         Eeprom_user_bal = User_bal
         Wait 3
         Cls
         Lcd "CURRENT BAL:" ; User_bal
         Wait 3
         Cls
         Flag = 0
      Else

         If User_bal < 15 And User_bal <> 0 Then
            Set Led1
            Reset Buzzer
            Set Relay
         Elseif User_bal = 0 Then
            Reset Relay
            Reset Buzzer
            Set Led1
         Elseif User_bal >= 10 Then
            Set Relay
            Set Buzzer
            Reset Led1
         End If


         Locate 1 , 1

         Lcd "BAL:" ; User_bal
         If User_bal < 100 Then Lcd " "

         Adc_reading = Getadc(1)
         'Voltage in milivolt
         Adc_reading = Adc_reading * 5
         Select Case Adc_reading
            Case 60 To 200 :
               Locate 1 , 8
               Lcd "LOAD:15W "
            Case 2000 To 5000 :
               Locate 1 , 8
               Lcd "LOAD:100W"

            Case 0:
               Locate 1 , 8
               Lcd "LOAD:0 W "
         End Select

         Waitms 500
         Locate 2 , 1
         Lcd "CT:" ; Adc_reading ; "  "
      End If

Loop



Timer0_isr:

   If Timer0_count > 30 Then
      Toggle Led4
      Timer0_count = 0
      Incr Deduct_bal
   End If
   Incr Timer0_count

   Select Case Adc_reading

      Case 60 To 200 :
         If Deduct_bal > 100 Then
            If User_bal > 0 Then
               Decr User_bal
               Eeprom_user_bal = User_bal
            End If
            Deduct_bal = 0
         End If

      Case 2000 To 5000 :
         If Deduct_bal > 50 Then
            If User_bal > 0 Then
               Decr User_bal
               Eeprom_user_bal = User_bal
            End If
            Deduct_bal = 0
         End If
      Case 0:
           Deduct_bal = 0
   End Select

Return

'------------------------ Serial Interrupt Lable -------------------------------

Lable:

   'INTERRUPT SEGMENT SHOULD NOT HANDLE TOO MUCH CONDITIONS(INSTRUCTIONS)
   _read_char = Inkey()

   Buffer = Buffer + Chr(_read_char)
   Incr Count

   If Count = 10 Then
      Flag = 1
   End If
Return