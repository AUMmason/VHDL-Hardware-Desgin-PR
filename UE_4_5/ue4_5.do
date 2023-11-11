quit -sim 

# Files needed for Simulation
vcom VHDL-Hardware-Desgin-PR\\UE_4_5\\sync_chain_ea.vhd
vcom VHDL-Hardware-Desgin-PR\\UE_4_5\\sync_chain_tb.vhd

# Start Simulation
vsim -t ms sync_chain_tb

# Label
add wave -divider Inputs

add wave -noupdate -color Cyan /sync_chain_tb/async_i
add wave -noupdate -color {Slate Blue} /sync_chain_tb/reset
add wave -noupdate -color {Slate Blue} /sync_chain_tb/clk

# Label
add wave -divider Outputs

add wave -noupdate /sync_chain_tb/sync_o

# Label
add wave -divider Internal

add wave -noupdate -color {Medium Slate Blue} -radix symbolic /sync_chain_tb/sync_chain/sync_chain
add wave -noupdate -color {Medium Slate Blue} -radix symbolic /sync_chain_tb/sync_chain/sync_chain_next

# Label
add wave -divider Configurations

add wave -noupdate -color {Medium Slate Blue} /sync_chain_tb/sync_chain/CHAIN_LENGTH

run 500 ms
# Set Zoom Level {from ms} {to ms}
WaveRestoreZoom {0 ms} {525 ms}