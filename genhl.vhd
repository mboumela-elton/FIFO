library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.my_package.all;

entity genhl is
    generic (
        M : integer := 8  -- Largeur du compteur (doit être >= log2(200) = 8)
    );
    port(
        RESET    : in  std_logic;
        CLK      : in  std_logic;
        ENREAD   : out std_logic;
        ENWRITE  : out std_logic
    );
end entity genhl;

architecture Behavioral of genhl is
    signal cnt_val : std_logic_vector(M-1 downto 0);
    signal enable_cnt : std_logic := '1';
    signal enread_int : std_logic := '0';
begin

    -- Instanciation du compteur
    compteur_inst : cptdcpt
        generic map (
            M => M
        )
        port map (
            CLK    => CLK,
            RESET  => RESET,
            ENABLE => enable_cnt,
            UD     => '1',  -- Compteur incrémental
            Q      => cnt_val
        );
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                enread_int  <= '0';
            elsif unsigned(cnt_val) = 199 then
                enread_int  <= '1';
            else
                enread_int  <= '0';
            end if;
        end if;
    end process;

    ENREAD  <= enread_int;
    ENWRITE <= not enread_int;

    -- Remise à zéro du compteur tous les 200 cycles
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                -- rien à faire ici, RESET gère déjà le compteur
                null;
            elsif unsigned(cnt_val) = 199 then
                -- Forcer un reset du compteur à la prochaine horloge
                enable_cnt <= '0';
            else
                enable_cnt <= '1';
            end if;
        end if;
    end process;

end architecture Behavioral;