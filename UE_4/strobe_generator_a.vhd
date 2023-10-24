library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

architecture rtl of strobe_generator is
  signal counter_val, next_counter_val : unsigned(BIT_WIDTH - 1 downto 0);
  signal strobe : std_ulogic;
begin
  
  strobe_o <= strobe;

  strobe <= '1' when counter_val < to_unsigned(1, BIT_WIDTH - 1) else '0';

  clock: process(clk_i, reset_i)
  begin
    if reset_i = '1' then
      counter_val <= (others => '0');
    elsif rising_edge(clk_i) then
      counter_val <= next_counter_val;
    end if;
  end process clock;
  
  counter_assignment: process(counter_val)
  begin

    next_counter_val <= counter_val;

    if counter_val < strobe_period_i - to_unsigned(1, BIT_WIDTH - 1) then
      next_counter_val <= counter_val + to_unsigned(1, BIT_WIDTH - 1);
    else
      next_counter_val <= (others => '0');  
    end if;

  end process counter_assignment;

end architecture rtl;