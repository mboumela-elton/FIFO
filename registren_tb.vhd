LIBRARY ieee  ; 
LIBRARY work  ; 
USE ieee.NUMERIC_STD.all  ; 
USE ieee.std_logic_1164.all  ; 
USE work.CHECK_PKG.all  ;
 
ENTITY registren_tb  IS 
  GENERIC (
    T_SETUP  : TIME   := 5 ns ;  
    T_HOLD  : TIME   := 2 ns ;  
    N  : INTEGER   := 8 ); 
END ; 
 
ARCHITECTURE registren_tb_arch OF registren_tb IS
  SIGNAL D   :  std_logic_vector (N - 1 downto 0)  ; 
  SIGNAL Q   :  std_logic_vector (N - 1 downto 0)  ; 
  SIGNAL CLK   :  STD_LOGIC  ; 
  SIGNAL RESET   :  STD_LOGIC  ; 
  COMPONENT registreN  
    GENERIC ( 
      T_SETUP  : TIME ; 
      T_HOLD  : TIME ; 
      N  : INTEGER  );  
    PORT ( 
      D  : in std_logic_vector (N - 1 downto 0) ; 
      Q  : out std_logic_vector (N - 1 downto 0) ; 
      CLK  : in STD_LOGIC ; 
      RESET  : in STD_LOGIC ); 
  END COMPONENT ; 
BEGIN
  DUT  : registreN  
    GENERIC MAP ( 
      T_SETUP  => T_SETUP  ,
      T_HOLD  => T_HOLD  ,
      N  => N   )
    PORT MAP ( 
      D   => D  ,
      Q   => Q  ,
      CLK   => CLK  ,
      RESET   => RESET   ) ; 

  CLK_process  : PROCESS
  BEGIN 
    CLK  <=  '0' ; 
    WAIT FOR 10 ns ; 
    CLK  <=  '1' ; 
    WAIT FOR 10 ns ; 
  END PROCESS ;

  stim_process  : PROCESS
  BEGIN
    RESET  <=  '1' ; 
    D  <=  (OTHERS => '0') ; 
    WAIT FOR 15 ns ; 
    RESET  <=  '0' ; 
    WAIT FOR 20 ns ; 
    D  <=  "00001111" ; 
    WAIT FOR 20 ns ; 
    D  <=  "11110000" ; 
    WAIT FOR 20 ns ; 
    D  <=  "10101010" ; 
    WAIT FOR 20 ns ; 
    D  <=  "01010101" ; 
    WAIT FOR 20 ns ; 
    D  <=  (OTHERS => '0') ; 
    WAIT FOR 20 ns ; 
    RESET  <=  '1' ; 
    WAIT FOR 15 ns ; 
    RESET  <=  '0' ; 
    WAIT FOR 20 ns ; 
    D  <=  "11111111" ; 
    WAIT FOR 20 ns ; 
    D  <=  (OTHERS => '0') ; 
    WAIT FOR 20 ns ; 

    WAIT ;
  END PROCESS ;
END ; 

