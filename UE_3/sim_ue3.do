onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Cyan /pwm_tb/clk
add wave -noupdate -color Red /pwm_tb/reset
add wave -noupdate /pwm_tb/PWM_pin
add wave -noupdate -color {Cornflower Blue} /pwm_tb/ON_counter_val
add wave -noupdate -color {Cornflower Blue} /pwm_tb/Period_counter_val
add wave -noupdate -color {Cornflower Blue} /pwm_tb/PWM_Module/counter_val
add wave -noupdate -color {Cornflower Blue} /pwm_tb/PWM_Module/next_counter_val
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {66904498 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 244
configure wave -valuecolwidth 38
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
configure wave -timelineunits ms
update
WaveRestoreZoom {21938630 ns} {367266388 ns}
