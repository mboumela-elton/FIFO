LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

PACKAGE my_package IS

    COMPONENT div2
        GENERIC (
            delay_time : TIME
        );
        PORT (
            clk_in   : IN  STD_LOGIC;
            reset    : IN  STD_LOGIC;
            clk_out  : OUT STD_LOGIC
        );
    END COMPONENT;
    
    COMPONENT ram
        GENERIC (
            M : INTEGER;
            N : INTEGER
        );
        PORT (
            clk   : IN  STD_LOGIC;
            CS_n  : IN  STD_LOGIC;
            RW_n  : IN  STD_LOGIC;
            OE    : IN  STD_LOGIC;
            addr  : IN  INTEGER;
            Din   : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
            Dout  : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
        );
    END COMPONENT;
    
    COMPONENT cptdcpt
        GENERIC (
            M : INTEGER
        );
        PORT (
            clk     : IN  STD_LOGIC;
            reset   : IN  STD_LOGIC;
            enable  : IN  STD_LOGIC;
            ud      : IN  STD_LOGIC;
            cptr    : OUT STD_LOGIC_VECTOR(M-1 DOWNTO 0)
        );
    END COMPONENT;
    
    COMPONENT genhl
    PORT (
        reset    : IN  STD_LOGIC;
        clk      : IN  STD_LOGIC;
        enread   : OUT STD_LOGIC;
        enwrite  : OUT STD_LOGIC
    );
    END COMPONENT;


END my_package;