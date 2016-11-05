$regfile = "m16def.dat"                                     'ATMEGA 32 MICROCONTROLLER
$crystal = 16000000                                         '16MHz CRYSTAL

Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0       'LCD PIN DECLARATION
Config Lcd = 16 * 2                                         'LCD TYPE

Dim A As Byte
Dim B As String * 10

$eeprom
$data

Cls
'Readeeprom B , Label1
Readeeprom B , 0
Lcd B

B = "55000E2B86"

Writeeeprom B , 0

B = "55000E209B"

Wait 1

Writeeeprom B , 16
'B = "Gangwar"
'Writeeeprom B , 8

End