'-------------------- HEADER FILES/CRYSTAL/BAUD RATE CONFIGURATION ----------------------

$regfile = "m16def.dat"
$crystal = 8000000
$baud = 9600
'------------------------------ LCD INITIALIZATION --------------------------------------
Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcd = 16 * 2
'------------------------------ I2C BUS INITIALIZATION -----------------------------------
Config Scl = Portc.0
Config Sda = Portc.1

'--------------------------- GPIO PINS CONFIGUARION --------------------------------------
Device Alias Porta.7
Config Device = Output
_ok_menu Alias Pind.2
_up Alias Pind.3
_down Alias Pind.4
_left Alias Pind.5
_right Alias Pind.6

Config Portc.3 = Output
Ir_sensor Alias Pinc.2

Config Porta.1 = Output                                     'red led
Config Porta.2 = Output                                     'green led

Portd.2 = 1
Portd.3 = 1
Portd.4 = 1
Portd.5 = 1
Portd.6 = 1
Portc.3 = 1                                                 'ir led
'----------------------------- FUNCTIONS PROTOTYPES DECLATION ---------------------------------------
Declare Function _read_all(byval _reg_addr As Byte) As Byte
Declare Sub _setday(byval Day As Byte)
Declare Sub _settime(byval Hour As Byte , Byval Minute As Byte , Byval Second As Byte)
Declare Sub _setdate(byval _date As Byte , Byval Month As Byte , Byval Year As Byte)
Declare Sub _print_data()
'--------------------------------- VARIABLES INITIALIATION -------------------------------------------
Dim Recv As Byte
Dim Red As Byte , Blue As Byte , Green As Byte
Dim Count As Byte , Var As Byte
Dim Buffer1(15) As Byte
Dim Flag As Bit

Dim Id(10) As Byte
Dim Names(10) As String * 8
Dim _date_array(10) As Byte
'---------------------------
Dim Hour As Byte , Minute As Byte , Second As Byte
Dim Alarm_hour As Byte , Alarm_minute As Byte , Alarm_second As Byte
Dim Eram_alarm_hour As Eram Byte , Eram_alarm_minute As Eram Byte , Eram_alarm_second As Eram Byte
Dim Eram_alarm_am As Eram Byte , Eram_alarm_pm As Eram Byte

Dim Am As Byte
Dim Pm As Byte
Dim Alarm_am As Byte
Dim Alarm_pm As Byte

Dim Day As Byte
Dim Year As Byte
Dim Month As Byte
Dim _date As Byte

Dim Lcd_count As Byte
Dim Set_time As Bit
Dim Set_alarm As Bit

Dim Menu_count As Byte

Dim I As Byte

Dim Array_day(7) As String * 9
Array_day(1) = "Sun"
Array_day(2) = "Mon"
Array_day(3) = "Tue"
Array_day(4) = "Wed"
Array_day(5) = "Thr"
Array_day(6) = "Fri"
Array_day(7) = "Sat"

Dim Menu_list(7) As String * 9
Menu_list(1) = "SET TIME "
Menu_list(2) = "SET ALARM"
Menu_list(3) = "SET DATE "
Menu_list(4) = "SET DAY  "

'========= DS1307 RTC chip registers addresss INITITIALIZATION =======
Const Write_addr = &HD0
Const Read_addr = &HD1
Const _regsecond = &H00
Const _regminute = &H01
Const _reghour = &H02
Const _regday = &H03
Const _regdate = &H04
Const _regmonth = &H05
Const _regyear = &H06
'----------------------------------------------------------------------------------------------------------------
Id(1) = 0
Id(2) = 0
Id(3) = 0
Id(4) = 0
Id(5) = 0
Id(6) = 0
Id(7) = 0
Id(8) = 0
Id(9) = 0
Id(10) = 0
'---------
_date_array(1) = 0
_date_array(2) = 0
_date_array(3) = 0
_date_array(4) = 0
_date_array(5) = 0
_date_array(6) = 0
_date_array(7) = 0
_date_array(8) = 0
_date_array(9) = 0
_date_array(10) = 0
'---------------------- NAMES DATABASE INITIALIZATION ----------------------------------------
Names(1) = ""
Names(2) = "TASLIM"
Names(3) = ""
Names(4) = ""
Names(5) = "KUSHAGRA"
Names(6) = ""
Names(7) = "KAMAL"
Names(8) = ""
Names(9) = ""
Names(10) = ""

Flag = 0
Count = 1
Var = 1


'----------------------------------------------------------------------------------------------------------------
            ' MAIN CODE STARTS HERE NOW
'----------------------------------------------------------------------------------------------------------------
Cls
Lcd "SRMS NEWSPAPER"
Lowerline
Lcd "VENDING MACHINE"
Wait 2
Cls
'----------------------------------------------------------------------------------------------------------------
I2cinit                                                     ' I2C INITIALIZAION
Cls                                                         'CLAER LCD
Portd = 255
Device = 0
Menu_count = 1

'Call _setday(5)
'Call _settime(13 , 40 , 0 )
'Call _setdate(7 , 4 , 16)
Waitms 500
Cursor Off Noblink                                          'LCD CURSOR OFF
Cls
Alarm_hour = Eram_alarm_hour
Waitms 50
Alarm_minute = Eram_alarm_minute
Waitms 50
Alarm_second = Eram_alarm_second
Waitms 50
Alarm_pm = Eram_alarm_pm
Waitms 50
Alarm_am = Eram_alarm_am
Waitms 50

If Alarm_hour <> 0 And Alarm_hour <> 255 Or Alarm_minute <> 0 And Alarm_minute <> 255 Or Alarm_second <> 0 And Alarm_second <> 255 Then
   Set_alarm = 1
   Lcd "<< Alarm  Set >>"
   Lowerline
   Lcd Alarm_hour ; ":" ; Alarm_minute ; ":" ; Alarm_second
   If Alarm_am = 1 Then
      Lcd " AM"
   Elseif Alarm_pm = 1 Then
      Lcd " PM"
   End If
   Wait 3
   Cls
End If
'----------------------------------------------------------------------------------------------------------------
Do
Rtc:                                                        'LABLE TO JUMP ON FROM ANYWHERE IN THE PROGRAM
   Cls
   Second = _read_all(_regsecond)                           'READING SECONDS FROM RTC DS1307
   Minute = _read_all(_regminute)                           'READING MINUTES FROM RTC DS1307
   Hour = _read_all(_reghour)                               'READING HOURS FROM RTC DS1307
   '----------------------- CHECK FOR AM/PM FORMAT GREATER OR LESS THAN 12/24 -------------------------------
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
   Year = _read_all(_regyear)
   Month = _read_all(_regmonth)
   _date = _read_all(_regdate)
   Call _print_data()
   Wait 5                                                   '5 SECONDS DELAY
'------------------ CHECKING FOR BUTTONS PRESSED CONDITION ---------------------------------
Lable1:
   If _up = 0 Then                                          'IF WE PRESS UPPER PUSH BUTTON
      While _up = 0
      Wend
      If Day < 7 Then Day = Day + 1
      If _date < 31 Then _date = _date + 1
      'If Month < 12 Then Month = Month + 1
      'Year = Year + 1
      Call _setday(day)
      Call _setdate(_date , Month , Year)
      Goto Rtc
   End If
   If _down = 0 Then                                        'IF WE PRESS DOWN PUSH BUTTON
      While _down = 0
      Wend
      If Day > 1 Then Day = Day - 1
      If _date > 1 Then _date = _date - 1
      'If Month > 1 Then Month = Month - 1
      'Year = Year - 1
      Call _setday(day)
      Call _setdate(_date , Month , Year)
      Goto Rtc
   End If
'----------------------------- BIOMETRIC MODULE R305 STARTS HERE FOR COLLECTING FINGER IMAGES--------------
   Restore Genimg
   Read Blue                                                'READ THE R305 COMMAND FOR GENERATION IMAGE FROM GIVEN LABLES AT BOTTOM SIDE OF CODE
   For Red = 1 To Blue
      Read Green : Printbin Green;                          'PRINTBIN IS USED TO SEND DATA SERIALLY TO THE R305 MODULE
   Next
   Count = 1
   Flag = 0                                                 'DO LOOP STARTS HERE
   Do                                                       'WAITKEY IS USED TO READ DATA FROM SERIAL PIN [RX] INTO RECV VARIABLE OF BYTE SIZE
      Recv = Waitkey()
     If Recv = 239 Or Flag = 1 Then
         Flag = 1
         Buffer1(count) = Recv                              ' PUT RECV DATA INTO A BUFFER
         Incr Count
         Locate 2 , 1
         Lcd Count
         If Count >= 9 Then Exit Do                         'IF COUNTING IS GREARTER THAN 9 THEN EXITS THE DO LOOP
      End If
   Loop

   If Buffer1(8) = 12 Then                                  'CHECK IF BUFFER VALUE AT 8TH LOCATION IS 12 THEN FINGER NOT DETECTED
      Porta.1 = 1
      Porta.2 = 0
      Cls
      Lcd "NO FINGER MATCH"
      Goto Lable1
   Elseif Buffer1(8) = 10 Then                              'CHECK IF BUFFER VALUE AT 8TH LOCATION IS 10 THEN FINGER NOT DETECTED
      'Cls
      'Lcd "FINGER DETECTED"
      '--------------------------------------------------------
      '--------------------- GENRATE TEMPLATE NOW FROM DETECTED FINGER IMAGE -------------------------
      Restore Img2tz                                        'READ COMMAND FOR TEMPALTE GENERATION                                      '
      Read Blue
      For Red = 1 To Blue
         Read Green : Printbin Green;                       'SEND COMMANDS TO R305 SERIALLY
      Next
      Flag = 0
      Count = 1
      Do
         Recv = Waitkey()
         Buffer1(count) = Recv
         Incr Count
         If Count >= 12 Then Exit Do
      Loop

      If Buffer1(10) = 1 Or Buffer1(10) = 6 Or Buffer1(10) = 7 Or Buffer1(10) = 15 Then
         Cls
         Lcd "TEMPLATE FAILED"
         Wait 1
         Cls
         Goto Lable1
      Elseif Buffer1(10) = 0 Then
         'Cls
         'Lcd "TEMPLATE SUCCESS"
         'Wait 1
         '---------------- SERACH FOR FINGER IN THE R305 FLASH LIBRARY -------------------------
         Restore Hispeedsearch
         Read Blue
         For Red = 1 To Blue
            Read Green : Printbin Green;
         Next
         Flag = 0
         Count = 1
         Do                                                 ' DO LOOP STARTS HERE
            Recv = Waitkey()
            'If Recv = 7 Or Flag = 1 Then
               Flag = 1
               Buffer1(count) = Recv                        'READ WHOLE DATA GETTING FROM R305 INTO BUFFER1 INCLUDING [ID]
               'Locate 2 , 1
               'Lcd Count
            'End If
            Incr Count
            If Count >= 15 Then Exit Do                     'IF RECEIVE CAHRACTER COUNT IS GRAETER TAHN 15 THEN EXIT DO LOOP
         Loop                                               ' DO LOOP ENDS HERE
         'Cls
         'Lcd Buffer1(13)
         'Wait 1

            If Buffer1(11) = 0 Then                         'NOW CHECK BUUFER1 AT 11TH LOCATION FOR CORRECT FINGER MATCH
               Porta.1 = 0
               Porta.2 = 1
               Cls
               Lcd "MATCH FOUND"
               Lowerline
               'Lcd "ID:" ; Buffer1(13)
               'Lowerline
               Lcd "Hello: " ; Names(buffer1(13))
               Wait 2
                'If Id(buffer1(13)) = 0 Then
                If _date_array(buffer1(13)) <> _date Then   'NOW READ CORRECT [ID] NUMBER FROM BUFFER1
                  _date_array(buffer1(13)) = _date
                 'Id(buffer1(13)) = 1
                  Cls
                  Lcd "AUTHORIZED ACCESS  "
                  Locate 2 , 1
                  Lcd "SENSOR:" ; Pinc.2
                  While Pinc.2 = 0
                  Wend
                  Device = 1
                  Locate 2 , 1
                  Lcd "SENSOR:" ; Pinc.2
                  While Pinc.2 = 1
                     If Pinc.2 = 0 Then Exit While
                  Wend
                  Locate 2 , 1
                  Lcd "SENSOR:" ; Pinc.2
                  Device = 0
                  Wait 1
                Else
                  Cls
                  Lcd "UNAUTHORIZED ACCESS"
                  Device = 0
                  Wait 1
                End If
               Goto Lable1
            Else
               Goto Lable1

            End If

      End If

   End If

   '---------------------------------------
   Wait 1
Loop
'---------------------- MAIN PROGRAM ENDS HERE ---------------------------------

Lable:
      Recv = Inkey()
      Buffer1(count) = Recv

      Locate 1 , 1
      Lcd Buffer1(count) ; "  "

      Locate 2 , 1
      Lcd Recv ; "  "

      Locate 2 , 9
      Lcd Count ; "  "

      Incr Count

Return
'----------------------------------------------------------------------------------------------------------------
Sub _print_data()
   Locate 1 , 1
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

   Locate 1 , 10
   If Am = 1 Then
      Lcd "AM"
   Elseif Pm = 1 Then
      Lcd "PM"
   End If

   Locate 2 , 1
   Lcd _date ; "/" ; Month ; "/" ; Year
   Lcd "     " ; Array_day(day)
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
'----------------------------------------------------------------------------------------------------------------
'REFER  TO DATA SHEET OF R305 FOR BEETER UNDERSTANDING
Genimg:
Data 12 , &HEF , &H1 , &HFF , &HFF , &HFF , &HFF , &H1 , &H0 , &H3 , &H1 , &H0 , &H5

Img2tz:
Data 13 , &HEF , &H1 , &HFF , &HFF , &HFF , &HFF , &H1 , &H0 , &H4 , &H2 , &H1 , &H0 , &H8

Img2tz1:
Data 13 , &HEF , &H1 , &HFF , &HFF , &HFF , &HFF , &H1 , &H0 , &H4 , &H2 , &H2 , &H0 , &H9

Hispeedsearch:
Data 17 , &HEF , &H1 , &HFF , &HFF , &HFF , &HFF , &H1 , &H0 , &H8 , &H4 , &H1 , &H0 , &H0 , &H0 , &HA , &H0 , &H18