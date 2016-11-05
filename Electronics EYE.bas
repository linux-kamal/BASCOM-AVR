$regfile = "m16def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcd = 16 * 2

Config Adc = Single , Prescaler = Auto
Start Adc

Declare Sub Password()

Magnate_sensor Alias Pind.1
Light_sensor Alias Pina.1
Ir_sensor Alias Pind.2
Relay1 Alias Porta.2
Relay2 Alias Porta.3
Relay3 Alias Porta.4

Buzzer Alias Portd.6
Button_gate Alias Pind.5
Button_home Alias Pind.0

Config Relay1 = Output
Config Relay2 = Output
Config Relay3 = Output
Keypad Alias Portc
Config Keypad = Input
Config Buzzer = Output

One Alias Pinc.0
Two Alias Pinc.1
Three Alias Pinc.2
Four Alias Pinc.3

Dim Count As Byte
Dim Array(7) As Byte , Array_index As Byte
Dim Recharge_pass As String * 6
Dim Gate_close_count As Word
Dim Temprature As Word
Dim Gate_manual_close_flag As Bit
Dim Recharge_array(5) As String * 6
Dim Index As Byte
Dim Eram_index As Eram Byte

Recharge_array(1) = "124134"
Recharge_array(2) = "231141"
Recharge_array(3) = "342112"
Recharge_array(4) = "413123"
Recharge_array(5) = "324144"

'Eram_index = 1
Index = Eram_index

Cursor Off
Cls
Lcd "      HOME     "
Lowerline
Lcd "SECURITY  SYSTEM"
Wait 3
Cls
Do

   Temprature = Getadc(0)
   Temprature = Temprature / 2

   If Temprature > 50 Then
      Sound Buzzer , 1000 , 200
   End If

   If Ir_sensor = 1 Then
      Set Buzzer
      Cls
      Lcd "SECURITY  BREACH"
      Lowerline
      Lcd "Zone : 3"
      Set Relay3                                            'GSM CAlling
      Wait 2
      Reset Relay3
      Do
      Loop
   End If

   If Magnate_sensor = 1 Then
      Cls
      Lcd "SECURITY  BREACH"
      Lowerline
      Lcd "Zone : 2"
      Set Buzzer

      Set Relay3                                            'GSM CAlling
      Wait 2
      Reset Relay3
      Do
      Loop
   End If
   If Light_sensor = 0 Then
      Set Buzzer
      Cls
      Lcd "SECURITY  BREACH"
      Lowerline
      Lcd "Zone : 1"
      Set Relay3                                            'GSM CAlling
      Wait 2
      Reset Relay3
      Do
      Loop
   End If

   If Button_gate = 0 Then
      While Button_gate = 0
         Sound Buzzer , 1000 , 200
         Locate 2 , 1
         Lcd "RING"
         Waitms 500
      Wend
   End If

   If Button_home = 0 Then
      Gate_close_count = 0
      While Button_home = 0
      Wend
         Set Relay1
         Waitms 900
         Reset Relay1

         While Ir_sensor = 0
            If Ir_sensor = 1 Then Exit While

            If Gate_close_count > 50 Then Exit While

            Incr Gate_close_count
            If Button_home = 0 Then
               While Button_home = 0
               Wend
               Exit While
            End If
            Waitms 100
         Wend
         'Wait 1
         Sound Buzzer , 1000 , 200
         Wait 2
         Set Relay2
         Waitms 900
         Reset Relay2
         Cls

   End If

   If One = 1 Or Two = 1 Or Three = 1 Or Four = 1 Then Call Password()
   Locate 1 , 1
   Lcd "  SECURITY  OK  "
   Locate 2 , 1
   Lcd "           "
   'Locate 2 , 12
   'Lcd "T:" ; Temprature ; "  "

   Waitms 300

Loop

Sub Password()
   Cls
   Count = 1
   Recharge_pass = ""
   For Count = 1 To 6
      While One = 0 And Two = 0 And Three = 0 And Four = 0
      Wend
      If One = 1 Then
         Recharge_pass = Recharge_pass + Chr(49)
         Lcd "1"
      Elseif Two = 1 Then
         Recharge_pass = Recharge_pass + Chr(50)
         Lcd "2"
      Elseif Three = 1 Then
         Recharge_pass = Recharge_pass + Chr(51)
         Lcd "3"
      Elseif Four = 1 Then
         Recharge_pass = Recharge_pass + Chr(52)
         Lcd "4"
      End If

      Incr Array_index
      Waitms 400                                            'wait is added to reduce key debouncing
      While One = 1 Or Two = 1 Or Three = 1 Or Four = 1     'INFINITE LOOP UNTIL KEY RELEASED
      Wend
   Next Count

   If Recharge_pass = Recharge_array(index) Or Recharge_pass = "234312" Then
      Gate_close_count = 0
      Cls
      Lcd " ACCESS GRANTED "
      Set Relay1
      Waitms 80
      Reset Relay1
      While Ir_sensor = 0
         If Ir_sensor = 1 Then
            Exit While
         End If
         If Gate_close_count > 50 Then
            Exit While
         End If
         Incr Gate_close_count
         Waitms 100
      Wend


      Sound Buzzer , 1000 , 200
      Wait 2
      Set Relay2
      Waitms 80
      Reset Relay2
      Cls
   Elseif Recharge_pass = "324124" Then
      Incr Index
      If Index > 5 Then Index = 1
      Eram_index = Index
      Cls
      Lcd "PASSWORD CHANGED"
      Lowerline
      Lcd Recharge_array(index)
      Wait 3
      Cls
   Else
      Cls
      Lcd " ACCESS  DENIED "
      Wait 2
      Cls
   End If

End Sub