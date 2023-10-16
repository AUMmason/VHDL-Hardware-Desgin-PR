library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture rtl of PWM is
  signal counter_val, next_counter_val: unsigned(COUNTER_LEN - 1 downto 0);
  signal PWM_pin: std_ulogic;
begin
  
  
  clk : process( clk_i, reset_i )
  begin
    if( reset_i = '1' ) then
      counter_val <= (others => '0');
    elsif( rising_edge(clk_i) ) then
      counter_val <= next_counter_val;
    end if ;
  end process ; -- clk

  counter_assignment: process(counter_val)
  begin
    
  end process counter_assignment;
  
  
  
end architecture rtl;