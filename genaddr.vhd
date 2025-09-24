library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.my_package.ALL;

entity genaddr is
    generic (
        M : integer := 4  -- largeur de l'adresse
    );
    port (
        RESET      : in  std_logic;
        CLK        : in  std_logic;
        incRead    : in  std_logic;
        incWrite   : in  std_logic;
        selectRead : in  std_logic;
        Addrgen     : out std_logic_vector(M-1 downto 0)
    );
end entity genaddr;

architecture Behavioral of genaddr is

    signal addrRead  : std_logic_vector(M-1 downto 0);
    signal addrWrite : std_logic_vector(M-1 downto 0);


begin

    -- Instanciation du compteur pour la lecture
    cptRead : cptdcpt
        generic map (M => M)
        port map (
            RESET => RESET,
            CLK   => CLK,
            ENABLE => incRead,
            UD    => '1',
            Q     => addrRead
        );

    -- Instanciation du compteur pour l'écriture
    cptWrite : cptdcpt
        generic map (M => M)
        port map (
            RESET => RESET,
            CLK   => CLK,
            ENABLE => incWrite,
            UD    => '1',
            Q     => addrWrite
        );

    -- Mux 2->1 pour sélectionner l'adresse à générer
    Addrgen <= addrRead when selectRead = '1' else addrWrite;

end architecture Behavioral;