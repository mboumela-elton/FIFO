LIBRARY ieee  ; 
LIBRARY work  ; 
USE ieee.std_logic_1164.all  ; 
USE work.mes_fonctions.all  ; 
USE work.my_package.all  ; 
ENTITY complement_a_2_tb  IS 
  GENERIC (
    N  : INTEGER   := 8 ); 
END ; 
 
ARCHITECTURE complement_a_2_tb_arch OF complement_a_2_tb IS
  SIGNAL sortie   :  std_logic_vector (N - 1 downto 0)  ; 
  SIGNAL nombre   :  std_logic_vector (N - 1 downto 0)  ; 
  COMPONENT complement_a_2  
    GENERIC ( 
      N  : INTEGER  );  
    PORT ( 
      sortie  : out std_logic_vector (N - 1 downto 0) ; 
      nombre  : in std_logic_vector (N - 1 downto 0) ); 
  END COMPONENT ; 
BEGIN
  DUT  : complement_a_2  
    GENERIC MAP ( 
      N  => N   )
    PORT MAP ( 
      sortie   => sortie  ,
      nombre   => nombre   ) ; 

  PROCESS
  BEGIN
  Nombre <= "00000000" ;
  WAIT FOR 10 ns ;
  Nombre <= "11111111" ;
  WAIT FOR 10 ns ;
  Nombre <= "11110000" ;
  WAIT FOR 10 ns ;
  Nombre <= "00001111" ;
  WAIT FOR 10 ns ;
  Nombre <= "10101010" ;
  wait;
END PROCESS;

END ; 

