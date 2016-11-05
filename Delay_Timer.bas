$regfile = "m8def.dat"

$crystal = 16000000

Dim Var As Byte

Config Timer0 = Timer , Prescale = 256

Load Timer0 , 6                                             ' 256-6 = 250 is Start Value For Counting Down

Config Pinb.5 = Output

Digital13 Alias Portb.5

Enable Interrupts

Enable Ovf0

On Ovf0 Empat_ms                                            ' Jump To Label Empat_ms Every Timer Is Overflow 4ms

Start Timer0                                                ' Start Timer & Do Nothing

Do

Loop

End

Empat_ms:

Incr Var                                                    ' Increment Pengali To Get Multiply Value(75)

If Var = 75 Then                                            ' 75 * 4ms = 300ms
   Var = 0                                                  ' Reset The Multiply Variable To Next Counting
   Toggle Digital13                                         ' Blingking The Led
End If

Return