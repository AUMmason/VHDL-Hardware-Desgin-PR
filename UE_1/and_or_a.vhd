library ieee;
use ieee.std_logic_1164.all;

architecture bhv of and_or_e is
  -- define internal signals

begin
  and_0 : process (operand_a_i, operand_b_i) is
  begin
    and_o <= operand_a_i and operand_b_i;
  end process;

  or_0 : process (operand_a_i, operand_b_i) is
  begin
    or_o <= operand_a_i or operand_b_i;
  end process;

end architecture;