library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cptdcpt is
    generic (
        M : integer := 8  -- Largeur du compteur
    );
    port (
        CLK     : in  std_logic;
        RESET   : in  std_logic;         
        ENABLE  : in  std_logic;         -- Validation
        UD      : in  std_logic;         -- 1: incrémente, 0: décrémente
        Q    : out std_logic_vector(M-1 downto 0)
    );
end entity cptdcpt;

architecture archi of cptdcpt is
    signal cnt : unsigned(M-1 downto 0) := (others => '0');
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                cnt <= (others => '0');
            elsif ENABLE = '1' then
                if UD = '1' then
                    cnt <= cnt + 1;
                else
                    cnt <= cnt - 1;
                end if;
            end if;
        end if;
    end process;

    Q <= std_logic_vector(cnt);
end architecture archi;