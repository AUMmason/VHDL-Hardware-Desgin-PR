quit -sim 

# Files needed for Simulation
vcom VHDL-Hardware-Desgin-PR/UE_3/pwm_e.vhd
vcom VHDL-Hardware-Desgin-PR/UE_3/pwm_a.vhd
vcom VHDL-Hardware-Desgin-PR/UE_5/servo_package.vhd
vcom VHDL-Hardware-Desgin-PR/UE_5/servo_controller_ea.vhd
vcom VHDL-Hardware-Desgin-PR/UE_5/servo_controller_tb.vhd

# Start Simulation
vsim -voptargs="\+acc" -t ns servo_controller_tb

# Label
add wave -divider Inputs

add wave -noupdate -color {Cornflower Blue} -radix symbolic /servo_controller_tb/reset
add wave -noupdate -color {Cornflower Blue} -radix symbolic /servo_controller_tb/clk
add wave -noupdate -color Cyan -radix unsigned /servo_controller_tb/pwm_on_value_i

# Label
add wave -divider Outputs

add wave -noupdate /servo_controller_tb/servo_o

# Label
add wave -divider Internal

add wave -noupdate -color {Medium Slate Blue} -radix unsigned /servo_controller_tb/ServoController/pwm_servo_on_val

run 100 ms
# Set Zoom Level {from ms} {to ms}
WaveRestoreZoom {0 ms} {105 ms}