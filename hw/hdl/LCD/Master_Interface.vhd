-- Master_Interface.vhd
-- Author : Pierre Fourcade
--
-- Master Interface entity.
-- This identity, once asked by the Slave interface, go retrieve the data from the memory and give it to the FIFO.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Master_Interface is
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
			Buffer_Saved	: in std_logic_vector(1 downto 0);
			Display_Buffer : out std_logic_vector(1 downto 0);
			
			Write_16			: in std_logic;
			Master_Start	: in std_logic;
			Master_Ready 	: out std_logic;
			Master_Waiting	: out std_logic;
			
			Full_FIFO			: in std_logic;
			Empty_FIFO			: in std_logic;
			Write_FIFO_Word	: in std_logic_vector(8 downto 0);
			Write_FIFO 			: out std_logic;
			Write_FIFO_Data 	: out std_logic_vector(31 downto 0));
end entity Master_Interface;
			
architecture behavioral of Master_Interface is

	-- State declaration
	type state is (Init, Copy, Assert_Read_Data, Check_WaitRequest, Read_Data, New_Add, Check_Add, Check_FIFO, Wait_LCD_Control);
	signal state_reg, state_next : state;
	
	signal Add_next, Add_reg					: unsigned(31 downto 0);
	signal EndAdd_next, EndAdd_reg			: unsigned(31 downto 0);
	signal BufferUsed_next, BufferUsed_reg : std_logic_vector(1 downto 0);
	signal avm_Read_next, avm_Read_reg 		: std_logic;
	
	signal counter_word_next, counter_word_reg : integer range 0 to 16;

	signal Word_Count : integer range 0 to 512;
	
	begin
	
		Word_Count <= to_integer(unsigned(Write_FIFO_Word)); -- Not used here.
	
		Next_State_Logic : process(state_reg, Master_Start, Empty_FIFO, avm_WaitRequest, counter_word_reg, Add_reg, EndAdd_reg, Full_FIFO, Write_16)
		
			begin
			
				state_next <= state_reg;
				
				case state_reg is
					when Init 					=> if Master_Start = '1' then
															state_next <= Copy;
														end if;
										
					when Copy					=> if Empty_FIFO = '1' then
															state_next <= Assert_Read_Data;
														end if;
					
					when Assert_Read_Data 	=>	state_next <= Check_WaitRequest;									
					
					when Check_WaitRequest	=> if avm_WaitRequest = '0' then
															state_next <= Read_Data;
														end if;
					
					when Read_Data				=>	if counter_word_reg = 16 then
															state_next <= New_Add;
														end if;
											
					when New_Add				=> state_next <= Check_Add;
					
					when Check_Add				=> if Add_reg = EndAdd_reg then
															state_next <= Init;
														else
															state_next <= Check_FIFO;
														end if;
					
					when Check_FIFO 			=> if Full_FIFO = '1' then
															state_Next <= Wait_LCD_Control;
														else
															state_next <= Assert_Read_Data;
														end if;
												
					when Wait_LCD_Control 	=> if Write_16 = '1' then
															state_next <= Assert_Read_Data;
														end if;
					
					when others					=> null;
				end case;
			
			end process Next_State_Logic;
			
			
		Register_Logic : process(clk, nReset)
		
			begin
				if nReset = '0' then
					state_reg 			<= Init;
					Add_reg				<= (others => '0');
					EndAdd_reg			<= (others => '0');
					counter_word_reg 	<= 0;
					BufferUsed_reg		<= "00";
					avm_Read_reg		<= '0';
				elsif rising_edge(clk) then
					state_reg 			<= state_next;
					Add_reg				<= Add_next;
					EndAdd_reg			<= EndAdd_next;
					counter_word_reg	<= counter_word_next;
					BufferUsed_reg		<= BufferUsed_next;
					avm_Read_reg		<= avm_Read_next;
				end if;
		
			end process Register_Logic;
			
			
		Combinational_Logic : process(state_reg, counter_word_reg, StartAdd, LengthBuffer, Buffer_Saved, Add_reg, EndAdd_reg, BufferUsed_reg, avm_Read_reg, avm_ReadDataValid, avm_WaitRequest, avm_ReadData)
		
			begin
			
				Add_next				<= Add_reg;
				EndAdd_next			<= EndAdd_reg;
				counter_word_next <= counter_word_reg;
				avm_Read_next		<= avm_Read_reg;
				BufferUsed_next	<= BufferUsed_reg;
				
				avm_Address 	<= (others => '0');
				avm_ByteEnable <= (others => '0');
				avm_BurstCount <= (others => '0');
				
				Master_Ready 		<= '0';
				Master_Waiting 	<= '0';
				
				Write_FIFO 			<= '0';
				Write_FIFO_Data 	<= (others => '0');
				
				case state_reg is
					when Init					=> Add_next				<= (others => '0');
														EndAdd_next			<= (others => '0');
														counter_word_next <= 0;
														BufferUsed_next 	<= "00";
														avm_Read_next 		<= '0';
														Master_Ready 		<= '1';

					when Copy 					=> Add_next 			<= unsigned(StartAdd) + unsigned(LengthBuffer(29 downto 0))*unsigned(Buffer_Saved);
														EndAdd_next			<= unsigned(StartAdd) + unsigned(LengthBuffer(29 downto 0))*(unsigned(Buffer_Saved)+1);
														BufferUsed_next 	<= Buffer_Saved;
														avm_Read_next		<= '0';
					
					when Assert_Read_Data	=> avm_Read_next	<= '1';
														avm_Address 	<= std_logic_vector(Add_reg);
														avm_ByteEnable <= "1111";
														avm_BurstCount <= "10000";
					
					when Check_WaitRequest 	=> avm_Address 	<= std_logic_vector(Add_reg);
														avm_ByteEnable <= "1111";
														avm_BurstCount <= "10000";
														if avm_WaitRequest = '0' then
															avm_Read_next		<= '0';
														end if;
					
					when Read_Data				=> if avm_ReadDataValid = '1' then
															if counter_word_reg = 16 then
																counter_word_next <= 0;
															else
																Write_FIFO 			<= '1';
																Write_FIFO_Data 	<= avm_ReadData;
																counter_word_next	<= counter_word_reg + 1;
															end if;
														end if;
											
					when New_Add				=> Add_next <= Add_reg + 64;
														counter_word_next <= 0;
														
					when Check_Add				=> null;
					
					when Check_FIFO 			=> null;
					
					when Wait_LCD_Control 	=> Master_Waiting	<= '1';
					
					when others					=> null;
				end case;
			
			end process Combinational_Logic;
	
		avm_Read 		<= avm_Read_reg;
		Display_Buffer <= BufferUsed_reg;
	
end architecture behavioral;