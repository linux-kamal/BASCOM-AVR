$regfile = "m16def.dat"
$crystal = 8000000
$baud = 9600
'----------------------------------------------------------------------------------------------------------------
Config Lcdpin = Pin , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7 , E = Porta.1 , Rs = Porta.0
Config Lcd = 16 * 2


Dim Flag As Byte , Count As Byte
Dim Red As Byte , Blue As Byte , Green As Byte
Dim Recv As Byte
Cls



Do

   Restore Genimg
   Read Blue
   For Red = 1 To Blue
      Read Green : Printbin Green;
   Next
   Wait 1

   Restore Img2tz
   Read Blue
   For Red = 1 To Blue
       Read Green : Printbin Green;
   Next
   Wait 1
'-------------------------------------
   Restore Hispeedsearch
   Read Blue
   For Red = 1 To Blue
       Read Green : Printbin Green;
   Next
   Wait 5

Loop

Genimg:
Data 12 , &HEF , &H1 , &HFF , &HFF , &HFF , &HFF , &H1 , &H0 , &H3 , &H1 , &H0 , &H5

Img2tz:
Data 13 , &HEF , &H1 , &HFF , &HFF , &HFF , &HFF , &H1 , &H0 , &H4 , &H2 , &H1 , &H0 , &H8

Img2tz1:
Data 13 , &HEF , &H1 , &HFF , &HFF , &HFF , &HFF , &H1 , &H0 , &H4 , &H2 , &H2 , &H0 , &H9

'Hispeedsearch:
'Data 17 , &HEF , &H1 , &HFF , &HFF , &HFF , &HFF , &H1 , &H0 , &H8 , &H1B , &H1 , &H0 , &H0 , &H1 , &H1 , &H0 , &H27

Hispeedsearch:
Data 17 , &HEF , &H1 , &HFF , &HFF , &HFF , &HFF , &H1 , &H0 , &H8 , &H4 , &H1 , &H0 , &H0 , &H0 , &HA , &H0 , &H18
