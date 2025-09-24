
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.my_package.ALL ;
use work.mes_fonctions.ALL ;

ENTITY complement_a_2 is
    GENERIC (
        N : INTEGER := 8
    );
    PORT ( 
        nombre      : in STD_LOGIC_VECTOR (N-1 downto 0);
        sortie      : out STD_LOGIC_VECTOR (N-1 downto 0)
    );
    END ENTITY complement_a_2;

architecture archi_complement_a_2 of complement_a_2 is
begin
    sortie <= cpl2(nombre, N);
end archi_complement_a_2;
