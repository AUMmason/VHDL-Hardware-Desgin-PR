library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

-- Usage:
--  Converts debounced input signal from button or switch to a strobe signal

entity debounce_to_strobe is
  generic (
    CLK_FREQUENCY_HZ : positive;
    DEBOUNCE_TIME_MS : positive -- sets the time debounce_o has to hold the initial input signal.
  );
  port (
    signal button_i, clk_i, reset_i : in std_ulogic;
    signal strobe_o : out std_ulogic
  );
end entity debounce_to_strobe;

architecture rtl of debounce_to_strobe is
  signal deb_input, deb_input_last : std_ulogic;
begin

  Debounce: entity work.debounce(rtl) generic map (
    CLK_FREQUENCY_HZ => CLK_FREQUENCY_HZ,
    DEBOUNCE_TIME_MS => DEBOUNCE_TIME_MS
  ) port map(
    clk_i => clk_i,
    reset_i => reset_i,
    button_i => button_i,
    debounce_o => deb_input
  );

  clk: process(clk_i, reset_i)
  begin
    if rising_edge(clk_i) then
      deb_input_last <= deb_input;
    end if;
  end process clk;
  
  strobe_o <= '1' when (deb_input = '1' and deb_input_last = '0' and reset_i = '0') else '0';

end architecture rtl;