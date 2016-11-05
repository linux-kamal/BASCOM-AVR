$regfile = "m16def.dat"
$crystal = 16000000

Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.1 , Rs = Portb.0
Config Lcd = 16 * 2

Config Kbd = Portc , Debounce = 50 , Delay = 100


Declare Sub Pass_match()

Dim Var As Byte
Dim Pass_count As Byte
Dim Pass_array(4) As Byte
Dim Set_pass(4) As Byte
Dim Flag As Bit

Set_pass(1) = 2
Set_pass(2) = 2
Set_pass(3) = 8
Set_pass(4) = 8

Flag = 0
Pass_count = 1
Cls
Lcd "Keypad Test"
Wait 1
Cls
Do

   Locate 1 , 1
   Lcd "Enter Password"
   Var = Getkbd()

   If Var <> 16 Then
      Var = Lookup(var , Table)
      'Locate 2 , Pass_count
      'Cls
      Locate 2 , 1
      Lcd Var ; " "
      'Pass_array(pass_count) = Var

      'Incr Pass_count

      'If Pass_count = 5 Then
       '  Call Pass_match
        ' Pass_count = 1
         'Cls
         'If Flag = 1 Then

            'Lcd "Password match"

         'Else

          '  Lcd "Password NOT match"

         End If

         'Wait 3
      'End If
   'Waitms 100
   'End If


Loop
End

'-------------------------------------------------------------------------------
Table:
Data 0 , 2 , 3 , 16 , 4 , 5 , 6 , 16 , 7 , 8 , 9 , 16 , 10 , 11 , 12 , 15 , 16
'-------------------------------------------------------------------------------
Sub Pass_match()
   Dim I As Byte

   For I = 1 To 4
      If Set_pass(i) = Pass_array(i) Then
         Set Flag
      Else
         Reset Flag
         Exit For
      End If

   Next I
End Sub