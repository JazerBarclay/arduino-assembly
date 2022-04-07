/* 
 * LED CONTROL 
 * 
 * In this example we turn on pin 13 by changing a single bit in
 * the data direction register and port register.
 * 
 * The first register we change is the Data Direction Register which
 * sets a pin as either input or output (like the pinMode() function).
 * 
 * The second register is the PORT register which outputs either a LOW
 * or HIGH signal for the associated pin (like the digitalWrite() function).
 * 
 * We use the Set Bit in I/O register opcode SBI to alter these registers
 * that exists in I/O memory space.
 * 
 * Give it a try and try changing other bits in the ports!
 * 
 * All code will be in the associated ".S" file in the same folder
 * Happy Coding!
 * 
 * - Jazer
 */
