library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.ue2_definitions.all;

architecture rtl of counter_e is
  type CNT_STATE is (RESET, COUNTING);
  signal counter_value: std_ulogic_vector(BIT_WIDTH - 1 downto 0) := (others => '0');
  signal state, next_state: CNT_STATE;
  
begin

  clk: process(clk_i, reset_i) is
  begin

    if reset_i = '1' then
      state <= RESET;
    elsif rising_edge(clk_i) then
      state <= next_state;
    end if;
  
  end process;

  counter_state: process(state, counter_restart_strobe_i)
  begin

    next_state <= state;

    case state is
      when COUNTING =>
        if counter_restart_strobe_i = '1' then
          next_state <= RESET;
        else 
          -- Why doesn't this work????
          counter_value <= std_ulogic_vector(unsigned(counter_value) + to_unsigned(1, BIT_WIDTH));
        end if;
    
      when RESET =>
        counter_value <= (others => '0');
        next_state <= COUNTING;
    end case;
  end process counter_state;
  
  counter_output: process(counter_value) is
  begin
    counter_value_o <= counter_value;
  end process;

end architecture rtl;