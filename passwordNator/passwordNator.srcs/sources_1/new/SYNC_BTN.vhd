library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SYNC_BUTTON is
    generic(
        BUTTON_CLOCK_DIVITION: positive := 1000000
    );
    port(
        CLK: in std_logic;
        ASYNC_IN: in std_logic;
        SYNC_OUT: out std_logic
    );
end entity;

architecture BEHAVIOURAL of SYNC_BUTTON is
begin
    process (CLK)
        variable COUNTER: natural range 0 to BUTTON_CLOCK_DIVITION := 0;
        variable BUTTON_PRESSED_VAR: std_logic := '0';
        variable IS_RELEASING: std_logic := '0';
    begin
        if rising_edge(CLK) then
            SYNC_OUT <= '0';
            if ASYNC_IN = '1' and BUTTON_PRESSED_VAR = '0' then
                BUTTON_PRESSED_VAR := '1';
                SYNC_OUT <= '1';
            end if;
            
            if BUTTON_PRESSED_VAR = '1' then
                if COUNTER = BUTTON_CLOCK_DIVITION and ASYNC_IN = '0' then
                    COUNTER := 0;
                    
		            if IS_RELEASING = '0' then
                        IS_RELEASING := '1';
		            else
			            IS_RELEASING := '0';
			            BUTTON_PRESSED_VAR := '0';
		            end if;
                else
                    COUNTER := COUNTER + 1;
                end if;                
            end if;
        end if;
    end process;
end architecture BEHAVIOURAL;