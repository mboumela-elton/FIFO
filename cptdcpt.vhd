library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cptdcpt is
    generic (
        M : integer := 8  -- Largeur du compteur
    );
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;         -- Reset synchrone
        enable  : in  std_logic;         -- Validation
        ud      : in  std_logic;         -- 1: incrémente, 0: décrémente
        cptr       : out std_logic_vector(M-1 downto 0)
    );
end entity cptdcpt;

architecture archi of cptdcpt is
    signal cnt : unsigned(M-1 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                cnt <= (others => '0');
            elsif enable = '1' then
                if ud = '1' then
                    cnt <= cnt + 1;
                else
                    cnt <= cnt - 1;
                end if;
            end if;
        end if;
    end process;

    cptr <= std_logic_vector(cnt);
end architecture archi;