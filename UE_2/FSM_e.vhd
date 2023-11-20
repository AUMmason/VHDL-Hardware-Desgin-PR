library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FSM_e is
  generic (
    BIT_WIDTH: integer;
    MAX_COUNTER_VALUE: natural
  );
  port (
    signal clk_i, reset_i, start_button_i: in std_ulogic;
    signal counter_value_i: in std_ulogic_vector(BIT_WIDTH - 1 downto 0);
    signal led_o, counter_restart_strobe_o: out std_ulogic
  );
end entity FSM_e;