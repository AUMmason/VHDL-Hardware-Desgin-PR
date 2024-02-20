library IEEE;
use IEEE.std_logic_1164.all;

entity and_or_tb is
end entity and_or_tb;

architecture stimuli of and_or_tb is
  signal operand_a_i, operand_b_i, and_o, or_o : std_ulogic;

begin

  and_or : entity work.and_or_e(bhv) port map (
    operand_a_i, operand_b_i, and_o, or_o
    );

  Stimuli : process is begin
    operand_a_i <= '0';
    operand_b_i <= '1';

    wait for 10 ns;

    operand_a_i <= '1';

    wait for 10 ns;

    operand_b_i <= '0';

    wait for 10 ns;

    operand_a_i <= '0';

    wait for 10 ns;
    wait;
  end process;

end architecture stimuli;