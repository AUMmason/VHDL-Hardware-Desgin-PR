library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture bhv of adder_e is
begin
  
  add: process(operand_a_i, operand_b_i) is
    begin
      -- Concatinate an extra leading 0 to the bit-vector.
      -- We need to add an extra bit to the output signal in 
      -- order to account for a possible carry bit

      result_o <= std_ulogic_vector(unsigned(('0' & operand_a_i)) + unsigned(('0' & operand_b_i)));

  end process;
  
end architecture bhv;