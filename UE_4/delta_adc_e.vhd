library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity delta_adc is
  generic (
    MAX_SAMPLE_VALUE: unsigned;
  );
  port (
    signal clk_i, reset_i, comparator_i : in std_ulogic;
    signal adc_valid_strobe : out std_logic;
    signal PWM_o : out unsigned(BIT_WIDTH - 1 downto 0);
  );
end entity delta_adc;