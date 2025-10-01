LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.my_package.ALL;

ENTITY sequenceur IS
    PORT (
        RESET    : IN  STD_LOGIC;
        CLK      : IN  STD_LOGIC;
        ENREAD   : IN STD_LOGIC;
        ENWRITE  : IN STD_LOGIC;
        REQ      : IN  STD_LOGIC;

        ACK      : OUT STD_LOGIC;
        RW_n     : OUT STD_LOGIC;
        OE       : OUT STD_LOGIC;
        INCWRITE : OUT STD_LOGIC;
        INCREAD  : OUT STD_LOGIC;
        HL       : OUT STD_LOGIC;
        SELREAD  : OUT STD_LOGIC;
        CS_n     : OUT STD_LOGIC
    );
END sequenceur;