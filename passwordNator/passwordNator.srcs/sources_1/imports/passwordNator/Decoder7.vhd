--          -------------     A
--          |            |
--          |            |
--       F  |            |  B  
--          |            |
--          |            |
--          -------------     G
--          |            |
--          |            |
--       E  |            |  C  
--          |            |
--          |            |
--          -------------     D
--
--          De la datasheet:
--          A: T10 6
--          B: R10 5
--          C: K16 4
--          D: K13 3
--          G: P15 2
--          F: T11 1
--          G: L18 0


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Decoder7 is
    Port(
        s7: out std_logic_vector (6 downto 0);
        e7: in std_logic_vector (4 downto 0)
    
    );
    
end Decoder7;

architecture Behavioral of Decoder7 is
    
begin
   s7(0)<=e7(4) 
            or ( e7(0) and  (   (   e7(3) and e7(2) and e7(1)   )   or (    not(    e7(3)   )  and  not (   e7(2)   )   and not (   e7(1)   ) )   )   )
            or (    e7(2)   and not (   e7(1) )    and not (   e7(0) ) ); 
            
  s7(1)<=e7(4) 
            or (   e7(2)  and  (    (   e7(3)   and not (   e7(1)   )   )   or  (   e7(1)   xor e7(0)   )   )   )
            or  (   e7(3)   and not (   e7(2)   )   and e7(1)   and   e7(0) );
  
  s7(2)<=e7(4) 
            or  (   e7(3)    and e7(2)    and (   not (   e7(1)    )    or  not    (   e7(0)    )   )   )
            or  (   not (   e7(3)    )    and not (   e7(2)    )    and e7(1)    and not (   e7(0)    )    )
            or  (   e7(3)   and not (   e7(2)   )   and e7(1)   and   e7(0) ); 
  
  s7(3)<=e7(4)  
            or  (   not (   e7(2)    )   and (   (   e7(3)    and e7(1)   )    or   (   not (   e7(1)    )    and e7(0)   )   ) )
            or  (   not (   e7(3)    )  and e7(2)   and (   e7(1) xnor  e7(0)   )   ); 
            
  s7(4)<=e7(4) 
            or  (   e7(0)    and (   not (   e7(3)   )    or    (   not (   e7(2)   )   and     not (   e7(1)   )  ) )  )
            or  (   not (   e7(3)   )    and e7(2)    and not (   e7(1)   )    ); 
  
  s7(5)<=e7(4) 
            or  (  not (    e7(3)    ) and ( (   not (   e7(2)    )    and (   e7(0)    or  e7(1) )  )   or    (   e7(1)    and e7(0)    )   )   );
  
  s7(6)<=e7(4) 
            or  (   not (   e7(1)   )   and not (   e7(3)   xor e7(2)   )   )
            or  (   e7(2)   and e7(1)   and e7(0)   );

  
end Behavioral;
