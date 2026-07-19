# Serial MCU Detector

https://youtu.be/Bc4x5P3rUnE
[![Serial MCU Detection](https://github.com/nylar357/mcu_detection/blob/main/mcu_detection.png)](https://www.youtube.com/watch?v=Bc4x5P3rUnE)


## Overview

This repository contains a lightweight, zero-dependency bash script designed to automatically detect and identify microcontrollers connected via USB. Instead of manually listing active ports or guessing which serial device belongs to which board, this tool polls your system and outputs a clean, formatted string containing the port name and the specific chip architecture.

It is specifically optimized for developers who want to integrate real-time hardware detection into their customized terminal prompts (such as a right-aligned Zsh or Bash prompt).

## Features

* **Automatic Port Discovery:** Automatically scans for and identifies the first connected `/dev/ttyUSB` or `/dev/ttyACM` device.


* **Silent Execution:** If no compatible microcontroller is found, the script exits cleanly without throwing errors, keeping your terminal prompt uncluttered.


* **Deep Hardware Identification:** Utilizes `udevadm` to extract the USB Vendor ID (VID) and Product ID (PID) directly from the device block.


* **Custom Hardware Dictionary:** Matches the extracted IDs against a hardcoded lookup table to provide 100% accurate identification for native USB chips and heuristic matching for common UART bridge chips.


* **OS Fallback:** If a board's VID:PID combination is not explicitly listed in the dictionary, the script falls back to parsing the default OS model name or defaults to a generic "Serial MCU" label.


* **Prompt-Ready Output:** Echoes a pre-formatted string (e.g., ` ttyACM0  ESP32-S2/S3/C3`) designed to be dropped directly into your terminal configuration.



## Supported Microcontrollers

The internal hardware dictionary currently maps the following devices:

**Native USB Chips:**

* RP2040 (Raspberry Pi Pico)


* ESP32-S2 / S3 / C3


* ATmega32U4 (Arduino Leonardo)


* SAMD51 (Adafruit)



**Bridge Chips (Heuristics):**

* ATmega328P (Arduino Uno)


* CH340 (Generic ESP/Arduino clones)


* CP2102 (ESP32/ESP8266)


* FT232 (Generic FTDI)



## Prerequisites

* A Linux-based operating system.
* `udevadm` (standard on most Linux distributions).


* Standard command-line utilities: `ls`, `grep`, `cut`, `tr`, `head`, and `basename`.



## Installation & Usage

1. **Clone or Download the Script:**
Save `mcu_detect.sh` to a dedicated scripts directory (e.g., `~/.local/bin/` or `~/scripts/`).
2. **Make it Executable:**
```bash
chmod +x ~/scripts/mcu_detect.sh

```


3. **Standalone Testing:**
Plug in a microcontroller and run the script directly in your terminal to verify it works:
```bash
./mcu_detect.sh

```


*Expected output: ` ttyACM0  ESP32-S2/S3/C3*`

4. **Terminal Prompt Integration:**
To get this displaying in your prompt (as seen in `mcu_detection.png`), you can call the script within your `.zshrc` or `.bashrc`.
*Example for a basic right-sided prompt in Zsh (`RPROMPT`):*
```zsh
# Add this to your .zshrc
get_mcu_status() {
    ~/scripts/mcu_detect.sh
}

RPROMPT='$(get_mcu_status)'

```


*(Note: If you are using a prompt framework like Starship or Powerlevel10k, you can easily add this script as a custom command module in their respective configuration files.)*

## Customization

To add support for your own specific development boards, simply open `mcu_detect.sh` and append your board's VID and PID to the `case "${VID}:${PID}" in` statement under the "Hardware Dictionary" section. You can find your board's IDs by running `lsusb` while the device is connected.
