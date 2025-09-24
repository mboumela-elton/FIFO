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

END my_package;
