-------------------------------------------------------------------------
-- my_package.vhd

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

PACKAGE my_package IS

    COMPONENT div2
        GENERIC (
            delay_time : TIME
        );
        PORT (
            clk_in   : IN  STD_LOGIC;
            reset    : IN  STD_LOGIC;
            enable   : IN  STD_LOGIC;
            clk_out  : OUT STD_LOGIC
        );
    END COMPONENT;
    
    COMPONENT ram_2pmxnbits
        GENERIC (
            M : INTEGER;
            N : INTEGER
        );
        PORT (
            clk   : IN  STD_LOGIC;
            CS_n  : IN  STD_LOGIC;
            RW_n  : IN  STD_LOGIC;
            OE    : IN  STD_LOGIC;
            addr  : IN  STD_LOGIC_VECTOR(M-1 DOWNTO 0);
            Din   : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
            Dout  : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
        );
    END COMPONENT;
    
    
    COMPONENT genhl
    PORT (
        reset    : IN  STD_LOGIC;
        clk      : IN  STD_LOGIC;
        enread   : OUT STD_LOGIC;
        enwrite  : OUT STD_LOGIC
    );
    END COMPONENT;


    COMPONENT cptdcpt
        GENERIC (
            M : integer := 4
        );
        PORT (
            RESET    : in  std_logic;
            CLK      : in  std_logic;
            ENABLE   : in  std_logic;
            UD       : in  std_logic;
            Q        : out std_logic_vector(M-1 downto 0)
        );
    END COMPONENT cptdcpt;

    COMPONENT genaddr
    GENERIC (
        M : integer := 4  -- largeur de l'adresse
    );
    PORT (
        RESET       : in  std_logic;
        CLK         : in  std_logic;
        incRead     : in  std_logic;
        incWrite    : in  std_logic;
        selectRead  : in  std_logic;
        Addrgen     : out std_logic_vector(M-1 downto 0)
    );
    END COMPONENT genaddr;
    
    COMPONENT fastslow
    GENERIC (
            M  : INTEGER
        );  
    PORT ( 
      slow  : out STD_LOGIC ; 
      incwrite  : in STD_LOGIC ; 
      fast  : out STD_LOGIC ; 
      clk  : in STD_LOGIC ; 
      incread  : in STD_LOGIC ; 
      reset  : in STD_LOGIC ); 
    END COMPONENT ;

    COMPONENT complement_a_2
    GENERIC (
        N : INTEGER := 8
    );
    PORT ( 
        nombre      : in STD_LOGIC_VECTOR (N-1 downto 0);
        sortie      : out STD_LOGIC_VECTOR (N-1 downto 0)
    );
    END COMPONENT complement_a_2;

    COMPONENT registreN
    GENERIC (
        N : integer := 8;
        T_SETUP : time := 5 ns;
        T_HOLD  : time := 2 ns
    );
    PORT (
        CLK   : in  std_logic;
        RESET : in  std_logic;
        D     : in  std_logic_vector(N-1 downto 0);
        Q     : out std_logic_vector(N-1 downto 0)
    );
    END COMPONENT registreN;

    
    COMPONENT sequenceur 
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
    END COMPONENT sequenceur;

END my_package;
-------------------------------------------------------------------------
library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

package mes_fonctions is
	function cpl2 (entree : std_logic_vector ; N : natural)
	return std_logic_vector ;
end mes_fonctions ;
-------------------------------------------------------------------------
package body mes_fonctions is
	function cpl2 (entree : std_logic_vector ; N : natural)
	return std_logic_vector  is
		variable temp : std_logic_vector( N-1 downto 0) ;
		begin
			temp := not entree;
			temp := temp + '1' ;
			return temp ;
	end cpl2 ;
end mes_fonctions ;
--------------------------------------------------------------------------
library ieee ;
use ieee.std_logic_1164.all ;

package CHECK_PKG is

-- Déclaration de la procédure check_setup. (pre positionnement)
procedure check_setup(
	signal clk 		: in std_logic;
	signal din 		: in std_logic_vector;
	t_setup 	: in time;
	severite	: in severity_level:= warning;
	hdeb 		: in time := time'low;
	hfin		: in time := time'high 
	);
-- Déclaration de la procédure T_hold. (maintien)
procedure check_hold(
		signal clk 		: in std_logic;
		signal din 		: in std_logic_vector;
		t_hold 	: in time;
		severite	: in severity_level:= warning;
		hdeb 		: in time := time'low;
		hfin		: in time := time'high );

end CHECK_PKG;
--------------------------------------------------------------------------
library ieee ;
use ieee.std_logic_1164.all ;

package body CHECK_PKG is		
-- Spécification du corps du paquetage.
--la procédure check_setup
procedure check_setup(
	signal clk 		: in std_logic;
		signal din 	: in std_logic_vector;
		t_setup 	: in time;
		severite	: in severity_level:= warning;
		hdeb 		: in time := time'low;
		hfin 		: in time := time'high) is
begin
	loop
		wait on clk;
		If clk = '1' and clk'event then
--wait until clk = 'l' and clk'event;
	if now >= hdeb and now <= hfin then
		assert din'last_event >= t_setup and din'event = false
			report "temps de setup non respecté" severity severite;
			elsif now > hfin then
				wait;
			end if;
	end if;
	end loop;	
end check_setup;

procedure check_hold(
		signal clk 		: in std_logic;
		signal din 		: in std_logic_vector;
			t_hold 	: in time;
			severite	: in severity_level:= warning;
			hdeb 		: in time := time'low;
			hfin		: in time := time'high ) is
				variable t : time;
begin
	loop
		wait until clk = '1';
		t := now;
		if t >= hdeb and t <= hfin then 
			if din'event = false then
				wait on din for t_hold;
			end if;
			assert (now - t) >= t_hold or din'event = false
				report "temps de hold non respecté" severity severite;
				elsif t > hfin then
					wait;
				end if;
	end loop;
	end check_hold;

End CHECK_PKG;
--------------------------------------------------------------------------