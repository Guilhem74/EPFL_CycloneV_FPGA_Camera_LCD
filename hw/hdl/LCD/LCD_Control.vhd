-- LCD_Control.vhd
-- Author : Pierre Fourcade

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LCD_Control is
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
end entity LCD_Control;

architecture behavioral of LCD_Control is
	
	-- State declaration
	type state is (Init, Command, Data, Display, Check_Full_FIFO, End_Display, Check_16_FIFO, Display_16, End_Command_Data);
	signal state_reg, state_next : state;
	
	signal counter_time_next, counter_time_reg : natural;
	signal counter_word_next, counter_word_reg : natural;
	
	signal Done_Command, Done_Data, Done_Display : std_logic;
	
	signal Word_Count : integer range 0 to 1024;
	
	begin
	
		Word_Count <= to_integer(unsigned(Read_FIFO_Word));
	
		Next_State_Logic : process(state_reg, Command_Data, State_Command_Data, Master_Ready, counter_word_reg, Waiting_Space, Empty_FIFO, Done_Command, Done_Data, Done_Display, Word_Count)
		
			begin
				
				state_next <= state_reg;
				case state_reg is
					when Init 					=> if State_Command_Data = "01" then
															state_next <= Command;
														elsif State_Command_Data = "10" then
															state_next <= Data;
														else
															state_next <= Init;
														end if;
											
					when Command 				=> if Done_Command = '1' then
															if Command_Data(7 downto 0) = x"2C" then
																state_next <= Check_Full_FIFO;
															else
																state_next <= End_Command_Data;
															end if;
														end if;
											
					when Data 					=> if Done_Data = '1' then
															state_next <= End_Command_Data;
														end if;
					
					when Check_Full_FIFO		=> if Master_Ready = '1' then
															if Empty_FIFO = '1' then
																state_next <= End_Display;
															else
																state_next <= Display;
															end if;
														else
															if Waiting_Space = '1' then
																state_next <= Check_16_FIFO;
															end if;
														end if;
					
					when Display 				=> if Done_Display = '1' then
															if Master_Ready = '1' then
																state_next <= Check_Full_FIFO;
															else
																state_next <= Check_16_FIFO;
															end if;
														end if;
					
					when Check_16_FIFO		=>	if Waiting_Space = '0' then
															state_next <= Check_Full_FIFO;
														else
															state_next <= Display_16;
														end if;
					
					when Display_16			=> if Done_Display = '1' then
															state_next <= Check_16_FIFO;
														end if;
					
					when End_Display			=> if Done_Command = '1' then
															state_next <= End_Command_Data;
														end if;
	
					when End_Command_Data	=> if State_Command_Data = "00" then
															state_next <= Init;
														end if;
												
					when others 		=> null;
				end case;
				
			end process Next_State_Logic;
					
					
					
		Register_Logic : process(clk, nReset)
		
			begin
			
				if nReset = '0' then
					state_reg <= Init;
					counter_time_reg <= 0;
					counter_word_reg <= 0;
				elsif rising_edge(clk) then
					state_reg <= state_next;
					counter_time_reg <= counter_time_next;
					counter_word_reg <= counter_word_next;
				end if;
				
			end process Register_Logic;
				
				
				
		Combinational_Logic : process(state_reg, Command_Data, Read_FIFO_Data, counter_time_reg, counter_word_reg, Empty_FIFO, Master_Ready)
		
			begin
				
				CSX 							<= '1';
				D_CX 							<= '1';
				WRX 							<= '1';
				RDX 							<= '1';
				D 								<= (others => '0');
				Read_FIFO 					<= '0';
				Read_16_Words 				<= '0';
				LCD_Control_Ready 		<=	'0';
				Done_Command_Data			<= '0';
				Done_Command				<= '0';
				Done_Data					<= '0';
				Done_Display				<= '0';
				counter_time_next 		<= counter_time_reg;
				counter_word_next			<= counter_word_reg;
				case state_reg is 
					when Init 		=> counter_time_next <= 0;
											counter_word_next <= 0;
											LCD_Control_Ready <=	'1';
										
					when Command 	=>	if counter_time_reg = 8 then
												Done_Command 		<= '1';
												counter_time_next <= 0;
											else
												CSX 	<= '0';
												D_CX 	<= '0';
												D 		<= Command_Data;
												if counter_time_reg < 5 then
													WRX <= '0';	
												else
													WRX <= '1';
												end if;
												counter_time_next <= counter_time_reg + 1;
											end if;
											
					when Data 		=> if counter_time_reg = 8 then
												Done_Data 			<= '1';
												counter_time_next <= 0;
											else
												CSX 	<= '0';
												D 		<= Command_Data;
												if counter_time_reg < 5 then
													WRX <= '0';	
												else
													WRX <= '1';
												end if;
											counter_time_next <= counter_time_reg + 1;
											end if;

					when Check_Full_FIFO	=> if Master_Ready = '1' then
														if Empty_FIFO = '0' then
															Read_FIFO <= '1';
														end if;
													end if;
													counter_word_next <= 0;
					
					when Display	=> if counter_time_reg = 8 then
												Done_Display <= '1';
												counter_time_next <= 0;
											else
												CSX <= '0';
												D <= Read_FIFO_Data;
												if counter_time_reg < 5 then
													WRX <= '0';	
												else
													WRX <= '1';
												end if;
											counter_time_next <= counter_time_reg + 1;
											end if;
					
					when Check_16_FIFO 	=> if counter_word_reg = 31 then
														Read_16_Words <= '1';
														counter_word_next <= 0;
													else
														Read_FIFO <= '1';
													end if;
													
					when Display_16	=> if counter_time_reg = 8 then
													Done_Display <= '1';
													counter_time_next <= 0;
													counter_word_next <= counter_word_reg + 1;
												else
													CSX <= '0';
													D <= Read_FIFO_Data;
													if counter_time_reg < 5 then
														WRX <= '0';	
													else
														WRX <= '1';
													end if;
												counter_time_next <= counter_time_reg + 1;
												end if;
					
					when End_Display 	=> if counter_time_reg = 8 then
													Done_Command 		<= '1';
													counter_time_next <= 0;
												else
													CSX 	<= '0';
													D_CX 	<= '0';
													D 		<= x"0000";
													if counter_time_reg < 5 then
														WRX <= '0';	
													else
														WRX <= '1';
													end if;
													counter_time_next <= counter_time_reg + 1;
												end if;
					
					when End_Command_Data	=> Done_Command_Data <= '1';
											
					when others 		=> null;
				end case;
					
			end process Combinational_Logic;

									

end architecture behavioral;
			
			
			