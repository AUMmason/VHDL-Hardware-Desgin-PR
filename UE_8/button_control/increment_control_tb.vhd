library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
-- Internal Package
use work.servo_package.all;
use work.tilt_package.all;

entity increment_control_tb is
end entity increment_control_tb;

architecture testbench of increment_control_tb is
  constant BIT_WIDTH : natural := integer( ceil(log2(real( ADC_VALUE_RANGE ))) );
  constant CLK_FREQUENCY : integer := 500; -- 500 Hz
  constant CLK_PERIOD : time := 1000 ms / CLK_FREQUENCY; -- T = 1/f

  signal clk, reset : std_ulogic := '0';
  signal increase, decrease, multiply_increment : std_ulogic := '0';
  signal value : unsigned(BIT_WIDTH - 1 downto 0);

begin

  increment_control_inst: entity work.increment_control
    generic map(
      BIT_WIDTH => BIT_WIDTH,
      INCREMENT_VALUE => 1,
      MULTIPLIER_VALUE => 10,
      MIN_VALUE => ADC_VALUE_0_DEG,
      MAX_VALUE => ADC_VALUE_180_DEG,
      DEFAULT_VALUE => DEFAULT_ADC_VALUE_DEBUG
    ) port map(
      clk_i => clk,
      reset_i => reset,
      increase_i => increase,
      decrease_i => decrease,
      multiply_increment_i => multiply_increment,
      value_o => value
    );
  
  clk <= not clk after CLK_PERIOD / 2;
  
  Stimuli_1 : process is
  begin
    reset <= '1';

    wait for 10 ms;
    
    reset <= '0';
    increase <= '1';

    wait for 50 ms;

    multiply_increment <= '1';

    wait for 40 ms;

    multiply_increment <= '0';
    increase <= '0';

    wait for 10 ms;

    decrease <= '1';

    wait for 50 ms;

    multiply_increment <= '1';

    wait for 80 ms;

    decrease <= '0';
    reset <= '1';

    wait for 10 ms;

    reset <= '0';

    wait;
  end process;

end architecture testbench;