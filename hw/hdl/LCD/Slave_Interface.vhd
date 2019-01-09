-- Slave_Interface.vhd
-- Author : Pierre Fourcade
--
-- Slave Interface entity.
-- This entity is responsible to communicate with the user and command the other entities of the interface.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Slave_Interface is
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
end entity Slave_Interface;
			
architecture behavioral of Slave_Interface is

	signal RegCommandData 						: std_logic_vector(15 downto 0);
	signal RegStateCommandData					: std_logic_vector(1 downto 0);
	signal RegStartAdd, RegLengthBuffer 	: std_logic_vector(31 downto 0);
	signal RegDisplayBuffer, RegBufferSaved: std_logic_vector(1 downto 0);
	
	begin
	
		Avalon_Write : process(clk, nReset) -- Process for writing the registers that the user can direclty command.
		
			begin
				if nReset = '0' then
					RegCommandData 		<= (others => '0');	RegStateCommandData 	<= (others => '0');
					RegStartAdd 			<= (others => '0');	RegLengthBuffer		<= (others => '0');	
				elsif rising_edge(clk) then
					if (avs_ChipSelect = '1' and avs_Write = '1') then
						case avs_Address(2 downto 0) is
							when "000" =>	RegCommandData			<= avs_WriteData(15 downto 0);
							when "001" =>  RegStateCommandData 	<= avs_WriteData(1 downto 0);
							when "010" => 	RegStartAdd				<= avs_WriteData;
							when "011" =>	RegLengthBuffer		<= avs_WriteData;
							when others =>	null;
						end case;
					end if;
					if Done_Command_Data = '1' then -- Once the task asked is done, RegStateCommandData is reset. Reading it allows then the user to know if he can send a new task.
						RegStateCommandData <= (others => '0');
					end if;
				end if;
					
			end process Avalon_Write;
			
		
		Avalon_Read : process(clk) -- Process to read the registers of the entity.
		
			begin	
				if rising_edge(clk) then
					avs_ReadData <= (others => '0');
					if (avs_ChipSelect = '1' and avs_Read = '1') then
						case avs_Address(2 downto 0) is
							when "000" => 	avs_ReadData(15 downto 0) 	<= RegCommandData;
							when "001" => 	avs_ReadData(1 downto 0)	<= RegStateCommandData;
							when "010" => 	avs_ReadData 					<= RegStartAdd;
							when "011" =>	avs_ReadData					<= RegLengthBuffer;
							when "100" => 	avs_ReadData(1 downto 0)	<= RegDisplayBuffer;
							when "101" => 	avs_ReadData(1 downto 0) 	<= RegBufferSaved;
							when others => null;
						end case;
					end if;
				end if;
				
			end process Avalon_Read;
			
		
		Communication : process(clk, nReset) -- Process to handle all the signals going in and out the entity.
		
			begin
				if nReset = '0' then
					Command_Data 		<= (others => '0');
					State_Command_Data<= (others => '0');
					StartAdd 			<= (others => '0');
					LengthBuffer		<= (others => '0');
					Display_Buffer 	<= "00";
					Master_Start 		<= '0';
					RegDisplayBuffer  <= (others => '0');
					RegBufferSaved		<= (others => '0');
				elsif rising_edge(clk) then
					Command_Data 			<= RegCommandData;
					State_Command_Data 	<= RegStateCommandData;
					if Master_Ready = '1' and RegCommandData = x"002C" and RegStateCommandData = "01" and LCD_Control_Ready = '1' then -- Needed conditions to start the Master Interface.
						Master_Start <= '1';
					else
						Master_Start <= '0';
					end if;
					StartAdd			<= RegStartAdd;
					LengthBuffer	<= RegLengthBuffer;
					Display_Buffer <= RegDisplayBuffer;
					RegBufferSaved <= Buffer_Saved;
					if Master_Ready = '1' then	-- If the master is available we can change the buffer we want to use.
						RegDisplayBuffer <= Buffer_Saved;
					end if;
					
				end if;
			
			end process Communication;
			
end architecture behavioral;
					