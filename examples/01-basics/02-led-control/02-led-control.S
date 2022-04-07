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
          ; The next line is like "pinMode(13, OUTPUT)"
          sbi   DDRB,7       ; Set bit 7 in data direction port b to 1
          ret                ; Return

; Assembly version of loop() function
loop:
          ; The next line is like "digitalWrite(13, HIGH)"
          sbi   PORTB,7      ; Set bit 7 in port b to 1
          ret                ; Return (to beginning of loop)
