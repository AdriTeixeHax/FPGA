library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package ARRAY_INT is
    type T_STATE_MEMORY is array (integer range <>) of integer;
end;   


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARRAY_INT.all;
use work.ARRAY_IN_VHDL.all;
use ieee.std_logic_arith.all;

entity selector is
    generic (
        num_displays: positive; 
        led_code_size: positive
    );

    port(
        reset: in std_logic;
        ce: in std_logic;
        clk:   in std_logic;
        up:    in std_logic;
        down:  in std_logic;
        left:  in std_logic;
        right: in std_logic;
        
        natural_out: out Natural  range  0 to 99999999;
        led_code_out: out T_DISPLAY_CODES_IN(num_displays - 1 downto 0);
        display_selected: out std_logic_vector(num_displays - 1 downto 0)
    );
end selector;

architecture behav of selector is
begin

    process(reset, clk)
        variable led_code_aux: T_STATE_MEMORY(num_displays - 1 downto 0);
        variable display_aux:  natural range num_displays - 1 downto 0;
        variable natural_code: Natural  range  0 to 99999999;
    begin
        if (reset = '0') then
            for i in 0 to led_code_size - 1 loop
                led_code_aux(i) := 0;
            end loop;

            display_aux := 0;

        elsif (rising_edge(clk)) then
            if(ce='1') then
                if (up = '1') then
                    if(led_code_aux(display_aux)/=9)  then 
                       led_code_aux(display_aux) := led_code_aux(display_aux) + 1;
                    else
                       led_code_aux(display_aux) :=  0;
                    end if;                         
                    
                elsif (down = '1') then
                    if(led_code_aux(display_aux)/=0)  then 
                       led_code_aux(display_aux) := led_code_aux(display_aux) - 1;
                    else
                       led_code_aux(display_aux) :=  9;
                    end if;                
                    
                    
                elsif (right = '1') then
                    if(display_aux /= num_displays - 1)  then 
                        display_aux := display_aux + 1;
                    else
                        display_aux :=  0;
                    end if;
                    
                elsif (left = '1') then
                    if(display_aux/=0)  then 
                        display_aux := display_aux - 1;
                    else
                        display_aux := num_displays - 1;
                    end if;                   
                end if;
            end if; 
        end if;

        for i in 0 to NUM_DISPLAYS - 1 loop
             led_code_out(i)<= conv_std_logic_vector(led_code_aux(i), 5);
            natural_code    :=  natural_code+led_code_aux(i)*10**i;
        end loop;
        
        display_selected <= (others => '0');
        display_selected(display_aux) <= '1';
        natural_out<=natural_code;
        end process;
    
end behav ; -- behav