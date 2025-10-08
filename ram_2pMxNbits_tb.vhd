library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE work.my_package.all;

entity ram_2pmxnbits_tb is
end ram_2pmxnbits_tb;

architecture tb_arch of ram_2pmxnbits_tb is

    constant M      : integer := 8;  -- profondeur mémoire
    constant N      : integer := 4;  -- largeur d?un mot
    constant DEPTH  : integer := 3;
    constant clk_period : time := 10 ns;

    signal clk    : std_logic := '0';
    signal CS_n   : std_logic := '1';
    signal RW_n   : std_logic := '1';
    signal OE     : std_logic := '0';
    signal addr   : std_logic_vector(M-1 downto 0) := (others => '0');
    signal Din    : std_logic_vector(N-1 downto 0) := (others => '0');
    signal Dout   : std_logic_vector(N-1 downto 0);

begin

    -- Instanciation du module RAM
    DUT : ram_2pmxnbits
        generic map (
            M => M,
            N => N
        )
        port map (
            CS_n  => CS_n,
            RW_n  => RW_n,
            OE    => OE,
            addr  => addr,
            Din   => Din,
            Dout  => Dout
        );

    -- Génération de l?horloge (inutile ici mais conservée si besoin futur)
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus : écriture puis lecture
    stimulus_process : process
    begin
        -- Initialisation
        CS_n <= '0';  -- activer la RAM
        RW_n <= '0';  -- mode écriture
        OE   <= '0';  -- désactiver la sortie

        -- Phase d?écriture
        for i in 0 to DEPTH-1 loop
            addr <= std_logic_vector(to_unsigned(i, M));
            Din  <= std_logic_vector(to_unsigned(i + 1, N));  -- données = i+1
            wait for clk_period;
        end loop;

        -- Phase de lecture
        RW_n <= '1';  -- mode lecture
        OE   <= '1';  -- activer la sortie

        for i in 0 to DEPTH-1 loop
            addr <= std_logic_vector(to_unsigned(i, M));
            wait for clk_period;
        end loop;

        -- Fin du test
        CS_n <= '1';  -- désactiver la RAM
        OE   <= '0';  -- désactiver la sortie

        wait;
    end process;

end architecture;