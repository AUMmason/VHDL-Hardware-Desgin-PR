onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color {Cornflower Blue} /delta_adc_tb/clk
add wave -noupdate -color {Orange Red} /delta_adc_tb/reset
add wave -noupdate /delta_adc_tb/adc_valid_strobe
add wave -noupdate /delta_adc_tb/Delta_ADC/sampling_strobe
add wave -noupdate /delta_adc_tb/comparator
add wave -noupdate /delta_adc_tb/Delta_ADC/adc_value
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {212748112 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 252
configure wave -valuecolwidth 65
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {279006528 ns}
