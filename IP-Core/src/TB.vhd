----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.05.2025 20:16:33
-- Design Name: 
-- Module Name: TB - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB is
--  Port ( );
end TB;


architecture Behavioral of TB is

SIGNAL A,RESET,SYS_CLOCK : STD_LOGIC;

COMPONENT  BD1_wrapper is
  port (
    A : out STD_LOGIC;
    reset : in STD_LOGIC;
    sys_clock : in STD_LOGIC
  );
end component;

begin


DUT: BD1_wrapper
port map (
A=>A,
reset=>reset,
sys_clock => sys_clock
);

clk_generator : process is          
   begin    
       while (now<=1000ms)loop		-- define number of clock cycles to simulate
        
 		sys_clock <= '1';					-- create one full clock period every loop iteration
           wait for 5ns;
			sys_clock <= '0';
           wait for 5ns;
			
        end loop;
        
        wait;		
    end process	clk_generator;
end Behavioral;
