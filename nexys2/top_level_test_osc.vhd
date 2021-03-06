----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:41:04 08/03/2012 
-- Design Name: 
-- Module Name:    top_level - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_level_test_osc is
    Port (
		sw : in  STD_LOGIC_VECTOR (7 downto 0);
		led : out  STD_LOGIC_VECTOR (7 downto 0);
		btn : in  STD_LOGIC_VECTOR (3 downto 0);
		disp : out  STD_LOGIC_VECTOR (12 downto 0);
		vga : out  STD_LOGIC_VECTOR (10 downto 0);
		tx : out  STD_LOGIC;
		rx : in  STD_LOGIC;
		clk : in STD_LOGIC;
		
		-- JA
		ja1	: out std_logic; -- sdout
		ja2	: out std_logic; -- sclk
		ja3	: out std_logic; -- lrck
		ja4	: out std_logic  -- mclk

	);
end top_level_test_osc;

architecture RTL of top_level_test_osc is
	
	-- UART signals
	signal data	: std_logic_vector(15 downto 0);
	signal lrck_d	: std_logic;



	
begin

	--ja1 <= sdout_d;-- and sw(0);
	ja3 <= lrck_d;-- and sw(2);
	
	led <= data(15 downto 8);
	--led(0) <= sdout_d and sw(0);
	--led(1) <= sclk_d and sw(1);
	--led(2) <= lrck_d and sw(2);
	--led(3) <= mclk_d and sw(3);
	--led(7 downto 0) <= (others => '0');
			
	
	-- Core instatiations
	i2s_cntrl1 : entity work.I2S_cntrl
		port map (
			ldin => data,
			rdin => data,
			clk => clk,
			reset	=> btn(0),
			sdout => ja1,
			sclk => ja2,
			lrck => lrck_d,
			mclk => ja4
		);
	
	test_osc1 : entity work.test_osc
		port map (
			samp_clk => lrck_d,
			freq => sw,
			dout => data
		);

		
	
end RTL;

