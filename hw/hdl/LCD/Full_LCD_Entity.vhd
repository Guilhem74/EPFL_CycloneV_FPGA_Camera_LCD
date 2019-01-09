-- Full_LCD_Entity.vhd
-- Author : Pierre Fourcade

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Full_LCD_Entity is
PORT ( 	clk	 : in std_logic;	
			nReset : in std_logic;
			
			Export_Full_FIFO : out std_logic;
			Export_Empty_FIFO : out std_logic;
			Export_Waiting	: out std_logic;
			Export_Read		: out std_logic;
			
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
end entity Full_LCD_Entity;

architecture behavioral of Full_LCD_Entity is

	component Slave_Interface
	PORT (	clk		: in std_logic;
				nReset	: in std_logic;
				
				avs_Address			: in std_logic_vector(2 downto 0);
				avs_ChipSelect		: in std_logic;
				avs_Read				: in std_logic;
				avs_Write			: in std_logic;
				avs_WriteData		: in std_logic_vector(31 downto 0);
				avs_ReadData		: out std_logic_vector(31 downto 0);
				
				Buffer_Saved	: in std_logic_vector(1 downto 0);
				
				Display_Buffer	: out std_logic_vector(1 downto 0);
				
				Master_Ready	: in std_logic;
				StartAdd			: out std_logic_vector(31 downto 0);
				LengthBuffer 	: out std_logic_vector(31 downto 0);
				Master_Start 	: out std_logic;
				
				LCD_Control_Ready : in std_logic;
				Done_Command_Data : in std_logic;
				State_Command_Data: out std_logic_vector(1 downto 0);
				Command_Data 		: out std_logic_vector(15 downto 0));
	end component Slave_Interface;
	
	component Master_Interface
	PORT (	clk		: in std_logic;
				nReset	: in std_logic;
				
				avm_WaitRequest	: in std_logic;
				avm_ReadDataValid	: in std_logic;
				avm_ReadData	 	: in std_logic_vector(31 downto 0);
				avm_Read 			: out std_logic;
				avm_Address 		: out std_logic_vector(31 downto 0);
				avm_ByteEnable 	: out std_logic_vector(3 downto 0);
				avm_BurstCount 	: out std_logic_vector(4 downto 0);
				
				StartAdd			: in std_logic_vector(31 downto 0);
				LengthBuffer 	: in std_logic_vector(31 downto 0);
				Display_Buffer	: in std_logic_vector(1 downto 0);
				Master_Start 	: in std_logic;
				
				Read_16_words	: in std_logic;
				Master_Ready 	: out std_logic;
				Waiting_Space	: out std_logic;
				
				Full_FIFO			: in std_logic;
				Empty_FIFO			: in std_logic;
				Write_FIFO_Word	: in std_logic_vector(8 downto 0);
				Write_FIFO 			: out std_logic;
				Write_FIFO_Data 	: out std_logic_vector(31 downto 0));
	end component Master_Interface;
	
	component FIFO_entity
	PORT ( 	clk		: in std_logic;
				nReset	: in std_logic;
				
				Write_FIFO		: in std_logic;
				Read_FIFO		: in std_logic;
				Write_FIFO_Data: in std_logic_vector(31 downto 0);
				Read_FIFO_Data	: out std_logic_vector(15 downto 0);
				Write_FIFO_Word: out std_logic_vector(8 downto 0);
				Read_FIFO_Word	: out std_logic_vector(9 downto 0);
				Full_FIFO		: out std_logic;
				Empty_FIFO		: out std_logic);
	end component FIFO_entity;
	
	component LCD_Control
	PORT (	clk 		: in std_logic;
				nReset 	: in std_logic;
				
				Read_FIFO_Data : in std_logic_vector(15 downto 0);
				Read_FIFO_Word	: in std_logic_vector(9 downto 0);
				Full_FIFO 		: in std_logic;
				Empty_FIFO		: in std_logic;
				Read_FIFO 		: out std_logic;
				
				Master_Ready : in std_logic;
				Waiting_Space: in std_logic;
				Read_16_Words: out std_logic;
				
				Command_Data 		: in std_logic_vector(15 downto 0);
				State_Command_Data: in std_logic_vector(1 downto 0);
				Done_Command_Data : out std_logic;
				LCD_Control_Ready : out std_logic;
				
				CSX 	: out std_logic;
				D_CX 	: out std_logic;
				WRX 	: out std_logic;
				RDX 	: out std_logic;
				D 		: out std_logic_vector(15 downto 0));
	end component LCD_Control;
	
	signal Done_Command_Data_in, LCD_Control_Ready_in 	: std_logic;
	signal State_Command_Data_in : std_logic_vector(1 downto 0);
	signal Command_Data_in			: std_logic_vector(15 downto 0);
	
	signal StartAdd_in, LengthBuffer_in			: std_logic_vector(31 downto 0);
	signal Display_Buffer_in 						: std_logic_vector(1 downto 0);
	signal Master_Start_in, Master_Ready_in 	: std_logic;
	signal Read_16_Words_in, Waiting_Space_in : std_logic;
	
	signal Write_FIFO_in, Read_FIFO_in, Full_FIFO_in, Empty_FIFO_in : std_logic;
	signal Write_FIFO_Data_in : std_logic_vector(31 downto 0);
	signal Read_FIFO_Data_in : std_logic_vector(15 downto 0);
	signal Write_FIFO_Word_in : std_logic_vector(8 downto 0);
	signal Read_FIFO_Word_in : std_logic_vector(9 downto 0);
	
	begin
	
	Export_Full_FIFO <= Full_FIFO_in;
	Export_Empty_FIFO <= Empty_FIFO_in;
	Export_Waiting <= Waiting_Space_in;
	Export_Read	<= Read_16_Words_in;
	
	
	Display_Buffer <= Display_Buffer_in;
	
	Slave : Slave_Interface	PORT MAP (	clk 							=> clk,
													nReset 						=> nReset,
													LCD_Control_Ready			=> LCD_Control_Ready_in,
													State_Command_Data		=> State_Command_Data_in,
													Done_Command_Data			=> Done_Command_Data_in,
													Buffer_Saved				=> Buffer_Saved,
													Master_Ready				=> Master_Ready_in,
													Command_Data		 		=> Command_Data_in,
													Display_Buffer				=> Display_Buffer_in,
													Master_Start				=> Master_Start_in,
													StartAdd						=> StartAdd_in,
													LengthBuffer				=> LengthBuffer_in,
													avs_Address					=> avs_Address,
													avs_ChipSelect				=> avs_ChipSelect,
													avs_Read						=> avs_Read,
													avs_Write					=> avs_Write,
													avs_WriteData				=> avs_WriteData,
													avs_ReadData				=> avs_ReadData);
													
		Master : Master_Interface PORT MAP (	clk					=> clk,
															nReset				=> nReset,
															Full_FIFO			=> Full_FIFO_in,
															Waiting_Space		=> Waiting_Space_in,
															Read_16_Words		=> Read_16_Words_in,
															Empty_FIFO			=> Empty_FIFO_in,
															Display_Buffer		=> Display_Buffer_in,
															Master_Start		=> Master_Start_in,
															StartAdd				=> StartAdd_in,
															LengthBuffer		=> LengthBuffer_in,
															Write_FIFO			=> Write_FIFO_in,
															Write_FIFO_Word	=> Write_FIFO_Word_in,
															Write_FIFO_Data	=> Write_FIFO_Data_in,
															Master_Ready 		=> Master_Ready_in,
															avm_WaitRequest	=> avm_WaitRequest,
															avm_ReadDataValid	=> avm_ReadDataValid,
															avm_ReadData	 	=> avm_ReadData,
															avm_Read 			=> avm_Read,
															avm_Address 		=> avm_Address,
															avm_ByteEnable 	=> avm_ByteEnable,
															avm_BurstCount 	=> avm_BurstCount);
															
		FIFO : FIFO_entity PORT MAP (	clk 				=> clk,
												nReset 			=> nReset,
												Write_FIFO 		=> Write_FIFO_in,
												Read_FIFO		=> Read_FIFO_in,
												Write_FIFO_Data=> Write_FIFO_Data_in,
												Read_FIFO_Data	=> Read_FIFO_Data_in,
												Write_FIFO_Word=> Write_FIFO_Word_in,
												Read_FIFO_Word => Read_FIFO_Word_in,
												Full_FIFO		=> Full_FIFO_in,
												Empty_FIFO		=> Empty_FIFO_in);
												
		LCD_Control_bis : LCD_Control	 PORT MAP (	clk 							=> clk,
																nReset 						=> nReset,
																Read_FIFO_Data 			=> Read_FIFO_Data_in,
																Read_FIFO_Word				=> Read_FIFO_Word_in,
																Waiting_Space				=> Waiting_Space_in,
																Read_16_Words				=> Read_16_Words_in,
																Empty_FIFO					=> Empty_FIFO_in,
																Full_FIFO					=> Full_FIFO_in,
																Read_FIFO 					=> Read_FIFO_in,
																Master_Ready 				=> Master_Ready_in,
																LCD_Control_Ready			=> LCD_Control_Ready_in,
																Command_Data		 		=> Command_Data_in,
																State_Command_Data		=> State_Command_Data_in,
																Done_Command_Data			=> Done_Command_Data_in,
																CSX 							=> CSX,
																D_CX 							=> D_CX,
																WRX 							=> WRX,
																RDX 							=> RDX,
																D 								=> D);
																	
end architecture behavioral;
