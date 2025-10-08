LIBRARY ieee  ; 
LIBRARY work  ; 
USE ieee.std_logic_1164.all  ; 
USE work.my_package.all  ; 

ENTITY sequenceur_tb  IS 
END ; 
 
ARCHITECTURE sequenceur_tb_arch OF sequenceur_tb IS
  SIGNAL REQ          :  STD_LOGIC  ; 
  SIGNAL SELREAD      :  STD_LOGIC  ; 
  SIGNAL CS_n         :  STD_LOGIC  ; 
  SIGNAL RESET        :  STD_LOGIC  ; 
  SIGNAL HL           :  STD_LOGIC  ; 
  SIGNAL INCWRITE     :  STD_LOGIC  ; 
  SIGNAL ACK          :  STD_LOGIC  ; 
  SIGNAL CLK          :  STD_LOGIC  ; 
  SIGNAL OE           :  STD_LOGIC  ; 
  SIGNAL ENWRITE      :  STD_LOGIC  ; 
  SIGNAL RW_n         :  STD_LOGIC  ; 
  SIGNAL INCREAD      :  STD_LOGIC  ; 
  SIGNAL ENREAD       :  STD_LOGIC  ; 
  COMPONENT sequenceur  
    PORT ( 
      REQ  : in STD_LOGIC ; 
      SELREAD  : out STD_LOGIC ; 
      CS_n  : out STD_LOGIC ; 
      RESET  : in STD_LOGIC ; 
      HL  : out STD_LOGIC ; 
      INCWRITE  : out STD_LOGIC ; 
      ACK  : out STD_LOGIC ; 
      CLK  : in STD_LOGIC ; 
      OE  : out STD_LOGIC ; 
      ENWRITE  : in STD_LOGIC ; 
      RW_n  : out STD_LOGIC ; 
      INCREAD  : out STD_LOGIC ; 
      ENREAD  : in STD_LOGIC ); 
  END COMPONENT ; 
BEGIN
  DUT  : sequenceur  
    PORT MAP ( 
      REQ   => REQ  ,
      SELREAD   => SELREAD  ,
      CS_n   => CS_n  ,
      RESET   => RESET  ,
      HL   => HL  ,
      INCWRITE   => INCWRITE  ,
      ACK   => ACK  ,
      CLK   => CLK  ,
      OE   => OE  ,
      ENWRITE   => ENWRITE  ,
      RW_n   => RW_n  ,
      INCREAD   => INCREAD  ,
      ENREAD   => ENREAD   ) ; 

  clk_process :process
  begin
    CLK <= '0';
    wait for 10 ns;
    CLK <= '1';
    wait for 10 ns;
  end process;

  stim_proc: process
  begin
    -- Initialisation
    RESET <= '1';
    ENREAD <= '0';
    ENWRITE <= '0';
    REQ <= '1';
    wait for 25 ns;

    RESET <= '0';
    wait for 20 ns;

    -- Test lecture (ENREAD = 1)
    ENREAD <= '1';
    wait for 20 ns;

    ENREAD <= '0';
    wait for 20 ns;

    -- Test écriture (ENWRITE = 1, REQ = 0)
    ENWRITE <= '1';
    REQ <= '0';
    wait for 20 ns;

    ENWRITE <= '0';
    REQ <= '0';
    wait for 20 ns;

    REQ <= '1';
    wait for 20 ns;

    -- Test lecture après écriture (cycle Attente -> Lecture2)
    ENWRITE <= '1';
    REQ <= '0';
    wait for 20 ns;

    ENWRITE <= '0';
    wait for 20 ns;

    ENREAD <= '1';
    wait for 20 ns;

    ENREAD <= '0';
    REQ <= '1';
    wait for 20 ns;

    -- Retour à l'état de repos
    wait for 40 ns;

    -- Fin de simulation
    wait;
    END PROCESS ;
END ; 

