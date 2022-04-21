; ====================================================
; Arduino-Assembly Copyright(C) 2022 Jazer Barclay
; This program comes with ABSOLUTELY NO WARRANTY; This is free software,
; and you are welcome to redistribute it under certain conditions; See
; file LICENSE, which is part of this source code package, for details.
; ====================================================

; == Definitions ==
#define __SFR_OFFSET 0

; Include libraries or other header files
#include "avr/io.h"

; Expose these global functions
.global setup            ; Used in place of setup() c function
.global loop             ; Used in place of loop() c function

; Assembly version of setup() function
setup:          
                rcall setup_usart        ; Setup usart
                ret                      ; Return from subroutine

setup_usart:
                push  r24                               ; Store r24 value temp
                clr   r24                               ; Clear register 24
                sts   UCSR0A, r24                       ; Set UCSR0A to value in r24 (0000 0000)
                sts   UBRR0H, r24                       ; Set UBRR0H to value in r24 (0000 0000)
                ldi   r24, 103                          ; Store baud rate in r24 (for baud [clock_freq / 16 * rate + 1] )
                sts   UBRR0L, r24                       ; Write baud rate into low byte of UBRR0
                ldi   r24, 1 << RXEN0 | 1 << TXEN0      ; Store transmit and receive bits into r24
                sts   UCSR0B, r24                       ; Write transmit and receive bits into UCSR0B
                ldi   r24, 1 << UCSZ00 | 1 << UCSZ01    ; Set transmit character frame size to 8 bits
                sts   UCSR0C, r24                       ; Write character 
                pop   r24                               ; Recover temp store of r24 value
                ret                                     ; Return from subroutine

; Assembly version of loop() function
loop:           
                rcall transmit           ; Write text
                rcall delay_1s           ; Delay for 1 second
                ret                      ; Return from subroutine

; Function to transmit the character 'A' to the serial port
transmit:       
                lds   r17, UCSR0A        ; Store value at UCSR0A into r17
                sbrs  r17, UDRE0         ; Skip if bit in register is set
                rjmp  transmit           ; Return to transmit beginning
                ldi   r18, 65            ; Load 'A' into r18
                sts   UDR0, r18          ; Write value in r18 to serial port
                ret                      ; Return from subroutine

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
