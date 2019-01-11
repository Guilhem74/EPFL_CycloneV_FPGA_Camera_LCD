-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "12/15/2018 19:51:32"
                                                            
-- Vhdl Test Bench template for design  :  Top_Level
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;                                
                              

ENTITY Top_Level_vhd_tst IS
END Top_Level_vhd_tst;
ARCHITECTURE Top_Level_arch OF Top_Level_vhd_tst IS
-- constants        
signal finished : boolean := FALSE;
constant CLK_PER :time := 20 ns ;     
signal Clk_FPGA : std_logic:= '0';
                                    
SIGNAL nReset :  std_logic;		
 SIGNAL CSX 	:  std_logic;
 SIGNAL D_CX 	:  std_logic;
 SIGNAL WRX 	:  std_logic;
 SIGNAL RDX 	:  std_logic;
 SIGNAL D 		:  std_logic_vector(15 downto 0);
 SIGNAL avs_Address			:  std_logic_vector(2 downto 0);
 SIGNAL avs_ChipSelect		:  std_logic;
 SIGNAL avs_Read				:  std_logic;
 SIGNAL avs_Write			:  std_logic;
 SIGNAL avs_WriteData		:  std_logic_vector(31 downto 0);
 SIGNAL avs_ReadData		:  std_logic_vector(31 downto 0);
 SIGNAL avm_WaitRequest	:  std_logic:='0';
 SIGNAL avm_ReadDataValid	:  std_logic:='0';
 SIGNAL avm_ReadData	 	:  std_logic_vector(31 downto 0):=std_logic_vector(to_unsigned(0,32));
 SIGNAL avm_Read 			:  std_logic;
 SIGNAL avm_Address 		:  std_logic_vector(31 downto 0);
 SIGNAL avm_ByteEnable 	:  std_logic_vector(3 downto 0);
 SIGNAL avm_BurstCount 	:  std_logic_vector(4 downto 0);
 SIGNAL Buffer_Saved				:  std_logic_vector(1 downto 0);
 SIGNAL Display_Buffer				:  std_logic_vector(1 downto 0);
			
Component Full_LCD_Entity is
PORT ( 		clk	 : in std_logic;	
			nReset : in std_logic;
			
			CSX 	: out std_logic;
			D_CX 	: out std_logic;
			WRX 	: out std_logic;
			RDX 	: out std_logic;
			D 		: out std_logic_vector(15 downto 0);
			
			avs_Address			: in std_logic_vector(2 downto 0);
			avs_ChipSelect		: in std_logic;
			avs_Read				: in std_logic;
			avs_Write			: in std_logic;
			avs_WriteData		: in std_logic_vector(31 downto 0);
			avs_ReadData		: out std_logic_vector(31 downto 0);
			
			avm_WaitRequest	: in std_logic;
			avm_ReadDataValid	: in std_logic;
			avm_ReadData	 	: in std_logic_vector(31 downto 0);
			avm_Read 			: out std_logic;
			avm_Address 		: out std_logic_vector(31 downto 0);
			avm_ByteEnable 	: out std_logic_vector(3 downto 0);
			avm_BurstCount 	: out std_logic_vector(4 downto 0);
			
			Buffer_Saved				: in std_logic_vector(1 downto 0);
			Display_Buffer				: out std_logic_vector(1 downto 0));
end Component;

BEGIN
	i1 : Full_LCD_Entity
	PORT MAP ( 	clk	 =>Clk_FPGA, 	
			nReset => nReset,
			CSX 	=> CSX,
			D_CX 	=> D_CX,
			WRX 	=> WRX,
			RDX 	=> RDX,
			D 		=> D,
			avs_Address			=> avs_Address,
			avs_ChipSelect		=> avs_ChipSelect,
			avs_Read			=> avs_Read,
			avs_Write			=> avs_Write,
			avs_WriteData		=> avs_WriteData,
			avs_ReadData		=> avs_ReadData,
			
			avm_WaitRequest	=> avm_WaitRequest,
			avm_ReadDataValid	=> avm_ReadDataValid,
			avm_ReadData	 	=> avm_ReadData,
			avm_Read 			=> avm_Read,
			avm_Address 		=> avm_Address,
			avm_ByteEnable 	=> avm_ByteEnable,
			avm_BurstCount 	=> avm_BurstCount,
			Buffer_Saved				=> Buffer_Saved,
			Display_Buffer				=> Display_Buffer
			);
 Clk_FPGA <= not(Clk_FPGA) after CLK_PER/2 when not finished;

process
      procedure init is
      begin
		 nReset <=	'1';
		 avs_Address(2 downto 0)<=(others =>'0');
		 avs_ChipSelect		<='0';
		 avs_Read			<='0';
		 avs_Write			<='0';
		 avs_WriteData(31 downto 0)<=(others =>'0');
		 Buffer_Saved(1 downto 0)<=(others =>'0');

         wait for CLK_PER/4;
         nReset <= '0';
         wait for CLK_PER/2;
         nReset <= '1';

         wait until rising_edge(Clk_FPGA);
      end procedure init;
      -- do one multiplication and verify the result
 
	procedure Write_And_Read_Avalon_Slave (Address : in STD_LOGIC_VECTOR(2 downto 0);Data : in STD_LOGIC_VECTOR(31 downto 0)) is
   							--when "000" => 	avs_ReadData(15 downto 0) 	<= RegCommandData;
							--when "001" => 	avs_ReadData(1 downto 0)	<= RegStateCommandData;
							--when "010" => 	avs_ReadData 					<= RegStartAdd;
							--when "011" =>		avs_ReadData					<= RegLengthBuffer;
							--when "100" => 	avs_ReadData(1 downto 0)	<= RegDisplayBuffer;
							--when "101" => 	avs_ReadData(1 downto 0) 	<= RegBufferSaved;
	begin
		wait until rising_edge(Clk_FPGA);
		avs_Write<='1';
		avs_WriteData<= Data;
		avs_Address<=Address;
		avs_ChipSelect<='1';
		wait until rising_edge(Clk_FPGA);
		avs_Address<=Address;
		avs_Read<='1';
		avs_ChipSelect<='1';
		wait until rising_edge(Clk_FPGA);
		avs_Address<="000";
		avs_Read<='0';
		avs_ChipSelect<='0';
   end procedure Write_And_Read_Avalon_Slave;

   begin
   	init;
   	Write_And_Read_Avalon_Slave("010",std_logic_vector(to_unsigned(0,32)));--RegStartAdd
		Write_And_Read_Avalon_Slave("011",std_logic_vector(to_unsigned(640,32)));--Length   	
   	Write_And_Read_Avalon_Slave("100",std_logic_vector(to_unsigned(0,32)));--RegDisplayBuffer
		wait until rising_edge(Clk_FPGA);
		wait until rising_edge(Clk_FPGA);
	Write_And_Read_Avalon_Slave("000",std_logic_vector(to_unsigned(21,32)));--RegStartAdd
   	Write_And_Read_Avalon_Slave("001",std_logic_vector(to_unsigned(1,32)));--RegStateCommandData
	  wait for 20*CLK_PER;
	Write_And_Read_Avalon_Slave("000",std_logic_vector(to_unsigned(17,32)));--RegStartAdd
   	Write_And_Read_Avalon_Slave("001",std_logic_vector(to_unsigned(1,32)));--RegStateCommandData
   	Write_And_Read_Avalon_Slave("000",std_logic_vector(to_unsigned(44,32)));--RegStartAdd
   	Write_And_Read_Avalon_Slave("001",std_logic_vector(to_unsigned(3,32)));--RegStateCommandData

	
      wait until rising_edge(Clk_FPGA);
      --Send_Frame(std_logic_vector(to_unsigned(21,32)));
      wait until rising_edge(Clk_FPGA);
      --Send_Frame(std_logic_vector(to_unsigned(21,32)));
	  wait for 2000*CLK_PER;
      finished <= TRUE;
      wait;
end process; 

process 
  procedure Receive_Frame (a : in STD_LOGIC_VECTOR(31 downto 0)) is
		variable i: integer:=0;
   	begin
		for i in 0 to 15 loop
			
      			avm_ReadDataValid	<='1';
			avm_ReadData(31 downto 0)<=std_logic_vector(to_unsigned(i+1,32));
			wait until rising_edge(Clk_FPGA);
			wait for 5ns;
		end loop;
			avm_ReadDataValid	<='0';
			wait for 5ns;
			avm_ReadData(31 downto 0)<=std_logic_vector(to_unsigned(0,32));
	end procedure Receive_Frame;
begin
avm_WaitRequest<='0';
wait until rising_edge(avm_Read);
wait for 1ns;
avm_WaitRequest<='1';--1
wait until rising_edge(Clk_FPGA);
wait for 1ns;

avm_WaitRequest<='0';
Receive_Frame(std_logic_vector(to_unsigned(21,32)));

wait for 30ns;
avm_WaitRequest<='0';--1
wait for 100ns;
avm_WaitRequest<='0';
end process;                                                      
END Top_Level_arch;
