library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_package.all;

entity FIFO is
    generic (
        M : integer := 16; -- profondeur mémoire (nombre de mots)
        N : integer := 8   -- largeur des données
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
    signal addr            : std_logic_vector(M-1 downto 0);
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

    -- Complément à deux (optionnel selon usage)
    U2: complement_a_2
        generic map (N => N)
        port map (
            nombre => reg_out,
            sortie => cpl2_out
        );
    
    -- Générateur des signaux ENREAD et ENWRITE
    U3: genhl
        port map (
            clk      => clk,
            reset    => reset,
            enread   => enread,
            enwrite  => enwrite
        );
        
    -- Séquenceur
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
        
    -- Générateur de rythme lecture/écriture
    U5: fastslow
        generic map (M => M)
        port map (
            clk       => clk,
            reset     => reset,
            incread   => INCREAD,
            incwrite  => INCWRITE,
            fast      => fast,
            slow      => slow
        );


    -- Générateur d'adresse
    U6: genaddr
        generic map (M => M)
        port map (
            CLK         => clk,
            RESET       => reset,
            incRead     => INCREAD,
            incWrite    => INCWRITE,
            selectRead  => SELREAD,
            Addrgen     => addr
        );

    -- Mémoire RAM FIFO
    U7: ram_2pmxnbits
        generic map (M => M, N => N)
        port map (
            CS_n  => CS_n,
            RW_n  => RW_n,
            OE    => OE,
            addr  => addr,
            Din   => cpl2_out,
            Dout  => data_out
        );

end architecture;