# Electromechanical Unlock Mechanism on Custom Verilog Processor (FPGA)

## Overview
This final project for Duke's ECE 350 course (Digital Systems) implements a "Secret Bookshelf" using an FPGA.  

Me and my partner Eric Mass programmed a custom CPU in Verilog and deployed it on the FPGA, then used it to interface with sensors and real hardware. Four books with embedded magnets and Hall effect sensors act as inputs. When the books are pulled in specific sequences, they trigger distinct outputs such as LEDs lighting up in different colors or releasing a hidden key.  

The system is controlled by a finite state machine (FSM) written in MIPS-like assembly and executed on the custom processor, which in turn drives the bookshelf’s hardware features.


---

## Features
- **Inputs:** 4 Hall effect sensors detect when a book is pulled off the shelf.
- **Outputs:**
  - RGB LED strip (controlled via BJTs).
  - Electromagnet-controlled hidden key release.
- **FSM Implementation:** Moore machine design tracks input sequences and triggers corresponding outputs.
- **Custom Processor Modifications:**
  - Removed multiplication and division instructions to meet timing requirements.
  - Added PLL to downscale FPGA clock from 100 MHz to 30 MHz.
  - Register-mapped I/O for direct hardware control.

---

## Hardware Setup
- **FPGA Platform:** Mounted with breadboard circuitry.
- **Voltage Rails:**
  - 5V for Hall sensors, LEDs, and NOT gate.
  - 3.3V for FPGA and relay logic.
  - 12V for electromagnet.
- **Circuitry:** Includes level shifters, NOT gates, BJTs, and a relay.

### Inputs and Outputs (Register-Mapped)
| Name       | Register | I/O | FPGA Pin | Voltage |
|------------|----------|-----|----------|---------|
| H1         | $R1      | I   | JA1      | 3.3V    |
| H2         | $R2      | I   | JA2      | 3.3V    |
| H3         | $R3      | I   | JA3      | 3.3V    |
| H4         | $R4      | I   | JA4      | 3.3V    |
| Red LED    | $R6      | O   | JA8      | 3.3V    |
| Green LED  | $R7      | O   | JA9      | 3.3V    |
| Blue LED   | $R8      | O   | JA10     | 3.3V    |
| Magnet Pin | $R10     | O   | JA7      | 3.3V    |

---

## Assembly Program
The project uses a single assembly file (`final_five.s`) implementing the FSM. Each passcode sequence corresponds to a specific output:
- Unlock sequence: `214134` → Releases hidden key (magnet deactivates).
- Other sequences trigger different LED colors:
  - Red: `324124`
  - Green: `212434`
  - Blue: `142323`

---

## Challenges
- Debugging interfacing between software and hardware.
- Timing issues due to branch/jump delays in MIPS assembly.
- Hall sensor tuning and relay reliability.
- Inconsistent electromagnet performance with 12V supply.

---

## Future Improvements
- **Customizable passcodes** stored dynamically instead of hardcoded in assembly.
- **Debounced inputs** for more accurate passcode entry.
- **Alarm system** for multiple failed attempts.
- **Electromagnet reliability fixes** (e.g., flyback diode, refined relay control).
