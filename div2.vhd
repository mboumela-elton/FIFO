LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY div2 IS
    GENERIC (
        delay_time : TIME := 2 ns
    );
    PORT (
        clk_in   : IN  STD_LOGIC;
        reset    : IN  STD_LOGIC;
        enable   : IN  STD_LOGIC;
        clk_out  : OUT STD_LOGIC
    );
END div2;

ARCHITECTURE behavior OF div2 IS
    SIGNAL clk_reg : STD_LOGIC := '0';
BEGIN

    PROCESS(clk_in, reset)
    BEGIN
        IF reset = '1' THEN
            clk_reg <= '0';
        ELSIF rising_edge(clk_in) THEN
            IF enable = '1' THEN
                clk_reg <= NOT clk_reg;
            END IF;
        END IF;
    END PROCESS;

    clk_out <= clk_reg AFTER delay_time;

END behavior;

