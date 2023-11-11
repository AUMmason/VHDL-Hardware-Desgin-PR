library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity strobe_generator is
  generic (
    STROBE_PERIOD : natural -- Defines the duration after which a strobe signal is generated periodically
  );
  port (
    signal clk_i, reset_i : in std_ulogic;
    signal strobe_o : out std_ulogic
  );
end entity strobe_generator;