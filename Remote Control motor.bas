'PWM CHANNEL USED ---> PORTB.1

'MOTOR INPUT1 -------> PORTC.0
'MOTOR INPUT2 -------> PORTC.1


'38Khz IR Receiver --->PORTD.2
'-------------------------------------------------------------------------------


$regfile = "m8def.dat"                                      'ATMEGA 8 MCU
$crystal = 8000000                                          '8MHz CRYSTAL
$baud = 2400

Config Timer1 = Pwm , Pwm = 10 , Compare A Pwm = Clear Down , Prescale = 1

Enable Compare1a


Config Rc5 = Pind.2                                         ' Pin for RC5 data receive

Config Portc = Output                                       'PORTC = OUTPUT FOR MOTOR

Config Portb.1 = Output                                     'PWM OUTPUT PORT

Enable Interrupts                                           'Enable Interrupts for Receiving RC5
'---------------------------VARIABLE DECLARATION--------------------------------
Dim Address As Byte , Command As Byte
Dim Speed As Word , Speed_e As Eram Word

'-------------------------------------------------------------------------------

'Stop
Portc = 0                                                   'Stop  motor

Pwm1a = 0                                                   'Stop Motor


Speed = Speed_e                                             'Read Value of Speed from EEPROM


Do

   Command = 0

   Getrc5(address , Command)                                'Receive RC5 Signal from Sensor

   If Address = 0 Then
      Command = Command And &B01111111                      'Remove Last Bit From Received Command
      Print Command


      Pwm1a = 0                                             'Stop Motor



         If Command = 32 Then

         'START ROTATING FORWARD

         Portc = 1
         Pwm1a = Speed

         Elseif Command = 33 Then

         'START ROTATING REVERSE
         Portc = 2
         Pwm1a = Speed


         Elseif Command = 1 Then
         'Decriment speed by 10
         Pwm1a = Speed

               If Speed > 10 Then
               Speed = Speed - 10
               Speed_e = Speed

               'else (use led for indication that speed is minimum)

               End If
         Pwm1a = Speed


         Elseif Command = 2 Then

         Pwm1a = Speed
               If Speed < 10 Then

               Speed = Speed + 10
               'Portc = 10
               Speed_e = Speed

               'Else (use led for indication that speed is maximum)
               End If
         Pwm1a = Speed

         Elseif Command = 0 Then                            'Reset Speed to default speed
         Speed = 800
         Speed_e = Speed                                    'Write value of speed into EEPROM


         Else
         'Stop
         Portc = 0
         Pwm1a = 0

         End If
   End If

Loop



End                                                         'PROGRAM ENDS HERE