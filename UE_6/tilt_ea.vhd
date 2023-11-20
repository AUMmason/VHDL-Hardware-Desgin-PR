library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
-- Internal Packages
use work.servo_package.all;
use work.tilt_package.all;

-- convert adc value to input value for PWM Servo

entity tilt is
  generic (
    ADC_BIT_WIDTH : natural;
    SERVO_BIT_WIDTH : natural;
  );
  port (
    signal clk_i, reset_i : std_ulogic;
    signal value_i : unsigned(ADC_BIT_WIDTH - 1 downto 0);
    signal pwm_on : unsigned(SERVO_BIT_WIDTH - 1 downto 0);
  );
end entity tilt;

architecture rtl of tilt is
  constant STEP_SIZE_BIT_WIDTH : natural := integer( ceil(log2(real( SERVO_SIGNAL_RANGE * (1 / ADC_VALUE_RANGE) ))) );
  constant ADC_STEP_SIZE : unsigned(SERVO_BIT_WIDTH - 1 downto 0) := to_unsigned(SERVO_SIGNAL_RANGE / ADC_VALUE_RANGE, STEP_SIZE_BIT_WIDTH);
begin
  
  
  
end architecture rtl;