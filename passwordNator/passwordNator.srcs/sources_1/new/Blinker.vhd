library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BLINKER is
    generic(
        BLINK_CLK_DIVIDER: positive;
        LED_CODE_SIZE: positive;
        NUM_DISPLAYS: positive
    );

    port(
        CLK: in std_logic;
        LED_CODE_IN: in std_logic_vector(LED_CODE_SIZE - 1 downto 0);
        DISPLAYS_TO_BLINK: in std_logic_vector(NUM_DISPLAYS - 1 downto 0);
        DISPLAY_SELECTED: in natural range 0 to NUM_DISPLAYS - 1;
        LED_CODE_OUT: out std_logic_vector(LED_CODE_SIZE - 1 downto 0)
    );
end entity BLINKER;

architecture BEHAVIOURAL of BLINKER is
begin
    process (CLK)
        variable BLINKING_CLK: std_logic := '0';
        variable COUNT: natural range 0 to BLINK_CLK_DIVIDER := 0;
    
    begin
        if rising_edge(CLK) then
            if COUNT = BLINK_CLK_DIVIDER then
                BLINKING_CLK := not BLINKING_CLK;
                COUNT := 0;
            else
                COUNT := COUNT + 1;
            end if;

            if DISPLAYS_TO_BLINK(DISPLAY_SELECTED) = '1' and BLINKING_CLK = '0' then
                LED_CODE_OUT <= (others => '1');
            else
                LED_CODE_OUT <= LED_CODE_IN;
            end if;
        end if;
    end process;
end architecture BEHAVIOURAL;