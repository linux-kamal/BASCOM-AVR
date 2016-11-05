$regfile = "m16def.dat"
$crystal = 8000000
$baud = 9600
Config Lcdpin = Pin , Db4 = Porta.2 , Db5 = Porta.3 , Db6 = Porta.4 , Db7 = Porta.5 , E = Porta.1 , Rs = Porta.0
Config Lcd = 16 * 2

Config Kbd = Portb , Debounce = 50 , Delay = 100

_ok Alias Pind.3
_up Alias Pind.4
_dn Alias Pind.6
_lt Alias Pind.2
_rt Alias Pind.5

Device Alias Portc.2
Config Device = Output
'-------------------------------------------------------------------------------
Declare Sub Amount()
'-------------------------------------------------------------------------------
Dim Keypad As Byte
Dim Amount_value As String * 5

Dim Recv As Byte
Dim Red As Byte , Blue As Byte , Green As Byte
Dim Count As Byte , Var As Byte
Dim Buffer1(15) As Byte
Dim Flag As Bit

Dim Id(10) As Byte
Dim Names(10) As String * 8
Dim Money(10) As Word

Dim Money1 As Eram Word
Dim Money2 As Eram Word
Dim Money3 As Eram Word
Dim Money4 As Eram Word
Dim Money5 As Eram Word

Names(1) = "KAMAL"
Names(2) = "BASSOYA"
Names(3) = "KAMBOJ"
Names(4) = "NIKHIL"
Names(5) = "ROBIN"
Names(6) = ""
Names(7) = ""
Names(8) = ""
Names(9) = ""
Names(10) = ""
'-------------------------------------------------------------------------------
Money(1) = Money1
Money(2) = Money2
Money(3) = Money3
Money(4) = Money4
Money(5) = Money5
'(
Money1 = Money(1)
Money2 = Money(2)
Money3 = Money(3)
Money4 = Money(4)
Money5 = Money(5)
')
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
Portd.2 = 1
Portd.3 = 1
Portd.4 = 1
Portd.5 = 1
Portd.6 = 1
'-------------------------------------------------------------------------------

Display On
Cursor Off
Cls
Lcd "  BIOMETRIC ATM  "
Wait 3
Jump:
Cls
Lcd "  1:SBI  2:PNB  "
Lowerline
Lcd "  3:HDFC 4:ALB  "
Do
      Keypad = Getkbd()
      If Keypad <> 16 Then
         Keypad = Lookup(keypad , Table)
         Locate 2 , 16
         Lcd Keypad
         Waitms 150
         Exit Do
      End If
Loop
   If Keypad = 1 Then
      Cls
      Lcd "SBI Welcomes You"
      Wait 2
   Elseif Keypad = 2 Then
      Cls
      Lcd "PNB Welcomes You"
      Wait 2
   Elseif Keypad = 3 Then
            Cls
            Lcd "HDFC Welcomes You"
            Wait 2
         Elseif Keypad = 4 Then
            Cls
            Lcd "ALB Welcomes You"
            Wait 2
         Else
            Cls
            Lcd "Invalid Selection"
            Lowerline
            Lcd "    Try Again    "
            Wait 2
            Cls
            Goto Jump
   End If
Cls
Lcd "Please Put Your"
Lowerline
Lcd "    Finger    "
Do

Lable1:
   '----------------------------------------------------------------------------
   Restore Genimg
   '-------------- SEND --------------------
   Read Blue
   For Red = 1 To Blue
      Read Green : Printbin Green;
   Next
   Count = 1
   Flag = 0
   Do
      Recv = Waitkey()
      If Recv = 239 Or Flag = 1 Then
         Flag = 1
         Buffer1(count) = Recv
         Incr Count
         Locate 2 , 1
         Lcd Count
         If Count >= 9 Then Exit Do
      End If
   Loop

   If Buffer1(8) = 12 Then
      Porta.1 = 1
      Porta.2 = 0
      Cls
      Lcd "  Finger Match  "
      Lowerline
      Lcd "    Not Found   "
      Goto Lable1
   Elseif Buffer1(8) = 10 Then
      'Cls
      'Lcd "FINGER DETECTED"
      '--------------------------------------------------------
      '--------------------- GEN TEMP -------------------------
      Restore Img2tz
      Read Blue
      For Red = 1 To Blue
         Read Green : Printbin Green;
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
         '-----------------------------------------------------
         Restore Hispeedsearch
         Read Blue

         For Red = 1 To Blue
            Read Green : Printbin Green;
         Next
         Flag = 0
         Count = 1

         Do
            Recv = Waitkey()
            'If Recv = 7 Or Flag = 1 Then
               Flag = 1
               Buffer1(count) = Recv
               'Locate 2 , 1
               'Lcd Count
            'End If
            Incr Count
            If Count >= 15 Then Exit Do
         Loop

            If Buffer1(11) = 0 Then
               Porta.1 = 0
               Porta.2 = 1
               Cls
               Lcd "Finger Match Found"
               Lowerline
               'Lcd "ID:" ; Buffer1(13)
               Lcd "Hello: " ; Names(buffer1(13))
               Wait 2
               Cls
               Call Amount()
               Cls
               Lcd Val(amount_value)
               Wait 2
               Cls
               If Money(buffer1(13)) <> 0 And Val(amount_value) <= Money(buffer1(13)) Then
                  Money(buffer1(13)) = Money(buffer1(13)) - Val(amount_value)
                  If Buffer1(13) = 1 Then Money1 = Money(buffer1(13))
                  If Buffer1(13) = 2 Then Money2 = Money(buffer1(13))
                  If Buffer1(13) = 3 Then Money3 = Money(buffer1(13))
                  If Buffer1(13) = 4 Then Money4 = Money(buffer1(13))
                  If Buffer1(13) = 5 Then Money5 = Money(buffer1(13))
                  Cls
                  Lcd "Processing..."
                  Device = 1
                  Wait 5
                  Device = 0
                  Lowerline
                  Lcd "Collect Your Amount!"
                  Wait 2
                  Cls
                  Lcd "Remaining Balance:"
                  Lowerline
                  Lcd Money(buffer1(13))
                  Wait 3
                  Cls
               Else
                  Cls
                  Lcd "Insufficient Balance"
                  Wait 2
                  Cls
               End If
            Else
               Cls
               Lcd "Please Put Your"
               Lowerline
               Lcd "    Finger    "
               Device = 0
               Wait 1
            End If
               Goto Lable1
            Else
               Goto Lable1

            End If

      End If


   '---------------------------------------
   Wait 1
Loop
'-------------------------------------------------------------------------------
Table:
Data 1 , 4 , 7 , 16 , 2 , 5 , 8 , 16 , 3 , 6 , 9 , 16 , 0 , 11 , 0 , 15 , 16
'-------------------------------------------------------------------------------
Sub Amount()
   Dim Counting As Byte
   Counting = 1
   Amount_value = ""
   Do
      Locate 1 , 1
      Lcd "Enter Amount:"
      Keypad = Getkbd()
      If Keypad <> 16 Then
         Keypad = Lookup(keypad , Table)
         Locate 2 , Counting
         Lcd Keypad
         Counting = Counting + 1
         If Keypad = 0 Then Amount_value = Amount_value + "0"
         If Keypad = 1 Then Amount_value = Amount_value + "1"
         If Keypad = 2 Then Amount_value = Amount_value + "2"
         If Keypad = 3 Then Amount_value = Amount_value + "3"
         If Keypad = 4 Then Amount_value = Amount_value + "4"
         If Keypad = 5 Then Amount_value = Amount_value + "5"
         If Keypad = 6 Then Amount_value = Amount_value + "6"
         If Keypad = 7 Then Amount_value = Amount_value + "7"
         If Keypad = 8 Then Amount_value = Amount_value + "8"
         If Keypad = 9 Then Amount_value = Amount_value + "9"
         Waitms 150
      End If
      If _ok = 0 Then
         While _ok = 0
         Wend
         Exit Do
      End If
   Loop
End Sub

'----------------------------------------------------------------------------------------------------------------
Genimg:
Data 12 , &HEF , &H1 , &HFF , &HFF , &HFF , &HFF , &H1 , &H0 , &H3 , &H1 , &H0 , &H5

Img2tz:
Data 13 , &HEF , &H1 , &HFF , &HFF , &HFF , &HFF , &H1 , &H0 , &H4 , &H2 , &H1 , &H0 , &H8

Img2tz1:
Data 13 , &HEF , &H1 , &HFF , &HFF , &HFF , &HFF , &H1 , &H0 , &H4 , &H2 , &H2 , &H0 , &H9

Hispeedsearch:
Data 17 , &HEF , &H1 , &HFF , &HFF , &HFF , &HFF , &H1 , &H0 , &H8 , &H4 , &H1 , &H0 , &H0 , &H0 , &HA , &H0 , &H18