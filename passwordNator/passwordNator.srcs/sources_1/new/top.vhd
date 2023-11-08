library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top is
 Port(
        s7: out std_logic_vector (6 downto 0);
        e7: in std_logic_vector (4 downto 0);
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
begin
  C1: Decoder7 port map(
            s7=>s7,
            e7=>e7
            );
    t7<=(others=>'0');

  
end Behavioral;