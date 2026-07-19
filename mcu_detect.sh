#!/bin/bash

# 1. Find the first connected ttyUSB or ttyACM device
PORT=$(ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null | head -n 1)

# 2. If no port is found, exit
if [ -z "$PORT" ]; then
    exit 1
fi

PORT_NAME=$(basename "$PORT")

# 3. Get the USB Vendor ID (VID) and Product ID (PID)
VID=$(udevadm info --name="$PORT" --query=property 2>/dev/null | grep 'ID_VENDOR_ID=' | cut -d'=' -f2)
PID=$(udevadm info --name="$PORT" --query=property 2>/dev/null | grep 'ID_MODEL_ID=' | cut -d'=' -f2)

# 4. Get the default OS name as a fallback
CHIP_INFO=$(udevadm info --name="$PORT" --query=property 2>/dev/null | grep 'ID_MODEL=' | cut -d'=' -f2 | tr '_' ' ')
if [ -z "$CHIP_INFO" ]; then
    CHIP_INFO="Serial MCU"
fi

# 5. The Hardware Dictionary: Map known VID:PID to actual Chip Models
if [ -n "$VID" ] && [ -n "$PID" ]; then
    case "${VID}:${PID}" in
        # Native USB Chips (100% Accurate)
        "2e8a:0005") CHIP_INFO="RP2040 (Pi Pico)" ;;
        "303a:1001") CHIP_INFO="ESP32-S2/S3/C3" ;;
        "2341:8036") CHIP_INFO="ATmega32U4 (Leonardo)" ;;
        "239a:8029") CHIP_INFO="SAMD51 (Adafruit)" ;;
        
        # Bridge Chips (Heuristics)
        "2341:0043") CHIP_INFO="ATmega328P (Uno)" ;;
        "1a86:7523") CHIP_INFO="CH340 (ESP/Arduino)" ;;
        "10c4:ea60") CHIP_INFO="CP2102 (ESP32/8266)" ;;
        "0403:6001") CHIP_INFO="FT232 (Generic)" ;;
    esac
fi

# 6. Output the final formatted string
echo " $PORT_NAME  $CHIP_INFO"
