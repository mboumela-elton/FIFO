LIBRARY ieee;
LIBRARY work;
USE ieee.NUMERIC_STD.ALL;
USE ieee.std_logic_1164.ALL;
USE work.my_package.ALL;

ENTITY fastslow_tb IS
    GENERIC (
        M : INTEGER := 8
    );
END fastslow_tb;

ARCHITECTURE fastslow_tb_arch OF fastslow_tb IS

    SIGNAL s_slow     : STD_LOGIC;
    SIGNAL s_incwrite : STD_LOGIC := '0';
    SIGNAL s_fast     : STD_LOGIC;
    SIGNAL s_clk      : STD_LOGIC := '0';
    SIGNAL s_incread  : STD_LOGIC := '0';
    SIGNAL s_reset    : STD_LOGIC := '0';

BEGIN

    -- Instanciation du module testé
    DUT : fastslow
        GENERIC MAP (
            M => M
        )
        PORT MAP (
            slow     => s_slow,
            incwrite => s_incwrite,
            fast     => s_fast,
            clk      => s_clk,
            incread  => s_incread,
            reset    => s_reset
        );

    -- Génération de l'horloge
    clk_process : PROCESS
    BEGIN
        WHILE TRUE LOOP
            s_clk <= '0';
            WAIT FOR 5 ns;
            s_clk <= '1';
            WAIT FOR 5 ns;
        END LOOP;
    END PROCESS;

    -- Stimulus : séquence de test
    stimulus_process : PROCESS
    BEGIN
        -- Initialisation
        s_reset <= '1';
        WAIT FOR 20 ns;
        s_reset <= '0';

        -- Écriture dans la FIFO
        FOR i IN 0 TO 9 LOOP
            s_incwrite <= '1';
            WAIT FOR 10 ns;
            s_incwrite <= '0';
            WAIT FOR 10 ns;
        END LOOP;

        -- Lecture depuis la FIFO
        FOR i IN 0 TO 4 LOOP
            s_incread <= '1';
            WAIT FOR 10 ns;
            s_incread <= '0';
            WAIT FOR 10 ns;
        END LOOP;

        WAIT;
    END PROCESS;

END fastslow_tb_arch;