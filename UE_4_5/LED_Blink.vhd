library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.math_real.all;

entity LED_Blink is
  port (
    signal clk_i, reset_i, start_button_i : in std_ulogic;
    signal led_o : out std_ulogic
  );
end entity LED_Blink;

architecture Synth of LED_Blink is
  constant CLK_FREQ: natural := 50_000_000; -- 50 MHz
  constant COUNTER_1_SEC_VALUE : natural := CLK_FREQ;
  constant BIT_WIDTH : natural := integer( ceil(log2(real( CLK_FREQ ))) );
  constant FF_AMOUNT: natural := 2;

  signal counter_restart_strobe, start_button_sync: std_ulogic;
  signal counter_value: std_ulogic_vector(BIT_WIDTH - 1 downto 0);
  signal reset_invert, start_button_invert : std_ulogic;
begin
  
  -- Buttons use Inverted Logic
  start_button_invert <= not start_button_i;
  reset_invert <= not reset_i;

  InputSynchronizer: entity work.sync_chain(rtl) generic map(
    CHAIN_LENGTH => FF_AMOUNT
  ) port map (
    Async_i => start_button_i,
    clk_i => clk_i,
    reset_i => reset_invert,
    sync_o => start_button_sync
  );

  Counter: entity work.counter_e(rtl) generic map(
    BIT_WIDTH => BIT_WIDTH
  ) port map (
    clk_i => clk_i,
    reset_i => reset_invert,
    counter_restart_strobe_i => counter_restart_strobe,
    counter_value_o => counter_value
  );

  FSM: entity work.FSM_e(rtl) generic map(
    BIT_WIDTH => BIT_WIDTH,
    MAX_COUNTER_VALUE => COUNTER_1_SEC_VALUE
  ) port map (
    clk_i => clk_i,
    reset_i => reset_invert,
    start_button_i => start_button_sync,
    counter_value_i => counter_value,
    led_o => led_o,
    counter_restart_strobe_o => counter_restart_strobe
  );

end architecture Synth;