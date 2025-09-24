LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

PACKAGE my_package IS

    COMPONENT div2
        GENERIC (
            delay_time : TIME := 2 ns
        );
        PORT (
            clk_in   : IN  STD_LOGIC;
            reset    : IN  STD_LOGIC;
            clk_out  : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT cptdcpt is
        GENERIC (
            M : integer := 8
        );
        PORT (
            RESET    : in  std_logic;
            CLK      : in  std_logic;
            ENABLE   : in  std_logic;
            UD       : in  std_logic;
            Q        : out std_logic_vector(M-1 downto 0)
        );
    END COMPONENT cptdcpt;

    COMPONENT genaddr is
    GENERIC (
        M : integer := 4  -- largeur de l'adresse
    );
    PORT (
        RESET      : in  std_logic;
        CLK        : in  std_logic;
        incRead    : in  std_logic;
        incWrite   : in  std_logic;
        selectRead : in  std_logic;
        Addrgen     : out std_logic_vector(M-1 downto 0)
    );
    END COMPONENT genaddr;


END my_package;
