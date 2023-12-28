library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
-- Internal Package
use work.tilt_package.all;

entity moving_average_filter_tb is
end entity moving_average_filter_tb;

architecture rtl of moving_average_filter_tb is
  constant BIT_WIDTH : natural := integer( ceil(log2(real( ADC_VALUE_RANGE ))) );
  constant CLK_FREQUENCY : natural := 50;
  constant CLK_PERIOD : time := 1000 ms / CLK_FREQUENCY;
  constant REGISTER_LENGTH : natural := 6;

  constant STROBE_PERIOD : natural := 3;

  signal enable : std_ulogic := '1';
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
    enable_i => enable,
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

    wait for 10 ms;

    data_i <= to_unsigned(250, BIT_WIDTH);
    
    wait for 600 ms;

    data_i <= to_unsigned(0, BIT_WIDTH);

    wait for 600 ms;

    data_i <= to_unsigned(120, BIT_WIDTH);

    wait for 60 ms;

    data_i <= to_unsigned(85, BIT_WIDTH);

    wait for 60 ms;

    data_i <= to_unsigned(145, BIT_WIDTH);

    wait for 60 ms;

    data_i <= to_unsigned(15, BIT_WIDTH);

    wait for 60 ms;

    data_i <= to_unsigned(231, BIT_WIDTH);

    wait for 60 ms;

    data_i <= to_unsigned(214, BIT_WIDTH);

    wait for 60 ms;

    data_i <= to_unsigned(13, BIT_WIDTH);

    wait for 60 ms;

    data_i <= to_unsigned(140, BIT_WIDTH);

    wait for 60 ms;

    data_i <= to_unsigned(56, BIT_WIDTH);

    wait for 60 ms;

    enable <= '0';
    data_i <= to_unsigned(100, BIT_WIDTH);

    wait for 60 ms;

    data_i <= to_unsigned(70, BIT_WIDTH);

    wait for 60 ms;

    enable <= '1';
    data_i <= to_unsigned(0, BIT_WIDTH);
    
    wait;

  end process Stimuli;

end architecture rtl;