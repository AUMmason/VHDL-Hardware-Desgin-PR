library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity moving_average_filter is
  generic (
    BIT_WIDTH : natural;
    REGISTER_LENGTH : positive range 2 to 128
    -- REGISTER_LENGTH has to be power of two in order to make division work
    -- REGISTER_LENGTH is effecively the order of the filter + 1.
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
  constant SHIFT_AMOUNT : natural := integer(ceil(log2(real(REGISTER_LENGTH))));

  signal sum : unsigned(BIT_WIDTH + REGISTER_LENGTH - 1 downto 0) := to_unsigned(0, BIT_WIDTH + REGISTER_LENGTH); -- Set initial state
  signal sum_next : unsigned(BIT_WIDTH + REGISTER_LENGTH - 1 downto 0);
  signal strobe_data_valid_next : std_ulogic;

  type unsigned_array is array (REGISTER_LENGTH - 1 downto 0) of unsigned(BIT_WIDTH - 1 downto 0);
  signal shift_register, shift_register_next : unsigned_array := (others => (others => '0')); -- Set initial state
begin
  -- Right shift by SHIFT_AMOUNT is equal to division by REGISTER_LENGTH if REGISTER is a power of 2
  data_o <= resize(sum srl SHIFT_AMOUNT, BIT_WIDTH) when enable_i = '1' else
            data_i;

  clk : process (clk_i, reset_i)
  begin
    if reset_i = '1' then
      shift_register <= (others => (others => '0'));
      sum <= to_unsigned(0, BIT_WIDTH + REGISTER_LENGTH);
      strobe_data_valid_o <= '0';
    elsif rising_edge(clk_i) then
      shift_register <= shift_register_next;
      sum <= sum_next;
      strobe_data_valid_o <= strobe_data_valid_next;
    end if;
  end process;

  -- Shift happens after sum is updated
  shift : process (data_i, strobe_data_valid_i, shift_register)
  begin
    if strobe_data_valid_i = '1' then
      -- Concatination of new data and removal of last entry in array
      shift_register_next <= data_i & shift_register(shift_register'left downto 1);
      strobe_data_valid_next <= '1';
    else -- Fallback
      shift_register_next <= shift_register;
      strobe_data_valid_next <= '0';
    end if;
  end process shift;

  sum_calc : process (shift_register, sum, strobe_data_valid_i, data_i)
  begin
    if strobe_data_valid_i = '1' then
      sum_next <= resize(data_i + sum - shift_register(0), BIT_WIDTH + REGISTER_LENGTH);
    else -- Fallback
      sum_next <= sum;
    end if;
  end process;

end architecture rtl;