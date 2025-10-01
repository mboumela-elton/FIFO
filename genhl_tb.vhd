LIBRARY ieee  ; 
LIBRARY work  ; 
USE ieee.NUMERIC_STD.all  ; 
USE ieee.std_logic_1164.all  ; 
USE work.my_package.all  ; 
ENTITY genhl_tb  IS 
  GENERIC (
    M  : INTEGER   := 8 ); 
END ; 
 
ARCHITECTURE genhl_tb_arch OF genhl_tb IS
  SIGNAL ENWRITE   :  STD_LOGIC  ; 
  SIGNAL CLK   :  STD_LOGIC  ; 
  SIGNAL ENREAD   :  STD_LOGIC  ; 
  SIGNAL RESET   :  STD_LOGIC  ; 
  COMPONENT genhl  
    GENERIC ( 
      M  : INTEGER  );  
    PORT ( 
      ENWRITE  : out STD_LOGIC ; 
      CLK  : in STD_LOGIC ; 
      ENREAD  : out STD_LOGIC ; 
      RESET  : in STD_LOGIC ); 
  END COMPONENT ; 
BEGIN
  DUT  : genhl  
    GENERIC MAP ( 
      M  => M   )
    PORT MAP ( 
      ENWRITE   => ENWRITE  ,
      CLK   => CLK  ,
      ENREAD   => ENREAD  ,
      RESET   => RESET   ) ; 
-- Clock generation process
clk_process : process
begin
  CLK <= '0';
  wait for 5 ns;
  CLK <= '1';
  wait for 5 ns;
end process;

-- Stimulus process
stim_proc: process
begin
  -- Initial values
  RESET <= '1';
  wait for 20 ns;
  RESET <= '0';

  -- Wait for a few cycles to observe ENREAD/ENWRITE toggling
  wait for 2200 ns;

  -- Apply a reset in the middle
  RESET <= '1';
  wait for 20 ns;
  RESET <= '0';

  wait for 1000 ns;

  -- End simulation
  wait;
end process;

END genhl_tb_arch ;