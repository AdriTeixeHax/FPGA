----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.11.2023 15:32:32
-- Design Name: 
-- Module Name: Transistor_mux - Behavioral
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


entity Transistor_mux is
    generic (
        num_displays: positive
    );
    Port (
           Mux_to_blinker_display:  natural range 0 to NUM_DISPLAYS - 1;
           t7: out std_logic_vector (NUM_DISPLAYS - 1 downto 0));
           
end Transistor_mux;

architecture Behavioral of Transistor_mux is
begin
    t7 <= not "00000001" when Mux_to_blinker_display = 0 else
          not "00000010" when Mux_to_blinker_display = 1 else
          not "00000100" when Mux_to_blinker_display = 2 else
          not "00001000" when Mux_to_blinker_display = 3 else
          not "00010000" when Mux_to_blinker_display = 4 else
          not "00100000" when Mux_to_blinker_display = 5 else
          not "01000000" when Mux_to_blinker_display = 6 else
          not "10000000" when Mux_to_blinker_display = 7;
end Behavioral;
