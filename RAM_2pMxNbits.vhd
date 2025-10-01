library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_2pmxnbits is
    generic (
        M : integer := 8;  -- profondeur mémoire (nombre de mots)
        N : integer := 4   -- largeur d?un mot (en bits)
    );
    port (
        clk    : in  std_logic;                         -- Horloge
        CS_n   : in  std_logic;                         -- Chip Select (actif bas)
        RW_n   : in  std_logic;                         -- Read/Write (0 = write, 1 = read)
        OE     : in  std_logic;                         -- Output Enable (active la sortie en lecture)
        addr   : in  std_logic_vector(M-1 downto 0); -- requis mais ignoré
        Din    : in  std_logic_vector(N-1 downto 0);    -- Données à écrire
        Dout   : out std_logic_vector(N-1 downto 0)     -- Données lues ou haute impédance
    );
end entity;

architecture rtl of ram_2pmxnbits is

    type ram_type is array (0 to M-1) of std_logic_vector(N-1 downto 0);
    signal mem       : ram_type := (others => (others => '0'));
    signal dout_reg  : std_logic_vector(N-1 downto 0);
    signal write_ptr : integer range 0 to M-1 := 0;
    signal read_ptr  : integer range 0 to M-1 := 0;

begin
  
    process(clk)
    begin
        if rising_edge(clk) then
            if CS_n = '0' then
                if RW_n = '0' then
                    -- Écriture FIFO
                    mem(write_ptr) <= Din;
                    write_ptr <= (write_ptr + 1) mod M;
                elsif RW_n = '1' then
                    -- Lecture FIFO
                    dout_reg <= mem(read_ptr);
                    read_ptr <= (read_ptr + 1) mod M;
                end if;
            end if;
        end if;
    end process;

    -- Sortie conditionnelle
    Dout <= dout_reg when (CS_n = '0' and RW_n = '1' and OE = '1')
           else (others => 'Z');

end architecture;