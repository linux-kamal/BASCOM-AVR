
'--------------------------HARDWARE INITIALIZATION------------------------------

$regfile = "m16def.dat"                                     'ATMEGA 32 MICROCONTROLLER
$crystal = 16000000                                          '16MHz CRYSTAL
$baud = 9600

Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0       'LCD PIN DECLARATION
Config Lcd = 16 * 2
Config Porta = Output                                       'LCD TYPE

Dim A As Byte , X As Byte
Dim Buffer As String * 11
Dim Kamal As String * 11
Dim Babu As String * 11
Dim Rev_babu As String * 11
Dim Rev_kamal As String * 11
'-------------------------------------------------------------------------------

Kamal = "55000E2B86"
Rev_kamal = "B8655000E2"
Babu = "55000E209B"
Rev_babu = "09B55000E2"
Cls                                                         'Clear LCD

Do
   Reset Porta.6
   Lcd "    Show Me"                                        'Write on LCD
   Lowerline
   Lcd "   Your Card"
   Buffer = ""
   X = 1
   While X < 11
      A = Waitkey()
      Buffer = Buffer + Chr(a)
      'T = Ischarwaiting()
      'Print Chr(a)
      'Lcd A
      Incr X
   Wend
   Cls
   If Buffer = Kamal Then
      Lcd "Hello KAMAL"
      Set Porta.6
   Elseif Buffer = Rev_kamal Then
      Lcd "Hello REV_KAMAL"
      Set Porta.6
   Elseif Buffer = Babu Then
      Lcd "Hello BABU"
      Set Porta.6
   Elseif Buffer = Rev_babu Then
      Lcd "Hello REV_BABU"
      Set Porta.6
   Else
      Lcd "Record Not Found"
      Lowerline
      Lcd "   Try Again"
   End If
   Waitms 800
   Cls
Loop
End                                                         'PROGRAM ENDS HERE