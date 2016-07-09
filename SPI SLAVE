library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
 use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Spi_Slave is
    Port ( CLK_FPGA : in STD_LOGIC;
           SCLK : in STD_LOGIC;
           CS : in STD_LOGIC;
           MOSI : in STD_LOGIC;
           MISO : out STD_LOGIC;
           READY : out STD_LOGIC;
           DATA_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           GAME_OVER : in STD_LOGIC );
end Spi_Slave;

architecture Behavioral of Spi_Slave is
    
      signal sig_MOSI : std_logic; 
      signal CS_latched, CS_old : std_logic;
      signal SCLK_latched, SCLK_old : std_logic; 
      signal sig_READY: std_logic; 
      signal sig_8_DATA : std_logic_vector(7 downto 0); 
      signal index: natural range 0 to 7; 
      signal sig_FIN: std_logic; 

begin
process(CLK_FPGA) 
 
 begin
  
    if (rising_edge (CLK_FPGA)) then 
        
        if ( CS = '1' ) then 
            
            index <= 7; 
            sig_8_DATA <= x"F0";--"00000000"; 
            SCLK_old <= '0'; 
            SCLK_latched <= '0'; 
            CS_old <= '0'; 
            CS_latched <= '0'; 
            sig_READY <= '0'; 
            sig_FIN <= '0';
 
         else
         
            SCLK_latched <= SCLK; 
            SCLK_old <= SCLK_latched; 
            CS_latched <= CS; 
            CS_old <= CS_latched; 
            sig_READY <= '0';
            sig_MOSI <= MOSI ; 
            
         if( CS_latched = '0' ) then 
                     if(SCLK_old = '0' and SCLK_latched = '1') then 
                        sig_8_DATA <= sig_8_DATA(6 downto 0) & sig_MOSI; 
                        if ( GAME_OVER = '1' ) then 
                            sig_FIN <= '1' ;
                        end if ;     
                        if(index = 0) then -- cycle ended 
                           index <= 7; 
                        else 
                           index <= index-1; 
                        end if; 
                     elsif(SCLK_old = '1' and SCLK_latched = '0') then 
                        if( index = 7 ) then 
                           sig_READY <= '1'; 
                        end if;  
                     end if; 
                  end if;
                  
        end if ;
    end if;         
end process ;
   
   READY <= sig_READY ;
   DATA_OUT <= sig_8_DATA ; 
   MISO <= sig_FIN;
end Behavioral;
