library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pwm_tb is
end entity pwm_tb;

architecture Testbench of pwm_tb is
  constant CLK_FREQENCY: integer := 200; -- 200 Hz
  constant CLK_PERIOD: time := 1000 ms / CLK_FREQENCY; -- T = 1/f

  constant COUNTER_LEN: integer := 4;
  signal clk, reset: std_ulogic := '0';
  signal PWM_pin: std_ulogic;
  signal ON_counter_val: unsigned(COUNTER_LEN - 1 downto 0) := "0100"; --4
  signal Period_counter_val: unsigned(COUNTER_LEN - 1 downto 0) := "1111"; --15
begin
  
  PWM_Module: entity work.PWM(rtl) generic map(
    COUNTER_LEN => COUNTER_LEN
  ) port map (
    clk_i => clk,
    reset_i => reset,
    Period_counter_val_i => Period_counter_val,
    ON_counter_val_i => ON_counter_val,
    PWM_pin_o => PWM_pin
  );
  
  clk <= not clk after CLK_PERIOD / 2;

  Stimuli: process is
  begin
    report std_ulogic'image(PWM_pin);

    wait for 210 ms;
  
    reset <= '1';
  
    wait for 1 ms;
  
    reset <= '0';    
  end process Stimuli;

end architecture Testbench;