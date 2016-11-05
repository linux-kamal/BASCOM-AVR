$regfile = "attiny13.dat"
$crystal = 4000000
$hwstack = 30
$swstack = 0
'$framesize = 24

Dim B As Byte
B = 5


Pcmsk = &B00000001 'PIN Change Int
ON PCINT0 pin_change_isr
Set Gimsk.5
Enable Interrupts

Do
!NOP
Loop

End 'end program

pin_change_isr:
  B = 7
Return