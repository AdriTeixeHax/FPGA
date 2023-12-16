library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.ARRAY_IN_VHDL.all; 
entity top is
 generic(
        BLINK_CLK_DIVIDER: positive := 50000000;
        LED_CODE_SIZE: positive := 5;
        NUM_DISPLAYS: positive := 8;
        DISPLAY_CHANGE_CLK_DIVIDER: positive := 100000 -- 1 ms
    );
 Port(
        CLK: in std_logic;
        OK_B: in std_logic;
        UP_B: in std_logic;
        DOWN_B: in std_logic;
        LEFT_B: in std_logic;
        RIGHT_B: in std_logic;
        RESET: in std_logic;
        s7: out std_logic_vector (6 downto 0);
        DOT: out std_logic;
        t7: out std_logic_vector (NUM_DISPLAYS - 1 downto 0)
    );
end top;

architecture Behavioral of top is
    component Decoder7 is
    Port(
        s7: out std_logic_vector (6 downto 0);
        e7: in std_logic_vector (LED_CODE_SIZE - 1 downto 0)
    
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
    
    component the_machine_of_the_state
        generic(
            NUM_DISPLAYS: positive;
            LED_CODE_SIZE: positive
        );
        Port ( 
            Reset: in std_logic;
            CLK:  in std_logic ;
            OK_B: in std_logic;
            UP: in std_logic;
            DOWN: in std_logic;
            LEFT: in std_logic;
            RIGHT: in std_logic;
            DISPLAYS_TO_BLINK: out std_logic_vector(NUM_DISPLAYS - 1 downto 0);
            DISPLAY_CODES_IN: out T_DISPLAY_CODES_IN (0 to NUM_DISPLAYS - 1) );
    end component;
    
    component Transistor_mux
        generic (
            num_displays: positive
        );
        Port (
               Mux_to_blinker_display:  natural range 0 to NUM_DISPLAYS - 1;
               t7: out std_logic_vector (NUM_DISPLAYS - 1 downto 0));    
    end component;
    
    component SYNC_BUTTON is
    port(
        CLK: in std_logic;
        ASYNC_IN: in std_logic;
        SYNC_OUT: out std_logic
    );
    end component;
    
    signal Blinker_to_decoder: std_logic_vector (4 downto 0);
    signal Mux_to_blinker_led_code: std_logic_vector (4 downto 0);
    signal Mux_to_blinker_display:  natural range 0 to NUM_DISPLAYS - 1;
    signal fsm_to_blinker_displays_to_blink: std_logic_vector(NUM_DISPLAYS - 1 downto 0);
    signal fsm_to_mux_displays_codes_in: T_DISPLAY_CODES_IN (0 to NUM_DISPLAYS - 1);
    signal OK_B_SIGNAL: std_logic;
    signal UP_B_SIGNAL: std_logic;
    signal DOWN_B_SIGNAL: std_logic;
    signal LEFT_B_SIGNAL: std_logic;
    signal RIGHT_B_SIGNAL: std_logic;
begin
    DOT <= '1';
    fsm_inst:  the_machine_of_the_state
    generic map(
        NUM_DISPLAYS => NUM_DISPLAYS,
        LED_CODE_SIZE => LED_CODE_SIZE
    )
    port map( 
         Reset  => RESET,
         CLK    =>  CLK,
         OK_B   =>  OK_B_SIGNAL,
         UP => UP_B_SIGNAL,
         DOWN => DOWN_B_SIGNAL,
         LEFT => LEFT_B_SIGNAL,
         RIGHT => RIGHT_B_SIGNAL,
         DISPLAYS_TO_BLINK  =>  fsm_to_blinker_displays_to_blink,
         DISPLAY_CODES_IN   =>  fsm_to_mux_displays_codes_in
    );
     
     
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
        DISPLAYS_TO_BLINK => fsm_to_blinker_displays_to_blink,
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
        DISPLAY_CODES_IN => fsm_to_mux_displays_codes_in,
        DISPLAY_CODE_OUT => Mux_to_blinker_led_code,
        DISPLAY_IN_USE=> Mux_to_blinker_display 
    );
    
    Transistor_mux_inst: Transistor_mux
    generic map(
         NUM_DISPLAYS => NUM_DISPLAYS
    )
    port map(
         Mux_to_blinker_display =>Mux_to_blinker_display,
         t7=>t7
    );
    
    OK_BTN_INST: SYNC_BUTTON
    port map(
        CLK => CLK,
        ASYNC_IN => OK_B,
        SYNC_OUT => OK_B_SIGNAL
    );
    
    UP_BTN_INST: SYNC_BUTTON
    port map(
        CLK => CLK,
        ASYNC_IN => UP_B,
        SYNC_OUT => UP_B_SIGNAL
    );
    
    DOWN_BTN_INST: SYNC_BUTTON
    port map(
        CLK => CLK,
        ASYNC_IN => DOWN_B,
        SYNC_OUT => DOWN_B_SIGNAL
    );
    
    LEFT_BTN_INST: SYNC_BUTTON
    port map(
        CLK => CLK,
        ASYNC_IN => LEFT_B,
        SYNC_OUT => LEFT_B_SIGNAL
    );
    
    RIGHT_BTN_INST: SYNC_BUTTON
    port map(
        CLK => CLK,
        ASYNC_IN => RIGHT_B,
        SYNC_OUT => RIGHT_B_SIGNAL
    );
  
end Behavioral;