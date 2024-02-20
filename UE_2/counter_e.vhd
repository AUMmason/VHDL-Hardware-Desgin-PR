library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter_e is
  generic (
    BIT_WIDTH : integer
  );
  port (
    signal clk_i, reset_i, counter_restart_strobe_i : in std_ulogic;
    signal counter_value_o : out std_ulogic_vector(BIT_WIDTH - 1 downto 0) := (others => '0')
  );
end entity counter_e;