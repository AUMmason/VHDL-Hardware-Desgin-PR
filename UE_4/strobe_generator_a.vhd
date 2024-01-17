library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

architecture rtl of strobe_generator is
  constant BIT_WIDTH : natural := integer( ceil(log2(real( STROBE_PERIOD ))) );

  constant STROBE_PERIOD_LENGTH : unsigned(BIT_WIDTH - 1 downto 0) := to_unsigned(STROBE_PERIOD, BIT_WIDTH);
  signal counter_val, next_counter_val : unsigned(BIT_WIDTH - 1 downto 0);
  signal strobe : std_ulogic;
begin
  
  strobe_o <= strobe;

  strobe <= '1' when counter_val < to_unsigned(1, BIT_WIDTH) else '0';

  clock: process(clk_i, reset_i)
  begin
    if reset_i = '1' then
      counter_val <= (others => '0');
    elsif rising_edge(clk_i) then
      counter_val <= next_counter_val;
    end if;
  end process clock;
  
  counter_assignment: process(counter_val, next_counter_val)
  begin

    next_counter_val <= counter_val;

    if counter_val < STROBE_PERIOD_LENGTH - to_unsigned(1, BIT_WIDTH) then
      next_counter_val <= counter_val + to_unsigned(1, BIT_WIDTH);
    else
      next_counter_val <= (others => '0');  
    end if;

  end process counter_assignment;

end architecture rtl;