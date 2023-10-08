library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder_tb_2bit is
end entity adder_tb_2bit;

architecture testbench of adder_tb_2bit is
  constant BIT_WIDTH: integer := 2;
  signal operand_a_i, operand_b_i: std_ulogic_vector(BIT_WIDTH - 1 downto 0);
  signal result_o: std_ulogic_vector(BIT_WIDTH downto 0);
  
  begin
  
  adder: entity work.adder_e(bhv) 
    generic map (BIT_WIDTH => BIT_WIDTH)
    port map(
      operand_a_i => operand_a_i, 
      operand_b_i => operand_b_i, 
      result_o => result_o
    );

  Stimuli: process is begin

    operand_a_i <= "00";
    operand_b_i <= "00";

    wait for 10 ns;

    operand_a_i <= "10";
    operand_b_i <= "01";

    wait for 10 ns;

    operand_a_i <= "10";
    operand_b_i <= "10";
    
    wait for 10 ns;

    operand_a_i <= "10";
    operand_b_i <= "11";

    wait for 10 ns;

    operand_a_i <= "00";
    operand_b_i <= "11";

    wait for 10 ns;

    operand_a_i <= "11";
    operand_b_i <= "11";
    
    wait for 10 ns;
    wait;
  end process;

  
end architecture ;