$regfile = "m16def.dat"
$crystal = 8000000
$baud = 9600

Config Lcdpin = Pin , Db4 = Portc.2 , Db5 = Portc.3 , Db6 = Portc.4 , Db7 = Portc.5 , E = Portc.1 , Rs = Portc.0
Config Lcd = 16 * 2

Sensor Alias Pina.0
Config Sensor = Input

Push_button Alias Pind.4
Config Portd.4 = Input


Declare Sub Find_a()
Declare Sub Read_lat()
Declare Sub Read_long()
Declare Sub Sendsms(mob As String , Buffer1 As String , Buffer2 As String)

Dim Gps As Byte
Dim Lat_buff As String * 9
Dim Long_buff As String * 9
Dim N_ddd As Byte , E_ddd As Byte
Dim N_mm As Byte , E_mm As Byte
Dim N_mmm As Byte , E_mmm As Byte

Dim Accident_wait_count As Byte

Dim Mobile_no1 As String * 10
Dim Mobile_no2 As String * 10
Dim Mobile_no3 As String * 10


'Mobile_no1 = "7830688489"
'Mobile_no2 = "8865814788"
'Mobile_no3 = "9012066507"

Mobile_no1 = "9568831111"
Mobile_no2 = "9634106184"
Mobile_no3 = "9457922095"

Open "comd.2:9600,8,n,1" For Input As #1

Print "ATE0" ; Chr(13) ; Chr(10)                            ' echo off
Waitms 100
Print "AT+CMGF =1" ; Chr(13) ; Chr(10)
Waitms 100
Cursor Off
Cls
Accident_wait_count = 0

Lcd "VEHICLE ACCIDENT"
Lowerline
Lcd "  ALERT SYSTEM  "
Wait 5
Cls
Do

   Startloop:
      Gps = Waitkey(#1)
      If Gps <> "$" Then Goto Startloop

      Gps = Waitkey(#1)
      If Gps <> "G" Then Goto Startloop

      Gps = Waitkey(#1)
      If Gps <> "P" Then Goto Startloop

      Gps = Waitkey(#1)
      If Gps <> "R" Then Goto Startloop

      Gps = Waitkey(#1)
      If Gps <> "M" Then Goto Startloop

      Gps = Waitkey(#1)
      If Gps <> "C" Then Goto Startloop

      Gps = Waitkey(#1)
      If Gps <> "," Then Goto Startloop

         Call Find_a
         Call Read_lat
         Call Read_long

         Locate 1 , 1
         Lcd Lat_buff ; " N"
         Locate 2 , 1
         Lcd Long_buff ; " E"
         'Wait 1


      If Sensor = 1 Then
         Cls
         Locate 1 , 1
         Lcd "ACCIDENT OCCURED"
         Do
            If Accident_wait_count < 10 And Push_button = 1 Then
               Accident_wait_count = 0
               Exit Do
            Elseif Accident_wait_count > 10 Then
               Exit Do
            End If
            Locate 2 , 1
            Lcd Accident_wait_count
            Incr Accident_wait_count
            Wait 2
         Loop

         If Accident_wait_count >= 10 Then
            Cls
            'send sms here after 10sec if no key presses
            Lcd "  SENDING  SMS  "
            If Mobile_no1 <> "" And Lat_buff <> "" And Long_buff <> "" Then
               Call Sendsms(mobile_no1 , Lat_buff , Long_buff)
            Else
               Lcd "Location Empty"
            End If
            Wait 3
            Cls
            If Mobile_no2 <> "" And Lat_buff <> "" And Long_buff <> "" Then
               Call Sendsms(mobile_no2 , Lat_buff , Long_buff)
            Else
               Lcd "Location Empty"
            End If
            Wait 3
            Cls
            If Mobile_no3 <> "" And Lat_buff <> "" And Long_buff <> "" Then
               Call Sendsms(mobile_no3 , Lat_buff , Long_buff)
            Else
               Lcd "Location Empty"
            End If
            Wait 3
            Cls
         End If
         Accident_wait_count = 0
         Cls
      End If
      'Goto Startloop

Loop

Sub Find_a()
   Do
      Gps = Waitkey(#1)
      If Gps = "A" Then Exit Do
   Loop
   Gps = Waitkey(#1)
   If Gps <> "," Then Goto Startloop
End Sub

Sub Read_lat()
   Lat_buff = ""
   Do
      Gps = Waitkey(#1)
      If Gps = "," Then Exit Do
      Lat_buff = Lat_buff + Chr(gps)
   Loop
   Gps = Waitkey(#1)
   If Gps <> "N" Then Call Read_lat
   Gps = Waitkey(#1)
   If Gps <> "," Then Call Read_lat

End Sub

Sub Read_long()
   Long_buff = ""
   Do
      Gps = Waitkey(#1)
      If Gps = "," Then Exit Do
      Long_buff = Long_buff + Chr(gps)
   Loop

End Sub

Sub Sendsms(mob As String , Buffer1 As String , Buffer2 As String)
   'Enter Text Mode
   Print "AT+CMGF=1" ; Chr(13) ; Chr(10)
   Waitms 200
   Cls
   Lcd "Sending SMS"
   Lowerline
   Lcd Mob
   Wait 1

   Print "AT+CMGS=" ; Chr(34) ; Mob ; Chr(34) ; Chr(13) ; Chr(10)
   Waitms 200

   Print "ACCIDENT OCCURED AT" ; Chr(10) ; Buffer1 ; "N" ; Chr(10) ; Buffer2 ; "E" ; Chr(26)
   'Print Buffer ; Chr(26)

   Lcd " SENT"
   Wait 2
   'Buffer1 = ""
   'Buffer2 = ""
   Cls
End Sub