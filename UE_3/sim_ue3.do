quit -sim 

# Files needed for Simulation

vcom VHDL-Hardware-Desgin-PR/UE_3/pwm_e.vhd
vcom VHDL-Hardware-Desgin-PR/UE_3/pwm_a.vhd
vcom VHDL-Hardware-Desgin-PR/UE_3/pwm_tb.vhd

# Start Simulation
vsim -voptargs="\+acc" -t us pwm_tb

# Label
add wave -divider Inputs

add wave -noupdate -color Cyan /pwm_tb/clk
add wave -noupdate -color Red /pwm_tb/reset
add wave -noupdate -color {Cornflower Blue} /pwm_tb/ON_counter_val
add wave -noupdate -color {Cornflower Blue} /pwm_tb/Period_counter_val
add wave -noupdate -color {Cornflower Blue} /pwm_tb/PWM_Module/counter_val
add wave -noupdate -color {Cornflower Blue} /pwm_tb/PWM_Module/next_counter_val

add wave -divider Outputs
add wave -noupdate /pwm_tb/PWM_pin

run 400 ms
# Set Zoom Level {from ns} {to ns}
WaveRestoreZoom {0 ms} {450 ms}