// SNES SPC700 Axel-F Song Demo (CPU Code) by krom (Peter Lemon):
arch snes.cpu
output "Axel-F.sfc", create

macro seek(variable offset) {
  origin ((offset & $7F0000) >> 1) | (offset & $7FFF)
  base offset
}

seek($8000); fill $18000 // Fill Upto $17FFF (Bank 2) With Zero Bytes
include "LIB/SNES.INC"        // Include SNES Definitions
include "LIB/SNES_HEADER.ASM" // Include Header & Vector Table
include "LIB/SNES_SPC700.INC" // Include SPC700 Definitions & Macros

seek($8000); Start:
  SNES_INIT(SLOWROM) // Run SNES Initialisation Routine

  SPCWaitBoot() // Wait For SPC To Boot
  TransferBlockSPC(SPCROM, SPCRAM, $8000) // Load SPC File To SMP/DSP
  TransferBlockSPC($28000, SPCRAM+$8000, SPCROM.size-$8000) // Load SPC File To SMP/DSP
  SPCExecute(SPCRAM) // Execute SPC At $0200

Loop:
  jmp Loop

// SPC Code
// BANK 1 & 2
seek($18000)
insert SPCROM, "Axel-F.spc"