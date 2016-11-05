'--------------------------------------------------------------------------------------------------------
'Since I have commented on evry line in a well mannered way.
'Inspite of it If there is any inconvinience you are facing regarding code/hardware feel free to ask me.@
'Contact: +91-9997088674
'Mail: kumarkamal203@gmail.com
'-------------------------------------------------------------------------------------
$regfile = "m16def.dat"                                     'MCU WE ARE USING
$crystal = 8000000                                          'MCU RUNNING ON INTERNEL CRYSTAL @ 8MHZ

'--------- LCD CONFIGURATION ACCORDING TO HARDWARE CONNECTIONS FOR MORE INFO SEE PCB DESIGN----------
Config Lcdpin = Pin , Db4 = Porta.2 , Db5 = Porta.3 , Db6 = Porta.4 , Db7 = Porta.5 , E = Porta.1 , Rs = Porta.0
Config Lcd = 16 * 2
'----------------------------------------------------------------------------------------------------
Config Portc = Input

'----------- MOTOR DRIVER INPUT PINS ARE CONNECTED HERE -----------
Config Portb.0 = Output
Config Portb.1 = Output
Config Portb.2 = Output
Config Portb.3 = Output
'------------------------------------------------------------------
Config Portd.7 = Output
Config Portd.1 = Output
'------------------------------------------------------------------

'EITHER USE PWM FOR MOTOR SPEED CONTROL OR DIRRECTLY ENABLE/DISABLE MOTOR ENA/ENB PINS

'Config Timer1 = Pwm , Pwm = 10 , Compare A Pwm = Clear Up , Compare B Pwm = Clear Up , Prescale = 8

'As we have taken 10-bit PWM the the minimum & maximum value ossilate b/w (0 to 2^10=1024)
'pwm1a=0 (motor 1 will be off )
'pwm1b=0 (motor 2 will be off )

'pwm1a=512 (motor 1 will be @ half speed )
'pwm1b=512 (motor 2 will be @ half speed )

'pwm1a=1024 (motor 1 will be @ full speed )
'pwm1b=1024 (motor 2 will be @ full speed )

'----EITHER USE ABOVE SETTINGS OR USE BELOW -----
'if you are using these settings then motor speed could not be controlled
'motors will run @ full speed so either you can stop the motor or run at full speed.

Config Portd.4 = Output
Config Portd.5 = Output
Set Portd.4                                                 'ENABLE MOTOR 1
Set Portd.5                                                 'ENABLE MOTOR 2

Reset Portd.7                                               'Lcd ON
Reset Portd.1                                               'relay
'------------------------------------------------------------------
'------------------------------------------------------------------

'----------------------------------------
'----------- SENSORS ARE CONNECTED ON THESE PINS ------------
'WHEN ANY OBJECT COMES IN FRONT OF SENSOR IT WILL BECOME 0
'IF THERE IS NO OBJECT IT WILL BE 1
Sensor1 Alias Pind.2

Sensor2 Alias Pind.3

'Sensor3 Alias Pinc.7
'------------------------------------------------------------

'------------------ VOICE MODULE IS CONNECTED ON THESE PINS---------------
D0 Alias Pinc.2
D1 Alias Pinc.3
D2 Alias Pinc.4
D3 Alias Pinc.5

'-------------------------------------------------------------------------

Dim _read As Byte
'(
CONFIG PORTB.4=INPUT
CONFIG PORTB.5=INPUT
CONFIG PORTB.6=INPUT
CONFIG PORTB.7=INPUT
')
Display On
Cursor Blink
Cls
Lcd "VOICE CONTROLLED"
Lowerline
Lcd "WHEEL CHAIR 2016"
Wait 4
Cls


'USING FOR BITS D0/D1/D2/D3 THE MAXIMUM VALUE CAN BE UPTO 2^4=16 AND HERE WE ARE USING JUST FEW LOCATIONS ON OUR VOICE MODULE BOARD
'IF YOU WANT ADD MORE ACTIONS THEN JUST ADD MORE ELSEIF CONDITIONS AND SET D0/D1/D2/D3 VALUES 0/1 ACCORDINGLY LOCATIONS PROGRAMMED ON VOICE BOARD
'SUPPOSE YOU ADDED LIGHTS ON @ 7th location (FOR 7 = 0111)
'If D3 = 0 And D2 = 1 And D1 = 1 And D0 = 1 Then
'AND @ 9th LOCATION LIGHTS OFF THEN CORRESPONDING CODE WILL ADD UP (FOR 9 = 1001 )


Do
   '----------- THESE CONDITIONS CHECKING IS FOR VOICE MODULE INPUTS -----------
   'ONE MORE THING YOU HAVE TAKE CARE OF, MOTOR WILL RUN FORWARD ONLY
   'IF THERE IS NOT ANY OBJECT INFRONT OF SENSOR1

   If D3 = 0 And D2 = 0 And D1 = 0 And D0 = 1 Then          '1

      If Sensor1 = 0 Then
      'RUN MOTOR FORWARD
      Portb.0 = 1
      Portb.1 = 0
      Portb.2 = 1
      Portb.3 = 0
      Locate 1 , 1
      Lcd "MOVING FORWARD "
      Elseif Sensor1 = 1 Then
      'STOP MOTOR
      Portb.0 = 0
      Portb.1 = 0
      Portb.2 = 0
      Portb.3 = 0
      Locate 1 , 1
      Lcd "STOP           "
      End If
   Elseif D3 = 0 And D2 = 0 And D1 = 1 And D0 = 0 Then      '2
      'RUN MOTOR BACKWARD
      If Sensor2 = 0 Then
      'RUN MOTOR BACKWARD
      Portb.0 = 0
      Portb.1 = 1
      Portb.2 = 0
      Portb.3 = 1
      Locate 1 , 1
      Lcd "MOVING BACKWARD"
      Elseif Sensor2 = 1 Then
      'STOP MOTOR
      Portb.0 = 0
      Portb.1 = 0
      Portb.2 = 0
      Portb.3 = 0
      Locate 1 , 1
      Lcd "STOP           "
      End If

   Elseif D3 = 0 And D2 = 0 And D1 = 1 And D0 = 1 Then      '3
      'RUN MOTOR LEFT
      Portb.0 = 1
      Portb.1 = 0
      Portb.2 = 0
      Portb.3 = 1
      Locate 1 , 1
      Lcd "MOVING LEFT    "

   Elseif D3 = 0 And D2 = 1 And D1 = 0 And D0 = 0 Then      '4
      'RUN MOTOR RIGHT
      Portb.0 = 0
      Portb.1 = 1
      Portb.2 = 1
      Portb.3 = 0
      Locate 1 , 1
      Lcd "MOVING RIGHT   "

   Elseif D3 = 1 And D2 = 0 And D1 = 0 And D0 = 0 Then      '8
      'RELAY ON
      Portd.1 = 1
      Locate 1 , 1
      Lcd "RELAY ON       "

   Elseif D3 = 1 And D2 = 0 And D1 = 0 And D0 = 1 Then      '9
      'RELAY OFF
      Portd.1 = 0
      Locate 1 , 1
      Lcd "RELAY OFF      "
   Else
      'STOP MOTOR IF ANY OTHER LOGIC DETECTED
      Portb.0 = 0
      Portb.1 = 0
      Portb.2 = 0
      Portb.3 = 0
      Locate 1 , 1
      Lcd "STOP           "
   End If
   '--------------------- CLOSED VOICE MODULE CHECKING -------------------------
   '----------------- ALSO CHECK SENSORS WHILE MOVING FORWARD/BACKWARD ---------
   'If any object comes infront of wheels chair while moving stop it imidiatly
   If Sensor1 = 1 Or Sensor2 = 1 Then
      'Stop Motors
      Portb.0 = 0
      Portb.1 = 0
      Portb.2 = 0
      Portb.3 = 0
      Locate 1 , 1
      Lcd "STOP           "
   End If
   'Locate 1 , 1
   'Lcd "D0:" ; D0 ; " " ; "D1:" ; D1 ; " " ; "D2:" ; D2
   'Locate 2 , 1
   'Lcd "D3:" ; D3 ; "   " ; "S1=" ; Sensor1 ; " " ; "S2=" ; ; Sensor2
   'Waitms 100
Loop

Do

   _read = Pinb And &H0F
   If _read = &H01 Then Portc = 1
   If _read = &H02 Then Portc = 3
   If _read = &H03 Then Portc = 7
   If _read = &H04 Then Portc = 15

   If _read <> &H01 And _read <> &H02 And _read <> &H03 And _read <> &H04 Then
      Portc = 255
      Waitms 50
      Portc = 0
      Waitms 50
   End If
   'Portb = Pina
   'Portb = Portb And &H0F
   Waitms 10

Loop

End