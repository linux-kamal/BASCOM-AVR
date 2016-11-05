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
Reset Portd.7                                               'Lcd ON
Reset Portd.1                                               'relay off
'------------------------------------------------------------------
'------------------------------------------------------------------
'----------------------------------------
'----------- SENSORS ARE CONNECTED ON THESE PINS ------------
Sensor1 Alias Pind.2

Sensor2 Alias Pind.3
'------------------------------------------------------------

'------------------ VOICE MODULE IS CONNECTED ON THESE PINS---------------
D0 Alias Pinc.2
D1 Alias Pinc.3
D2 Alias Pinc.4
D3 Alias Pinc.5

'-------------------------------------------------------------------------
Display On
Cursor Blink
Cls
Lcd "MOTOR TEST"
Lowerline
Lcd "----------"
Wait 2
Cls

Do
   'FORWARD
   Portb.0 = 1
   Portb.1 = 0
   Portb.2 = 1
   Portb.3 = 0

   Wait 4
   'BACK
   Portb.0 = 0
   Portb.1 = 1
   Portb.2 = 0
   Portb.3 = 1

   Wait 4
   'LEFT
   Portb.0 = 0
   Portb.1 = 0
   Portb.2 = 0
   Portb.3 = 1

   Wait 4
   'RIGHT
   Portb.0 = 1
   Portb.1 = 0
   Portb.2 = 0
   Portb.3 = 0

   Wait 4
   'STOP
   Portb.0 = 0
   Portb.1 = 0
   Portb.2 = 0
   Portb.3 = 0

   Wait 4

Loop




