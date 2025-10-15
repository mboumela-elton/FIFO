library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_package.all;

entity FIFO is
    generic (
        M : integer := 16; -- profondeur m�moire (nombre de mots)
        N : integer := 8   -- largeur des donn�es
    );
    port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        req        : in  std_logic;
        data_in    : in  std_logic_vector(N-1 downto 0);
        data_out   : out std_logic_vector(N-1 downto 0);
        ack        : out std_logic;
        fast       : out std_logic;
        slow       : out std_logic;
        hl         : out std_logic
    );
end entity;

architecture RTL of FIFO is

    -- Signaux internes
    signal enread, enwrite, SELREAD : std_logic;
    signal RW_n, OE, CS_n : std_logic;
    signal INCWRITE, INCREAD : std_logic;
    function clog2(n : natural) return natural is
        variable v : natural := n - 1;
        variable r : natural := 0;
    begin
        while v > 0 loop
            v := v / 2;
            r := r + 1;
        end loop;
        return r;
    end function;

    constant ADDR_W : integer := clog2(M);
    signal addr            : std_logic_vector(ADDR_W-1 downto 0);
    signal reg_out         : std_logic_vector(N-1 downto 0);
    signal cpl2_out        : std_logic_vector(N-1 downto 0);

begin
  
    -- Registre de sortie
    U1: registreN
        generic map (N => N)
        port map (
            CLK   => clk,
            RESET => reset,
            D     => data_in,
            Q     => reg_out
        );

    -- Compl�ment � deux (optionnel selon usage)
    U2: complement_a_2
        generic map (N => N)
        port map (
            nombre => reg_out,
            sortie => cpl2_out
        );
    
    -- G�n�rateur des signaux ENREAD et ENWRITE
    U3: genhl
        port map (
            clk      => clk,
            reset    => reset,
            enread   => enread,
            enwrite  => enwrite
        );
        
    -- S�quenceur
    U4: sequenceur
        port map (
            CLK      => clk,
            RESET    => reset,
            ENREAD   => enread,
            ENWRITE  => enwrite,
            REQ      => req,
            ACK      => ack,
            RW_n     => RW_n,
            OE       => OE,
            INCWRITE => INCWRITE,
            INCREAD  => INCREAD,
            HL       => hl,
            SELREAD  => SELREAD,
            CS_n     => CS_n
        );
        
    -- G�n�rateur de rythme lecture/�criture
    U5: fastslow
        generic map (M => ADDR_W)
        port map (
            incread   => INCREAD,
            incwrite  => INCWRITE,
            clk       => clk,
            reset     => reset,
            fast      => fast,
            slow      => slow
        );


    -- G�n�rateur d'adresse
    U6: genaddr
        generic map (M => ADDR_W)
        port map (
            CLK         => clk,
            RESET       => reset,
            incRead     => INCREAD,
            incWrite    => INCWRITE,
            selectRead  => SELREAD,
            Addrgen     => addr
        );

    -- M�moire RAM FIFO
    U7: ram_2pmxnbits
        generic map (M => M, N => N, AW => ADDR_W)
        port map (
            CS_n  => CS_n,
            RW_n  => RW_n,
            OE    => OE,
            addr  => addr,
            Din   => cpl2_out,
            Dout  => data_out
        );

end architecture;