library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity unsigned_shift_register_tb is
end entity unsigned_shift_register_tb;

architecture rtl of unsigned_shift_register_tb is
  constant BIT_WIDTH : natural := 4;
  constant CLK_FREQUENCY : natural := 50;
  constant CLK_PERIOD : time := 1000 ms / CLK_FREQUENCY;
  constant REGISTER_LENGTH : natural := 5;

  signal clk, reset : std_ulogic := '0';
  signal data_i, data_o : unsigned(BIT_WIDTH - 1 downto 0) := (others => '0');
begin

  clk <= not clk after CLK_PERIOD / 2;

  ShiftRegister : entity work.unsigned_shift_register(rtl) generic map (
    BIT_WIDTH => BIT_WIDTH,
    LENGTH => REGISTER_LENGTH
    ) port map (
    clk_i => clk,
    reset_i => reset,
    data_i => data_i,
    data_o => data_o
    );

  Stimuli : process is
  begin
    wait for 100 ms;

    data_i <= "1110";

    wait for 20 ms;

    data_i <= "0001";

    wait for 20 ms;

    data_i <= "0000";

    wait for 500 ms;

    data_i <= "1111";

    wait for 20 ms;

    data_i <= "0000";

    wait for 500 ms;

  end process Stimuli;

end architecture rtl;