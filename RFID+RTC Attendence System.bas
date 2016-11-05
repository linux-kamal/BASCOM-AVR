
'===============================================================================
'===============================================================================
'Author : Kamal Babu <kumarkamal203ATgmailDOTcom>
'About  : Attendence System Using RFID & Real Time Clock DS1307
'Date   : 08/11/14
'Time   : 11:06 PM
'===============================================================================
'===============================================================================

'--------------------------HARDWARE INITIALIZATION------------------------------

$regfile = "m16def.dat"                                     'ATMEGA 32 MICROCONTROLLER
$crystal = 16000000                                         '16MHz CRYSTAL
$baud = 9600
$eeprom
$data

Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0       'LCD PIN DECLARATION
Config Lcd = 16 * 2

Config Scl = Portc.0
Config Sda = Portc.1

Config Porta = Output
Config Watchdog = 2048
'----------------- Subroutines/ Functions  Declarations ------------------------
Declare Function _read_all(byval _reg_addr As Byte) As Byte
Declare Sub _setday(byval Day As Byte)
Declare Sub _settime(byval Hour As Byte , Byval Minute As Byte , Byval Second As Byte)
Declare Sub _setdate(byval _date As Byte , Byval Month As Byte , Byval Year As Byte)
Declare Sub _print_data()
'------------------------ Variables Declarations -------------------------------
Dim Hour As Byte , Minute As Byte , Second As Byte
Dim Am As Byte
Dim Pm As Byte
Dim Day As Byte
Dim Year As Byte
Dim Month As Byte
Dim _date As Byte
Dim Array_day(7) As String * 9
Array_day(1) = "Sun"
Array_day(2) = "Mon"
Array_day(3) = "Tue"
Array_day(4) = "Wed"
Array_day(5) = "Thr"
Array_day(6) = "Fri"
Array_day(7) = "Sat"

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
Dim Emp_in_or_out(10) As Byte
Dim Attendence_counter As Byte
Dim Eeprom_address(10) As Byte

Flag = 0
Index = 1
Card_db(1) = "55000E2B86"
Card_db(2) = "55000E209B"

'If First 6 bytes are same for every card then we can discard first 2 bytes
'and we can save remaining 8 bytes in EEPROM

Emp_name_db(1) = "Kamal"
Emp_name_db(2) = "Babu"

Eeprom_address(1) = 0
Eeprom_address(2) = 1
'-------------------- DS1307 RTC chip registers addresss -----------------------
Const Write_addr = &HD0
Const Read_addr = &HD1
Const _regsecond = &H00
Const _regminute = &H01
Const _reghour = &H02
Const _regday = &H03
Const _regdate = &H04
Const _regmonth = &H05
Const _regyear = &H06


On Urxc Lable
Enable Interrupts
Enable Urxc
'-------------------------------------------------------------------------------
Cursor Off
Cls

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
Jump:                                                       'lable
      Start Watchdog                                        'start  WATCHDOG
      Do
         String_db = ""
         String_db = Card_db(index)
         If String_db = Local_buffer Then
            Exit Do
         End If
         Incr Index
      Loop Until Index => 10                                ' increments utill index become 10

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
         '----------------- Read I2C DATA HERE ---------------------------------------
         Second = _read_all(_regsecond)
         Minute = _read_all(_regminute)
         Hour = _read_all(_reghour)
         '-------------------------- CHECK FOR AM/PM ---------------------------------
         If Hour >= 0 And Hour < 12 Or Hour = 24 Then
            If Hour = 0 Or Hour = 24 Then
               Hour = 12
            End If
            Am = 1
            Pm = 0
         Elseif Hour >= 12 And Hour <= 23 Then
            Am = 0
            Pm = 1
            If Hour > 12 Then
               Hour = Hour - 12
            End If
         End If

         If Hour > 24 Then
            Call _settime(0 , 0 , 0)
         End If

         Day = _read_all(_regday)
         'Year = _read_all(_regyear)
         'Month = _read_all(_regmonth)
         '_date = _read_all(_regdate)

         Cls
         Locate 1 , 1
         Lcd "Hello !" ; "Mr." ; " " ; Emp_name_db(index)

         Call _print_data()

         'Print Index

         Wait 4
         Buffer = ""
         Flag = 0
         Count = 0
         Cls
         If Emp_in_or_out(index) = 0 Then
            'Employee signed in
            Emp_in_or_out(index) = 1
         Elseif Emp_in_or_out(index) = 1 Then
            'Employee signed out
            Emp_in_or_out(index) = 0
            Attendence_counter = 0
            Readeeprom Attendence_counter , Eeprom_address(index)
            Incr Attendence_counter
            Writeeeprom Attendence_counter , Eeprom_address(index)
         End If
      End If
   Else
      Locate 1 , 6
      Lcd "Please"
      Locate 2 , 2
      Lcd "Show Your Card"

   End If


Loop
'-------------------------- DO Ends Here ---------------------------------------

End

'-------------------------------------------------------------------------------
'-------------------------- MAIN ENDS HERE -------------------------------------
'-------------------------------------------------------------------------------
Sub _print_data()

   Locate 2 , 1
   If Hour < 10 Then
      Lcd "0"
   End If
   Lcd Hour ; ":"

   If Minute < 10 Then
      Lcd "0"
   End If
   Lcd Minute ; ":"

   If Second < 10 Then
      Lcd "0"
   End If
   Lcd Second

   Locate 2 , 10
   If Am = 1 Then
      Lcd "AM"
   Elseif Pm = 1 Then
      Lcd "PM"
   End If

   Locate 2 , 13
   'Lcd _date ; "/" ; Month ; "/" ; Year
   Lcd Array_day(day)
End Sub

'-------------------------------------------------------------------------------
Function _read_all(byval _reg_addr As Byte) As Byte
   Dim _localvar As Byte
   I2cstart
   I2cwbyte Write_addr
   I2cwbyte _reg_addr
   'repeated start
   I2cstart
   I2cwbyte Read_addr
   I2crbyte _localvar , Nack
   I2cstop
   _read_all = Makedec(_localvar)
End Function


Sub _setday(byval Day As Byte)
   Dim _bcdday As Byte
   _bcdday = Makebcd(day)

   I2cstart
   I2cwbyte Write_addr
   I2cwbyte _regday
   I2cwbyte _bcdday
   I2cstop
End Sub

Sub _settime(byval Hour As Byte , Byval Minute As Byte , Byval Second As Byte)

   Hour = Makebcd(hour)
   Minute = Makebcd(minute)
   Second = Makebcd(second)

   I2cstart
   I2cwbyte Write_addr
   I2cwbyte _reghour
   I2cwbyte Hour
   I2cstop

   I2cstart
   I2cwbyte Write_addr
   I2cwbyte _regminute
   I2cwbyte Minute
   I2cstop

   I2cstart
   I2cwbyte Write_addr
   I2cwbyte _regsecond
   I2cwbyte Second
   I2cstop
End Sub

Sub _setdate(byval _date As Byte , Byval Month As Byte , Byval Year As Byte)
   Dim _bcddate As Byte
   Dim _bcdmonth As Byte
   Dim _bcdyear As Byte

   _date = Makebcd(_date)
   Month = Makebcd(month)
   Year = Makebcd(year)

   I2cstart
   I2cwbyte Write_addr
   I2cwbyte _regdate
   I2cwbyte _date
   I2cstop

   I2cstart
   I2cwbyte Write_addr
   I2cwbyte _regmonth
   I2cwbyte Month
   I2cstop

   I2cstart
   I2cwbyte Write_addr
   I2cwbyte _regyear
   I2cwbyte Year
   I2cstop

End Sub

'------------------------ Serial Interrupt Lable -------------------------------
Lable:
   _read_char = Inkey()
   Buffer = Buffer + Chr(_read_char)
   Incr Count
   If Count = 10 Then
      Flag = 1
   End If
Return