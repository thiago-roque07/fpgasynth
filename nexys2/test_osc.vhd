----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:36:34 08/03/2012 
-- Design Name: 
-- Module Name:    uart - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Test oscilliator, basic sawtooth, with 8 bit input for selecting a freq
-- 				and a 16 bit sample output
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity test_osc is
	Port (
	clk 		: in std_logic;
	param_cmd : in std_logic_vector(7 downto 0);
	param_val : in std_logic_vector(15 downto 0);
	
	samp_clk	: in std_logic;
	dout		: out std_logic_vector(15 downto 0)
	
	);
		
end test_osc;

architecture RTL of test_osc is
	

	signal note_val	: std_logic_vector(6 downto 0);
	signal note_vel	: std_logic_vector(6 downto 0);
	signal fcw 			: unsigned (15 downto 0);
	
	signal phase		: unsigned (15 downto 0);
	
begin

	-- Data readin
	process(clk)
	begin 
		if rising_edge(clk) then
			if param_cmd = "00000000" and param_val(6 downto 0) = note_val then
				-- note off	
				note_vel <= (others => '0');
			elsif param_cmd = "00000001" and note_vel = "0000000" then
				-- we are not playing a note and we got a note on
				note_val <= param_val(6 downto 0);
				note_vel <= param_val(13 downto 7);
				
				-- calculate freqeuncy control word for NCO
				-- FCW (Delta F) = Fout*2^N / Fclock
				-- midi note number to frequency conversion:
				-- f=(2^((m−69)/12))*(440 Hz).
				-- So to get the increment value from the midi note
				-- FCW = 2^((m-69)/12) * 440 Hz * 2^N / Fclock
				-- Using N = 16 gives us a frequency step size of 0.7324 hz which is nice
				
				-- fcw <=  ((440 * 2^16) / 48000) sll ((unsigned(note_val)-69)/12);

 				fcw <= to_unsigned(601, 16) sll to_integer((unsigned(note_val)-69)/12);
				
			end if;
			
		
		end if;
	end process;		


	-- Numerically Controlled Oscillator
	process(samp_clk)
	begin
		if rising_edge(samp_clk) then 
			-- increment accumulator
			phase <= phase + fcw;
			-- Output sawtooth, this has bad rounding but i don't care rn
			dout <= std_logic_vector(phase);
		end if;
	end process;
end RTL;
