'(
   DDD° MM' SS.S"    Degrees, Minutes and Seconds
   DDD° MM.MMM'      Degrees and Decimal Minutes (GPS SEND THIS FORMAT)
   DDD.DDDDD°        Decimal Degrees

   Http://Www.csgnetwork.com/Gpscoordconv.html

   GOOGLE EARTH SEARCH FORMAT

   41°24'12.2"N 2°10'26.5"E
   'DMM TO DMS
   2900.54381n = 2900°(.54381 * 60 = 32.6286) 32            '(.6286 * 60 = 37.7) 38 ""

')
$regfile = "m16def.dat"
$baud = 9600
$crystal = 16000000

Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcd = 16 * 2
Declare Sub Find_a()
Declare Sub Read_lat()
Declare Sub Read_long()
'On Urxc Lable
'Enable Interrupts
'Enable Urxc

Dim Gps As Byte
Dim Lat_buff As String * 9
Dim Long_buff As String * 9
Dim N_ddd As Byte , E_ddd As Byte
Dim N_mm As Byte , E_mm As Byte
Dim N_mmm As Byte , E_mmm As Byte

Open "comd.2:9600,8,n,1" For Input As #1

Cls
Cursor Off
Lcd "GPS"
Wait 1
Cls

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
      Lcd Lat_buff ; " N°"
      Locate 2 , 1
      Lcd Long_buff ; " E°"
      Wait 1
      Goto Startloop

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