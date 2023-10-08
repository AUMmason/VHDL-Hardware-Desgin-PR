library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder_e is
  generic(
    BIT_WIDTH: integer
  );
  port (
    signal operand_a_i, operand_b_i: in std_ulogic_vector(BIT_WIDTH - 1 downto 0);
    signal result_o: out std_ulogic_vector(BIT_WIDTH downto 0)
  );
end entity adder_e;