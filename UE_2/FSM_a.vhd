library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture rtl of FSM_e is
  type FSM_STATE is (START, STANDBY, LED_ON);
  signal state, next_state: FSM_STATE;
begin
  
  clk: process(clk_i, reset_i) is
  begin
    if reset_i = '1' then
      state <= START;
    elsif rising_edge(clk_i) then
      state <= next_state;
    end if;
  end process;
  
  state_machine: process(state, counter_value_i, start_button_i) is
  begin
    -- default assignment
    next_state <= state;

    case state is
      when START =>
        led_o <= '0';
        if start_button_i = '1' then
          next_state <= STANDBY;
        end if;
      when STANDBY =>
        led_o <= '0';
        if unsigned(counter_value_i) >= to_unsigned(MAX_COUNTER_VALUE, BIT_WIDTH) then
          next_state <= LED_ON;
        end if;
      when LED_ON => 
        led_o <= '1';
        if unsigned(counter_value_i) >= to_unsigned(MAX_COUNTER_VALUE, BIT_WIDTH) then
          next_state <= START;
        end if;
      when others =>
        -- FALLBACK
        next_state <= state;    
    end case;
  end process state_machine;

  send_strobe: process(state, next_state) is
    begin
      if (state = START and next_state = STANDBY) or (state = STANDBY and next_state = LED_ON) then
        counter_restart_strobe_o <= '1';
      else
        counter_restart_strobe_o <= '0';
      end if;
    end process send_strobe;

end architecture rtl;