quit -sim 

# Files needed for Simulation

vcom VHDL-Hardware-Desgin-PR/UE_5/servo_package.vhd
vcom VHDL-Hardware-Desgin-PR/UE_6/tilt_package.vhd
vcom VHDL-Hardware-Desgin-PR/UE_6/tilt_ea.vhd
vcom VHDL-Hardware-Desgin-PR/UE_6/tilt_tb.vhd

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
add wave -divider Constants
add wave -noupdate -color {Cornflower Blue} -radix unsigned /tilt_tb/tilt/ADC_STEP_SIZE
add wave -noupdate -color {Cornflower Blue} -radix unsigned /tilt_tb/tilt/ADC_CORRECTION

run 600 ns
# Set Zoom Level {from ns} {to ns}
WaveRestoreZoom {0 ns} {600 ns}