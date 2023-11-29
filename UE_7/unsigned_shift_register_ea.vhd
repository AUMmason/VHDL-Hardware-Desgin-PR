library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity unsigned_shift_register is
  generic (
    BIT_WIDTH : natural;
    LENGTH : natural
  );
  port (
    signal clk_i, reset_i : in std_ulogic;
    signal data_i : in unsigned(BIT_WIDTH - 1 downto 0);
    signal data_o : out unsigned(BIT_WIDTH - 1 downto 0)
  );
end entity unsigned_shift_register;

architecture rtl of unsigned_shift_register is
  type unsigned_array is array (LENGTH - 1 downto 0) of unsigned(BIT_WIDTH - 1 downto 0);
  signal data_chain, data_chain_next : unsigned_array := (others => (others => '0'));
begin

  data_o <= data_chain(data_chain'right);
  
  clk: process(clk_i, reset_i)
  begin
    if reset_i = '1' then
      data_chain <= (others => (others => '0'));
    elsif rising_edge(clk_i) then
      data_chain <= data_chain_next;
    end if;
  end process clk;
  
  shift_register: process(data_chain, data_i)
  begin
    data_chain_next <= data_chain;
    -- Shift data input from left to right
    data_chain_next <= data_i & data_chain(data_chain'left downto 1);
  end process shift_register;

end architecture rtl;