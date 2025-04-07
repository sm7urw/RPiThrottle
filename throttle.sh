#!/bin/bash

# Funktion för att hämta och tolka "throttled"-status
get_throttled_status() {
    # Hämtar "throttled"-status med vcgencmd
    throttled_hex=$(vcgencmd get_throttled | cut -d '=' -f 2 | tr -d ' ')

    # Kontrollerar att vi har en giltig hexadecimal kod
    if [[ $throttled_hex =~ ^0x[0-9a-fA-F]+$ ]]; then
        # Tar bort prefixet "0x" och konverterar till decimaltal
        throttled_dec=$((16#${throttled_hex#0x}))
    else
        echo "Invalid throttled status: $throttled_hex"
        return
    fi

    # Array med beskrivningar av varje bit i statusen
    throttled_reasons=("Under-voltage detected" "Arm frequency capped" "Currently throttled" "Soft temperature limit active"
                       "" "" "" "" "Under-voltage has occurred" "Arm frequency capping has occurred"
                       "Throttling has occurred" "Soft temperature limit has occurred")

    # Kontrollerar vilka bitar som är satta och sparar beskrivningarna i en array
    active_reasons=()
    for ((i=0; i<${#throttled_reasons[@]}; i++)); do
        if (( (throttled_dec >> i) & 1 )); then
            active_reasons+=("${throttled_reasons[i]}")
        fi
    done

    echo "Throttled Reasons: ${active_reasons[@]}"
}

# Funktion för att hämta CPU-temperaturen
get_temperature() {
    temperature=$(vcgencmd measure_temp | cut -d '=' -f 2 | tr -d "'" | tr -d ' ')
    echo "CPU Temperature: $temperature"
}

# Funktion för att hämta kärnspänningen
get_voltage() {
    voltage=$(vcgencmd measure_volts | cut -d '=' -f 2 | tr -d ' ')
    echo "Core Voltage: $voltage"
}

# Huvudfunktion som kör de andra funktionerna
main() {
    get_throttled_status
    get_temperature
    get_voltage
}

# Kör huvudfunktionen
main
