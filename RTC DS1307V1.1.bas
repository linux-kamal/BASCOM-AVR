'===============================================================================
'===============================================================================
'Author : Kamal Babu <kumarkamal203ATgmailDOTcom>
'About  : DS1307 RTC chip demo code
'Date   : 08/06/14
'Time   : 10:46 AM
'===============================================================================
'===============================================================================

$regfile = "m16def.dat"
$crystal = 16000000

'Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcdpin = Pin , Rs = Portd.0 , E = Portd.1 , Db4 = Portd.2 , Db5 = Portd.3 , Db6 = Portd.4 , Db7 = Portd.5
Config Lcd = 16 * 2

'Config Portc = Output
Config Scl = Portc.0
Config Sda = Portc.1

_ok_menu Alias Pinb.0
_up Alias Pinb.1
_down Alias Pinb.2
_left Alias Pinb.3
_right Alias Pinb.4

'======= Subroutines/ Functions  Declarations =============
Declare Function _readsec() As Byte
Declare Function _readmin() As Byte
Declare Function _readhrs() As Byte
Declare Function _readday() As Byte
Declare Function _readyear() As Byte
Declare Function _readmonth() As Byte
Declare Function _readdate() As Byte

Declare Sub _setday(byval Day As Byte)
Declare Sub _settime(byval Hour As Byte , Byval Minute As Byte , Byval Second As Byte)
Declare Sub _setdate(byval _date As Byte , Byval Month As Byte , Byval Year As Byte)
Declare Sub _print_data()

'=========== Variables Declarations ===============

Dim Hour As Byte , Minute As Byte , Second As Byte
Dim Day As Byte
Dim Year As Byte
Dim Month As Byte
Dim _date As Byte
Dim Am As Bit
Dim Pm As Bit
Dim Lcd_count As Byte
'Dim Right_count As Byte


Dim Array_day(7) As String * 9
Array_day(1) = "Sunday"
Array_day(2) = "Monday"
Array_day(3) = "Tuesday"
Array_day(4) = "Wednesday"
Array_day(5) = "Thrusday"
Array_day(6) = "Friday"
Array_day(7) = "Saturday"

'========= DS1307 RTC chip registers addresss =======
Const Write_addr = &HD0
Const Read_addr = &HD1
Const _regsecond = &H00
Const _regminute = &H01
Const _reghour = &H02
Const _regday = &H03
Const _regdate = &H04
Const _regmonth = &H05
Const _regyear = &H06

'====== Main Starts here =====================
I2cinit
Cls
Lcd "Real Time Clock"
Wait 1
Cls


'Call _setday(1)
'Call _settime(21 , 55 , 0 )
'Call _setdate(26 , 10 , 14)
Portb = 255

Do


   If _ok_menu = 0 Then

      While _ok_menu = 0
      Wend
      Cls

      Cursor On Blink
      Locate 1 , 1
      'Lcd Hour ; ":" ; Minute ; ":" ; Second
      Call _print_data()
      Locate 1 , 1
      Lcd_count = 1
      Do


         If _left = 0 Then
            While _left = 0
            Wend
            Shiftcursor Left
            'Waitms 10
            'Shiftcursor Left
            Decr Lcd_count

         End If

         If _right = 0 Then
            While _right = 0
            Wend
            Shiftcursor Right
            'Waitms 10
            'Shiftcursor Right
            Incr Lcd_count

         End If

         If _up = 0 Then
            While _up = 0
            Wend
            Select Case Lcd_count
            Case Is <= 2:
                           Incr Hour
                           If Hour >= 1 And Hour <= 12 Then
                              Locate 1 , 1
                              If Hour < 10 Then
                                 Lcd "0" ; Hour
                              Else
                                 Lcd Hour
                              End If
                              Locate 1 , 1
                           Elseif Hour > 12 Then
                              Hour = 12
                           Elseif Hour < 1 Then
                              Hour = 1
                           End If
            Case 4 To 5:

                           Incr Minute
                           If Minute >= 1 And Minute <= 60 Then
                              Locate 1 , 4
                              If Minute < 10 Then
                                 Lcd "0" ; Minute
                              Else
                                 Lcd Minute
                              End If
                              Locate 1 , 4
                           Elseif Minute > 60 Then
                              Minute = 60
                           Elseif Minute < 1 Then
                              Minute = 1
                           End If
            Case 7 To 8:
                           Incr Second
                           If Second >= 1 And Second <= 60 Then
                              Locate 1 , 7
                              If Second < 10 Then
                                 Lcd "0" ; Second
                              Else
                                 Lcd Second
                              End If
                              Locate 1 , 7
                           Elseif Second > 60 Then
                              Second = 60
                           Elseif Second < 1 Then
                              Second = 1
                           End If
            Case 10 To 11:
                           Toggle Am
                           Toggle Pm
                           Locate 1 , 10
                           If Am = 1 Then
                              Lcd "AM"
                           Elseif Pm = 1 Then
                              Lcd "PM"
                           End If
                           Locate 1 , 10
            End Select


         End If

         If _down = 0 Then
            While _down = 0
            Wend
            Select Case Lcd_count
            Case Is <= 2:
                           Decr Hour
                           If Hour >= 1 And Hour <= 12 Then
                              Locate 1 , 1
                              If Hour < 10 Then
                                 Lcd "0" ; Hour
                              Else
                                 Lcd Hour
                              End If
                              Locate 1 , 1
                           Elseif Hour > 12 Then
                              Hour = 12
                           Elseif Hour < 1 Then
                              Hour = 1
                           End If
            Case 4 To 5:
                           Decr Minute
                           If Minute >= 1 And Minute <= 60 Then
                              Locate 1 , 4
                              If Minute < 10 Then
                                 Lcd "0" ; Minute
                              Else
                                 Lcd Minute
                              End If
                              Locate 1 , 4
                           Elseif Minute > 60 Then
                              Minute = 60
                           Elseif Minute < 1 Then
                              Minute = 1
                           End If
            Case 7 To 8:
                           Decr Second
                           If Second >= 1 And Second <= 60 Then
                              Locate 1 , 7
                              If Second < 10 Then
                                 Lcd "0" ; Second
                              Else
                                 Lcd Second
                              End If
                              Locate 1 , 7
                           Elseif Second > 60 Then
                              Second = 60
                           Elseif Second < 1 Then
                              Second = 1
                           End If

            Case 10 To 11:
                           Toggle Am
                           Toggle Pm
                           Locate 1 , 10
                           If Am = 1 Then
                              Lcd "AM"
                           Elseif Pm = 1 Then
                              Lcd "PM"
                           End If
                           Locate 1 , 10

            End Select


         End If


         '------------------ Exit from Do Loop -----------------
         If _ok_menu = 0 Then
            While _ok_menu = 0
            Wend
            Exit Do
         End If
      Loop
      Cls
      Lcd "Time Set"

      Call _settime(hour , Minute , Second )
      ' here i can call time set subroutine to set the time or i can set alarm

      Waitms 500
      Cls
      Cursor Off Blink
   End If



   Second = _readsec()
   Minute = _readmin()
   Hour = _readhrs()

   Day = _readday()
   Year = _readyear()
   Month = _readmonth()
   _date = _readdate()

   Call _print_data()

Loop

End

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
   Lcd Array_day(day)
End Sub

Function _readhrs() As Byte
   Dim _localhrs As Byte
   Am = 0
   Pm = 0
   I2cstart
   I2cwbyte Write_addr
   I2cwbyte _reghour
   'repeated start
   I2cstart
   I2cwbyte Read_addr
   I2crbyte _localhrs , Nack
   I2cstop
   _localhrs = Makedec(_localhrs)

   If _localhrs >= 1 And _localhrs <= 12 Then
      Am = 1
      Pm = 0
   Elseif _localhrs >= 13 And _localhrs <= 24 Then
      Am = 0
      Pm = 1
   End If

   If _localhrs > 12 Then                                   'If time is 13 means 1 O'CLOCK

      _localhrs = _localhrs - 12
   End If

   _readhrs = _localhrs
End Function

Function _readmin() As Byte
   Dim _localmin As Byte
   I2cstart
   I2cwbyte Write_addr
   I2cwbyte _regminute
   'repeated start
   I2cstart
   I2cwbyte Read_addr
   I2crbyte _localmin , Nack
   I2cstop
   _localmin = Makedec(_localmin)
   _readmin = _localmin

End Function

Function _readsec() As Byte
   Dim _localsec As Byte
   I2cstart
   I2cwbyte Write_addr
   I2cwbyte _regsecond
   'repeated start
   I2cstart
   I2cwbyte Read_addr
   I2crbyte _localsec , Nack
   I2cstop
   _localsec = Makedec(_localsec)
    _readsec = _localsec

End Function

Function _readday() As Byte
   Dim _localday As Byte
   I2cstart
   I2cwbyte Write_addr
   I2cwbyte _regday
   I2cstart
   I2cwbyte Read_addr
   I2crbyte _localday , Nack
   I2cstop
   _localday = Makedec(_localday)
   _readday = _localday
End Function

Function _readyear() As Byte
   Dim _localyear As Byte
   I2cstart
   I2cwbyte Write_addr
   I2cwbyte _regyear
   I2cstart
   I2cwbyte Read_addr
   I2crbyte _localyear , Nack
   I2cstop
   _localyear = Makedec(_localyear)
   _readyear = _localyear
End Function

Function _readmonth() As Byte
   Dim _localmonth As Byte
   I2cstart
   I2cwbyte Write_addr
   I2cwbyte _regmonth
   I2cstart
   I2cwbyte Read_addr
   I2crbyte _localmonth , Nack
   I2cstop
   _localmonth = Makedec(_localmonth)
   _readmonth = _localmonth
End Function

Function _readdate() As Byte
   Dim _localdate As Byte
   I2cstart
   I2cwbyte Write_addr
   I2cwbyte _regdate
   I2cstart
   I2cwbyte Read_addr
   I2crbyte _localdate , Nack
   I2cstop
   _localdate = Makedec(_localdate)
   _readdate = _localdate
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
   Dim _bcdhour As Byte
   Dim _bcdminute As Byte
   Dim _bcdsecond As Byte
   _bcdhour = Makebcd(hour)
   _bcdminute = Makebcd(minute)
   _bcdsecond = Makebcd(second)

   I2cstart
   I2cwbyte Write_addr
   I2cwbyte _reghour
   I2cwbyte _bcdhour
   I2cstop

   I2cstart
   I2cwbyte Write_addr
   I2cwbyte _regminute
   I2cwbyte _bcdminute
   I2cstop

   I2cstart
   I2cwbyte Write_addr
   I2cwbyte _regsecond
   I2cwbyte _bcdsecond
   I2cstop
End Sub

Sub _setdate(byval _date As Byte , Byval Month As Byte , Byval Year As Byte)
   Dim _bcddate As Byte
   Dim _bcdmonth As Byte
   Dim _bcdyear As Byte
   _bcddate = Makebcd(_date)
   _bcdmonth = Makebcd(month)
   _bcdyear = Makebcd(year)

   I2cstart
   I2cwbyte Write_addr
   I2cwbyte _regdate
   I2cwbyte _bcddate
   I2cstop

   I2cstart
   I2cwbyte Write_addr
   I2cwbyte _regmonth
   I2cwbyte _bcdmonth
   I2cstop

   I2cstart
   I2cwbyte Write_addr
   I2cwbyte _regyear
   I2cwbyte _bcdyear
   I2cstop

End Sub