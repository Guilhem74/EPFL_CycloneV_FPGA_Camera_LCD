onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group FIFO -radix decimal /master_interface_vhd_tst/FIFO_1_inst/aclr
add wave -noupdate -expand -group FIFO -radix decimal /master_interface_vhd_tst/FIFO_1_inst/clock
add wave -noupdate -expand -group FIFO -radix decimal /master_interface_vhd_tst/FIFO_1_inst/data
add wave -noupdate -expand -group FIFO -radix decimal /master_interface_vhd_tst/FIFO_1_inst/rdreq
add wave -noupdate -expand -group FIFO -radix decimal /master_interface_vhd_tst/FIFO_1_inst/wrreq
add wave -noupdate -expand -group FIFO -radix decimal /master_interface_vhd_tst/FIFO_1_inst/almost_empty
add wave -noupdate -expand -group FIFO -radix decimal /master_interface_vhd_tst/FIFO_1_inst/almost_full
add wave -noupdate -expand -group FIFO -radix decimal /master_interface_vhd_tst/FIFO_1_inst/empty
add wave -noupdate -expand -group FIFO -radix decimal /master_interface_vhd_tst/FIFO_1_inst/full
add wave -noupdate -expand -group FIFO -radix decimal /master_interface_vhd_tst/FIFO_1_inst/q
add wave -noupdate -expand -group FIFO -radix decimal /master_interface_vhd_tst/FIFO_1_inst/usedw
add wave -noupdate -expand -group {Master Interface} -radix decimal /master_interface_vhd_tst/i1/Reset_n
add wave -noupdate -expand -group {Master Interface} -radix decimal /master_interface_vhd_tst/i1/Address
add wave -noupdate -expand -group {Master Interface} -radix decimal /master_interface_vhd_tst/i1/Ready
add wave -noupdate -expand -group {Master Interface} -radix decimal /master_interface_vhd_tst/i1/FIFO_Data_Available
add wave -noupdate -expand -group {Master Interface} -radix decimal /master_interface_vhd_tst/i1/FIFO_Read_Request
add wave -noupdate -expand -group {Master Interface} -radix decimal /master_interface_vhd_tst/i1/FIFO_Read_Data
add wave -noupdate -expand -group {Master Interface} -radix hexadecimal /master_interface_vhd_tst/i1/AM_Adresse
add wave -noupdate -expand -group {Master Interface} -radix binary /master_interface_vhd_tst/i1/AM_ByteEnable
add wave -noupdate -expand -group {Master Interface} -radix decimal /master_interface_vhd_tst/i1/AM_Write
add wave -noupdate -expand -group {Master Interface} -radix decimal /master_interface_vhd_tst/i1/AM_Read
add wave -noupdate -expand -group {Master Interface} -radix decimal /master_interface_vhd_tst/i1/AM_DataWrite
add wave -noupdate -expand -group {Master Interface} -radix decimal /master_interface_vhd_tst/i1/AM_BurstCount
add wave -noupdate -expand -group {Master Interface} -radix decimal /master_interface_vhd_tst/i1/AM_DataRead
add wave -noupdate -expand -group {Master Interface} -radix decimal /master_interface_vhd_tst/i1/AM_WaitRequest
add wave -noupdate -expand -group {Master Interface} -radix decimal /master_interface_vhd_tst/i1/Current_Address
add wave -noupdate -expand -group {Master Interface} -radix decimal /master_interface_vhd_tst/i1/State
add wave -noupdate -expand -group {Master Interface} -radix decimal /master_interface_vhd_tst/i1/Actual_Value_indice_FIFO
add wave -noupdate -expand -group {Master Interface} -radix decimal /master_interface_vhd_tst/i1/Actual_Value_indice_DMA
add wave -noupdate -expand -group {Master Interface} -radix decimal /master_interface_vhd_tst/i1/Clk
add wave -noupdate -expand -group {Master Interface} -radix decimal -childformat {{/master_interface_vhd_tst/i1/DATA_Array(7) -radix decimal} {/master_interface_vhd_tst/i1/DATA_Array(6) -radix decimal} {/master_interface_vhd_tst/i1/DATA_Array(5) -radix decimal} {/master_interface_vhd_tst/i1/DATA_Array(4) -radix decimal} {/master_interface_vhd_tst/i1/DATA_Array(3) -radix decimal} {/master_interface_vhd_tst/i1/DATA_Array(2) -radix decimal} {/master_interface_vhd_tst/i1/DATA_Array(1) -radix decimal} {/master_interface_vhd_tst/i1/DATA_Array(0) -radix decimal}} -subitemconfig {/master_interface_vhd_tst/i1/DATA_Array(7) {-height 15 -radix decimal} /master_interface_vhd_tst/i1/DATA_Array(6) {-height 15 -radix decimal} /master_interface_vhd_tst/i1/DATA_Array(5) {-height 15 -radix decimal} /master_interface_vhd_tst/i1/DATA_Array(4) {-height 15 -radix decimal} /master_interface_vhd_tst/i1/DATA_Array(3) {-height 15 -radix decimal} /master_interface_vhd_tst/i1/DATA_Array(2) {-height 15 -radix decimal} /master_interface_vhd_tst/i1/DATA_Array(1) {-height 15 -radix decimal} /master_interface_vhd_tst/i1/DATA_Array(0) {-height 15 -radix decimal}} /master_interface_vhd_tst/i1/DATA_Array
add wave -noupdate -expand -group {Master Interface} -radix decimal /master_interface_vhd_tst/i1/Number_Of_Transfert
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {790354 ps} 0}
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
WaveRestoreZoom {404500 ps} {1055500 ps}
