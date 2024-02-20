library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity hold_value_on_strobe_tb is
end entity hold_value_on_strobe_tb;

architecture Testbench of hold_value_on_strobe_tb is
  constant CLK_FREQUENCY : integer := 50e6; -- Hz
  constant CLK_PERIOD : time := 1000 ms / CLK_FREQUENCY; -- T = 1/f

  constant BIT_WIDTH : natural := 4;

  signal clk, reset : std_ulogic := '0';
  signal strobe : std_ulogic;
  signal value_in : unsigned(BIT_WIDTH - 1 downto 0);
  signal value_out : unsigned(BIT_WIDTH - 1 downto 0);
begin

  StrobeGenerator : entity work.strobe_generator(rtl) generic map(
    STROBE_PERIOD => 5
    ) port map (
    strobe_o => strobe,
    clk_i => clk,
    reset_i => reset
    );

  HoldValueOnStrobe : entity work.hold_value_on_strobe(rtl) generic map (
    BIT_WIDTH => BIT_WIDTH
    ) port map (
    strobe_i => strobe,
    clk_i => clk,
    reset_i => reset,
    value_i => value_in,
    hold_value_o => value_out
    );

  clk <= not clk after CLK_PERIOD / 2;

  Stimuli : process is
  begin
    reset <= '1';
    value_in <= "0000";

    wait for 10 ns;

    reset <= '0';

    wait for 150 ns;
    value_in <= "0011";

    wait for 300 ns;
    value_in <= "1100";

    wait for 20 ns;
    value_in <= "0000";

    wait for 20 ns;
    value_in <= "0001";

    wait for 20 ns;
    value_in <= "0010";

    wait for 20 ns;
    value_in <= "0011";

    wait for 20 ns;
    value_in <= "0100";

    wait for 20 ns;
    value_in <= "0101";

    wait for 20 ns;
    value_in <= "0111";

    wait for 20 ns;
    value_in <= "1000";

    wait for 20 ns;
    value_in <= "1001";

    wait for 20 ns;
    value_in <= "1011";

    wait for 20 ns;
    value_in <= "1111";

    wait for 80 ns;
    value_in <= "0000";

    wait;

  end process Stimuli;

end architecture Testbench;