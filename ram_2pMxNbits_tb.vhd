LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.my_package.ALL;

ENTITY RAM_2pMxNbits IS
    GENERIC (
        M : INTEGER := 4;  
        N : INTEGER := 8 
    );
END RAM_2pMxNbits;

ARCHITECTURE RAM_2pMxNbits_arch OF RAM_2pMxNbits IS

    CONSTANT s_clk_period : TIME := 10 ns;     -- Clock period
    CONSTANT s_setup_time : TIME := 5 ns;      -- Setup time between RW_n and Din

    SIGNAL s_clk    : STD_LOGIC := '0';
    SIGNAL s_CS_n   : STD_LOGIC := '1';
    SIGNAL s_RW_n   : STD_LOGIC := '1';
    SIGNAL s_OE     : STD_LOGIC := '0';
    SIGNAL s_addr   : INTEGER RANGE 0 TO M-1 := 0;
    SIGNAL s_Din    : STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL s_Dout   : STD_LOGIC_VECTOR(N-1 DOWNTO 0);

BEGIN

    -- RAM instantiation
    DUT : ram
        GENERIC MAP (
            M => M,
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

    -- Clock generation process
    clk_process : PROCESS
    BEGIN
        WHILE TRUE LOOP
            s_clk <= '0';
            WAIT FOR s_clk_period / 2;
            s_clk <= '1';
            WAIT FOR s_clk_period / 2;
        END LOOP;
    END PROCESS;

    -- Test sequence process
    stimulus_process : PROCESS
    BEGIN
        -- Enable memory
        s_CS_n <= '0';

        -- Write value to address 0
        s_RW_n <= '0';
        s_addr <= 0;
        s_Din  <= "00001111";
        WAIT FOR s_setup_time;
        WAIT FOR s_clk_period;

        -- Write value to address 1
        s_addr <= 1;
        s_Din  <= "10101010";
        WAIT FOR s_setup_time;
        WAIT FOR s_clk_period;

        -- Write value to address 2
        s_addr <= 2;
        s_Din  <= "11110000";
        WAIT FOR s_setup_time;
        WAIT FOR s_clk_period;

        -- Switch to read mode
        s_RW_n <= '1';
        s_OE   <= '1';

        -- Read from address 0
        s_addr <= 0;
        WAIT FOR s_clk_period;

        -- Read from address 1
        s_addr <= 1;
        WAIT FOR s_clk_period;

        -- Read from address 2
        s_addr <= 2;
        WAIT FOR s_clk_period;

        -- Disable memory
        s_CS_n <= '1';
        s_OE   <= '0';

        WAIT;
    END PROCESS;

END RAM_2pMxNbits_arch;