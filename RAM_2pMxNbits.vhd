LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ram IS
    GENERIC (
        M : INTEGER := 8;  -- Nombre de mots (profondeur mémoire)
        N : INTEGER := 4      -- Taille d?un mot (largeur en bits)
    );
    PORT (
        clk    : IN  STD_LOGIC;                         -- Horloge
        CS_n   : IN  STD_LOGIC;                         -- Chip Select (actif bas)
        RW_n   : IN  STD_LOGIC;                         -- Read/Write (0 = write, 1 = read)
        OE     : IN  STD_LOGIC;                         -- Output Enable (active la sortie en lecture)
        addr   : IN  INTEGER RANGE 0 TO M-1;            -- Adresse du mot é lire ou écrire
        Din    : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);    -- Données é écrire
        Dout   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)     -- Données lues ou haute impédance
    );
END ram;

ARCHITECTURE rtl OF ram IS

    -- Définition du type mémoire : tableau de M mots de N bits
    TYPE ram_type IS ARRAY (0 TO M-1) OF STD_LOGIC_VECTOR(N-1 DOWNTO 0);

    -- Signal interne représentant la mémoire
    SIGNAL mem : ram_type := (OTHERS => (OTHERS => '0'));

    -- Registre temporaire pour stocker la donnée lue
    SIGNAL dout_reg : STD_LOGIC_VECTOR(N-1 DOWNTO 0);

BEGIN

    -- Processus principal : lecture ou écriture synchronisée sur l?horloge
    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF CS_n = '0' THEN  -- Mémoire activée
                IF RW_n = '0' THEN
                    -- Mode écriture : stocker Din é l?adresse addr
                    mem(addr) <= Din;
                ELSIF RW_n = '1' THEN
                    -- Mode lecture : lire la donnée de addr dans dout_reg
                    dout_reg <= mem(addr);
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- Sortie conditionnelle : active uniquement si lecture + OE = '1'
    Dout <= dout_reg WHEN (CS_n = '0' AND RW_n = '1' AND OE = '1')
           ELSE (OTHERS => 'Z');  -- Sinon, sortie en haute impédance

END rtl;