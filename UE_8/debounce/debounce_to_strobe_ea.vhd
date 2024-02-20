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
  signal deb_input, deb_signal, deb_signal_next : std_ulogic;
  signal strobe, strobe_next : std_ulogic;
begin

  Debounce : entity work.debounce(rtl) generic map (
    CLK_FREQUENCY_HZ => CLK_FREQUENCY_HZ,
    DEBOUNCE_TIME_MS => DEBOUNCE_TIME_MS
    ) port map (
    clk_i => clk_i,
    reset_i => reset_i,
    button_i => button_i,
    debounce_o => deb_input
    );

  strobe_o <= strobe;

  clk : process (clk_i, reset_i)
  begin
    if reset_i = '1' then
      strobe <= '0';
      deb_signal <= '0';
    elsif rising_edge(clk_i) then
      strobe <= strobe_next;
      deb_signal <= deb_signal_next;
    end if;
  end process clk;

  State : process (deb_input, deb_signal, deb_signal_next, strobe, strobe_next)
  begin
    strobe_next <= strobe;
    deb_signal_next <= deb_input;

    if deb_signal = '0' and deb_signal_next = '1' then -- erkennen einer steigenden Flanke
      strobe_next <= '1';
    else
      strobe_next <= '0';
    end if;

  end process State;

end architecture rtl;