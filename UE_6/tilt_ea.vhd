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
    signal adc_value_i : in unsigned(ADC_BIT_WIDTH - 1 downto 0);
    signal pwm_on_o : out unsigned(SERVO_BIT_WIDTH - 1 downto 0)
    -- SERVO_BIT_WIDTH can be derived from SERVO_SIGNAL_MAX in servo_package
  );
end entity tilt;

architecture rtl of tilt is
  -- Calculates the the ratio between SERVO_SIGNAL_RANGE and ADC_VALUE_RANGE 1000 / 50 = 20
  constant ADC_STEP_SIZE : unsigned(SERVO_BIT_WIDTH - 1 downto 0) := to_unsigned(SERVO_SIGNAL_RANGE / ADC_DEG_RANGE, SERVO_BIT_WIDTH);
  constant ADC_CORRECTION : unsigned(SERVO_BIT_WIDTH - 1 downto 0) :=
                                                                     resize(ADC_STEP_SIZE * to_unsigned(ADC_VALUE_0_DEG, ADC_BIT_WIDTH), SERVO_BIT_WIDTH)
                                                                     - to_unsigned(SERVO_SIGNAL_MIN, SERVO_BIT_WIDTH);
begin
  -- pwm_on_o is constrained in order to prevent over or underflow, thus resulting in wrong servo movements in the implementation
  pwm_on_o <= to_unsigned(SERVO_SIGNAL_MIN, SERVO_BIT_WIDTH) when adc_value_i < to_unsigned(ADC_VALUE_0_DEG, ADC_BIT_WIDTH)
              else
              to_unsigned(SERVO_SIGNAL_MAX, SERVO_BIT_WIDTH) when adc_value_i > to_unsigned(ADC_VALUE_180_DEG, ADC_BIT_WIDTH)
              else
              resize(ADC_STEP_SIZE * adc_value_i, SERVO_BIT_WIDTH) - ADC_CORRECTION;

end architecture rtl;