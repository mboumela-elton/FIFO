LIBRARY ieee  ; 
USE ieee.NUMERIC_STD.all  ; 
USE ieee.std_logic_1164.all  ;
USE work.my_package.ALL ;
 
ENTITY genaddr_tb  IS 
  GENERIC (
    M  : INTEGER   := 8 ); 
END ; 
 
ARCHITECTURE genaddr_tb_arch OF genaddr_tb IS
  SIGNAL selectRead   :  STD_LOGIC  ; 
  SIGNAL Addrgen   :  std_logic_vector (M - 1 downto 0)  ; 
  SIGNAL incWrite   :  STD_LOGIC  ; 
  SIGNAL incRead   :  STD_LOGIC  ; 
  SIGNAL CLK   :  STD_LOGIC  ; 
  SIGNAL RESET   :  STD_LOGIC  ; 



BEGIN
  DUT  : genaddr  
    GENERIC MAP ( 
      M  => M   )
    PORT MAP ( 
      selectRead   => selectRead  ,
      Addrgen   => Addrgen  ,
      incWrite   => incWrite  ,
      incRead   => incRead  ,
      CLK   => CLK  ,
      RESET   => RESET   ) ; 

  CLK_process  : PROCESS
  BEGIN
    CLK  <= '0'  ;
    WAIT FOR 10 ns;
    CLK  <= '1'  ;
    WAIT FOR 10 ns;
  END PROCESS;

  stimulus_process: PROCESS
  BEGIN
    -- hold reset state for 20 ns.
    RESET <= '1';
    incRead <= '0';
    incWrite <= '0';
    selectRead <= '0';
    WAIT FOR 20 ns;  
    
    RESET <= '0';
    WAIT FOR 20 ns;  
    
    incRead <= '1';
    WAIT FOR 100 ns;  
    
    incRead <= '0';
    WAIT FOR 40 ns;  
    
    incWrite <= '1';
    WAIT FOR 40 ns;
    RESET <= '1';
    WAIT FOR 20 ns;  
    RESET <= '0';
    WAIT FOR 40 ns;  
    
    incWrite <= '0';
    WAIT FOR 40 ns;  
    
    selectRead <= '1';
    incRead <= '1';
    WAIT FOR 100 ns;  
    
    incRead <= '0';
    WAIT FOR 40 ns;  
    
    selectRead <= '0';
    WAIT FOR 50 ns;  

    incWrite <= '1';
    selectRead <= '1';
    WAIT FOR 50 ns;
    WAIT;
  END PROCESS stimulus_process;
END genaddr_tb_arch;