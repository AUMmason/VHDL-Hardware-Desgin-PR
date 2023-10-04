library IEEE;
use IEEE.std_logic_1164.all;

entity and_or_e is
  port(
    signal operand_a_i, operand_b_i: in std_ulogic;
    signal and_o, or_o: out std_ulogic
  );
end entity;