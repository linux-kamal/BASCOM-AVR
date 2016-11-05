$regfile = "m16def.dat"
$crystal = 16000000

Config Lcdpin = Pin , Rs = Portb.0 , E = Portb.1 , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5
Config Lcd = 16 * 2
Config Scl = Portc.0
Config Sda = Portc.1

'=========================== Subroutines =======================================
Declare Sub Write_eeprom()
Declare Sub Read_eeprom()

'  EEPROM address { 1010+A2A1A0+R/W } = 1010 000 1/0 In Case address lines are ground
'  write = 1010 0000
Const W_addr = &HA0
'  read = 1010 0001
Const R_addr = &HA1

'============================ Variables ========================================
Dim Value As Byte
Dim Wchar As String * 1
Dim Rchar As String * 1
Wchar = "A"
'========================= Main Starts Here ====================================
I2cinit
Cls
Lcd "EEPROM"
Lowerline
Lcd "AT24C64"
Wait 1
Cls

'Do




   Lcd "value = " ; Chr(value)

'Loop
End

'========================== Write EEPROM =======================================
Sub Write_eeprom()
   I2cstart
   I2cwbyte W_addr
   I2cwbyte 0                                               'H asdress of EEPROM
   I2cwbyte 1                                               'L asdress of EEPROM
   I2cwbyte Wchar                                           'value to write
   I2cstop
   Waitms 100

End Sub
 
'========================== Read EEPROM ========================================
Sub Read_eeprom()
   I2cstart
   I2cwbyte W_addr
   I2cwbyte 0
   I2cwbyte 1
   I2cstart
   I2cwbyte R_addr

   I2crbyte Value , Ack
   I2cstop
   Waitms 100

End Sub
