library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture rtl of PWM is
  signal counter_val, next_counter_val: unsigned(COUNTER_LEN - 1 downto 0);
  signal PWM_pin: std_ulogic;
begin
  
  PMW_pin_o <= PMW_pin;

  -- Concurrent conditional signal assignment
  PMW_pin <= '1' when counter_val < on_counter_val_i else '0'; 

  clk : process( clk_i, reset_i )
  begin
    if(reset_i = '1') then
      counter_val <= (others => '0');
    elsif(rising_edge(clk_i)) then
      counter_val <= next_counter_val;
    end if ;
  end process ; -- clk

  counter_assignment: process(counter_val)
  begin
    -- Sequential signal assignment
    next_counter_val <= counter_val;  

    if(counter_val < period_counter_val_i) then
      next_counter_val <= counter_val + to_unsigned(1, COUNTER_LEN - 1);
    else then
      next_counter_val <= (ohters => '0');
    end if;
  end process counter_assignment;
  
end architecture rtl;