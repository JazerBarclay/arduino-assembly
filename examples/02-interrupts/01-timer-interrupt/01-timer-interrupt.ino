/* 
 * TIMER OVERFLOW INTERRUPT
 * 
 * In this example we start with a flashing LED on PIN 12.
 * 
 * We include an interrupt on TIMER1 which has its value set by
 * the defined value timer_delay at the top of our code.
 * 
 * We setup the appropriate registers with this starting timer value
 * and when the code counter overflows, we trigger an interrupt to occur.
 * 
 * This runs the function with the label "TIMER1_OVF_vect" where we can
 * execute some code before returning to the main program using the RETI
 * opcode.
 * 
 * All code will be in the associated ".S" file in the same folder
 * Happy Coding!
 * 
 * - Jazer
 */
