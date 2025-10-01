LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.my_package.ALL;

ENTITY ram_2pmxnbits_tb IS
END ram_2pmxnbits_tb;

ARCHITECTURE tb_arch OF ram_2pmxnbits_tb IS

    CONSTANT M : INTEGER := 8;  -- log2(8) = 3
    CONSTANT N : INTEGER := 4;
    CONSTANT DEPTH : INTEGER := 3;
    CONSTANT clk_period : TIME := 10 ns;

    SIGNAL clk    : STD_LOGIC := '0';
    SIGNAL reset  : STD_LOGIC := '0';
    SIGNAL CS_n   : STD_LOGIC := '1';
    SIGNAL RW_n   : STD_LOGIC := '1';
    SIGNAL OE     : STD_LOGIC := '0';
    SIGNAL addr   : STD_LOGIC_VECTOR(M-1 DOWNTO 0);
    SIGNAL Din    : STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Dout   : STD_LOGIC_VECTOR(N-1 DOWNTO 0);

BEGIN

    DUT : ram_2pmxnbits
        GENERIC MAP (
            M => M,
            N => N
        )
        PORT MAP (
            clk   => clk,
            CS_n  => CS_n,
            RW_n  => RW_n,
            OE    => OE,
            addr  => addr,
            Din   => Din,
            Dout  => Dout
        );

    -- Clock generation
    clk_process : PROCESS
    BEGIN
        WHILE TRUE LOOP
            clk <= '0';
            WAIT FOR clk_period / 2;
            clk <= '1';
            WAIT FOR clk_period / 2;
        END LOOP;
    END PROCESS;

    -- Stimulus process
    stimulus_process : PROCESS
    BEGIN
        CS_n <= '0';
        RW_n <= '0';
        OE   <= '0';

        -- Écriture séquentielle
        FOR i IN 0 TO DEPTH-1 LOOP
            addr <= std_logic_vector(to_unsigned(i, M));
            Din  <= std_logic_vector(to_unsigned(i + 1, N)); -- données = i+1
            WAIT FOR clk_period;
        END LOOP;

        -- Lecture séquentielle FIFO
        WAIT FOR clk_period/2;
        RW_n <= '1';
        OE   <= '1';
        WAIT FOR clk_period/2;

        FOR i IN 0 TO DEPTH-1 LOOP
           --  addr <= std_logic_vector(to_unsigned(i, M));
            WAIT FOR clk_period;
        END LOOP;

        CS_n <= '1';
        OE   <= '0';

        WAIT;
    END PROCESS;

END tb_arch;