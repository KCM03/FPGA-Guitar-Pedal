----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.05.2025 18:16:20
-- Design Name: 
-- Module Name: PWMDAC - Behavioral
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

entity PWMDAC is
generic(
Resolution : integer :=8;
Prescaler  : integer :=1
);
    Port ( 
           
           clk : in std_logic;
           D   : in std_logic_vector(Resolution-1 downto 0);
           areset_n : in STD_LOGIC;
           PWM : out STD_LOGIC);
           
end PWMDAC;

architecture Behavioral of PWMDAC is
signal pwmclk : std_logic :='0';
begin


clkgen: process(clk,areset_n)
variable clkcount : integer:=0;
begin

if areset_n = '0' then
clkcount := 0;
pwmclk <='0';
elsif rising_edge(clk) then

if clkcount >= Prescaler/2 then

pwmclk <= not pwmclk;
clkcount := 0;
else 
clkcount := clkcount+1;
end if;
end if;
end process;


pwmgen: process(clk,areset_n)
variable count : integer:=0;
variable max : unsigned(resolution-1 downto 0):=(others=>'1');
begin

if areset_n = '0' then
pwm <='0';
count :=0;
elsif rising_edge(clk) then

if count >= 255 then
count:=0;

else 

count := count+1;
end if;

if count < unsigned(D) then
PWM <='1';

else
PWM <='0';
end if;

end if;
end process;

end Behavioral;
