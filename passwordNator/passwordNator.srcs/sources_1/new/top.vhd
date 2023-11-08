library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.ARRAY_IN_VHDL.all; 
entity top is
 generic(
        BLINK_CLK_DIVIDER: positive := 50000000;
        LED_CODE_SIZE: positive := 5;
        NUM_DISPLAYS: positive := 8;
        DISPLAY_CHANGE_CLK_DIVIDER: positive := 1000000 -- 10 ms
    );
 Port(
        CLK: in std_logic;
        s7: out std_logic_vector (6 downto 0);
        temporal_delete_after_use: in std_logic_vector (4 downto 0);
        t7: out std_logic_vector (7 downto 0)
    );
end top;

architecture Behavioral of top is
    component Decoder7 is
    Port(
        s7: out std_logic_vector (6 downto 0);
        e7: in std_logic_vector (4 downto 0)
    
    );
    end component;
    
    component BLINKER is
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
    end component;
    
    component DISPLAY_MUX is
    generic(
        NUM_DISPLAYS: positive;
        LED_CODE_SIZE: positive;
        DISPLAY_CHANGE_CLK_DIVIDER: positive
    );
    
    port(
        CLK: in std_logic;
        DISPLAY_CODES_IN: in T_DISPLAY_CODES_IN (0 to NUM_DISPLAYS - 1);
        DISPLAY_CODE_OUT: out std_logic_vector(LED_CODE_SIZE - 1  downto 0);
        DISPLAY_IN_USE: out natural range 0 to NUM_DISPLAYS - 1
    );
    end component;
    
    signal Blinker_to_decoder: std_logic_vector (4 downto 0);
    signal Mux_to_blinker_led_code: std_logic_vector (4 downto 0);
    signal Mux_to_blinker_display:  natural range 0 to NUM_DISPLAYS - 1;
    signal sexo: T_DISPLAY_CODES_IN (0 to NUM_DISPLAYS - 1);
    
begin
     sexo<=(others => (others=>'0'));

    Deocoder7_inst: Decoder7
    port map( 
        s7=>s7,
        e7=>Blinker_to_decoder
    );
    
    Blinker_inst: BLINKER
    generic map(
        BLINK_CLK_DIVIDER => BLINK_CLK_DIVIDER,
        LED_CODE_SIZE => LED_CODE_SIZE,
        NUM_DISPLAYS => NUM_DISPLAYS
    )
    port map( 
        CLK => CLK,
        LED_CODE_IN => Mux_to_blinker_led_code,
        DISPLAYS_TO_BLINK => "01011010",
        DISPLAY_SELECTED => Mux_to_blinker_display,
        LED_CODE_OUT => Blinker_to_decoder
    );
    
    DISPLAY_MUX_inst: DISPLAY_MUX
    generic map(
        DISPLAY_CHANGE_CLK_DIVIDER => DISPLAY_CHANGE_CLK_DIVIDER,
        LED_CODE_SIZE => LED_CODE_SIZE,
        NUM_DISPLAYS => NUM_DISPLAYS
    )
    
    port map(
        CLK => CLK,
        DISPLAY_CODES_IN => sexo,
        DISPLAY_CODE_OUT => Mux_to_blinker_led_code,
        DISPLAY_IN_USE=> Mux_to_blinker_display 
    );
    
    
    
    t7 <= "00000001" when Mux_to_blinker_display = 0 else
           "00000010" when Mux_to_blinker_display = 1 else
           "00000100" when Mux_to_blinker_display = 2 else
           "00001000" when Mux_to_blinker_display = 3 else
           "00010000" when Mux_to_blinker_display = 4 else
           "00100000" when Mux_to_blinker_display = 5 else
           "01000000" when Mux_to_blinker_display = 6 else
           "10000000" when Mux_to_blinker_display = 7;
    
  
end Behavioral;