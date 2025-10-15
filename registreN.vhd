-- registreN.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.CHECK_PKG.all;

entity registreN is
    generic (
        N : integer := 8;
        T_SETUP : time := 5 ns;
        T_HOLD  : time := 2 ns
    );
    port (
        CLK   : in  std_logic;
        RESET : in  std_logic;
        D     : in  std_logic_vector(N-1 downto 0);
        Q     : out std_logic_vector(N-1 downto 0)
    );
end entity registreN;

architecture archi_regN of registreN is
begin
    setup_check: process
    begin
        --check_setup(CLK, D, T_SETUP);
        wait;
    end process setup_check;

    hold_check: process
    begin
        --check_hold(CLK, D, T_HOLD);
        wait;
    end process hold_check;

    -- Fonctionnement du registre
    process(CLK, RESET)
    begin
        if RESET = '1' then
            Q <= (others => '0');
        elsif rising_edge(CLK) then
            Q <= D;
        end if;
    end process;

end architecture archi_regN;