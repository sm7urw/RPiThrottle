import subprocess
def get_throttled_status():
    try:
        # Använder 'vcgencmd get_throttled' för att hämta en hexadecimal statuskod
        # som anger orsakerna till att Raspberry Pi är "throttled".
        result = subprocess.run(['vcgencmd', 'get_throttled'], capture_output=True, text=True)
        # Extraherar den hexadecimala koden och konverterar den till ett heltal
        throttled_status = int(result.stdout.split('=')[1].strip(), 16)

        # Definierar betydelsen av varje bit i den hexadecimala statuskoden
        throttled_reasons = {
            0: "Under-voltage detected",  # Låg spänning upptäckt
            1: "Arm frequency capped",    # ARM-frekvens begränsad
            2: "Currently throttled",     # Aktuellt "throttled"
            3: "Soft temperature limit active",  # Mjuk temperaturgräns aktiv
            16: "Under-voltage has occurred",    # Låg spänning har inträffat
            17: "Arm frequency capping has occurred",  # ARM-frekvensbegränsning har inträffat
            18: "Throttling has occurred",       # "Throttling" har inträffat
            19: "Soft temperature limit has occurred"  # Mjuk temperaturgräns har inträffat
        }

        # Kontrollerar vilka bitar som är satta i statuskoden
        active_reasons = [reason for bit, reason in throttled_reasons.items() if throttled_status & (1 << bit)]

        return active_reasons

    except Exception as e:
        return [f"Error retrieving throttled status: {e}"]

def get_temperature():
    try:
        # Använder 'vcgencmd measure_temp' för att hämta CPU-temperaturen
        result = subprocess.run(['vcgencmd', 'measure_temp'], capture_output=True, text=True)
        temperature = result.stdout.split('=')[1].strip()
        return temperature
    except Exception as e:
        return f"Error retrieving temperature: {e}"

def get_voltage():
    try:
        # Använder 'vcgencmd measure_volts' för att hämta kärnspänningen
        result = subprocess.run(['vcgencmd', 'measure_volts'], capture_output=True, text=True)
        voltage = result.stdout.split('=')[1].strip()
        return voltage
    except Exception as e:
        return f"Error retrieving voltage: {e}"

def main():
    # Hämtar och skriver ut orsakerna till att Raspberry Pi är "throttled"
    throttled_reasons = get_throttled_status()
    print("Throttled Reasons:", throttled_reasons)

    # Hämtar och skriver ut CPU-temperaturen
    temperature = get_temperature()
    print("CPU Temperature:", temperature)

    # Hämtar och skriver ut kärnspänningen
    voltage = get_voltage()
    print("Core Voltage:", voltage)

if __name__ == "__main__":
    main()
