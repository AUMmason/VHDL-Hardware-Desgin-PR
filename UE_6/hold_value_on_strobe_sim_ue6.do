quit -sim 

# Files needed for Simulation

vcom VHDL-Hardware-Desgin-PR/UE_4/strobe_generator_e.vhd
vcom VHDL-Hardware-Desgin-PR/UE_4/strobe_generator_a.vhd
vcom VHDL-Hardware-Desgin-PR/UE_6/hold_value_on_strobe_ea.vhd
vcom VHDL-Hardware-Desgin-PR/UE_6/hold_value_on_strobe_tb.vhd

# Start Simulation
vsim -voptargs="\+acc" -t ns hold_value_on_strobe_tb

# Label
add wave -divider Inputs

add wave -noupdate -color {Cornflower Blue} -radix symbolic /hold_value_on_strobe_tb/reset
add wave -noupdate -color {Cornflower Blue} -radix symbolic /hold_value_on_strobe_tb/clk
add wave -noupdate -color Cyan -radix unsigned /hold_value_on_strobe_tb/value_in
add wave -noupdate -color Cyan -radix unsigned /hold_value_on_strobe_tb/strobe

# Label
add wave -divider Outputs

add wave -noupdate -color Cyan -radix unsigned /hold_value_on_strobe_tb/value_out

# Label
add wave -divider Internal
add wave -noupdate -color {Cornflower Blue} -radix unsigned /hold_value_on_strobe_tb/HoldValueOnStrobe/hold_value
add wave -noupdate -color {Cornflower Blue} -radix unsigned /hold_value_on_strobe_tb/HoldValueOnStrobe/hold_value_next

run 800 ns
# Set Zoom Level {from ns} {to ns}
WaveRestoreZoom {0 ns} {800 ns}