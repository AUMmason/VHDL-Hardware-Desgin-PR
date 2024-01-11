library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity button_debounce is
  generic (
    CLK_FREQUENCY_HZ : positive;
    DEBOUNCE_TIME_MS : positive
  );
  port (
    signal button_i, clk_i, reset_i : in std_ulogic;
    signal debounce_o : out std_ulogic
  );
end entity button_debounce;

architecture rtl of button_debounce is
  constant COUNTER_MAX : natural := (DEBOUNCE_TIME_MS / 1000) / (1 / CLK_FREQUENCY_HZ); 

  constant BIT_WIDTH : natural := integer( ceil(log2(real( COUNTER_MAX ))) );
  constant COUNTER_MAX_VALUE : unsigned(BIT_WIDTH - 1 downto 0) := to_unsigned(COUNTER_MAX, BIT_WIDTH);
  signal counter_value : unsigned(BIT_WIDTH - 1 downto 0);
  signal reset_counter : std_ulogic;
  
  
  type FSM_STATE is (START, PRESSED, UNPRESSED);
  signal state, state_next : FSM_STATE;
begin
  
  clk: process(clk_i, reset_i)
  begin
    if reset_i = '1' then
      counter_value <= to_unsigned(0, BIT_WIDTH);
      state <= START; 
    elsif rising_edge(clk_i) then
      state <= state_next;
      if reset_counter = '0' then
        if counter_value < COUNTER_MAX then  
          -- prevent overflow, because this would produce additional delay
          counter_value <= counter_value + to_unsigned(1, BIT_WIDTH);
        end if;
      else 
        counter_value <= to_unsigned(0, BIT_WIDTH);
      end if;
    end if;
  end process clk;
  
  state_machine: process(button_i, counter_value)
  begin
    state_next <= state;

    case state is
      when START =>
        debounce_o <= '0';
        if rising_edge(button_i) then
          state_next <= PRESSED;
          reset_counter <= '1';
        end if;
      when PRESSED => 
        reset_counter <= '0';
        debounce_o <= '1';
        if counter_value >= COUNTER_MAX_VALUE then
          if falling_edge(button_i) then
            state_next <= UNPRESSED;
            reset_counter <= '1';
          end if;
        end if;
      when UNPRESSED => 
        reset_counter <= '0';
        debounce_o <= '0';
        if counter_value >= COUNTER_MAX_VALUE then
          state_next <= START;
          reset_counter <= '1';
        end if;
      when others =>
        -- FALLBACK
        state_next <= state;
    end case;
    
  end process state_machine;

end architecture rtl;