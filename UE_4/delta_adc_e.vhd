library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity delta_adc is
  generic (
    BIT_WIDTH: natural
  );
  port (
    signal sampling_period_i : in unsigned;
    signal clk_i, reset_i, comparator_i : in std_ulogic;
    signal adc_valid_strobe_o : out std_ulogic;
    signal PWM_o : out std_ulogic
  );
end entity delta_adc;