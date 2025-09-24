LIBRARY ieee;
LIBRARY work;
USE ieee.NUMERIC_STD.ALL;
USE ieee.std_logic_1164.ALL;
USE work.my_package.ALL;

ENTITY genhl_tb IS
END genhl_tb;

ARCHITECTURE genhl_tb_arch OF genhl_tb IS

    SIGNAL enwrite : STD_LOGIC;
    SIGNAL clk     : STD_LOGIC := '0';
    SIGNAL enread  : STD_LOGIC;
    SIGNAL reset   : STD_LOGIC := '0';

BEGIN

    -- Instantiation of the DUT (Device Under Test)
    DUT : genhl
        PORT MAP (
            enwrite => enwrite,
            clk     => clk,
            enread  => enread,
            reset   => reset
        );

    -- Clock generation process
    clk_process : PROCESS
    BEGIN
        WHILE TRUE LOOP
            clk <= '0';
            WAIT FOR 5 ns;
            clk <= '1';
            WAIT FOR 5 ns;
        END LOOP;
    END PROCESS;

    -- Stimulus process
    stimulus_process : PROCESS
    BEGIN
        -- Initial reset
        reset <= '1';
        WAIT FOR 20 ns;
        reset <= '0';
        
        -- Let the system run for 100 ns
        WAIT FOR 100 ns;

        WAIT;
    END PROCESS;

END genhl_tb_arch;