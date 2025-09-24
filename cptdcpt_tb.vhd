LIBRARY ieee  ; 
USE ieee.NUMERIC_STD.all  ; 
USE ieee.std_logic_1164.all  ; 
ENTITY cptdcpt_tb  IS 
  GENERIC (
    M  : INTEGER   := 8 ); 
END ; 
 
ARCHITECTURE cptdcpt_tb_arch OF cptdcpt_tb IS
  SIGNAL cptr   :  std_logic_vector (M - 1 downto 0)  ; 
  SIGNAL ud   :  STD_LOGIC  ; 
  SIGNAL clk   :  STD_LOGIC  ; 
  SIGNAL enable   :  STD_LOGIC  ; 
  SIGNAL reset   :  STD_LOGIC  ; 
  COMPONENT cptdcpt  
    GENERIC ( 
      M  : INTEGER  );  
    PORT ( 
      cptr  : out std_logic_vector (M - 1 downto 0) ; 
      ud  : in STD_LOGIC ; 
      clk  : in STD_LOGIC ; 
      enable  : in STD_LOGIC ; 
      reset  : in STD_LOGIC ); 
  END COMPONENT ; 

BEGIN
  DUT  : cptdcpt  
    GENERIC MAP ( 
      M  => M   )
    PORT MAP ( 
      cptr   => cptr  ,
      ud   => ud  ,
      clk   => clk  ,
      enable   => enable  ,
      reset   => reset   ) ; 

  clk_process  : PROCESS
  BEGIN
    clk  <=  '0'  ; 
    WAIT FOR 10 ns  ; 
    clk  <=  '1'  ; 
    WAIT FOR 10 ns  ; 
  END PROCESS clk_process  ;

  stimulus_process  : PROCESS
  BEGIN
    -- hold reset state for 20 ns.
    reset  <=  '1'  ; 
    enable  <=  '0'  ; 
    ud  <=  '0'  ; 
    WAIT FOR 20 ns  ; 

    reset  <=  '0'  ; 
    enable  <=  '1'  ; 
    ud  <=  '1'  ; 
    WAIT FOR 160 ns  ; 

    ud  <=  '0'  ; 
    WAIT FOR 160 ns  ; 

    enable  <=  '0'  ; 
    WAIT FOR 40 ns  ; 

    enable  <=  '1'  ; 
    ud  <=  '1'  ; 
    WAIT FOR 80 ns  ; 

    ud  <=  '0'  ; 
    WAIT FOR 80 ns  ; 

    reset  <=  '1'  ; 
    WAIT FOR 20 ns   ; 

    WAIT   ;
    END PROCESS stimulus_process  ;
END cptdcpt_tb_arch ;

