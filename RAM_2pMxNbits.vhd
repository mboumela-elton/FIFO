library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_2pmxnbits is
    generic (
        M : integer := 8;  -- profondeur m�moire (nombre de mots)
        N : integer := 4;  -- largeur d'un mot (en bits)
        AW : integer := 3  -- largeur d'adresse (bits)
    );
    port (
        CS_n   : in  std_logic;                         -- Chip Select (actif bas)
        RW_n   : in  std_logic;                         -- Read/Write (0 = write, 1 = read)
        OE     : in  std_logic;                         -- Output Enable (active la sortie en lecture)
        addr   : in  std_logic_vector(AW-1 downto 0);    -- Adresse m�moire
        Din    : in  std_logic_vector(N-1 downto 0);    -- Donn�es � �crire
        Dout   : out std_logic_vector(N-1 downto 0)     -- Donn�es lues ou haute imp�dance
    );
end entity;

architecture rtl of ram_2pmxnbits is

    type ram_type is array (0 to M-1) of std_logic_vector(N-1 downto 0);
    signal mem       : ram_type := (others => (others => '0'));

begin
process(CS_n, RW_n, OE, addr, Din)
    begin
                if CS_n = '0' then
                        if RW_n = '0' then
                                mem(to_integer(unsigned(addr))) <= Din;
                                Dout <= (others => 'Z');
                        elsif RW_n = '1' then
                                    if OE='1' then
                                        Dout <= mem(to_integer(unsigned(addr)));
                                    else
                                        Dout <= (others => 'Z');
                                    end if;
                        end if;
                else       
                        Dout <= (others => 'Z');
                end if;
    
end process;

end architecture;
