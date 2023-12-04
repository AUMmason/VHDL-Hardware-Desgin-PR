library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
-- Internal Packages
use work.servo_package.all;
use work.tilt_package.all;

-- convert adc value to input value for PWM Servo
-- convert 0 - 250 unsigned to 1000 - 2000 unsigned 

entity tilt is
  generic (
    ADC_BIT_WIDTH : natural;
    SERVO_BIT_WIDTH : natural
  );
  port (
    signal clk_i, reset_i : in std_ulogic;
    signal adc_value_i : in unsigned(ADC_BIT_WIDTH - 1 downto 0);
    signal pwm_on_o : out unsigned(SERVO_BIT_WIDTH - 1 downto 0)
    -- SERVO_BIT_WIDTH can be derived from SERVO_SIGNAL_MAX in servo_package.vhd
  );
end entity tilt;

architecture rtl of tilt is
  -- Calculates the the ratio between SERVO_SIGNAL_RAGE and ADC_VALUE_RANGE
  -- => 1000 / 250 = 4
  constant ADC_STEP_SIZE : unsigned(SERVO_BIT_WIDTH - 1 downto 0) := to_unsigned(SERVO_SIGNAL_RANGE / ADC_DEG_RANGE, SERVO_BIT_WIDTH);
  constant ADC_CORRECTION : unsigned(SERVO_BIT_WIDTH - 1 downto 0) := 
    resize(
    to_unsigned(SERVO_SIGNAL_RANGE, SERVO_BIT_WIDTH) 
    - ADC_STEP_SIZE * to_unsigned(natural(ADC_VALUE_0_DEG), ADC_BIT_WIDTH),
    SERVO_BIT_WIDTH);
begin

  --Todo implement constraints for pwm_on_o to always be in range of 1000 and 2000
  --this means checking if adc_value_i ist between 100 and 150 (ADC_VALUE_0_DEG and ADC_VALUE_180_DEG)

  pwm_on_o <= resize(ADC_STEP_SIZE * adc_value_i, SERVO_BIT_WIDTH) - ADC_CORRECTION;
end architecture rtl;