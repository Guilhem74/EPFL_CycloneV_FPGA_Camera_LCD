onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group External /acquisition_module_vhd_tst/Clk
add wave -noupdate -expand -group External /acquisition_module_vhd_tst/Data_Camera
add wave -noupdate -expand -group External /acquisition_module_vhd_tst/FVAL
add wave -noupdate -expand -group External /acquisition_module_vhd_tst/LVAL
add wave -noupdate -expand -group External /acquisition_module_vhd_tst/Out_Pixel
add wave -noupdate -expand -group External /acquisition_module_vhd_tst/Reset_n
add wave -noupdate -expand -group External /acquisition_module_vhd_tst/finished
add wave -noupdate -expand -group External /acquisition_module_vhd_tst/CLK_PER
add wave -noupdate -expand -group External /acquisition_module_vhd_tst/Pixel_Valid_Out
add wave -noupdate -expand -group {Internals Signals} /acquisition_module_vhd_tst/i1/Clk
add wave -noupdate -expand -group {Internals Signals} /acquisition_module_vhd_tst/i1/Reset_n
add wave -noupdate -expand -group {Internals Signals} /acquisition_module_vhd_tst/i1/FVAL
add wave -noupdate -expand -group {Internals Signals} /acquisition_module_vhd_tst/i1/LVAL
add wave -noupdate -expand -group {Internals Signals} -radix decimal /acquisition_module_vhd_tst/i1/Data_Camera
add wave -noupdate -expand -group {Internals Signals} -radix decimal /acquisition_module_vhd_tst/i1/Out_Pixel
add wave -noupdate -expand -group {Internals Signals} /acquisition_module_vhd_tst/i1/Pixel_Valid_Out
add wave -noupdate -expand -group {Internals Signals} -radix decimal /acquisition_module_vhd_tst/i1/Data_Write_FIFO_Store_Line
add wave -noupdate -expand -group {Internals Signals} -radix decimal /acquisition_module_vhd_tst/i1/Data_Read_FIFO_Store_Line
add wave -noupdate -expand -group {Internals Signals} /acquisition_module_vhd_tst/i1/Write_Req_FIFO_Store_Line
add wave -noupdate -expand -group {Internals Signals} /acquisition_module_vhd_tst/i1/Read_Req_FIFO_Store_Line
add wave -noupdate -expand -group {Internals Signals} /acquisition_module_vhd_tst/i1/Clear_FIFO_Store_Line
add wave -noupdate -expand -group {Internals Signals} /acquisition_module_vhd_tst/i1/Empty_FIFO_Store_Line
add wave -noupdate -expand -group {Internals Signals} /acquisition_module_vhd_tst/i1/Full_FIFO_Store_Line
add wave -noupdate -expand -group {Internals Signals} /acquisition_module_vhd_tst/i1/Number_Words_FIFO_Store_Line
add wave -noupdate -expand -group {Internals Signals} /acquisition_module_vhd_tst/i1/State
add wave -noupdate -expand -group {Internals Signals} /acquisition_module_vhd_tst/i1/Pixel_Number
add wave -noupdate -expand -group {Internals Signals} /acquisition_module_vhd_tst/i1/Line_Number
add wave -noupdate -expand -group {Internals Signals} /acquisition_module_vhd_tst/i1/Pixel_Value
add wave -noupdate -expand -group {Internals Signals} /acquisition_module_vhd_tst/i1/Pixel_Value_Even
add wave -noupdate -expand -group {Internals Signals} /acquisition_module_vhd_tst/i1/FVAL_Previous
add wave -noupdate -expand -group {Internals Signals} /acquisition_module_vhd_tst/i1/LVAL_Previous
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {267194 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 229
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {264077 ps} {354641 ps}
