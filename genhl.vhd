LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.my_package.ALL;

ENTITY genhl IS
    PORT (
        reset    : IN  STD_LOGIC;
        clk      : IN  STD_LOGIC;
        enread   : OUT STD_LOGIC;
        enwrite  : OUT STD_LOGIC
    );
END genhl;

ARCHITECTURE behavior OF genhl IS

    SIGNAL cycle_count : INTEGER := 0;
    SIGNAL enable       : STD_LOGIC := '0';
    SIGNAL ud           : STD_LOGIC := '0';
    SIGNAL cptr         : STD_LOGIC_VECTOR(7 DOWNTO 0);  -- M = 8

BEGIN

    -- Instantiation of the counter-decounter component
    CreateCpt : cptdcpt
        GENERIC MAP (
            M => 8
        )
        PORT MAP (
            clk    => clk,
            reset  => reset,
            enable => enable,
            ud     => ud,
            Q   => cptr
        );

    -- Cycle counter process
    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF reset = '1' THEN
                cycle_count <= 0;
            ELSE
                cycle_count <= cycle_count + 1;
            END IF;
        END IF;
    END PROCESS;

    -- Combinational logic for enread and enwrite
    enread  <= '1' WHEN cycle_count MOD 2 = 0 ELSE '0';   -- Example: read on even cycles
    enwrite <= '1' WHEN cycle_count MOD 2 = 1 ELSE '0';   -- Example: write on odd cycles

    -- Reset counter after 200 cycles
    enable <= '1' WHEN cycle_count < 250 ELSE '0';

END behavior;