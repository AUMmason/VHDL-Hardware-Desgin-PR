library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

package tilt_package is
  constant SYNC_CHAIN_LENGTH : natural := 2;

  constant CLOCK_FREQ : natural := 50e6; -- 50 Mhz
  constant DELTA_ADC_PWM_FREQ : natural := 200e3; -- 200 kHz
  -- Sampling and PWM Frequency should be the same as there would
  -- be no advantage in using a higher pwm frequency than the sampling
  -- frequency of the input signal
  
  constant ADC_SAMPLING_FREQ : natural := 50; -- 50 Hz
  constant SERVO_PWM_FREQ : natural := 50; -- 50 Hz

  -- Calculate ADC values for 0° and 180° respectively
  -- ADC Values can be between 0 and 250.
  -- The Accelerometer outputs 2 V for 0° and 3 V for 180°
  -- The maximum ADC value is defined at 5 V
  
  -- This means we have to find the corresponding ADC values for
  -- 0° and 180° by taking the accelerometer and the maximum adc
  -- value into account.

  -- Note: Calculation of constants can be achieved using the natural type
  -- since there is no rounding required for the chosen value above
  constant ADC_VALUE_RANGE : natural := CLOCK_FREQ / DELTA_ADC_PWM_FREQ;
  constant SUPPLY_VOLTAGE : natural := 5; -- V
  constant MIN_VOLTAGE : natural := 2; --V (= 0°)
  constant MAX_VOLTAGE : natural := 3; --V (= 180°)

  constant ADC_VALUE_0_DEG : natural := (ADC_VALUE_RANGE * MIN_VOLTAGE) / SUPPLY_VOLTAGE; -- 100
  constant ADC_VALUE_180_DEG : natural := (ADC_VALUE_RANGE * MAX_VOLTAGE) / SUPPLY_VOLTAGE; -- 150

  constant ADC_DEG_RANGE : natural := ADC_VALUE_180_DEG - ADC_VALUE_0_DEG;

  
end package tilt_package;