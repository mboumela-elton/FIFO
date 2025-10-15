LIBRARY ieee  ; 
LIBRARY work  ; 
USE ieee.std_logic_1164.all  ;
USE work.my_package.all  ;

CONFIGURATION cfg_sequenceur OF fifo IS 
    FOR RTL
        FOR U4 : sequenceur USE ENTITY 
            --work.sequenceur(archi_Moore_sync);
            work.sequenceur(archi_Moore_imm);
            --work.sequenceur(archi_Mealy_sync);
            --work.sequenceur(archi_Mealy_imm);
        END FOR;
    END FOR;
END cfg_sequenceur ;