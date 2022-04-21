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
.global INT4_vect  ; We must expose the timer overflow label too

; Assembly version of setup() function
setup:
          ; The next line is like "pinMode(13, OUTPUT);"
          sbi   DDRB,7           ; Set bit 7 in data direction port b to 1
          rcall init_interrupts  ; Setup interrupts
          ret                    ; Return

init_interrupts:
          cli                    ; Disable global interrupts
          
          ldi   r18,0x03         ; Load 0011 into reg 18 (for rising edge combination)
          sts   EICRB,r18        ; Set EICRB (0x6A) to 11 from register 18
          
          sbi   EIMSK,4          ; Set INT4 bit in EIMSK (0x1D) register

          sei                    ; Enable global interrupts
          ret                    ; Return from subroutine

; Assembly version of loop() function
loop:
          ret                    ; Return (to beginning of loop)

INT4_vect:
          cbi   EIMSK,4          ; Clear INT4 bit in EIMSK (0x1D) masking interrupt
          rcall toggle_led       ; Toggle On-board LED
          sbi   EIMSK,4          ; Set INT4 bit in EIMSK (0x1D) unmasking interrupt
          reti                   ; Return from interrupt
          
toggle_led:
          sbis PORTB,7           ; Skips the next instruction if PB7 is 1
          rjmp toggle_on         ; Toggle on (this is skipped if set to 1 already)
          rjmp toggle_off        ; Toggle off
toggle_on:                       
          sbi PORTB,7            ; Turn on D13
          ret                    ; Return
toggle_off:                       
          cbi PORTB,7            ; Turn on D13
          ret                    ; Return

; Function to delay for 1 second
delay_1s:
          push r24               ; Store register 24 value on stack
          push r25               ; Store register 25 value on stack
          push r26               ; Store register 26 value on stack
          push r27               ; Store register 27 value on stack
          ldi  r24,10            ; Load 10 into register 24
delay_100ms:
          ldi  r25,100           ; Load 100 into register 25
delay_1ms:
          ldi  r27,4010 >> 8     ; Load high byte of value 4010 into reg 27
          ldi  r26,4010 & 255    ; Load low byte of value 4010 into reg 26
delay_ms:
          sbiw r26,1             ; Decrement ms count (r27:r26)
          brne delay_ms          ; loop to delay_ms while > 0
          dec  r25               ; Decrement register 25 by 1
          brne delay_1ms         ; loop for 100 us
          dec  r24               ; decrement register 24 by one
          brne delay_100ms       ; loop for 100 us
          pop  r27               ; Restore value r27 from stack
          pop  r26               ; Restore value r26 from stack
          pop  r25               ; Restore value r25 from stack
          pop  r24               ; Restore value r24 from stack
          ret                    ; return from subroutine
