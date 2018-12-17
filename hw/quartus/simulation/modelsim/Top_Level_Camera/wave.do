onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /top_level_vhd_tst/i1/FVAL
add wave -noupdate -radix decimal /top_level_vhd_tst/i1/LVAL
add wave -noupdate -radix decimal /top_level_vhd_tst/i1/Master_Interface_inst/Reset_n
add wave -noupdate -radix decimal /top_level_vhd_tst/i1/Master_Interface_inst/Address
add wave -noupdate -radix decimal /top_level_vhd_tst/i1/Master_Interface_inst/Length_Frame
add wave -noupdate -radix decimal /top_level_vhd_tst/i1/Master_Interface_inst/Ready
add wave -noupdate -radix decimal /top_level_vhd_tst/i1/Master_Interface_inst/FIFO_Data_Available
add wave -noupdate -radix decimal /top_level_vhd_tst/i1/Master_Interface_inst/FIFO_Read_Request
add wave -noupdate -radix decimal /top_level_vhd_tst/i1/Master_Interface_inst/FIFO_Read_Data
add wave -noupdate -radix decimal /top_level_vhd_tst/i1/Master_Interface_inst/AM_readdatavalid
add wave -noupdate -radix decimal /top_level_vhd_tst/i1/Master_Interface_inst/AM_Adresse
add wave -noupdate -radix decimal /top_level_vhd_tst/i1/Master_Interface_inst/AM_ByteEnable
add wave -noupdate -radix decimal /top_level_vhd_tst/i1/Master_Interface_inst/AM_Write
add wave -noupdate -radix decimal /top_level_vhd_tst/i1/Master_Interface_inst/AM_Read
add wave -noupdate -radix decimal /top_level_vhd_tst/i1/Master_Interface_inst/Clk
add wave -noupdate -radix decimal /top_level_vhd_tst/i1/Master_Interface_inst/AM_DataWrite
add wave -noupdate -radix unsigned /top_level_vhd_tst/i1/Master_Interface_inst/Actual_Value_indice_DMA
add wave -noupdate -radix decimal /top_level_vhd_tst/i1/Master_Interface_inst/AM_BurstCount
add wave -noupdate -radix decimal /top_level_vhd_tst/i1/Master_Interface_inst/AM_DataRead
add wave -noupdate /top_level_vhd_tst/i1/Master_Interface_inst/AM_beginbursttransfer
add wave -noupdate -radix decimal /top_level_vhd_tst/i1/Master_Interface_inst/AM_WaitRequest
add wave -noupdate -radix decimal /top_level_vhd_tst/i1/Master_Interface_inst/Current_Address
add wave -noupdate -radix decimal /top_level_vhd_tst/i1/Master_Interface_inst/Offset_Address
add wave -noupdate -radix decimal /top_level_vhd_tst/i1/Master_Interface_inst/Copy_Base_Address
add wave -noupdate -radix decimal /top_level_vhd_tst/i1/Master_Interface_inst/State
add wave -noupdate -radix decimal /top_level_vhd_tst/i1/Master_Interface_inst/Actual_Value_indice_FIFO
add wave -noupdate -radix decimal -childformat {{/top_level_vhd_tst/i1/Master_Interface_inst/DATA_Array(8) -radix decimal} {/top_level_vhd_tst/i1/Master_Interface_inst/DATA_Array(7) -radix decimal} {/top_level_vhd_tst/i1/Master_Interface_inst/DATA_Array(6) -radix decimal} {/top_level_vhd_tst/i1/Master_Interface_inst/DATA_Array(5) -radix decimal} {/top_level_vhd_tst/i1/Master_Interface_inst/DATA_Array(4) -radix decimal} {/top_level_vhd_tst/i1/Master_Interface_inst/DATA_Array(3) -radix decimal} {/top_level_vhd_tst/i1/Master_Interface_inst/DATA_Array(2) -radix decimal} {/top_level_vhd_tst/i1/Master_Interface_inst/DATA_Array(1) -radix decimal} {/top_level_vhd_tst/i1/Master_Interface_inst/DATA_Array(0) -radix decimal}} -expand -subitemconfig {/top_level_vhd_tst/i1/Master_Interface_inst/DATA_Array(8) {-height 15 -radix decimal} /top_level_vhd_tst/i1/Master_Interface_inst/DATA_Array(7) {-height 15 -radix decimal} /top_level_vhd_tst/i1/Master_Interface_inst/DATA_Array(6) {-height 15 -radix decimal} /top_level_vhd_tst/i1/Master_Interface_inst/DATA_Array(5) {-height 15 -radix decimal} /top_level_vhd_tst/i1/Master_Interface_inst/DATA_Array(4) {-height 15 -radix decimal} /top_level_vhd_tst/i1/Master_Interface_inst/DATA_Array(3) {-height 15 -radix decimal} /top_level_vhd_tst/i1/Master_Interface_inst/DATA_Array(2) {-height 15 -radix decimal} /top_level_vhd_tst/i1/Master_Interface_inst/DATA_Array(1) {-height 15 -radix decimal} /top_level_vhd_tst/i1/Master_Interface_inst/DATA_Array(0) {-height 15 -radix decimal}} /top_level_vhd_tst/i1/Master_Interface_inst/DATA_Array
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8511300 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {10878 ns}
