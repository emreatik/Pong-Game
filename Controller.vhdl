library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller is
    Port ( 
           CLK_FPGA : in STD_LOGIC;
           data_in1 : in STD_LOGIC_VECTOR (7 downto 0);
           data_in2 : in STD_LOGIC_VECTOR (7 downto 0);
           READY_1 : in STD_LOGIC;
           READY_2 : in STD_LOGIC;
           GAME_OVER_OUT : out STD_LOGIC;
           GAME_OVER_IN : in STD_LOGIC;
           VGA1 : out STD_LOGIC_VECTOR (7 downto 0);
           VGA2 : out STD_LOGIC_VECTOR (7 downto 0);
           START : out STD_LOGIC;
           RESET : out STD_LOGIC;
			  
		start_in 		: in std_logic;
		exit_in			: in std_logic);
end controller;

architecture Behavioral of controller is
    signal sig_8_DATA1 : std_logic_vector(7 downto 0);
    signal sig_8_DATA2 : std_logic_vector(7 downto 0);
    signal sig_FIN_OUT : std_logic;
    signal sig_reset : std_logic;
    signal sig_start : std_logic;
begin
    process(CLK_FPGA) 
 
 begin
  
    if (rising_edge (CLK_FPGA)) then 
        if ( READY_1 = '1' ) then
            sig_8_DATA1 <= data_in1 ;
        end if;
        if ( READY_2 = '1' ) then
            sig_8_DATA2 <= data_in2 ;
        end if;
        if ( GAME_OVER_IN = '1' ) then 
            sig_FIN_OUT <= '1' ;
            else
            sig_FIN_OUT <= '0' ;
        end if;
--        if ( data_in1 = "00001111" or data_in2 = "00001111" ) then 
--            sig_reset <= '1' ;
--				sig_start <= '0';
--        end if ; 
--        if ( data_in1 = "11110000" or data_in2 = "11110000" ) then 
--            sig_start <= '1' ;
--				sig_reset <= '0' ;
--        end if ;  

			if exit_in='1' then
				 sig_reset <= '1' ;
				 sig_start <= '0';
		   end if;
			if start_in='1' then
				 sig_reset <= '0' ;
				 sig_start <= '1';
		   end if;
    end if;        
   end process ;
   VGA1 <=  sig_8_DATA1 ;
   VGA2 <=  sig_8_DATA2 ;
   GAME_OVER_OUT <= sig_FIN_OUT ;
   RESET <= sig_reset ;
   START <= sig_start ;
end Behavioral;
