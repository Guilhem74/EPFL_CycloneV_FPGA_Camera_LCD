library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
Entity Master_Interface is
Port(
 Clk : IN STD_LOGIC ;
 Reset_n : IN STD_LOGIC ;
 Address: IN STD_LOGIC_VECTOR(31 downto 0) ;
 Length_Frame: IN STD_LOGIC_VECTOR(31 downto 0) ;
 Ready: IN STD_LOGIC ;
 --FIFO Connection
 FIFO_Data_Available: IN STD_LOGIC ;
 FIFO_Read_Request : OUT STD_LOGIC ;
 FIFO_Read_Data : IN STD_LOGIC_VECTOR(31 downto 0) ; 
 FIFO_Flush_Signal   : OUT STD_LOGIC;
-- Avalon Master :
 AM_readdatavalid: IN STD_LOGIC;
 AM_beginbursttransfer: OUT STD_LOGIC ;
 AM_Adresse : OUT STD_LOGIC_VECTOR(31 downto 0) ;
 AM_ByteEnable : OUT STD_LOGIC_VECTOR(3 downto 0) ;
 AM_Write : OUT STD_LOGIC ;
 AM_Read : OUT STD_LOGIC ;
 AM_DataWrite : OUT STD_LOGIC_VECTOR(31 downto 0) ;
 AM_BurstCount : OUT STD_LOGIC_VECTOR(3 downto 0) ;
 AM_DataRead : IN STD_LOGIC_VECTOR(31 downto 0) ;
 AM_WaitRequest : IN STD_LOGIC
) ; 
end entity Master_Interface;

Architecture Comp of Master_Interface is

	TYPE Master_State IS (IDLE_FOR_READY,IDLE_FOR_DATA,CLOCK_WAIT_DATA_FIFO,Collect_Data_FIFO,DMA_Send_Init,DMA_Send_Loop);
	signal State:Master_State;
	signal Copy_Address, Offset_Address: STD_LOGIC_VECTOR(31 downto 0) ;
	signal Indice_Array_FIFO,Indice_Array_DMA: unsigned ( 4 downto 0):= "00000";
	type DATA is array (8 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
	signal DATA_Array: Data;
Begin 
	
	-- Acquisition
	Avalon_Bus:
	Process(Clk, Reset_n)
		Begin
		 if Reset_n = '0' then
			Offset_Address<=(others=>'0');
			Copy_Address<=(others=>'0');
 			DATA_Array<=(others=>(others=>'0'));
			FIFO_Read_Request<='0';
			Indice_Array_FIFO<="00000";
			Indice_Array_DMA<="00000";
			AM_beginbursttransfer<='0';
 			AM_Adresse<=(others=>'0');
 			AM_ByteEnable<=(others=>'0');
 			AM_Write<='0';
 			AM_Read<='0';
 			AM_DataWrite<=(others=>'0');
 			AM_BurstCount<=(others=>'0');
 			FIFO_Flush_Signal<='1';
 			State<=IDLE_FOR_READY;
		 elsif rising_edge(Clk) then
			case State is
			when IDLE_FOR_READY => 	
				AM_Write<='0';
				AM_BurstCount<="0000";
					if Ready='1' then
						FIFO_Flush_Signal<='0';
						State<=IDLE_FOR_DATA;
						Indice_Array_DMA<="00000";
						Indice_Array_FIFO<="00000";
						if Offset_Address>=Length_Frame then
							Offset_Address<=(others=>'0');	
							Copy_Address<=(Address);
						else
							Copy_Address<=std_logic_vector(unsigned(Address)+unsigned(Offset_Address));
							
						end if;
					else
						FIFO_Flush_Signal<='1';
						Copy_Address<=(others=>'0');
						Offset_Address<=(others=>'0');
					end if;
				when IDLE_FOR_DATA =>
					if FIFO_Data_Available='0' then
						FIFO_Read_Request<='1';
						State<=CLOCK_WAIT_DATA_FIFO;
					end if;
				when CLOCK_WAIT_DATA_FIFO=>
					State<=Collect_Data_FIFO;
				when  Collect_Data_FIFO =>
					DATA_Array(to_integer(Indice_Array_FIFO))<=FIFO_Read_Data;
					Indice_Array_FIFO<=Indice_Array_FIFO+1;
					if Indice_Array_FIFO=7 then
						
						State<=DMA_Send_Init;
					elsif Indice_Array_FIFO=6 then
						FIFO_Read_Request<='0';
					end if;
				when DMA_Send_Init =>
					AM_Write<='1';
					AM_Adresse<=Copy_Address;
					AM_BurstCount<="1000";
					AM_ByteEnable<="1111";
					AM_DataWrite<=DATA_Array(0);
					AM_beginbursttransfer<='1';
					State<=DMA_Send_Loop;
				when DMA_Send_Loop =>
					AM_beginbursttransfer<='0';
					if AM_WaitRequest='0' then
						AM_DataWrite<=DATA_Array(to_integer(Indice_Array_DMA+1));
						if Indice_Array_DMA<6 then
							Indice_Array_DMA<=Indice_Array_DMA+1;
						else
							Offset_Address<=std_logic_vector(unsigned(Offset_Address)+to_unsigned(32,32));-- 8 
							
							State<=IDLE_FOR_READY;
						end if;
					end if;
			end case;	
		 end if;
	End Process Avalon_Bus;

End Comp; 