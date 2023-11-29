library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity moving_average_filter is
  generic (
    BIT_WIDTH : natural;
    FILTER_ORDER: natural -- = N
    -- TODO Implement length to be capped at powers of two
  );
  port (
    signal clk_i, reset_i, strobe_data_valid_i : in std_ulogic;
    signal data_i : in unsigned(BIT_WIDTH - 1 downto 0);
    signal data_o : out unsigned(BIT_WIDTH - 1 downto 0);
    signal strobe_data_valid_o : out std_ulogic
  );
end entity moving_average_filter;

architecture rtl of moving_average_filter is
  signal sum : unsigned(BIT_WIDTH + FILTER_ORDER - 1 downto 0);
  signal sum_next : unsigned(BIT_WIDTH + FILTER_ORDER - 1 downto 0);

  signal data_last : unsigned(BIT_WIDTH - 1 downto 0);
  signal strobe_data_valid_next : std_ulogic;
begin

  data_o <= resize(sum * (1/(FILTER_ORDER + 1)), BIT_WIDTH);

  ShiftRegister: entity work.unsigned_shift_register(rtl) generic map (
    BIT_WIDTH => BIT_WIDTH,
    LENGTH => FILTER_ORDER + 2 
    -- Average is calculated by multiplying with 1/(FILTER_ORDER + 1), 
    -- but we need an additional value to subtract the last from the sum
  ) port map (
    clk_i => clk_i,
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

  Filter: process(data_i, strobe_data_valid_i)
  begin
    strobe_data_valid_next <= strobe_data_valid_i;
    sum_next <= sum;
    if strobe_data_valid_i = '1' then
      sum_next <= sum + resize(data_i, BIT_WIDTH + FILTER_ORDER) - resize(data_last, BIT_WIDTH + FILTER_ORDER);
    end if;
  end process Filter;

end architecture rtl;