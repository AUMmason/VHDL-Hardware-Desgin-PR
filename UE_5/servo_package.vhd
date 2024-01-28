library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

use work.tilt_package.all;

package servo_package is
  -- SERVO INPUT RANGE:
  -- Min and Max values that are vaild for the input signals to set the servo angle!
  constant SERVO_SIGNAL_RANGE : natural := 1000;
  constant SERVO_SIGNAL_MIN : natural := 1000; -- 0°
  constant SERVO_SIGNAL_MAX : natural := SERVO_SIGNAL_MIN + SERVO_SIGNAL_RANGE; -- 180°
  -- TIMING SETUP:
  -- Clock Frequency is per Millisecond!
  constant CLOCK_FREQUENCY_MS : natural := BOARD_CLOCK_FREQ / 1000; -- 50 MHz
  constant SERVO_PWM_PERIOD_MS : natural := 20; -- ms 
  constant SERVO_COUNTER_MAX : natural := SERVO_PWM_PERIOD_MS * CLOCK_FREQUENCY_MS;
  constant SERVO_COUNTER_BIT_WIDTH : natural := integer( ceil(log2(real( SERVO_COUNTER_MAX ))) );
  -- INPUT SIGNAL MAPPING:
  constant SERVO_STEP_SIZE : unsigned(SERVO_COUNTER_BIT_WIDTH - 1 downto 0) := to_unsigned(CLOCK_FREQUENCY_MS / SERVO_SIGNAL_RANGE, SERVO_COUNTER_BIT_WIDTH); 
end package servo_package;