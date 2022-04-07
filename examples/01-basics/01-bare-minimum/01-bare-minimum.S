; ====================================================
; Arduino-Assembly Copyright(C) 2022 Jazer Barclay
; This program comes with ABSOLUTELY NO WARRANTY; This is free software,
; and you are welcome to redistribute it under certain conditions; See
; file LICENSE, which is part of this source code package, for details.
; ====================================================

; Definitions
#define __SFR_OFFSET 0

; Include libraries or other header files
#include "avr/io.h"

; Expose these global functions
.global setup ; Used in place of setup() c function
.global loop  ; Used in place of loop() c function

; Assembly version of setup() function
setup:
          nop         ; Do nothing
          ret         ; Return

; Assembly version of loop() function
loop:
          nop         ; Do nothing
          ret         ; Return (to beginning of loop)
