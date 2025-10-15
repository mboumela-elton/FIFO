LIBRARY ieee;
LIBRARY work;
USE ieee.NUMERIC_STD.all;
USE ieee.std_logic_1164.all;
USE work.my_package.all;

ENTITY fifo_tb IS
  GENERIC (
    M : INTEGER := 8;
    N : INTEGER := 4
  );
END fifo_tb;

ARCHITECTURE fifo_tb_arch OF fifo_tb IS

  SIGNAL hl        : STD_LOGIC;
  SIGNAL data_in   : std_logic_vector(N - 1 downto 0);
  SIGNAL req       : STD_LOGIC;
  SIGNAL slow      : STD_LOGIC;
  SIGNAL data_out  : std_logic_vector(N - 1 downto 0);
  SIGNAL fast      : STD_LOGIC;
  SIGNAL clk       : STD_LOGIC := '0';
  SIGNAL ack       : STD_LOGIC;
  SIGNAL reset     : STD_LOGIC;

BEGIN

  -- Instanciation de la FIFO
  DUT : FIFO
    GENERIC MAP (
      M => M,
      N => N
    )
    PORT MAP (
      hl        => hl,
      data_in   => data_in,
      req       => req,
      slow      => slow,
      data_out  => data_out,
      fast      => fast,
      clk       => clk,
      ack       => ack,
      reset     => reset
    );

  -- Génération de l'horloge
  clk_process : PROCESS
  BEGIN
    WHILE TRUE LOOP
      clk <= '0';
      WAIT FOR 5 ns;
      clk <= '1';
      WAIT FOR 5 ns;
    END LOOP;
  END PROCESS;

  -- Séquence de test
  stimulus_process : PROCESS
  BEGIN
    reset <= '0';
    data_in <= "0100";
    WAIT FOR 20 ns;
    req   <= '0';
    WAIT FOR 20 ns;
    req   <= '0';

    data_in <= "0110";
    WAIT FOR 20 ns;
    req   <= '0';
    
    data_in <= "0111";
    WAIT FOR 20 ns;
    req   <= '0';
    

    -- Envoi de données
    --data_in <= "0011";
    --req <= '0';
    --WAIT FOR 20 ns;

    --data_in <= "0010";
    --WAIT FOR 20 ns;

    --data_in <= "0100";
    --WAIT FOR 20 ns;

    ---req <= '0';
    --WAIT FOR 100 ns;

    -- Fin du test
    WAIT;
  END PROCESS;

END fifo_tb_arch;