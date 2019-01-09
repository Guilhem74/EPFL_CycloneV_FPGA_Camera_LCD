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
end entity Master_Interface;
			
architecture behavioral of Master_Interface is

	-- State declaration
	type state is (Init, Copy, Assert_Read_Data, Read_Data, New_Add, Check_FIFO, Wait_LCD_Control);
	signal state_reg, state_next : state;
	
	signal Add_next, Add_reg 					: unsigned(31 downto 0);
	signal EndAdd_next, EndAdd_reg			: unsigned(31 downto 0);
	signal DataValid_next, DataValid_reg 	: std_logic;

	signal Word_Count : integer range 0 to 512;
	
	begin
	
		Word_Count <= to_integer(unsigned(Write_FIFO_Word)); -- Not used here.
	
		Next_State_Logic : process(state_reg, Master_Start, avm_WaitRequest, avm_ReadDataValid, DataValid_reg, Add_reg, EndAdd_reg, Empty_FIFO, Full_FIFO, Read_16_Words)
		
			begin
				state_next <= state_reg;
				case state_reg is
					when Init 					=> if Master_Start = '1' then
															state_next <= Copy;
														end if;
										
					when Copy					=> if Empty_FIFO = '1' then
															state_next <= Assert_Read_Data;
														end if;
					
					when Assert_Read_Data 	=>	if avm_WaitRequest = '0' then
															state_next <= Read_Data;
														end if;
														
					when Read_Data				=>	if DataValid_reg = '1' and avm_ReadDataValid = '0' then
															state_next <= New_Add;
														end if;
											
					when New_Add				=> if Add_reg + 64 >= EndAdd_reg then
															state_next <= Init;
														else
															state_next <= Check_FIFO;
														end if;
											
					when Check_FIFO 			=> if Full_FIFO = '1' then
															state_Next <= Wait_LCD_Control;
														else
															state_next <= Assert_Read_Data;
														end if;
												
					when Wait_LCD_Control 	=> if (Read_16_Words = '1' and Full_FIFO = '0') then -- LCD Control have read 16 words, we can fill the FIFO.
															state_next <= Assert_Read_Data;
														end if;
					
					when others					=> null;
				end case;
			
			end process Next_State_Logic;
			
			
		Register_Logic : process(clk, nReset)
		
			begin
				if nReset = '0' then
					state_reg 		<= Init;
					Add_reg 			<= (others => '0');
					DataValid_reg	<= '0';
				elsif rising_edge(clk) then
					state_reg 		<= state_next;
					Add_reg 			<= Add_next;
					EndAdd_reg		<= EndAdd_next;
					DataValid_reg	<= DataValid_next;
				end if;
		
			end process Register_Logic;
			
			
		Combinational_Logic : process(state_reg, StartAdd, LengthBuffer, Display_Buffer, Add_reg, EndAdd_reg, DataValid_reg, avm_ReadDataValid, avm_ReadData)
		
			begin
				Add_next 			<= Add_reg;
				EndAdd_next			<= EndAdd_reg;
				DataValid_next		<= DataValid_reg;
				avm_Read 			<= '0';
				avm_Address 		<= (others => '0');
				avm_ByteEnable 	<= (others => '0');
				avm_BurstCount 	<= (others => '0');
				Master_Ready 		<= '0';
				Write_FIFO 			<= '0';
				Waiting_Space		<= '0';
				Write_FIFO_Data 	<= (others => '0');			
				case state_reg is
					when Init					=> Add_next 		<= (others => '0');
														EndAdd_next 	<= (others => '0');
														DataValid_next <= '0';
														Master_Ready 	<= '1';
					
					when Copy 					=> Add_next 		<= unsigned(StartAdd) + unsigned(LengthBuffer(29 downto 0))*unsigned(Display_Buffer);
														EndAdd_next		<= unsigned(StartAdd) + unsigned(LengthBuffer(29 downto 0))*(unsigned(Display_Buffer)+1);
														DataValid_next <= '0';
					
					when Assert_Read_Data	=> avm_Read <= '1';
														avm_Address <= std_logic_vector(Add_reg);
														avm_ByteEnable <= "1111";
														avm_BurstCount <= "10000";
														
					when Read_Data				=> avm_Read <= '1';
														avm_Address <= std_logic_vector(Add_reg);
														avm_ByteEnable <= "1111";
														avm_BurstCount <= "10000";
														if avm_ReadDataValid = '1' then
															Write_FIFO <= '1';
															Write_FIFO_Data <= avm_ReadData;
															DataValid_next <= '1'; -- Thanks to this signal we know that avm_ReadDataValid has been to one.
														end if;
											
					when New_Add				=> Add_next <= Add_reg + 64; -- Because we have a BurstCount of 16 and we read 32 bits words we increment by 64 (16*4).
														DataValid_next <= '0';
					
					when Check_FIFO 			=> null;
					
					when Wait_LCD_Control 	=> Waiting_Space <= '1';
					
					when others					=> null;
				end case;
			
			end process Combinational_Logic;
			
end architecture behavioral;