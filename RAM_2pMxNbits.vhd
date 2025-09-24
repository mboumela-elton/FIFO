LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ram IS
    GENERIC (
        M : INTEGER := 8;  -- Number of memory words (depth)
        N : INTEGER := 4   -- Size of each word in bits (width)
    );
    PORT (
        clk    : IN  STD_LOGIC;                         -- Clock signal
        CS_n   : IN  STD_LOGIC;                         -- Chip Select (active low)
        RW_n   : IN  STD_LOGIC;                         -- Read/Write control (0 = write, 1 = read)
        OE     : IN  STD_LOGIC;                         -- Output Enable (controls output during read)
        addr   : IN  INTEGER RANGE 0 TO M-1;            -- Address of the word to read or write
        Din    : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);    -- Data input for write operations
        Dout   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)     -- Data output or high impedance
    );
END ram;

ARCHITECTURE rtl OF ram IS

    -- Memory type: array of M words, each N bits wide
    TYPE ram_type IS ARRAY (0 TO M-1) OF STD_LOGIC_VECTOR(N-1 DOWNTO 0);

    -- Internal signal representing the memory contents
    SIGNAL mem : ram_type := (OTHERS => (OTHERS => '0'));

    -- Temporary register to hold the read data
    SIGNAL dout_reg : STD_LOGIC_VECTOR(N-1 DOWNTO 0);

BEGIN

    -- Main process: handles read and write operations on clock rising edge
    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF CS_n = '0' THEN  -- Memory is enabled
                IF RW_n = '0' THEN
                    -- Write mode: store Din at the specified address
                    mem(addr) <= Din;
                ELSIF RW_n = '1' THEN
                    -- Read mode: load data from memory into dout_reg
                    dout_reg <= mem(addr);
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- Conditional output: active only during read with OE = '1'
    Dout <= dout_reg WHEN (CS_n = '0' AND RW_n = '1' AND OE = '1')
           ELSE (OTHERS => 'Z');  -- Otherwise, output is high impedance

END rtl;