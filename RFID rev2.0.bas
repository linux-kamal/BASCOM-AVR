$regfile = "m16def.dat"
$crystal = 8000000
$baud = 9600
Config Lcdpin = Pin , Db4 = Portc.3 , Db5 = Portc.2 , Db6 = Portc.1 , Db7 = Portc.0 , E = Portc.4 , Rs = Portc.5
Config Lcd = 16 * 2

Declare Sub Read_tag

Dim Read_id As Byte
Dim Id_1 As String * 10
Dim Id_2 As String * 10
Dim Buffer As String * 11
Dim Char_available As Byte

'Tag_1 = "55000E2B86"
'Tag_2 = "55000E209B"
Cls
Lcd "hi"
$eeprom
$data
Readeeprom Id_1 , 0
Readeeprom Id_2 , 16
Lcd Id_1
Wait 5
Lowerline
Lcd Id_2
Wait 5
Cls
Do
   Char_available = Ischarwaiting()
   If Char_available = 1 Then
      Read_tag
   Elseif Id_1 = Buffer Then
      Cls
      Lcd "Tag_1"
      Print "1"
      Buffer = ""
      'Wait 2
   Elseif Id_2 = Buffer Then
      Cls
      Lcd "Tag_2"
      Print "2"
      Buffer = ""
      'Wait 2
   End If
Loop
'==================================================
'================ Subroutines =====================
'==================================================

Sub Read_tag
    'we can loop here 10 times
    Read_id = Inkey()
    Buffer = Buffer + Chr(read_id)
    'Lcd Buffer
End Sub



End