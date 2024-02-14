library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity increment_control is
  generic (
    BIT_WIDTH : natural;
    INCREMENT_VALUE : natural;
    MULTIPLIER_VALUE : natural;
    MIN_VALUE : natural;
    MAX_VALUE : natural;
    DEFAULT_VALUE : natural
  );
  port (
    clk_i, reset_i : in std_ulogic;
    increase_i : in std_ulogic;
    decrease_i : in std_ulogic;
    multiply_increment_i : in std_ulogic;
    value_o : out unsigned(BIT_WIDTH - 1 downto 0)
  );
end entity;

architecture rtl of increment_control is
  signal value, value_next : unsigned(BIT_WIDTH - 1 downto 0);
  signal increment, multiplier : unsigned(BIT_WIDTH - 1 downto 0);
begin

  clk: process (clk_i, reset_i)
  begin
    if reset_i = '1' then
      value <= to_unsigned(DEFAULT_VALUE, BIT_WIDTH);
    elsif rising_edge(clk_i) then
      value <= value_next;
    end if;
  end process;
  
  value_o <= value;

  multiplier <= to_unsigned(1, BIT_WIDTH) when multiply_increment_i = '0' 
                else to_unsigned(MULTIPLIER_VALUE, BIT_WIDTH);

  increment <= resize(multiplier * to_unsigned(INCREMENT_VALUE, BIT_WIDTH), BIT_WIDTH);
  
  process (increase_i, decrease_i, value)
  begin
    value_next <= value;
    if increase_i = '1' then 
      if value <= to_unsigned(MAX_VALUE, BIT_WIDTH) - increment then
        value_next <= value + increment;
      else 
        value_next <= to_unsigned(MAX_VALUE, BIT_WIDTH);
      end if;
    elsif decrease_i = '1' then
      if value >= to_unsigned(MIN_VALUE, BIT_WIDTH) + increment then
        value_next <= value - increment;      
      else
        value_next <= to_unsigned(MIN_VALUE, BIT_WIDTH);
      end if;
    else 
      value_next <= value;
    end if;
  end process;

end architecture;