library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.math_real.all;

entity servo_controller_tb is
end entity servo_controller_tb;

architecture testbench of servo_controller_tb is

  constant INPUT_MAX : natural := 2000;
  constant BIT_WIDTH : natural := integer( ceil(log2(real( INPUT_MAX ))) );
  constant CLK_FREQUENCY : integer := 50_000_000; -- 50 MHz
  constant CLK_PERIOD : time := 1000 ms / CLK_FREQUENCY; -- T = 1/f

  signal clk, reset : std_ulogic := '0';
  signal pwm_on_value_i : unsigned(BIT_WIDTH - 1 downto 0);
  signal servo_o : std_ulogic;

begin

  ServoController: entity work.servo_controller(rtl) generic map(
    INPUT_BIT_WIDTH => BIT_WIDTH
  ) port map (
    clk_i => clk,
    reset_i => reset,
    pwm_on_value_i => pwm_on_value_i,
    servo_o => servo_o
  );

  clk <= not clk after CLK_PERIOD / 2;
  
  Stimuli: process is
  begin
    report std_ulogic'image(servo_o);
    reset <= '1';
    pwm_on_value_i <= to_unsigned(1000, BIT_WIDTH); -- 0°
    wait for 100 ns;

    reset <= '0';

    wait for 0 ms;

    pwm_on_value_i <= to_unsigned(1341, BIT_WIDTH); -- Example for very specicif value
    
    wait for 20 ms;
    
    pwm_on_value_i <= to_unsigned(1500, BIT_WIDTH); -- 90°

    wait for 20 ms;

    pwm_on_value_i <= to_unsigned(1742, BIT_WIDTH); -- Example for very specicif value

    wait for 20 ms;

    pwm_on_value_i <= to_unsigned(2000, BIT_WIDTH); -- 180°

    wait;

  end process Stimuli;

end architecture testbench;