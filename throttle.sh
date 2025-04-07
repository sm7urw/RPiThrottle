#!/bin/bash

# Funktion för att hämta och tolka "throttled"-status
get_throttled_status() {
    # Hämtar "throttled"-status med vcgencmd
    throttled_hex=$(vcgencmd get_throttled | cut -d '=' -f 2 | xargs)
    throttled_dec=$((16#$throttled_hex))

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
    temperature=$(vcgencmd measure_temp | cut -d '=' -f 2 | xargs)
    echo "CPU Temperature: $temperature"
}

# Funktion för att hämta kärnspänningen
get_voltage() {
    voltage=$(vcgencmd measure_volts | cut -d '=' -f 2 | xargs)
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
