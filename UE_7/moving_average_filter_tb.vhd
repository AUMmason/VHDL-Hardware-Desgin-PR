library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity moving_average_filter_tb is
end entity moving_average_filter_tb;

architecture rtl of moving_average_filter_tb is
  constant FILTER_ORDER : natural := 7;

  constant BIT_WIDTH : natural := 4;
  constant CLK_FREQUENCY : natural := 50;
  constant CLK_PERIOD : time := 1000 ms / CLK_FREQUENCY;
  constant REGISTER_LENGTH : natural := 5;

  constant STROBE_PERIOD : natural := 2;

  signal clk, reset : std_ulogic := '0';
  signal data_i, data_o : unsigned(BIT_WIDTH - 1 downto 0) := (others => '0');

  signal strobe : std_ulogic := '0';
  signal strobe_valid : std_ulogic := '0';
begin
  
  clk <= not clk after CLK_PERIOD / 2;

  Strobe_Module: entity work.strobe_generator(rtl) generic map (
    STROBE_PERIOD => STROBE_PERIOD
  ) port map (
    clk_i => clk,
    reset_i => reset,
    strobe_o => strobe
  );

  Moving_Average: entity work.moving_average_filter(rtl) generic map (
    BIT_WIDTH => BIT_WIDTH,
    FILTER_ORDER => REGISTER_LENGTH
  ) port map (
    clk_i => clk,
    reset_i => reset,
    data_i => data_i,
    data_o => data_o,
    strobe_data_valid_i => strobe,
    strobe_data_valid_o => strobe_valid
  );

  Stimuli: process is
  begin
    reset <= '1';

    wait for 10 ms;

    reset <= '0';

    wait for 100 ms;

    data_i <= "1110";
    
    wait for 30 ms;

    data_i <= "0001";

    wait for 30 ms;

    data_i <= "0000";

    wait for 500 ms;

    data_i <= "1111";

    wait for 20 ms;

    data_i <= "0000";

    wait for 500 ms;

  end process Stimuli;

end architecture rtl;