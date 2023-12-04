quit -sim 

# Files needed for Simulation

vcom ../UE_5/servo_package.vhd
vcom tilt_package.vhd
vcom tilt_ea.vhd
vcom tilt_tb.vhd

# Start Simulation
vsim -voptargs="\+acc" -t ns tilt_tb

# Label
add wave -divider Inputs

add wave -noupdate -color {Cornflower Blue} -radix symbolic /tilt_tb/reset
add wave -noupdate -color {Cornflower Blue} -radix symbolic /tilt_tb/clk
add wave -noupdate -color Cyan -radix unsigned /tilt_tb/adc_value

# Label
add wave -divider Outputs

add wave -noupdate -color Cyan -radix unsigned /tilt_tb/pwm_on

# Label
# add wave -divider Internal

# add wave -noupdate -color {Medium Slate Blue} -radix unsigned /servo_controller_tb/ServoController/pwm_servo_on_val

run 600 ns
# Set Zoom Level {from ns} {to ns}
WaveRestoreZoom {0 ns} {600 ns}