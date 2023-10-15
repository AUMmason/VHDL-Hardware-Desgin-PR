library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity LED_Blinking_Tb is
end entity LED_Blinking_Tb;

architecture Simulation of LED_Blinking_Tb is
  constant CLK_FREQ: integer := 50; -- Hz
  constant CLK_PERIOD: time := 1000 ms / CLK_FREQ; -- T = 1/f 

  constant BIT_WIDTH: integer := 4;

  signal clk, reset, start_button, led, counter_restart_strobe: std_ulogic := '0';
  signal counter_value: std_ulogic_vector(BIT_WIDTH - 1 downto 0);

begin
  
  Counter: entity work.counter_e(rtl) generic map(
    BIT_WIDTH => BIT_WIDTH
  ) port map (
    clk_i => clk,
    reset_i => reset,
    counter_restart_strobe_i => counter_restart_strobe,
    counter_value_o => counter_value
  );

  FSM: entity work.FSM_e(rtl) generic map(
    BIT_WIDTH => BIT_WIDTH
  ) port map (
    clk_i => clk,
    reset_i => reset,
    start_button_i => start_button,
    counter_value_i => counter_value,
    led_o => led,
    counter_restart_strobe_o => counter_restart_strobe
  );

  -- Clock
  clk <= not clk after CLK_PERIOD / 2;
  
  Stimuli: process is
  begin
    reset <= '1';
    wait for 50 ms;

    reset <= '0';
    wait for 50 ms;

    start_button <= '1';
    wait for 100 ms;

    start_button <= '0';

    wait for 1000 ms;

    start_button <= '1';
    wait for 100 ms;

    start_button <= '0';

    wait for 400 ms;
    reset <= '1';

    wait for 100 ms;
    reset <= '0';

    wait for 1000 ms;

    wait;
  end process Stimuli;


end architecture Simulation;