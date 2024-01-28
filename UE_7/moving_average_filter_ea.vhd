library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity moving_average_filter is
  generic (
    BIT_WIDTH : natural;
    REGISTER_LENGTH : positive range 2 to 128
    -- REGISTER_LENGTH has to be power of two in order to make division work
    -- REGISTER_LENGTH is effecively FITLER_ORDER + 1.
  );
  port (
    signal enable_i : in std_ulogic;
    signal clk_i, reset_i, strobe_data_valid_i : in std_ulogic;
    signal data_i : in unsigned(BIT_WIDTH - 1 downto 0);
    signal data_o : out unsigned(BIT_WIDTH - 1 downto 0);
    signal strobe_data_valid_o : out std_ulogic
  );
end entity moving_average_filter;

architecture rtl of moving_average_filter is
  constant SHIFT_AMOUNT : natural := integer( ceil(log2(real( REGISTER_LENGTH ))) );
  signal sum : unsigned(BIT_WIDTH + REGISTER_LENGTH - 1 downto 0);
  signal sum_next : unsigned(BIT_WIDTH + REGISTER_LENGTH - 1 downto 0);
  signal data_last : unsigned(BIT_WIDTH - 1 downto 0);
  signal strobe_data_valid_next : std_ulogic;
begin
  -- Division of a number that is a power n of 2 equals a bit shift right by n:
  data_o <= resize(sum srl SHIFT_AMOUNT, BIT_WIDTH) when enable_i = '1' else data_i; 

  shift_register: entity work.unsigned_shift_register(rtl) generic map (
    BIT_WIDTH => BIT_WIDTH,
    LENGTH => REGISTER_LENGTH + 1 -- ! Register must be n + 1 long (to subtract the oldest value from the sum properly)
  ) port map (
    clk_i => strobe_data_valid_i,
    reset_i => reset_i,
    data_i => data_i,
    data_o => data_last
  );

  clk: process(clk_i, reset_i)
  begin
    if reset_i = '1' then
      sum <= (others => '0');
      strobe_data_valid_o <= '0';
    elsif rising_edge(clk_i) then
      sum <= sum_next;
      strobe_data_valid_o <= strobe_data_valid_next;
    end if;
  end process clk;

  filter: process(strobe_data_valid_i, data_i, data_last, sum)
  begin
    strobe_data_valid_next <= strobe_data_valid_i;
    sum_next <= sum;
    if strobe_data_valid_i = '1' then
      sum_next <= sum + resize(data_i, BIT_WIDTH + REGISTER_LENGTH) - resize(data_last, BIT_WIDTH + REGISTER_LENGTH);
    end if;
  end process filter;

end architecture rtl;