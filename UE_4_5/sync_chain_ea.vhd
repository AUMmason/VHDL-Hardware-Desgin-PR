library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Entity that is used to synchronize an asynchronous input signal for further useage

entity sync_chain is
  generic (
    CHAIN_LENGTH : positive
  );
  port (
    signal Async_i, clk_i, reset_i : in std_ulogic;
    signal Sync_o : out std_ulogic
  );
end entity sync_chain;

architecture rtl of sync_chain is
  signal sync_chain, sync_chain_next : std_ulogic_vector(CHAIN_LENGTH - 1 downto 0);
begin

  Sync_o <= sync_chain(sync_chain'right); -- right most value is selected as the synchronized output

  clk : process (clk_i, reset_i)
  begin
    if reset_i = '1' then
      sync_chain <= (others => '0');
    elsif rising_edge(clk_i) then
      sync_chain <= sync_chain_next;
    end if;
  end process clk;

  chain_shift : process (sync_chain, Async_i)
  begin
    sync_chain_next <= sync_chain;
    -- Shift asynchronous input from right to left
    sync_chain_next <= Async_i & sync_chain(sync_chain'left downto 1);
  end process chain_shift;

end architecture rtl;