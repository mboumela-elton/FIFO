library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_2pmxnbits is
    generic (
        M : integer := 8;  -- profondeur mémoire (nombre de mots)
        N : integer := 4   -- largeur d?un mot (en bits)
    );
    port (
        --clk    : in  std_logic;                         -- Horloge
        CS_n   : in  std_logic;                         -- Chip Select (actif bas)
        RW_n   : in  std_logic;                         -- Read/Write (0 = write, 1 = read)
        OE     : in  std_logic;                         -- Output Enable (active la sortie en lecture)
        addr   : in  std_logic_vector(M-1 downto 0);    -- Adresse mémoire
        Din    : in  std_logic_vector(N-1 downto 0);    -- Données à écrire
        Dout   : out std_logic_vector(N-1 downto 0)     -- Données lues ou haute impédance
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
                  if oe='1' then
                    dout <= mem(to_integer(unsigned(addr)));
                  end if;
            end if;
        else       
            Dout <= (others => 'Z');
        end if;
    
end process;

end architecture;
