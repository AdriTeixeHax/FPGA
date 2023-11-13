library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package ARRAY_INT is
    type T_STATE_MEMORY is array (natural range <>) of natural range 0 to 9;
end;   

--package ARRAY_IN_VHDL is
--    subtype T_DISPLAY_CODES_BUS is std_logic_vector(4 downto 0);
--    type T_DISPLAY_CODES_IN is array (natural range <>) of T_DISPLAY_CODES_BUS;
--end;    

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARRAY_INT.all;
use work.ARRAY_IN_VHDL.all;

entity selector is
    generic (
        num_displays: positive; 
        led_code_size: positive
    );

    port(
        reset: in std_logic;
        clk:   in std_logic;
        up:    in std_logic;
        down:  in std_logic;
        left:  in std_logic;
        right: in std_logic;
        
        led_code_out: out T_DISPLAY_CODES_IN(num_displays - 1 downto 0);
        display_selected: out std_logic_vector(num_displays - 1 downto 0)
    );
end selector;

architecture behav of selector is
begin

    process(reset, clk)
        variable led_code_aux: T_STATE_MEMORY(led_code_size - 1 downto 0);
        variable display_aux:  natural range num_displays - 1 downto 0;
    begin
        if (reset = '0') then
            for i in 0 to led_code_size - 1 loop
                led_code_aux(i) := 0;
            end loop;

            display_aux := 0;

        elsif (rising_edge(clk)) then
            if (up = '1') then
                led_code_aux(display_aux) := led_code_aux(display_aux) + 1;
            elsif (down = '1') then
                led_code_aux(display_aux) := led_code_aux(display_aux) - 1;
            elsif (right = '1') then
                display_aux := display_aux + 1;
            elsif (left = '1') then
                display_aux := display_aux - 1;
            end if;
        
        end if;

        for i in led_code_out'range loop
            led_code_out(i) <= std_logic_vector(to_unsigned(led_code_aux(i), led_code_size - 1));
        end loop;

        display_selected <= (others => '0');
        display_selected(display_aux) <= '1';
        
        end process;

end behav ; -- behav