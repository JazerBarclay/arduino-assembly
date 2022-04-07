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
          ldi   r18,0xff     ; Set register 18 to 11111111
          out   DDRB,r18     ; Write register 18 value to DDRB
          ret                ; Return

; Assembly version of loop() function
loop:
          ; The next line is like "digitalWrite(13, HIGH)"
          out   PORTB,r18    ; Write register 18 to PORTB
          ret                ; Return (to beginning of loop)
