library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity strobe_generator_tb is
end entity strobe_generator_tb;

architecture stimuli of strobe_generator_tb is
  constant BIT_WIDTH : natural := 4;
  constant CLK_FREQUENCY : integer := 200; -- Hz
  constant CLK_PERIOD : time := 1000 ms / CLK_FREQUENCY; -- T = 1/f
  constant STROBE_PERIOD : unsigned(BIT_WIDTH - 1 downto 0) := "1100";

  signal clk, reset : std_ulogic := '0';
  signal strobe : std_ulogic;

begin
  
  Strobe_Module: entity work.strobe_generator(rtl) generic map(
    BIT_WIDTH => BIT_WIDTH,
    STROBE_PERIOD => STROBE_PERIOD
  ) port map (
    clk_i => clk,
    reset_i => reset,
    strobe_o => strobe
  );
  
  clk <= not clk after CLK_PERIOD / 2;
  
  Stimuli: process is
  begin
    report std_ulogic'image(strobe);

    wait for 1000 ms;
  end process Stimuli;

end architecture stimuli;