library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture rtl of PWM is
  signal counter_val, next_counter_val: unsigned(COUNTER_LEN - 1 downto 0);
  signal PWM_pin: std_ulogic;
begin
  
  PWM_pin_o <= PWM_pin;

  PWM_pin <= '1' when (counter_val < ON_counter_val_i) and reset_i = '0' else '0'; 

  clk : process(clk_i, reset_i)
  begin
    if(reset_i = '1') then
      -- Which behavior is wanted here? Should the pmw signal be '1' when reset is hit?
      -- This code leads to asynchronous behavior. But the next PWM-Cycle will be
      -- synchronous again.
      counter_val <= (others => '0');
    elsif(rising_edge(clk_i)) then
      counter_val <= next_counter_val;
    end if ;
  end process ; -- clk

  counter_assignment: process(counter_val, period_counter_val_i)  
  begin
    next_counter_val <= counter_val;  
    if counter_val < period_counter_val_i - to_unsigned(1, COUNTER_LEN) then
      next_counter_val <= counter_val + to_unsigned(1, COUNTER_LEN);
    else
      next_counter_val <= (others => '0');
    end if;
  end process counter_assignment;

  
end architecture rtl;