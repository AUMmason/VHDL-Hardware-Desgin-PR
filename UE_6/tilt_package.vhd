library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

package tilt_package is
  constant CLOCK_FREQ : natural := 50_000_000; -- 50 Mhz
  constant DELTA_ADC_PWM_FREQ : natural := 200_000; -- 200 kHz
  -- Sampling and PWM Frequency should be the same as there would
  -- be no advantage in using a higher pwm frequency than the sampling
  -- frequency of the input signal

  constant ADC_VALUE_RANGE : natural := CLOCK_FREQ * (1 / DELTA_ADC_PWM_FREQ);

  -- Calculate ADC values for 0° and 180° respectively
  -- ADC Values can be between 0 and 250.
  -- The Accelerometer outputs 2 V for 0° and 3 V for 180°
  -- The maximum ADC value is defined at 5 V
  
  -- This means we have to find the corresponding ADC values for
  -- 0° and 180° by taking the accelerometer and the maximum adc
  -- value into account.

  -- TODO see hand written notes!

  constant ADC_SAMPLING_FREQ : natural := 50; -- 50 Hz
  constant SERVO_PWM_FREQ : natural := 50; -- 50 Hz
end package tilt_package;