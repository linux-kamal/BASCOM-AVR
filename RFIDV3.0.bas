'--------------------------HARDWARE INITIALIZATION------------------------------

$regfile = "m16def.dat"                                     'ATMEGA 32 MICROCONTROLLER
$crystal = 8000000                                          '16MHz CRYSTAL
$baud = 9600

Config Lcdpin = Pin , Db4 = Portc.3 , Db5 = Portc.2 , Db6 = Portc.1 , Db7 = Portc.0 , E = Portc.4 , Rs = Portc.5
Config Lcd = 16 * 2

'portc.6 is RX
Open "comc.6:9600,8,n,1" For Input As # 1

Config Porta = Output

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

Deflcdchar [0] , 10 , 32 , 21 , 21 , 17 , 14 , 32 , 32      ' replace [x] with number (0-7)
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
Cls
Cursor Off

Lcd "--SYSTEM RESET--"
Wait 1
Cls

Count = 0

' start watch dog timer

'------------------------ DO starts Here ---------------------------------------
Do

   If Flag = 1 Then
      Index = 1
      Local_buffer = Buffer
      Buffer = ""
      'Disable Interrupts                                    'disable serial interrupts untill we finish some check mechanism
      'Cls
      'Lcd Local_buffer
      'Lowerline
      'Wait 5
      'Cls

Jump:                                                       'lable
      Start Watchdog                                        'start  WATCHDOG
      Do
         String_db = ""
         String_db = Card_db(index)
         If String_db = Local_buffer Then
            Exit Do
         End If
         Incr Index
      Loop Until Index => 10                                ' increments utill index become 10 MEANS MAX TAG IS 10


      'It's very important to recheck the array from begining INDEX, some times upper check gives wrong index that is 10 ,and which is empty
      If Card_db(index) = "" Then
         Index = 1
         Goto Jump
      End If
      Reset Watchdog
      Stop Watchdog
'(                                   'check the array for match
      If Local_buffer = "55000E2B86" Then
         Local_buffer = ""
         Index = 1
         'Exit For
         'lcd "Welcome Mr. XYZ"
         'lcd "Have a nice day"
      Elseif Local_buffer = "55000E209B" Then
         Local_buffer = ""
         Index = 2
         'Elseif Local_buffer <> "55000E2B86" Or Local_buffer <> "55000E209B" Then
            'Local_buffer = ""
            'Index = 0
      End If

')
      If Index = 0 Or Index > 10 Then
         Lcd "No Match Found"
      Else
         Cls
         Lcd "   Welcome !" ; "  " ; Chr(0)
         Lowerline
         Lcd "   Mr." ; " " ; Emp_name_db(index)
         'Lcd "Card" ; " " ; Index ; " " ; "Match"

         Print Index

         Wait 5
         Buffer = ""
         Flag = 0
         Count = 0
         Cls
      End If
      Else
         Locate 1 , 6
         Lcd "Please"
         Locate 2 , 2
         Lcd "Show Your Card"
         'Soft_uart_byte = Inkey(#1)
         'If Soft_uart_byte > 0 Then
          '  Locate 2 , 16
           ' Lcd Chr(soft_uart_byte)
         'End If
         'Enable Interrupts
   End If

Loop
'-------------------------- DO Ends Here ---------------------------------------

End

'------------------------ Serial Interrupt Lable -------------------------------
Lable:

   _read_char = Inkey()
   If Chr(_read_char) = "Z" Or Chr(_read_char) = "Z" Then
      Cls
      Lcd "DATA FROM PC"
      Wait 2
      Cls
      Return
   End If

   Buffer = Buffer + Chr(_read_char)
   Incr Count

   If Count = 10 Then

      'Count = 0
      Flag = 1
   End If
Return