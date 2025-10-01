LIBRARY ieee;
USE ieee.NUMERIC_STD.ALL;
USE ieee.std_logic_1164.ALL;
USE work.my_package.ALL;

ENTITY ram_2pmxnbits_tb IS 
  GENERIC ( 
    M : INTEGER := 8;  -- log2(8) = 3 pour adresser 8 mots 
    N : INTEGER := 4   -- largeur d?un mot 
  ); 
END ram_2pmxnbits_tb;

ARCHITECTURE ram_2pmxnbits_tb_arch OF ram_2pmxnbits_tb IS

    CONSTANT s_clk_period : TIME := 10 ns;
    CONSTANT s_setup_time : TIME := 5 ns;

    SIGNAL s_clk    : STD_LOGIC := '0';
    SIGNAL s_CS_n   : STD_LOGIC := '1';
    SIGNAL s_RW_n   : STD_LOGIC := '1';
    SIGNAL s_OE     : STD_LOGIC := '0';
    SIGNAL s_addr   : STD_LOGIC_VECTOR(M-1 DOWNTO 0);
    SIGNAL s_Din    : STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL s_Dout   : STD_LOGIC_VECTOR(N-1 DOWNTO 0);

BEGIN

    DUT : ram_2pmxnbits
        GENERIC MAP (
            M => M,  -- profondeur mémoire
            N => N
        )
        PORT MAP (
            clk   => s_clk,
            CS_n  => s_CS_n,
            RW_n  => s_RW_n,
            OE    => s_OE,
            addr  => s_addr,
            Din   => s_Din,
            Dout  => s_Dout
        );

    clk_process : PROCESS
    BEGIN
        WHILE TRUE LOOP
            s_clk <= '0';
            WAIT FOR s_clk_period / 2;
            s_clk <= '1';
            WAIT FOR s_clk_period / 2;
        END LOOP;
    END PROCESS;

    stimulus_process : PROCESS
    BEGIN
        s_CS_n <= '0';

        s_RW_n <= '0';
        s_addr <= std_logic_vector(to_unsigned(0, M));
        s_Din  <= "0001";
        WAIT FOR s_setup_time;
        WAIT FOR s_clk_period;

        s_addr <= std_logic_vector(to_unsigned(1, M));
        s_Din  <= "0010";
        WAIT FOR s_setup_time;
        WAIT FOR s_clk_period;

        s_addr <= std_logic_vector(to_unsigned(2, M));
        s_Din  <= "0100";
        WAIT FOR s_setup_time;
        WAIT FOR s_clk_period;

        s_RW_n <= '1';
        s_OE   <= '1';

        s_addr <= std_logic_vector(to_unsigned(0, M));
        WAIT FOR s_clk_period;

        s_addr <= std_logic_vector(to_unsigned(1, M));
        WAIT FOR s_clk_period;

        s_addr <= std_logic_vector(to_unsigned(2, M));
        WAIT FOR s_clk_period;

        s_CS_n <= '1';
        s_OE   <= '0';

        WAIT;
    END PROCESS;

END ram_2pmxnbits_tb_arch;