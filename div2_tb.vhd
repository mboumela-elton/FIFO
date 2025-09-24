LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY div2_tb IS
END div2_tb;

ARCHITECTURE div2_tb_arch OF div2_tb IS

    SIGNAL s_clk_in   : STD_LOGIC := '0';
    SIGNAL s_clk_out  : STD_LOGIC;
    SIGNAL s_reset    : STD_LOGIC := '0';
    SIGNAL s_enable   : STD_LOGIC := '0';

    COMPONENT div2
        GENERIC (
            delay_time : TIME := 1 ns
        );
        PORT (
            clk_in   : IN  STD_LOGIC;
            clk_out  : OUT STD_LOGIC;
            reset    : IN  STD_LOGIC;
            enable   : IN  STD_LOGIC
        );
    END COMPONENT;

    CONSTANT clk_period : TIME := 10 ns;

BEGIN

    DUT : div2
        GENERIC MAP (
            delay_time => 1 ns
        )
        PORT MAP (
            clk_in   => s_clk_in,
            clk_out  => s_clk_out,
            reset    => s_reset,
            enable   => s_enable
        );

    clk_process : PROCESS
    BEGIN
        WHILE TRUE LOOP
            s_clk_in <= '0';
            WAIT FOR clk_period / 2;
            s_clk_in <= '1';
            WAIT FOR clk_period / 2;
        END LOOP;
    END PROCESS;

    stimulus_process : PROCESS
    BEGIN
        -- Initial reset
        s_reset <= '1';
        s_enable <= '0';
        WAIT FOR 20 ns;

        -- Enable toggling and release reset
        s_reset <= '0';
        s_enable <= '1';
        WAIT FOR 100 ns;

        -- Disable toggling temporarily
        s_enable <= '0';
        WAIT FOR 40 ns;

        -- Re-enable toggling
        s_enable <= '1';
        WAIT FOR 60 ns;

        -- Apply reset again
        s_reset <= '1';
        WAIT FOR 20 ns;

        -- Final run with enable active
        s_reset <= '0';
        WAIT FOR 100 ns;

        WAIT;
    END PROCESS;

END div2_tb_arch;
