LIBRARY ieee  ; 
LIBRARY work  ; 
USE ieee.std_logic_1164.all  ;
USE work.my_package.all  ;

CONFIGURATION cfg_sequenceur OF sequenceur_tb IS 
    FOR sequenceur_tb_arch
        FOR DUT : sequenceur USE ENTITY 
            --work.sequenceur(archi_Moore);
            work.sequenceur(archi_Mealy);
        END FOR;
    END FOR;
END cfg_sequenceur ;