library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture bhv of adder_a is
begin
  
  add: process(operand_a_i, operand_b_i) is
    begin
      -- this probably wont work xd do some research
      result_o <= operand_a_i + operand_b_i;
  end process;
  
end architecture bhv;