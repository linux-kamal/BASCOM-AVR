$regfile = "m16def.dat"
$crystal = 8000000
$baud = 9600

Config Lcdpin = Pin , Rs = Porta.0 , E = Porta.1 , Db4 = Porta.2 , Db5 = Porta.3 , Db6 = Porta.4 , Db7 = Porta.5
Config Lcd = 16 * 2

'Config Timer1 = Pwm , Pwm = 10 , Compare A Pwm = Clear Up , C
ompare B Pwm = Clear Up , Prescale = 8

'----------- MOTOR DRIVER INPUT PINS ARE CONNECTED HERE -----------
Config Portc.0 = Output
Config Portc.1 = Output
Config Portc.2 = Output
Config Portc.3 = Output
'------------------------------------------------------------------
Config Portd.4 = Output
Config Portd.5 = Output

Set Portd.4                                                 'ENABLE MOTOR 1
Set Portd.5                                                 'ENABLE MOTOR 2
Dim _byte As Word
Dim _speed As Word

'----------------- ULTRASONIC ROVER ---------------------------
Config Timer1 = Timer , Prescale = 8

Ultra_trigger Alias Portb.0
Ultra_echo Alias Pinb.1
Config Ultra_trigger = Output
Dim Temp As Word

Display On
Cursor Off
Cls
Lcd "   ULTRASONIC   "
Lowerline
Lcd "SENSOR INTERFACE"
Wait 3
Cls
Do
   Set Ultra_trigger
   Waitus 10
   Reset Ultra_trigger
   'Cls
   'Lcd "waiting for high edge"
   Bitwait Ultra_echo , Set
   Timer1 = 0
   Start Timer1

   Bitwait Ultra_echo , Reset
   Stop Timer1
   Temp = Timer1
   Temp = Temp / 58
   If Temp > 50 Then
      Locate 1 , 1
      Lcd "DISTANCE:OD      "
   Else

      Locate 1 , 1
      Lcd "DISTANCE:" ; Temp ; "CM   "

      If Temp > 25 And Temp < 30 Then
         'SPEED UP++
         Locate 2 , 1
         Lcd "SPEED UP++   "
      Elseif Temp > 20 And Temp < 25 Then
         'SPEED UP+
         Locate 2 , 1
         Lcd "SPEED UP+    "
      Elseif Temp > 15 And Temp < 20 Then
         'SPEED DOWN
         Locate 2 , 1
         Lcd "SPEED DOWN-  "
      Elseif Temp > 10 And Temp < 15 Then
         'SPEED DOWN
         Locate 2 , 1
         Lcd "SPEED DOWN-- "
      Elseif Temp <= 10 Then
         'STOP
         Locate 2 , 1
         Lcd "STOP VEHICLE "
      End If

   End If
   Waitms 100
Loop

'----------------- DTMF CONTROLLED LAND ROVER ---------------------------
Display On
Cursor Off
Cls
Lcd "DTMF CONTROLLED"
Lowerline
Lcd "   SPY ROVER    "
Wait 3
Cls

Do
   If Pinb.0 = 0 And Pinb.1 = 0 And Pinb.2 = 1 And Pinb.3 = 0 Then
      ' 2 Forward
      Locate 1 , 1
      Lcd " MOVING FORWARD "
      Portc.0 = 1
      Portc.1 = 0
      Portc.2 = 1
      Portc.3 = 0

   Elseif Pinb.0 = 1 And Pinb.1 = 0 And Pinb.2 = 0 And Pinb.3 = 0 Then
      ' 8 Backward
      Locate 1 , 1
      Lcd " MOVING BACKWARD"
      Portc.0 = 0
      Portc.1 = 1
      Portc.2 = 0
      Portc.3 = 1

   Elseif Pinb.0 = 0 And Pinb.1 = 1 And Pinb.2 = 0 And Pinb.3 = 0 Then
      ' 4 Left
      Locate 1 , 1
      Lcd "  MOVING LEFT  "
      Portc.0 = 1
      Portc.1 = 0
      Portc.2 = 0
      Portc.3 = 0

   Elseif Pinb.0 = 0 And Pinb.1 = 1 And Pinb.2 = 1 And Pinb.3 = 0 Then
      ' 6 Right
      Locate 1 , 1
      Lcd "  MOVING RIGHT  "
      Portc.0 = 0
      Portc.1 = 0
      Portc.2 = 1
      Portc.3 = 0

   Elseif Pinb.0 = 0 And Pinb.1 = 1 And Pinb.2 = 0 And Pinb.3 = 1 Then
      ' 5 Start/Stop
      Locate 1 , 1
      Lcd "      STOP       "
      Portc.0 = 0
      Portc.1 = 0
      Portc.2 = 0
      Portc.3 = 0
   Else
      Locate 1 , 1
      Lcd "      STOP       "
      Portc.0 = 0
      Portc.1 = 0
      Portc.2 = 0
      Portc.3 = 0
   End If



Loop
'-------------------------- SPEED CHANGE OF DC MOTOR ---------------------------
Cls
Display On
Cursor Off
Lcd "SPEED CHANGE OF"
Lowerline
Lcd "DC MOTOR"
Wait 5
Cls
Pwm1a = 0
Pwm1b = 0
Portb.0 = 1
Portb.1 = 1
Portb.2 = 1

      Portc.0 = 1
      Portc.1 = 0
      Portc.2 = 1
      Portc.3 = 0
Do
   If Pinb.0 = 0 Then
      While Pinb.0 = 0
      Wend
     If _byte < 1000 Then
         _byte = _byte + 100
         _speed = _byte / 10
         Locate 1 , 1
         Lcd "SPEED:" ; _speed ; " " ; "%    "
     Else
        _byte = 1000
        _speed = 100
         Locate 1 , 1
         Lcd "SPEED:" ; _speed ; " " ; "%    "
     End If
      Pwm1a = _byte
      Pwm1b = _byte
   Elseif Pinb.1 = 0 Then
      While Pinb.1 = 0
      Wend
      If _byte <= 0 Then
         _byte = 0
         _speed = 0
         Locate 1 , 1
         Lcd "SPEED:" ; _speed ; " " ; "%    "
      Else
         _byte = _byte - 100
         _speed = _byte / 10
         Locate 1 , 1
         Lcd "SPEED:" ; _speed ; " " ; "%    "
      End If
      Pwm1a = _byte
      Pwm1b = _byte
   Elseif Pinb.2 = 0 Then
      While Pinb.2 = 0
      Wend
      Pwm1a = 0
      Pwm1b = 0
      Locate 1 , 1
      Lcd "SPEED:" ; 0 ; " " ; "%    "
   End If
   Waitms 100

Loop


'-------------------- BLUETOOTH CONTROLLED LAND ROVER -------------------
Do
   _byte = Waitkey()


   If Chr(_byte) = "U" Then                                 '1

      'RUN MOTOR FORWARD
      Portc.0 = 1
      Portc.1 = 0
      Portc.2 = 1
      Portc.3 = 0
   Elseif Chr(_byte) = "D" Then                             '2
      'RUN MOTOR BACKWARD
      Portc.0 = 0
      Portc.1 = 1
      Portc.2 = 0
      Portc.3 = 1

   Elseif Chr(_byte) = "L" Then                             '3
      'RUN MOTOR LEFT
      Portc.0 = 1
      Portc.1 = 0
      Portc.2 = 0
      Portc.3 = 1
   Elseif Chr(_byte) = "R" Then                             '4
      'RUN MOTOR RIGHT
      Portc.0 = 0
      Portc.1 = 1
      Portc.2 = 1
      Portc.3 = 0
   Elseif Chr(_byte) = "C" Then
      'STOP MOTOR IF ANY OTHER LOGIC DETECTED
      Portc.0 = 0
      Portc.1 = 0
      Portc.2 = 0
      Portc.3 = 0
   End If

Loop