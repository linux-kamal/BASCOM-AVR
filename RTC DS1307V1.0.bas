$regfile = "m16def.dat"
$crystal = 16000000

Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcd = 16 * 2

'Config Portc = Output
Config Scl = Portc.0
Config Sda = Portc.1
I2cinit
Const Write_addr = &HD0
Const Read_addr = &HD1
Dim Hour As Byte , Minute As Byte , Second As Byte
Declare Sub Udate_min_and_second

Cls
Lcd "RTC DS1307 Test"
Wait 1
Hour = 0
Minute = 0
Second = 0
'================ write section =======================
'(
I2cstart
I2cwbyte Write_addr                                         'slave address
I2cwbyte 2                                                  'address of register location in RTC
I2cwbyte 10                                                 'value to write
Waitms 10
I2cstop
')
'=============== read section =========================

Do

   I2cstart
   I2cwbyte Write_addr                                      'slave address
   I2cwbyte 0                                               'address of register to be read
   'repeated start
   I2cstart
   I2cwbyte Read_addr                                       'slave address
   I2crbyte Second , Ack
      If Second > 59 Then
         'Udate_min_and_second
         Second = 0

      End If
   I2crbyte Minute , Ack
   I2crbyte Hour , Nack
   I2cstop

   'Var1 = Makedec(var1)
   Cls
   Lcd "Data Read"
   Lowerline
   Lcd Hour ; ":" ; Minute ; ":" ; Second ; " PM"
   Waitms 700
   Cls
Loop
'============ Subroutines =============================
'(
Sub Udate_min_and_second
   I2crbyte Minute , Ack
   Incr Minute
   ' condition start to update seconds and minute
   Second = 0
   I2cstart
   I2cwbyte Write_addr                                      'slave address
   I2cwbyte 0                                               'address of register location in RTC
   I2cwbyte Second                                          'value to write
   'Waitms 10
   I2cstop
   I2cstart
   I2cwbyte Write_addr                                      'slave address
   I2cwbyte 1                                               'address of register location in RTC
   I2cwbyte Minute                                          'value to write
   'Waitms 10
   I2cstop
End Sub
')
End