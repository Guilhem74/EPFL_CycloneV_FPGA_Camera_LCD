-- LCD_Control.vhd
-- Author : Pierre Fourcade
--
-- LCD Control entity.
-- LCD Control translates the data or command from the Slave Interface or the FIFO to the LCD.
-- Once its task is done, it informs the Slave Interface that it is ready for an other task.

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
			
			Master_Ready 	: in std_logic;
			Master_Waiting	: in std_logic;
			Master_Start	: out std_logic;
			Write_16			: out std_logic;
			
			Command_Data 		: in std_logic_vector(15 downto 0);
			State_Command_Data: in std_logic_vector(1 downto 0);
			Done_Command_Data : out std_logic;
			
			CSX 	: out std_logic;
			D_CX 	: out std_logic;
			WRX 	: out std_logic;
			RDX 	: out std_logic;
			D 		: out std_logic_vector(15 downto 0));
end entity LCD_Control;

architecture behavioral of LCD_Control is
	
	-- State declaration
	type state is (Init, Command, Data, Check_Command, Check_Master, Empty, Display, Empty_16, Display_16, End_Display, End_Command_Data);
	signal state_reg, state_next : state;
	
	signal counter_time_next, counter_time_reg : integer range 0 to 8;
	signal counter_word_next, counter_word_reg : integer range 0 to 32;
	
	signal Done_Task : std_logic;
	
	signal Word_Count : integer range 0 to 1024;
	
	begin
	
		Word_Count <= to_integer(unsigned(Read_FIFO_Word)); -- Not used here.
	
		Next_State_Logic : process(state_reg, State_Command_Data, Command_Data, Done_Task, Master_Ready, Master_Waiting, Empty_FIFO, counter_word_reg)
		
			begin
			
				state_next <= state_reg;
				
				case state_reg is
					when Init 					=> if State_Command_Data = "01" or State_Command_Data = "11" then
															state_next <= Command;
														elsif State_Command_Data = "10" then
															state_next <= Data;
														end if;
											
					when Command 				=> if Done_Task = '1' then
															state_next <= Check_Command;
														end if;
					
					when Check_Command		=> if Command_Data(7 downto 0) = x"2C" then
															if Master_ready = '0' then
																state_next <= Check_Master;
															end if;
														else
															state_next <= End_Command_Data;
														end if;
	
					when Data 					=> if Done_Task = '1' then
															state_next <= End_Command_Data;
														end if;
					
					when Check_Master			=> if Master_Ready = '1' then
															state_next <= Empty;
														else
															if Master_Waiting = '1' then
																state_next <= Empty_16;
															end if;
														end if;
														
					when Empty					=> if Empty_FIFO = '1' then
															state_next <= End_Display;
														else
															state_next <= Display;
														end if;
														
					when Display				=> if Done_Task = '1' then
															state_next <= Empty;
														end if;
														
					when Empty_16				=> if counter_word_reg = 32 then
															state_next <= Check_Master;
														else
															state_next <= Display_16;
														end if;
														
					when Display_16			=> if Done_Task = '1' then
															state_next <= Empty_16;
														end if;
														
					when End_Display			=> if Done_Task = '1' then
															if State_Command_Data = "01" then
																state_next <= End_Command_Data;
															elsif State_Command_Data = "11" then
																state_next <= Command;
															end if;	
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
					state_reg 			<= Init;
					counter_word_reg 	<= 0;
					counter_time_reg 	<= 0;
				elsif rising_edge(clk) then
					state_reg 			<= state_next;
					counter_word_reg 	<= counter_word_next;
					counter_time_reg 	<= counter_time_next;
				end if;
				
			end process Register_Logic;			
				
				
		Combinational_Logic : process(state_reg, Command_Data, counter_time_reg, counter_word_reg, Empty_FIFO, Read_FIFO_Data)
		
			begin
				
				CSX 	<= '1';
				D_CX 	<= '1';
				WRX 	<= '1';
				RDX 	<= '1';
				D 		<= (others => '0');
				
				Read_FIFO 	<= '0';
				
				Master_Start	<= '0';
				Write_16 		<= '0';
				
				Done_Command_Data	<= '0';
				Done_Task			<= '0';
				
				counter_time_next <= counter_time_reg;
				counter_word_next	<= counter_word_reg;
				
				case state_reg is 
					when Init 					=> counter_time_next <= 0;
														counter_word_next <= 0;
										
					when Command 				=>	if counter_time_reg = 8 then
															Done_Task 			<= '1';
															counter_time_next <= 0;
														else
															CSX 	<= '0';
															D_CX 	<= '0';
															D 		<= Command_Data;
															if counter_time_reg < 4 then
																WRX <= '0';	
															else
																WRX <= '1';
															end if;
															counter_time_next <= counter_time_reg + 1;
														end if;
					
					when Check_Command		=> if Command_Data(7 downto 0) = x"2C" then
															Master_Start <= '1';
														end if;
					
					when Data 					=> if counter_time_reg = 8 then
															Done_Task 			<= '1';
															counter_time_next <= 0;
														else
															CSX 	<= '0';
															D 		<= Command_Data;
															if counter_time_reg < 4 then
																WRX <= '0';	
															else
																WRX <= '1';
															end if;
														counter_time_next <= counter_time_reg + 1;
														end if;
													
					when Check_Master			=> null;
					
					when Empty					=> if Empty_FIFO = '0' then
															Read_FIFO <= '1';
														end if;
													
					when Display				=> if counter_time_reg = 8 then
															Done_Task 			<= '1';
															counter_time_next <= 0;
														else
															CSX 	<= '0';
															D 		<= Read_FIFO_Data;
															if counter_time_reg < 4 then
																WRX <= '0';	
															else
																WRX <= '1';
															end if;
														counter_time_next <= counter_time_reg + 1;
														end if;
												
					when Empty_16				=> if counter_word_reg = 32 then
															Write_16 <= '1';
															counter_word_next <= 0;
														else
															Read_FIFO <= '1';
														end if;
									
					when Display_16			=> if counter_time_reg = 8 then
															Done_Task 			<= '1';
															counter_time_next <= 0;
															counter_word_next	<= counter_word_reg + 1;
														else
															CSX 	<= '0';
															D 		<= Read_FIFO_Data;
															if counter_time_reg < 4 then
																WRX <= '0';	
															else
																WRX <= '1';
															end if;
														counter_time_next <= counter_time_reg + 1;
														end if;

					when End_Display			=>	if counter_time_reg = 8 then
															Done_Task 			<= '1';
															counter_time_next <= 0;
														else
															CSX 	<= '0';
															D_CX 	<= '0';
															D 		<= x"0000";
															if counter_time_reg < 4 then
																WRX <= '0';	
															else
																WRX <= '1';
															end if;
															counter_time_next <= counter_time_reg + 1;
														end if;
													
					when End_Command_Data	=> Done_Command_Data <= '1';
											
					when others 				=> null;
				end case;
					
			end process Combinational_Logic;
									

end architecture behavioral;
			
			
			