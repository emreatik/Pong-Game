library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_SYNC is
    Port ( CLK_PIXEL : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           start : in  STD_LOGIC;
           y_control : out  STD_LOGIC_VECTOR (9 downto 0);
           x_control : out  STD_LOGIC_VECTOR (9 downto 0);
           h_s : out  STD_LOGIC;
           v_s : out  STD_LOGIC;
           video_on : out  STD_LOGIC);
end VGA_SYNC;

architecture Behavioral of VGA_SYNC is

constant  HR     : integer := 640; --Horizontal Resolution (visible area)
constant  HFP    : integer := 16;  --Horizontal Front Porch
constant  HBP    : integer:=48;    --Horizontal  Back Porch
constant  HRet   : integer:=96;    --Horizontal  retrace
constant  VR     : integer:=480;   --Vertical  Resolution (visible area)
constant  VFP    : integer:=10;    --Vertical  Front Porch 
constant  VBP    : integer:=33;    --Vertical  Back Porch
constant  VRet   : integer:=2;     --Vertical  Retrace
constant  Htotal : integer:=800;   --Horizontal Total Count = ( HR + HFP + Hret + HBP )
constant  Vtotal : integer:=525;   --Vertical Total Count = ( VR + VFP + Vret + VBP )

    --sync counter signals
    signal  horizontal_count : std_logic_vector ( 9 downto 0 ) := (others => '0');
    signal  vertical_count   : std_logic_vector ( 9 downto 0 ) := (others => '0');
                                        
begin

process (CLK_PIXEL)
	begin

	if (rising_edge(CLK_PIXEL)) then

		if (reset = '1' ) then
		
			horizontal_count <= (others => '0' ) ;
			vertical_count   <= (others => '0' ) ;

		elsif (start = '1' ) then
			
			-- Horizontal Counter
			if ( horizontal_count = (Htotal - 1) ) then
				horizontal_count <= (others => '0' ) ;
			else
				horizontal_count <= horizontal_count + 1 ;
			end if;
 
			-- Vertical Counter
			if ( vertical_count = (Vtotal - 1) and horizontal_count = (Htotal - 1) ) then
				vertical_count <= (others => '0' ) ;
			elsif ( vertical_count < (Vtotal - 1) and horizontal_count = (Htotal - 1) ) then
				vertical_count <= vertical_count + 1 ;
			end if;
			
			-- X axis coordinates
			if ( horizontal_count < HR ) then -- HR is active display area
				x_control <= horizontal_count ;
			end if ;

			-- Y axis coordinates
			if ( vertical_count < VR ) then -- VR is active display area
				y_control <= vertical_count ;
			end if ;	
			
			-- Horizontal SYNC 
			if (  horizontal_count > (HR + HFP) and horizontal_count < (HR + HFP + Hret) ) then
				h_s <= '0' ;
			else
				h_s <= '1' ;
			end if ;

			-- Vertical SYNC 
			if ( vertical_count > (VR + VFP) and vertical_count < (VR + VFP + Vret) ) then
				v_s <= '0' ;
			else
				v_s <= '1' ;
			end if ;
			
			-- Video On
			if ( vertical_count < VR and horizontal_count < HR ) then 
				video_on <= '1' ;
			else
				video_on <= '0' ;
			end if;	
		end if;
	end if;
	end process;

end Behavioral;

