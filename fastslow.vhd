LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.my_package.ALL;

ENTITY fastslow IS
    GENERIC (
            M  : INTEGER
        );
    PORT (
        incread   : IN  STD_LOGIC;
        incwrite  : IN  STD_LOGIC;
        clk       : IN  STD_LOGIC;
        reset     : IN  STD_LOGIC;
        fast      : OUT STD_LOGIC;
        slow      : OUT STD_LOGIC
    );
END fastslow;

ARCHITECTURE behavior OF fastslow IS

    SIGNAL enable : STD_LOGIC := '0';
    SIGNAL ud     : STD_LOGIC := '0';
    SIGNAL cptr   : STD_LOGIC_VECTOR(7 DOWNTO 0);  -- M = 8

BEGIN

    -- Instantiation of the counter-decounter component
    CreateCpt : cptdcpt
        GENERIC MAP (
            M => M
        )
        PORT MAP (
            clk    => clk,
            reset  => reset,
            enable => enable,
            ud     => ud,
            Q   => cptr
        );

    -- Logic to control counter direction and enable
    enable <= incwrite OR incread;
    ud     <= incwrite;  -- '1' for increment, '0' for decrement

    -- FAST signal: active if number of words < 2^M - 2 ? bit M-2 = '0'
    fast <= NOT cptr(M-2);  -- M = 8 ? M-2 = 6

    -- SLOW signal: active if number of words ? 2^M - 2^(M-2) ? bit M-2 = '1'
    slow <= cptr(M-2);

END behavior;