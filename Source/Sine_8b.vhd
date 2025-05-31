----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2025 15:14:28
-- Design Name: 
-- Module Name: Sine_8b - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Sine_8b is
generic(
clkdiv : integer :=1
);
port(
clk     : in std_logic;
aresetn : in std_logic;
Rate    : in std_logic_vector(7 downto 0);
Depth   : in std_logic_vector(7 downto 0);
OSC_out : out std_logic_vector(7 downto 0)
);
end Sine_8b;

architecture Behavioral of Sine_8b is
signal count         : unsigned(7 downto 0):=(others=>'0');
signal divcount      : unsigned(23 downto 0):=(others=>'0');
signal timclk        : std_logic :='0';
signal douta         : STD_LOGIC_VECTOR(7 DOWNTO 0);

component blk_mem_gen_0 IS
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END component;
begin

clkgen:process (clk,aresetn)
begin
if (aresetn='0') then
divcount<= (others=>'0');
elsif rising_edge(clk) then

if (divcount>=clkdiv) then
divcount<= (others=>'0');
timclk <= not timclk;
else
divcount<=divcount+1;
end if;
end if;
end process;



countgen:process (timclk,aresetn)
begin
if (aresetn='0') then
count<= (others=>'0');
elsif rising_edge(timclk) then

if (count>=255) then
count<= (others=>'0');
else
count<=count+unsigned(rate);
end if;
end if;
end process;

sineROM: blk_mem_gen_0
port map(
clka=>clk,
addra=>std_logic_vector(count),
douta=>douta
);

OSC_OUT <= std_logic_vector(unsigned(douta)/(256-unsigned(Depth)));
end Behavioral;
