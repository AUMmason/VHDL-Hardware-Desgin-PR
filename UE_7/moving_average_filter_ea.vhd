library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity moving_average_filter is
  generic (
    BIT_WIDTH : natural;
    -- gets converted to nearest power of two!
    FILTER_ORDER: natural -- = N
  );
  port (
    signal clk_i, reset_i, strobe_data_valid_i : in std_ulogic;
    signal data_i : in unsigned(BIT_WIDTH - 1 downto 0);
    signal data_o : out unsigned(BIT_WIDTH - 1 downto 0);
    signal strobe_data_valid_o : out std_ulogic
  );
end entity moving_average_filter;

architecture rtl of moving_average_filter is
  constant REG_AMOUNT : natural := integer( ceil(log2(real(FILTER_ORDER))) ) ** 2;

  signal sum : unsigned(BIT_WIDTH + REG_AMOUNT - 1 downto 0);
  signal sum_next : unsigned(BIT_WIDTH + REG_AMOUNT - 1 downto 0);

  signal data_last : unsigned(BIT_WIDTH - 1 downto 0);
  signal strobe_data_valid_next : std_ulogic;
begin

  data_o <= resize(sum * (1 / (REG_AMOUNT + 1)), BIT_WIDTH);

  ShiftRegister: entity work.unsigned_shift_register(rtl) generic map (
    BIT_WIDTH => BIT_WIDTH,
    LENGTH => REG_AMOUNT + 2 
    -- Average is calculated by multiplying with 1/(REG_AMOUNT + 1), 
    -- but we need an additional + 1 as this is the value we subtract from the new sum
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
      sum_next <= sum + resize(data_i, BIT_WIDTH + REG_AMOUNT) - resize(data_last, BIT_WIDTH + REG_AMOUNT);
    end if;
  end process Filter;

end architecture rtl;