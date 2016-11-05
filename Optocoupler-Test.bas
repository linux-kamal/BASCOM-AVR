$regfile = "m16def.dat"
$crystal = 16000000
'$baud = 9600

Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcd = 16 * 2

Config Int0 = Falling
Enable Int0
Enable Interrupts
On Int0 Isr Nosave
Config Portd.2 = Input

Dim Int_count As Word
Int_count = 0

Cls
Lcd "test"

Do
   If Pind.2 = 0 Then
      'Cls
      'Lcd "Power Live"
   Else
      'Cls
      'Lcd "Power Down"

   End If
   'Waitms 200
Loop
End

Isr:
   Incr Int_count
   Cls
   Lcd "Interrupt"
   Lowerline
   Lcd Int_count
   Waitms 200

Return