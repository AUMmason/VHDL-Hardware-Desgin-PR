library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity delta_adc is
  generic (
    -- Take clock frequency into consideration when instancing!
    PWM_PERIOD : natural;
    SAMPLING_PERIOD : natural;
    ADC_BIT_WIDTH : natural
  );
  port (
    signal clk_i, reset_i, comparator_i : in std_ulogic;
    signal adc_valid_strobe_o : out std_ulogic;
    signal PWM_o : out std_ulogic;
    signal adc_value_o : out unsigned(ADC_BIT_WIDTH - 1 downto 0)
  );
end entity delta_adc;