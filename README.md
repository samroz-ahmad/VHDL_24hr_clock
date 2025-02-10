# Hex Counter Implementation on Digital Logic Board (VHDL | BASYS 2)

This project involves the implementation of a hex counter on a digital logic board, designed to count in hexadecimal (base 16). The core component is a 4-bit counter that increments its count on each clock cycle. The result is then displayed on a 7-segment display, showcasing the hexadecimal value. Additionally, the binary representation of the count is visually presented through a set of LEDs.

## Input and Output Ports

### Inputs:

- **clk:** A 1 Hz clock input.
- **reset:** An input for the reset button.
- **change:** An input used to modify the clock frequency.

### Outputs:

- **leds:** A 6-bit signal driving 4 LEDs.
- **an:** A 4-bit signal driving a multiplexed 7-segment display.
- **seg:** A 7-bit signal driving individual segments of the 7-segment display.

## Processes

### Clock Divider Process

The clock divider process is responsible for generating a 1 Hz clock pulse from a 50 MHz clock input. It includes a counter for tracking elapsed seconds (`sec_counter`). The process also dynamically adjusts the clock frequency based on the `change` input. When the `reset` input is high, all counters and variables are reset to their initial values.

### Counter Process

The counter process is the core of the hex counter functionality. It increments the counter value by 1 on each rising edge of the clock input, updating the `sec_counter` variable to keep track of elapsed seconds. Similar to the clock divider process, it adjusts the clock frequency based on the `change` input and resets counters and variables when `reset` is high.

### 7-Segment Display Output Process

The 7-segment display output process plays a crucial role in visually presenting the counter values. It utilizes the `counter1` variable to determine which digit of the 7-segment display to update. The process converts the value of the corresponding counter variable to hexadecimal and outputs it to the 7-segment display. Time information is organized using variables (`hours`, `minutes`, `tens`, and `ones`), with the thousands and hundreds variables not utilized in this specific implementation.
