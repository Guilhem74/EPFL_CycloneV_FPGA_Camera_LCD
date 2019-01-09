-- FIFO_entity.vhd
-- Author : Pierre Fourcade
--
-- FIFO entity.
-- This file corresponds to a PORT MAP of the FIFO from the IP catalogue to match our needs.
-- The input data of the FIFO is 32 bits wide.
-- The output data of the FIFO is 16 bits wide.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FIFO_entity is
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
end entity FIFO_entity;

architecture behavioral of FIFO_entity is

	component FIFO_intel
	PORT ( 	aclr		: IN STD_LOGIC  := '0';
				data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
				rdclk		: IN STD_LOGIC ;
				rdreq		: IN STD_LOGIC ;
				wrclk		: IN STD_LOGIC ;
				wrreq		: IN STD_LOGIC ;
				q				: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
				rdempty		: OUT STD_LOGIC ;
				rdusedw		: OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
				wrfull		: OUT STD_LOGIC ;
				wrusedw		: OUT STD_LOGIC_VECTOR (8 DOWNTO 0));
	end component FIFO_intel;	
	
	signal inv_nReset : std_logic;
	
	begin

		inv_nReset <= not(nReset); -- The clear of the FIFO is for 1 so we need to invert our nReset to match them.
	
		FIFO : FIFO_intel PORT MAP (	aclr 		=> inv_nReset,
												data 		=> Write_FIFO_Data,
												rdclk 	=> clk,
												rdreq 	=> Read_FIFO,
												wrclk 	=> clk,
												wrreq 	=> Write_FIFO,
												q 			=> Read_FIFO_Data,
												rdempty 	=> Empty_FIFO,
												rdusedw	=> Read_FIFO_Word,
												wrfull 	=> Full_FIFO,
												wrusedw	=> Write_FIFO_Word);
	
end architecture behavioral;
