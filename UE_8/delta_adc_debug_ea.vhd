library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- Internal Package
use work.tilt_package.all;

-- This entity is used to replicate the functionality of the delta_adc used in this projcet
-- But insead of following a comparator signal, the pwm output is set by a given adc_value

entity delta_adc is
  generic (
    ADC_BIT_WIDTH : natural
  );
  port (
    signal clk_i, reset_i : in std_ulogic;
    signal adc_value_i : in unsigned(ADC_BIT_WIDTH - 1 downto 0);
    signal PWM_o : out std_ulogic
  );
end entity delta_adc;

architecture rtl of delta_adc is
  constant ADC_MAX_VALUE: unsigned(ADC_BIT_WIDTH - 1 downto 0) := to_unsigned(ADC_VALUE_RANGE, ADC_BIT_WIDTH);
begin

  PWM_Module: entity work.PWM(rtl) generic map(
    COUNTER_LEN => ADC_BIT_WIDTH
  ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    Period_counter_val_i => ADC_MAX_VALUE,
    ON_counter_val_i => adc_value_i,
    PWM_pin_o => PWM_o
  );
  
end architecture rtl;