LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.my_package.ALL;

ENTITY sequenceur IS
    PORT (
        RESET    : IN  STD_LOGIC;
        CLK      : IN  STD_LOGIC;
        ENREAD   : IN STD_LOGIC;
        ENWRITE  : IN STD_LOGIC;
        REQ      : IN  STD_LOGIC;

        ACK      : OUT STD_LOGIC;
        RW_n     : OUT STD_LOGIC;
        OE       : OUT STD_LOGIC;
        INCWRITE : OUT STD_LOGIC;
        INCREAD  : OUT STD_LOGIC;
        HL       : OUT STD_LOGIC;
        SELREAD  : OUT STD_LOGIC;
        CS_n     : OUT STD_LOGIC
    );
END sequenceur;

ARCHITECTURE archi_Mealy OF sequenceur IS

TYPE state IS (Repos, Lecture1, Ecriture, Attente, Lecture2);
SIGNAL etat, etat_suivant : state;

BEGIN
PROCESS (CLK)
BEGIN
    IF (RESET = '1') THEN
        etat <= Repos;
    ELSIF (rising_edge(CLK)) THEN
        etat <= etat_suivant;
    END IF;
END PROCESS;

PROCESS (etat, ENREAD, ENWRITE, REQ)
BEGIN
    CASE etat IS
        WHEN Repos =>
            ACK      <= '1';
            RW_n     <= '0';
            OE       <= '0';
            INCWRITE <= '0';
            INCREAD  <= '0';
            HL       <= '0';
            SELREAD  <= '1';
            CS_n     <= '1';
            IF (REQ = '0' AND ENWRITE = '1') THEN
                etat_suivant <= Ecriture;
            ELSIF (ENREAD = '1') THEN
                etat_suivant <= Lecture1;
            ELSE
                etat_suivant <= Repos;
            END IF;

        WHEN Lecture1 =>
            ACK      <= '1';
            RW_n     <= '1';
            OE       <= '1';
            INCWRITE <= '0';
            INCREAD  <= '1';
            HL       <= '1';
            SELREAD  <= '1';
            CS_n     <= '0';
            
            etat_suivant <= Repos;

        WHEN Ecriture =>
            ACK      <= '0';
            RW_n     <= '0';
            OE       <= '0';
            INCWRITE <= '1';
            INCREAD  <= '0';
            HL       <= '0';
            SELREAD  <= '0';
            CS_n     <= '0';
            
            etat_suivant <= Attente;

        WHEN Attente =>
            ACK      <= '0';
            RW_n     <= '0';
            OE       <= '0';
            INCWRITE <= '0';
            INCREAD  <= '0';
            HL       <= '0';
            SELREAD  <= '1';
            CS_n     <= '0';
            IF (REQ = '1' AND ENWRITE = '0') THEN
                etat_suivant <= Repos;
            ELSIF (ENREAD = '1') THEN
                etat_suivant <= Lecture2;
            ELSIF (REQ = '0' AND ENWRITE = '0') THEN
                etat_suivant <= Attente;
            END IF;

        WHEN Lecture2 =>
            ACK      <= '0';
            RW_n     <= '1';
            OE       <= '1';
            INCWRITE <= '0';
            INCREAD  <= '1';
            HL       <= '1';
            SELREAD  <= '1';
            CS_n     <= '0';
            etat_suivant <= Attente;
    END CASE;
END PROCESS;

END archi_Mealy;

ARCHITECTURE archi_Moore OF sequenceur IS
    TYPE state IS (Repos, Lecture1, Ecriture, Attente, Lecture2);
    SIGNAL etat, etat_suivant : state;

BEGIN
PROCESS (CLK)
BEGIN
    IF (RESET = '1') THEN
        etat <= Repos;
    ELSIF (rising_edge(CLK)) THEN
        etat <= etat_suivant;
    END IF;
END PROCESS;

PROCESS (etat, ENREAD, ENWRITE, REQ)
BEGIN
etat_suivant <= etat;  -- valeur par défaut
    CASE etat IS
        WHEN Repos =>
            IF (REQ = '0' AND ENWRITE = '1') THEN
                etat_suivant <= Ecriture;
            ELSIF (ENREAD = '1') THEN
                etat_suivant <= Lecture1;
            ELSE
                etat_suivant <= Repos;
            END IF;

        WHEN Lecture1 =>
            etat_suivant <= Repos;

        WHEN Ecriture =>
            etat_suivant <= Attente;

        WHEN Attente =>
            IF (REQ = '1' AND ENWRITE = '0') THEN
                etat_suivant <= Repos;
            ELSIF (ENREAD = '1') THEN
                etat_suivant <= Lecture2;
            ELSIF (REQ = '0' AND ENWRITE = '0') THEN
                etat_suivant <= Attente;
            END IF;

        WHEN Lecture2 =>
            etat_suivant <= Attente;
    END CASE;
END PROCESS;

PROCESS (etat)
BEGIN
CASE etat IS
    WHEN Repos =>
        ACK      <= '1';
        RW_n     <= '0';
        OE       <= '0';
        INCWRITE <= '0';
        INCREAD  <= '0';
        HL       <= '0';
        SELREAD  <= '1';
        CS_n     <= '1';

    WHEN Lecture1 =>
        ACK      <= '1';
        RW_n     <= '1';
        OE       <= '1';
        INCWRITE <= '0';
        INCREAD  <= '1';
        HL       <= '1';
        SELREAD  <= '1';
        CS_n     <= '0';

    WHEN Ecriture =>
        ACK      <= '0';
        RW_n     <= '0';
        OE       <= '0';
        INCWRITE <= '1';
        INCREAD  <= '0';
        HL       <= '0';
        SELREAD  <= '0';
        CS_n     <= '0';

    WHEN Attente =>
        ACK      <= '0';
        RW_n     <= '0';
        OE       <= '0';
        INCWRITE <= '0';
        INCREAD  <= '0';
        HL       <= '0';
        SELREAD  <= '1';
        CS_n     <= '1';

    WHEN Lecture2 =>
        ACK      <= '0';
        RW_n     <= '1';
        OE       <= '1';
        INCWRITE <= '0';
        INCREAD  <= '1';
        HL       <= '1';
        SELREAD  <= '1';
        CS_n     <= '0';
END CASE;
END PROCESS;

END archi_Moore;