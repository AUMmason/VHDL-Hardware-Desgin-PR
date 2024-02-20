library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

-- Usage:
--  Can be used for debouncing buttons and switches.
-- Example: 
--  BUTTON IS PRESSED: 
--  button_i = '1', bounces for 5 ms (example time). 
--  At the first rising_edge of button_i, debounce_o = '1' for DEBOUNCE_TIME_MS.
--  BUTTON IS RELEASED: 
--  button_i = '0', bounces for 4 ms (example time)
--  The release of the button is detected and debounce_o holds '0' for at least DEBOUNCE_TIME_MS 
--  until further user input.

entity debounce is
  generic (
    CLK_FREQUENCY_HZ : positive;
    DEBOUNCE_TIME_MS : positive -- sets the time debounce_o has to hold the initial input signal.
  );
  port (
    signal button_i, clk_i, reset_i : in std_ulogic;
    signal debounce_o : out std_ulogic
  );
end entity debounce;

architecture rtl of debounce is
  constant COUNTER_MAX : natural := DEBOUNCE_TIME_MS * (CLK_FREQUENCY_HZ / 1000);
  constant BIT_WIDTH : natural := integer(ceil(log2(real(COUNTER_MAX))));
  constant COUNTER_MAX_VALUE : unsigned(BIT_WIDTH - 1 downto 0) := to_unsigned(COUNTER_MAX, BIT_WIDTH);

  type FSM_STATE is (START, PRESSED, UNPRESSED);
  signal state, state_next : FSM_STATE;
  signal counter_value : unsigned(BIT_WIDTH - 1 downto 0) := to_unsigned(0, BIT_WIDTH); -- * has to be initialized
  signal reset_counter : std_ulogic;
begin

  clk : process (clk_i, reset_i)
  begin
    if reset_i = '1' then
      counter_value <= to_unsigned(0, BIT_WIDTH);
      state <= START;
    elsif rising_edge(clk_i) then
      state <= state_next;
      if reset_counter = '0' then
        if counter_value < COUNTER_MAX then
          counter_value <= counter_value + to_unsigned(1, BIT_WIDTH);
        else
          counter_value <= counter_value;
        end if;
      else
        counter_value <= to_unsigned(0, BIT_WIDTH);
      end if;
    end if;
  end process clk;

  state_machine : process (state, button_i, counter_value)
  begin
    state_next <= state;

    case state is
      when START =>
        debounce_o <= '0';
        if button_i = '1' then
          state_next <= PRESSED;
        end if;
      when PRESSED =>
        debounce_o <= '1';
        if counter_value >= COUNTER_MAX_VALUE then
          if button_i = '0' then
            state_next <= UNPRESSED;
          end if;
        end if;
      when UNPRESSED =>
        debounce_o <= '0';
        if counter_value >= COUNTER_MAX_VALUE then
          state_next <= START;
        end if;
      when others =>
        -- FALLBACK
        state_next <= state;
    end case;
  end process state_machine;

  counter : process (state, state_next)
  begin
    if state = state_next then
      reset_counter <= '0';
    else
      reset_counter <= '1';
    end if;
  end process counter;

end architecture rtl;