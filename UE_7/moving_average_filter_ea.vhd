library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity moving_average_filter is
  generic (
    BIT_WIDTH : natural;
    ORDER: natural -- = N + 1
  );
  port (
    signal clk_i, reset_i, strobe_data_valid_i : in std_ulogic;
    signal strobe_data_valid_o : out std_ulogic;
    signal data_i : in std_ulogic(BIT_WIDTH downto 0);
    signal data_o : out std_ulogic(BIT_WIDTH + ORDER - 1 downto 0);
  );
end entity moving_average_filter;

architecture rtl of moving_average_filter is
  signal sum : std_ulogic(BIT_WIDTH + ORDER downto 0);
  signal sum_old : std_ulogic(BIT_WIDTH + ORDER downto 0);

  signal value_new : std_ulogic(BIT_WIDTH + ORDER downto 0);
  signal value_old : std_ulogic(BIT_WIDTH + ORDER downto 0);
begin
  -- siehe Mitschrift am Zettel

  clk: process(clk_i, reset_i)
  begin
    if reset_i = '1' then
      
    elsif rising_edge(clk_i) then
      
    end if;
  end process clk;

  shift_register: process(sensitivity_list)
  begin
    
  end process shift_register;

end architecture rtl;