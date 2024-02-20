library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sync_chain_tb is
end entity sync_chain_tb;

architecture Testbench of sync_chain_tb is
  constant CLK_FREQUENCY : integer := 100; -- Hz
  constant CLK_PERIOD : time := 1000 ms / CLK_FREQUENCY; -- T = 1/f

  signal clk, reset : std_ulogic := '0';
  signal async_i, sync_o : std_ulogic;
begin

  clk <= not clk after CLK_PERIOD;

  sync_chain : entity work.sync_chain(rtl) generic map(
    CHAIN_LENGTH => 4
    ) port map(
    Async_i => async_i,
    Sync_o => sync_o,
    reset_i => reset,
    clk_i => clk
    );

  Stimuli : process is
  begin
    report std_ulogic'image(sync_o);
    reset <= '1';

    wait for 12 ms;

    reset <= '0';

    wait for 18 ms;

    async_i <= '1';

    wait for 15 ms;

    async_i <= '0';

    wait for 80 ms;

    async_i <= '1';

    wait for 25 ms;

    async_i <= '0';

    wait for 80 ms;

    async_i <= '1';

    wait for 100 ms;

    async_i <= '0';

    wait;

  end process Stimuli;

end architecture Testbench;