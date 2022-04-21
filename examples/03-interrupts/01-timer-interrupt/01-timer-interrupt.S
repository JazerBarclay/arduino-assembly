; ====================================================
; Arduino-Assembly Copyright(C) 2022 Jazer Barclay
; This program comes with ABSOLUTELY NO WARRANTY; This is free software,
; and you are welcome to redistribute it under certain conditions; See
; file LICENSE, which is part of this source code package, for details.
; ====================================================

; == Definitions ==
#define __SFR_OFFSET 0

; Starting counter value for timer interrupt
#define timer_delay 3035

; Include libraries or other header files
#include "avr/io.h"

; Expose these global functions
.global setup            ; Used in place of setup() c function
.global loop             ; Used in place of loop() c function
.global TIMER1_OVF_vect  ; We must expose the timer overflow label too

; Assembly version of setup() function
setup:
                rcall init_pins           ; Run pin and port initialisation
                rcall init_interrupts     ; Run interrupt initialisation
                ret                      ; Return from subroutine

init_pins:
                sbi   0x04,7             ; Set DDRB7 (D13) as output
                sbi   0x04,6             ; Set DDRB4 (D10) as output
                ret                      ; Return from subroutine

init_interrupts:
                cli                      ; Disable global interrupts
                
                ldi   r18,0x00           ; Load 0 into reg 18
                sts   0x80,r18           ; Store 0 from reg 18 into TCCR1A (0x80)
                sts   0x81,r18           ; Store 0 from reg 18 into TCCR1B (0x81)
                ldi   r18,4              ; Load 0 into reg 18
                sts   0x81,r18           ; Store 0 from reg 18 into TCCR1B (0x81)
                
                ldi   r18,timer_delay >> 8  ; Load high byte into reg 18
                sts   0x85,r18              ; Copy reg 30 value into TCNT1H (0x85)
                ldi   r18,timer_delay & 255 ; Load low byte into reg 30
                sts   0x84,r18              ; Copy reg 31 value into TCNT1L (0x84)

                lds   r18,0x6f           ; Load value in TIMSK1 (0x6f) into reg 18
                ori   r18,0x01           ; Set first bit to 1
                sts   0x6f,r18           ; Store new value in reg 18 into TIMSK1 (0x6f)
                
                sei                      ; Enable global interrupts
                ret                      ; Return from subroutine

; Assembly version of loop() function
loop:           
                sbi   0x05,6             ; Set PB7 HIGH
                rcall delay_1s           ; Delay for 1 second
                cbi   0x05,6             ; Set PB7 LOW
                rcall delay_1s           ; Delay for 1 second
                ret                      ; Return from subroutine

; Timer 1 Overflow Interrupt Routine
TIMER1_OVF_vect:
                cli                      ; Disable global interrupts
                sbi   0x05,7             ; Set PB6 HIGH
                rcall delay_200ms        ; Delay for 1 second
                cbi   0x05,7             ; Set PB6 LOW
                rcall delay_200ms        ; Delay for 1 second
                
                ldi   r18,timer_delay >> 8  ; Load high byte into reg 18
                sts   0x85,r18              ; Copy reg 30 value into TCNT1H (0x85)
                ldi   r18,timer_delay & 255 ; Load low byte into reg 30
                sts   0x84,r18              ; Copy reg 31 value into TCNT1L (0x84)
                
                sei                      ; Enable global interrupts
                reti                     ; Return from interrupt
                

; Function to delay for 1 second
delay_1s:
                push r24              ; Store register 24 value on stack
                push r25              ; Store register 25 value on stack
                push r26              ; Store register 26 value on stack
                push r27              ; Store register 27 value on stack
                ldi  r24,10           ; Load 10 into register 24
delay_100ms:
                ldi  r25,100          ; Load 100 into register 25
delay_1ms:
                ldi  r27,4010 >> 8    ; Load high byte of value 4010 into reg 27
                ldi  r26,4010 & 255   ; Load low byte of value 4010 into reg 26
delay_ms:
                sbiw r26,1            ; Decrement ms count (r27:r26)
                brne delay_ms         ; loop to delay_ms while > 0
                dec  r25              ; Decrement register 25 by 1
                brne delay_1ms        ; loop for 100 us
                dec  r24              ; decrement register 24 by one
                brne delay_100ms      ; loop for 100 us
                pop  r27              ; Restore value r27 from stack
                pop  r26              ; Restore value r26 from stack
                pop  r25              ; Restore value r25 from stack
                pop  r24              ; Restore value r24 from stack
                ret                   ; return from subroutine

; Function to delay for 200 milliseconds (makes use of 1s delay function code)
delay_200ms:
                push r24              ; Store register 24 value on stack
                push r25              ; Store register 25 value on stack
                push r26              ; Store register 26 value on stack
                push r27              ; Store register 27 value on stack
                ldi  r24,2            ; Load 10 into register 24
                rjmp delay_100ms      ; Jump to delay_100ms using different r24 value :D
