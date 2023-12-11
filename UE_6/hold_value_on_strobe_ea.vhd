library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity hold_value_on_strobe is
  generic (
    BIT_WIDTH : natural
  );
  port (
    signal strobe_i, clk_i, reset_i : in std_ulogic;
    signal value_i : in unsigned(BIT_WIDTH - 1 downto 0);
    signal hold_value_o : out unsigned(BIT_WIDTH - 1 downto 0)
  );
end entity hold_value_on_strobe;

architecture rtl of hold_value_on_strobe is
  signal hold_value, hold_value_next : unsigned(BIT_WIDTH - 1 downto 0);
begin
  
  hold_value_o <= hold_value;

  clk: process(clk_i, reset_i)
  begin
    if reset_i = '1' then
      hold_value <= value_i; -- ? Is this correct ?
    elsif rising_edge(clk_i) then
      hold_value <= hold_value_next;
    end if;
  end process clk;

  AssignHoldValue: process(strobe_i, value_i)
  begin
    hold_value_next <= hold_value;

    if strobe_i = '1' then 
      hold_value_next <= value_i;
    else 
      hold_value_next <= hold_value; -- Fallback
    end if;
    
  end process AssignHoldValue;
  
end architecture rtl;