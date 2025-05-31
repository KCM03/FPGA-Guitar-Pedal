--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
--Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
--Date        : Thu May 29 23:25:25 2025
--Host        : Kish_Maharaj running 64-bit major release  (build 9200)
--Command     : generate_target BD1_wrapper.bd
--Design      : BD1_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity BD1_wrapper is
  port (
    PWM : out STD_LOGIC;
    VN : in STD_LOGIC;
    VP : in STD_LOGIC;
    reset : in STD_LOGIC;
    rgb_led_tri_o : out STD_LOGIC_VECTOR ( 2 downto 0 );
    sys_clock : in STD_LOGIC;
    usb_uart_rxd : in STD_LOGIC;
    usb_uart_txd : out STD_LOGIC
  );
end BD1_wrapper;

architecture STRUCTURE of BD1_wrapper is
  component BD1 is
  port (
    reset : in STD_LOGIC;
    sys_clock : in STD_LOGIC;
    usb_uart_rxd : in STD_LOGIC;
    usb_uart_txd : out STD_LOGIC;
    VN : in STD_LOGIC;
    VP : in STD_LOGIC;
    PWM : out STD_LOGIC;
    rgb_led_tri_o : out STD_LOGIC_VECTOR ( 2 downto 0 )
  );
  end component BD1;
begin
BD1_i: component BD1
     port map (
      PWM => PWM,
      VN => VN,
      VP => VP,
      reset => reset,
      rgb_led_tri_o(2 downto 0) => rgb_led_tri_o(2 downto 0),
      sys_clock => sys_clock,
      usb_uart_rxd => usb_uart_rxd,
      usb_uart_txd => usb_uart_txd
    );
end STRUCTURE;
