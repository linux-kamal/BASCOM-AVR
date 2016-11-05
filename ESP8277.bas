$regfile = "m16def.dat"
$baud = 9600
$crystal = 16000000

Config Lcdpin = Pin , Db4 = Portb.4 , Db5 = Portb.5 , Db6 = Portb.6 , Db7 = Portb.7 , E = Portb.2 , Rs = Portb.1
Config Lcd = 16 * 2

Dim Recv_data As Byte

'On Urxc Lable
'Enable Interrupts
'Enable Urxc


Cls
Cursor Off
Lcd "    WI-FI   "
Wait 1

Cls
'Print "AT" ; Chr(10) ; Chr(13)

Do
      Recv_data = Waitkey()
      If Recv_data < 128 Then
      'Buffer = Buffer + Chr(recv_data)
      Lcd Chr(recv_data)

      End If


Loop


Lable:

   Recv_data = Inkey()
      If Recv_data < 128 Then
      'Buffer = Buffer + Chr(recv_data)
      Lcd Recv_data ; " "

      End If
Return