LIBRARY ieee  ; 
USE ieee.NUMERIC_STD.all  ; 
USE ieee.std_logic_1164.all  ; 
USE work.my_package.ALL ;

ENTITY cptdcpt_tb  IS 
  GENERIC (
    M  : INTEGER   := 8 ); 
END ; 
 
ARCHITECTURE cptdcpt_tb_arch OF cptdcpt_tb IS
  SIGNAL Q   :  std_logic_vector (M - 1 downto 0)  ; 
  SIGNAL UD   :  STD_LOGIC  ; 
  SIGNAL CLK   :  STD_LOGIC  ; 
  SIGNAL ENABLE   :  STD_LOGIC  ; 
  SIGNAL RESET   :  STD_LOGIC  ;  

BEGIN
  DUT  : cptdcpt  
    GENERIC MAP ( 
      M  => M   )
    PORT MAP ( 
      Q   => Q  ,
      UD   => UD  ,
      CLK   => CLK  ,
      ENABLE   => ENABLE  ,
      RESET   => RESET   ) ; 

  CLK_process  : PROCESS
  BEGIN
    CLK  <=  '0'  ;
    WAIT FOR 10 ns;
    CLK  <=  '1'  ;
    WAIT FOR 10 ns;
  END PROCESS CLK_process  ;

  stimulus_process  : PROCESS
  BEGIN
    -- hold reset state for 20 ns.
    RESET  <=  '1'  ;
    ENABLE  <=  '0'  ;
    UD  <=  '0'  ;
    WAIT FOR 20 ns  ;

    RESET  <=  '0'  ;
    ENABLE  <=  '1'  ;
    UD  <=  '1'  ;
    WAIT FOR 160 ns  ;

    UD  <=  '0'  ;
    WAIT FOR 160 ns  ;

    ENABLE  <=  '0'  ;
    WAIT FOR 40 ns  ;

    ENABLE  <=  '1'  ;
    UD  <=  '1'  ;
    WAIT FOR 80 ns  ;

    UD  <=  '0'  ;
    WAIT FOR 80 ns  ;

    RESET  <=  '1'  ;
    WAIT FOR 20 ns  ;

    WAIT   ;
    END PROCESS stimulus_process  ;
END cptdcpt_tb_arch ;

