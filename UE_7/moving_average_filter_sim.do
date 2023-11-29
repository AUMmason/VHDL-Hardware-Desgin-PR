quit -sim 

# Files needed for Simulation
vcom VHDL-Hardware-Desgin-PR\\UE_4\\strobe_generator_a.vhd
vcom VHDL-Hardware-Desgin-PR\\UE_4\\strobe_generator_e.vhd
vcom VHDL-Hardware-Desgin-PR\\UE_7\\unsigned_shift_register_ea.vhd
vcom VHDL-Hardware-Desgin-PR\\UE_7\\moving_average_filter_tb.vhd
vcom VHDL-Hardware-Desgin-PR\\UE_7\\moving_average_filter_ea.vhd

# Start Simulation
vsim -voptargs="\+acc" -t ms moving_average_filter_tb

# Label
add wave -divider Inputs

add wave -noupdate -color {Cornflower Blue} -radix symbolic /moving_average_filter_tb/clk
add wave -noupdate -color {Cornflower Blue} -radix symbolic /moving_average_filter_tb/reset
add wave -noupdate -color Cyan -radix unsigned /moving_average_filter_tb/strobe_valid
add wave -noupdate -radix unsigned /moving_average_filter_tb/data_i


# Label
add wave -divider Outputs

add wave -noupdate -color Cyan -radix symbolic /moving_average_filter_tb/strobe_valid
add wave -noupdate -radix unsigned /moving_average_filter_tb/data_o

# Label
add wave -divider Internal

add wave -noupdate -color Cyan -radix unsigned /moving_average_filter_tb/Moving_Average/sum
add wave -noupdate -color Cyan -radix unsigned /moving_average_filter_tb/Moving_Average/sum_next
add wave -noupdate -color Cyan -radix unsigned /moving_average_filter_tb/Moving_Average/data_last
add wave -noupdate -color Cyan -radix unsigned /moving_average_filter_tb/Moving_Average/data_o

run 1500 ms
# Set Zoom Level {from ms} {to ms}
WaveRestoreZoom {0 ms} {1550 ms}