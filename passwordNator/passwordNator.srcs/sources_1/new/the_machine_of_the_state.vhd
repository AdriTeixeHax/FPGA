--  CODES   Display 
--  00000   0
--  00001   1
--  00010   2
--  00011   3
--  00100   4
--  00101   5
--  00110   6
--  00111   7
--  01000   8
--  01001   9
--  01010   A
--  01011   F
--  01100   L
--  01101   C
--  01110   E
--  01111   U
--  1XXXX   None



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.ARRAY_IN_VHDL.all; 
entity the_machine_of_the_state is
   generic(
        NUM_DISPLAYS: positive;
        led_code_size: positive
    );
  Port ( Reset: in std_logic;
         CLK:  in std_logic ;
         OK_B: in std_logic;
        up:    in std_logic;
        down:  in std_logic;
        left:  in std_logic;
        right: in std_logic;         
         
         
         DISPLAYS_TO_BLINK: out std_logic_vector(NUM_DISPLAYS - 1 downto 0);
         DISPLAY_CODES_IN: out T_DISPLAY_CODES_IN (0 to NUM_DISPLAYS - 1) );
         
end the_machine_of_the_state;

architecture Behavioral of the_machine_of_the_state is
    component selector is
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
    end component;



    type STATES is (start,get_password,setting_password, solve_window,attemp,success,fail);
    signal reset_password: std_logic;
    signal reset_attempt: std_logic;
    signal ce_password: std_logic;
    signal ce_attempt: std_logic;
    
    signal current_state: STATES := start;
    signal next_state: STATES;
    signal password: natural range 0 to 99999999;
    signal guess: natural range 0 to 99999999;
    
    
    signal led_code_out_password:  T_DISPLAY_CODES_IN(num_displays - 1 downto 0);
    signal display_selected_password:  std_logic_vector(num_displays - 1 downto 0);
    
    signal led_code_out_attempt:  T_DISPLAY_CODES_IN(num_displays - 1 downto 0);
    signal display_selected_attempt:  std_logic_vector(num_displays - 1 downto 0);
begin

selector_inst_password:  selector
    generic map(
        num_displays=>num_displays,
        led_code_size=>led_code_size
    
    )
    port map(
        reset=>reset_password,
        ce=>ce_password,
        clk=> clk,
        up=>up,
        down=>down,
        left=>left,
        right=>right,
        natural_out=> password,
        led_code_out=>led_code_out_password,
        display_selected=>display_selected_password
    );

selector_inst_attempt:  selector
    generic map(
        num_displays=>num_displays,
        led_code_size=>led_code_size
    
    )
    port map(
        reset=>reset_attempt,
        ce=>ce_attempt,
        clk=> clk,
        up=>up,
        down=>down,
        left=>left,
        right=>right,
        natural_out=> guess,
        led_code_out=>led_code_out_attempt,
        display_selected=>  display_selected_attempt      
    );    

 state_register: process (RESET, CLK)
    begin
        if reset = '0' then
            current_state <= start;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if; 
    end process;

    nextstate_decod: process (OK_B, current_state)

    begin
        next_state <= current_state;

        case current_state is
        when start =>
            if OK_B = '1' then 
                next_state <= get_password;
            end if;
        when get_password =>
            if OK_B = '1' then 
                next_state <= setting_password;
            end if;
        when setting_password => 
            if OK_B = '1' then 
                next_state <= solve_window;
            end if;
        when solve_window => 
            if OK_B = '1' then 
                next_state <= attemp;
            end if;
        when attemp => 
            if OK_B = '1' then 
                if password = guess then
                    next_state <= success;
                else
                     next_state <= fail;
                end if;
            end if;
        when success => 
            if OK_B = '1' then 
                next_state <= attemp;
            end if;
        when others => --Estado de fail
            next_state <= attemp;
        end case;
    end process;

    output_decod: process (current_state)
    begin
        case current_state is
        when start =>
             reset_password<='1';
             reset_attempt<='1';
             ce_attempt<='0';
             ce_password<='0';
             DISPLAY_CODES_IN<=(others=>(others=>'1'));
             DISPLAYS_TO_BLINK<=(others=>'0'); --No blink
        when get_password =>
             DISPLAY_CODES_IN<=("01101","01100","01010","01111","01110",others=>(others=>'1'));  
                                          --    C       L       A       U       E 
                                          --    01101   01100   01010   01111   01110   others=>1
             DISPLAYS_TO_BLINK<=(others=>'0'); --No blink
        when setting_password => 
            reset_password<='0';
            reset_attempt<='0';
            ce_password<='1';
            DISPLAY_CODES_IN<=led_code_out_password;
            DISPLAYS_TO_BLINK <=    display_selected_password;
            
        when solve_window => 
             ce_password<='0';
             DISPLAY_CODES_IN<=("00101","00000","01100","01111","01110",others=>(others=>'1'));  
                                          --    S       O       L       U       E 
                                          --    00101   00000   01010   01111   01110   others=>1
             DISPLAYS_TO_BLINK<=(others=>'0'); --No blink                                          
        when attemp => 
             ce_attempt<='1';
             DISPLAY_CODES_IN<=led_code_out_attempt;
             DISPLAYS_TO_BLINK<=display_selected_attempt;
             
        when success => 
             reset_password<='1';
             reset_attempt<='1';
             ce_attempt<='0';
             DISPLAY_CODES_IN<=("00101","01111","01101","01101","01110","00101","00101",others=>(others=>'1'));  
                                          --    s       U       C       C       E       S       S 
                                          --    00101   01111   01101   01101   01110   00101   00101   others=>1  
             DISPLAYS_TO_BLINK<=(others=>'0'); --No blink                                                    
        when others => --Estado de fail
             ce_attempt<='0';
             DISPLAY_CODES_IN<=("01011","01010","00001","01100",others=>(others=>'1'));  
                                          --    F       A       I       L        
                                          --    01011   01010   00001   01100   others=>1   
             DISPLAYS_TO_BLINK<=(others=>'0'); --No blink    
                                                            
        end case;
    end process;

end Behavioral;
