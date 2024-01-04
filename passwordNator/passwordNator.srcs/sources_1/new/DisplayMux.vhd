-- Code your design here
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package ARRAY_IN_VHDL is
    subtype T_DISPLAY_CODES_BUS is std_logic_vector(4 downto 0);
    type T_DISPLAY_CODES_IN is array (natural range <>) of T_DISPLAY_CODES_BUS;
end;    

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ARRAY_IN_VHDL.all; 


entity DISPLAY_MUX is

    generic(
        NUM_DISPLAYS: positive;
        LED_CODE_SIZE: positive;
        DISPLAY_CHANGE_CLK_DIVIDER: positive
    );
    
    port(
        CLK: in std_logic;
        DISPLAY_CODES_IN: in T_DISPLAY_CODES_IN (NUM_DISPLAYS - 1 downto 0);
        DISPLAY_CODE_OUT: out std_logic_vector(LED_CODE_SIZE - 1  downto 0);
        DISPLAY_IN_USE: out natural range 0 to NUM_DISPLAYS - 1
    );
end entity;

architecture BEHAVOURAL of DISPLAY_MUX is

begin
    process (CLK)
        variable COUNT: natural range 0 to DISPLAY_CHANGE_CLK_DIVIDER := 0;
        variable DISPLAY_IN_USE_VAR: natural range 0 to NUM_DISPLAYS := 0;
    begin
        if rising_edge(CLK) then
            if COUNT = DISPLAY_CHANGE_CLK_DIVIDER then
                if DISPLAY_IN_USE_VAR = NUM_DISPLAYS then
                    DISPLAY_IN_USE_VAR := 0;
                else
                    DISPLAY_IN_USE_VAR := DISPLAY_IN_USE_VAR + 1;
                end if;
                COUNT := 0;
            else
                COUNT := COUNT + 1;
            end if;

            DISPLAY_CODE_OUT <= DISPLAY_CODES_IN(DISPLAY_IN_USE_VAR);
            DISPLAY_IN_USE <= DISPLAY_IN_USE_VAR;
        end if;
    end process;
end architecture BEHAVOURAL;
