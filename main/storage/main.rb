# Blink built-in LED. Change pin number as needed.
led = ESP32::GPIO_NUM_2
ESP32::GPIO::pinMode(led, ESP32::GPIO::OUTPUT)

# RAW timings for Panasonic TV Power button
timings = [3550, -1750, 400, -450, 450, -1300, 450, -400, 450, -450, 450, -400, 500, -400, 450, -400, 500, -400, 450, -400, 500, -400, 450, -400, 500, -400, 450, -400, 500, -1300, 450, -400, 450, -400, 500, -400, 450, -450, 450, -400, 450, -450, 450, -400, 450, -450, 450, -400, 450, -1350, 400, -450, 450, -400, 500, -400, 450, -400, 500, -400, 450, -400, 500, -400, 450, -400, 500, -1300, 450, -400, 450, -1350, 400, -1350, 400, -1350, 400, -1350, 400, -450, 450, -400, 500, -1300, 450, -400, 450, -1300, 450, -1300, 450, -1300, 450, -1300, 450, -400, 500, -1300, 450]

# How many cycles
CARRIERFREQ_SECS=1/37_000 # seconds
CARRIERFREQ_U=CARRIERFREQ_SECS*1_000_000 # MicroSeconds = 27

loop {

  timings.each_with_index do |timing,index|

    # Remove sign
    timing = timing * -1 if timing < 0

    # On/off for positive/negative
    if index % 2 == 0  # on

      # (timing / CARRIERFREQ_U).times do # FAILS because decimals!
      # Tried 'to_i' but mruby doesn't have this function
      # 25 is a fudge number because of a decimal kills the times function
      (timing/25).times do
        ESP32::GPIO::digitalWrite(led, ESP32::GPIO::HIGH)
        ESP32::System.delay(9)
        ESP32::GPIO::digitalWrite(led, ESP32::GPIO::LOW)
        ESP32::System.delay(9)
      end

    else               # off
      ESP32::GPIO::digitalWrite(led, ESP32::GPIO::LOW)
    end

    ESP32::System.delay(timing / 1000)
  end

  # Repeat 3 times
  ESP32::GPIO::digitalWrite(led, ESP32::GPIO::LOW)
  ESP32::System.delay(10000)

}
