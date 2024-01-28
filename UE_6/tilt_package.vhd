library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

package tilt_package is
  constant SYNC_CHAIN_LENGTH : natural := 2;
  constant BTN_DEBOUNCE_TIME_MS : natural := 20; -- 20 ms
  constant DEFAULT_ADC_VALUE_DEBUG : natural := 125; -- Servo at 90°
  constant MOV_AVG_LENGTH : natural := 8;

  constant BOARD_CLOCK_FREQ : natural := 50e6; -- 50 Mhz
  constant DELTA_ADC_PWM_FREQ : natural := 200e3; -- 200 kHz
  -- Note: Sampling and Servo-PWM Frequency should be the same as there would
  -- be no advantage in using a higher pwm frequency than the sampling
  -- frequency of the input signal
  constant DELTA_ADC_SAMPLING_FREQ : natural := 50; -- 50 Hz

  constant ADC_VALUE_RANGE : natural := BOARD_CLOCK_FREQ / DELTA_ADC_PWM_FREQ;
  constant ADC_VALUE_0_DEG : natural := 0;
  constant ADC_VALUE_180_DEG : natural := ADC_VALUE_RANGE;
  -- The below costant can be used to limit the rotation range
  constant ADC_DEG_RANGE : natural := ADC_VALUE_180_DEG - ADC_VALUE_0_DEG; -- Full 180°
end package tilt_package;