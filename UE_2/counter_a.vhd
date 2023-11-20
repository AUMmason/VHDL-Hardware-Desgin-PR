library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture rtl of counter_e is
  type CNT_STATE is (RESET, COUNTING);
  signal counter_value: std_ulogic_vector(BIT_WIDTH - 1 downto 0) := (others => '0');  
begin

  clk: process(reset_i, clk_i) is
  begin

    if reset_i = '1' then
      counter_value <= (others => '0');
    elsif rising_edge(clk_i) then
      if counter_restart_strobe_i = '1' then
        counter_value <= (others => '0');
      else
        counter_value <= std_ulogic_vector(unsigned(counter_value) + to_unsigned(1, BIT_WIDTH));
      end if;
    end if;
  
  end process;

  counter_output: process(counter_value) is
  begin
    counter_value_o <= counter_value;
  end process counter_output;

end architecture rtl;