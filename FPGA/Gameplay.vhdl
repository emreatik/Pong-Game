----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2016 02:22:27 PM
-- Design Name: 
-- Module Name: gameplay - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


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

entity gameplay is
    Port ( CLK_FPGA : in STD_LOGIC;
           X_CONTROL : in STD_LOGIC_VECTOR (9 downto 0);
           Y_CONTROL : in STD_LOGIC_VECTOR (9 downto 0);
           VIDEO_ON : in STD_LOGIC;
           VGA_IN_1 : in STD_LOGIC_VECTOR (7 downto 0);
           VGA_IN_2 : in STD_LOGIC_VECTOR (7 downto 0);
           RGB  :  out  STD_LOGIC_VECTOR(2 downto 0) ; 
           GAME_OVER : out STD_LOGIC;
			  restart : in  std_logic;
			  vga_test_1 : in std_logic;
			  vga_test_2 : in std_logic;
			  faster		 : in std_logic;
			  invisible  : in std_logic;
			  pause      : in std_logic);
end gameplay;

architecture Behavioral of gameplay is

--WALL1
constant wall_top_1 : integer range 0 to 0 := 0;
constant wall_thickness_1 : integer range 0 to 10 := 10;
signal wall_on_1 : std_logic;
signal wall_rgb_1 : std_logic_vector (2 downto 0);

--WALL2                                                      
constant wall_top_2 : integer range 0 to 470 := 470;               
constant wall_thickness_2 : integer range 0 to 10 := 10;       
signal wall_on_2 : std_logic; 
signal wall_rgb_2 : std_logic_vector (2 downto 0); 
 
 --BAR1
 signal bar_top_1 : integer range 0 to 511 := 182;  -- max range is 480
 constant bar_left_1 : integer range 0 to 1023 := 10; --max range is 640
 constant bar_thickness_1 : integer range 0 to 10 := 10;
 constant bar_height_1 : integer range 0 to 200 := 76;
 constant bar_speed_1 : integer range 0 to 2 := 2;
 signal bar_on_1 : std_logic;
 signal bar_rgb_1 : std_logic_vector (2 downto 0);

--BAR2
 signal bar_top_2 : integer range 0 to 511 := 182;  -- max range is 480
 constant bar_left_2 : integer range 0 to 1023 := 630;  -- max range is 640
 constant bar_thickness_2 : integer range 0 to 50 := 50;
 constant bar_height_2 : integer range 0 to 200 := 76;
 constant bar_speed_2 : integer range 0 to 2 := 2;
 signal bar_on_2 : std_logic;
 signal bar_rgb_2 : std_logic_vector (2 downto 0); 
 
  --PAUSE
 signal pause_top : integer range 0 to 511 :=225;  -- max range is 480
 constant pause_left : integer range 0 to 1023 := 305; --max range is 640
 constant pause_width : integer range 0 to 10 := 10;
 constant pause_height : integer range 0 to 200 := 30;
 signal pause_on : std_logic;
 signal pause_rgb : std_logic_vector (2 downto 0);
 
   --END
 signal end_top : integer range 0 to 511 :=225;  -- max range is 480
 constant end_left : integer range 0 to 1023 := 265; --max range is 640
 constant end_width : integer range 0 to 10 := 10;
 constant end_height : integer range 0 to 200 := 30;
 signal end_on : std_logic;
 signal end_rgb : std_logic_vector (2 downto 0);
 
 --BALL
 signal ball_left : integer range 0 to 1023 := 315;  -- max range is 640
 signal ball_top : integer range 0 to 511 := 235;    -- max range is 480
 constant ball_width, ball_height : integer range 0 to 10 := 10;
 signal x_speed, y_speed : integer range 0 to 4 := 2;
 signal ball_on : std_logic;
 signal ball_rgb : std_logic_vector (2 downto 0);  
 
--SCORE_L_0
constant score_L_0_left : integer range 0 to 292 := 292;            
constant score_L_0_top : integer range 0 to 20 := 20;               
constant score_L_0_height : integer range 0 to 2 := 2;
constant score_L_0_width : integer range 0 to 16 := 16;        
signal score_L_0_on : std_logic; 
signal score_L_0_rgb : std_logic_vector (2 downto 0) := "000";
 
  --SCORE_L_1
constant score_L_1_left : integer range 0 to 290 := 290;            
constant score_L_1_top : integer range 0 to 20 := 20;               
constant score_L_1_height : integer range 0 to 20 := 20;
constant score_L_1_width : integer range 0 to 2 := 2;      
signal score_L_1_on : std_logic; 
signal score_L_1_rgb : std_logic_vector (2 downto 0) := "000";
 
  --SCORE_L_2
constant score_L_2_left : integer range 0 to 292 := 292;            
constant score_L_2_top : integer range 0 to 40 := 40;               
constant score_L_2_height : integer range 0 to 2 := 2;
constant score_L_2_width : integer range 0 to 16 := 16;        
signal score_L_2_on : std_logic; 
signal score_L_2_rgb : std_logic_vector (2 downto 0) := "000";
 
  --SCORE_L_3
constant score_L_3_left : integer range 0 to 308 := 308;            
constant score_L_3_top : integer range 0 to 20 := 20;               
constant score_L_3_height : integer range 0 to 20 := 20;
constant score_L_3_width : integer range 0 to 2 :=2;       
signal score_L_3_on : std_logic; 
signal score_L_3_rgb : std_logic_vector (2 downto 0) := "000";

  --SCORE_L_4
constant score_L_4_left : integer range 0 to 290 := 290;            
constant score_L_4_top : integer range 0 to 40 := 40;               
constant score_L_4_height : integer range 0 to 20 := 20;
constant score_L_4_width : integer range 0 to 2 := 2;       
signal score_L_4_on : std_logic; 
signal score_L_4_rgb : std_logic_vector (2 downto 0) := "000";

  --SCORE_L_5
constant score_L_5_left : integer range 0 to 292 := 292;            
constant score_L_5_top : integer range 0 to 58 := 58;               
constant score_L_5_height :integer range 0 to 2 := 2;
constant score_L_5_width : integer range 0 to 16 := 16;        
signal score_L_5_on : std_logic; 
signal score_L_5_rgb : std_logic_vector (2 downto 0) := "000";

  --SCORE_L_6
constant score_L_6_left : integer range 0 to 308 := 308;            
constant score_L_6_top : integer range 0 to 40 := 40;               
constant score_L_6_height : integer range 0 to 20 := 20;
constant score_L_6_width : integer range 0 to 2 := 2;       
signal score_L_6_on : std_logic; 
signal score_L_6_rgb : std_logic_vector (2 downto 0) := "000";

  --SCORELINE
constant score_line_left : integer range 0 to 312 := 312;            
constant score_line_top : integer range 0 to 40 := 40;               
constant score_line_height : integer range 0 to 2 :=2;
constant score_line_width : integer range 0 to 16 := 16;        
signal score_line_on : std_logic; 
signal score_line_rgb : std_logic_vector (2 downto 0) := "000";

 --SCORE_R_0
constant score_R_0_left : integer range 0 to 332 := 332;            
constant score_R_0_top : integer range 0 to 20 := 20;               
constant score_R_0_height : integer range 0 to 2 := 2;
constant score_R_0_width : integer range 0 to 16 := 16;        
signal score_R_0_on : std_logic; 
signal score_R_0_rgb : std_logic_vector (2 downto 0) := "000";
 
  --SCORE_R_1
constant score_R_1_left : integer range 0 to 330 := 330;            
constant score_R_1_top : integer range 0 to 20 := 20;               
constant score_R_1_height : integer range 0 to 20 := 20;
constant score_R_1_width : integer range 0 to 2 :=2;       
signal score_R_1_on : std_logic; 
signal score_R_1_rgb : std_logic_vector (2 downto 0) := "000";
 
  --SCORE_R_2
constant score_R_2_left : integer range 0 to 332 := 332;            
constant score_R_2_top : integer range 0 to 40 := 40;               
constant score_R_2_height : integer range 0 to 2 :=2;
constant score_R_2_width : integer range 0 to 16 := 16;        
signal score_R_2_on : std_logic; 
signal score_R_2_rgb : std_logic_vector (2 downto 0) := "000";
 
  --SCORE_R_3
constant score_R_3_left : integer range 0 to 348 := 348;            
constant score_R_3_top : integer range 0 to 20 := 20;               
constant score_R_3_height : integer range 0 to 20 := 20;
constant score_R_3_width : integer range 0 to 2 := 2;       
signal score_R_3_on : std_logic; 
signal score_R_3_rgb : std_logic_vector (2 downto 0) := "000";

  --SCORE_R_4
constant score_R_4_left : integer range 0 to 330 := 330;            
constant score_R_4_top : integer range 0 to 40 := 40;               
constant score_R_4_height : integer range 0 to 20 := 20;
constant score_R_4_width : integer range 0 to 2 :=2;       
signal score_R_4_on : std_logic; 
signal score_R_4_rgb : std_logic_vector (2 downto 0) := "000";

  --SCORE_R_5
constant score_R_5_left : integer range 0 to 332 := 332;            
constant score_R_5_top : integer range 0 to 58 := 58;               
constant score_R_5_height : integer range 0 to 2 := 2;
constant score_R_5_width : integer range 0 to 16 := 16;        
signal score_R_5_on : std_logic; 
signal score_R_5_rgb : std_logic_vector (2 downto 0) := "000";

  --SCORE_R_6
constant score_R_6_left : integer range 0 to 348 :=348;            
constant score_R_6_top : integer range 0 to 40 := 40;               
constant score_R_6_height : integer range 0 to 20 := 20;
constant score_R_6_width : integer range 0 to 2 :=2;       
signal score_R_6_on : std_logic; 
signal score_R_6_rgb : std_logic_vector (2 downto 0) := "000";

--SCORE_LEFT AND SCORE_RIGHT

signal score_left : integer range 0 to 16 :=0 ; -- max range is 10
signal score_right :integer range 0 to 16 :=0; -- max range is 10

--gameover
signal sig_game_over : std_logic :='0' ;
 
 --x,y pixel  cursor
 signal  x,y: integer range 0 to 650;
 
 --mux
 signal  mux_select :std_logic_vector(22 downto 0);

--buffer
 signal rgb_reg :std_logic_vector(2 downto 0);
 
 -- speed neg or pos
 signal negative_x : std_logic := '0'; 
 signal negative_y : std_logic := '0'; 
 
 -- counter
 signal counter : integer range 0 to 250000 := 0;
 
 signal score_increased : std_logic := '0' ;
 signal restart_manual : std_logic := '0';
 
 --rand
 signal random : integer range 0 to 511 := 182;  -- max range is 480
 
 --faster
 signal sig_faster_counter : integer range 0 to 50000000 := 0;
 
  --invisible
 signal sig_invisible_counter : integer range 0 to 25000000 := 0;
 
begin 

x <= conv_integer(X_CONTROL); 
y <= conv_integer(Y_CONTROL); 

 
 --restart                
 process(CLK_FPGA)
 begin
    if  (rising_edge(CLK_FPGA))   then
	 
				 -- PAUSE
				if (pause = '1' and ((x >= pause_left and x <= (pause_left + pause_width)  and y >= pause_top and y <= (pause_top + pause_height)) or
											(x >= (pause_left + 20) and x <= (pause_left + pause_width + 20)  and y >= pause_top and y <= (pause_top + pause_height)))) then
						pause_on <= '1';
						pause_rgb <= "101" ;
				else
						pause_on <= '0';
				end if;
				
				-- PAUSE
				if (sig_game_over = '1' and ((x >= end_left and x <= (end_left + end_width)  and y >= end_top and y <= (end_top + end_height)) or
												(x >= (end_left) and x <= (end_left + end_width + end_width)  and y >= end_top and y <= (end_top + 6)) or
												(x >= (end_left) and x <= (end_left + end_width + end_width)  and y >= (end_top + 12) and y <= (end_top + 18)) or
												(x >= (end_left) and x <= (end_left + end_width + end_width)  and y >= (end_top + 24) and y <= (end_top + 30)) or
												
												(x >= (end_left + 35) and x <= (end_left + end_width + 35)  and y >= end_top and y <= (end_top + end_height)) or
												(x >= (end_left + 35) and x <= (end_left + end_width + end_width + 35)  and y >= end_top and y <= (end_top + 6)) or
												(x >= (end_left + 55) and x <= (end_left + end_width + 55)  and y >= end_top and y <= (end_top + end_height)) or
												
												(x >= (end_left + 80) and x <= (end_left + end_width + 80)  and y >= end_top and y <= (end_top + end_height)) or
												(x >= (end_left + 80) and x <= (end_left + end_width + end_width + 80)  and y >= end_top and y <= (end_top + 6)) or
												(x >= (end_left + 100) and x <= (end_left + end_width + 100)  and y >= end_top and y <= (end_top + end_height)) or
												(x >= (end_left + 80) and x <= (end_left + end_width + end_width + 80)  and y >= (end_top +24) and y <= (end_top + 30))
												)) then
						end_on <= '1';
						end_rgb <= "101" ;
				else
						end_on <= '0';
				end if;
	 

--				if( VGA_IN_1 = "01100110" or VGA_IN_2 = "01100110" ) then
--					sig_faster <= 1;
--				end if;

--				if( VGA_IN_1 = "10011001" or VGA_IN_2 = "10011001" ) then
--					sig_invisible <= 1;
--				end if;
	 
			--	if ( VGA_IN_1 = "01010101" or VGA_IN_2 = "01010101" or restart_manual = '1' ) then
				if ( restart = '1' or restart_manual = '1' ) then
				
					if(random < 120) 		then
						negative_x <= '0';
						negative_y <= '0';
					elsif (random >= 120 and random <= 240)	then
						negative_x <= '1';
						negative_y <= '0';
					elsif (random >= 240 and random <= 360)	then
						negative_x <= '0';
						negative_y <= '1';
					elsif (random <= 480)	then
						negative_x <= '1';
						negative_y <= '1';
					end if;	
					
					bar_top_1     <= 182 ;
					bar_top_2     <= 182 ;
					ball_left     <= 315 ;
					ball_top      <= 235 ;
					sig_game_over <= '0' ;
					score_increased <= '0';
					restart_manual <= '0';
					sig_faster_counter <= 0;
					x_speed <= 2;
					y_speed <= 2;
					
					--if(VGA_IN_1 = "01010101" or VGA_IN_2 = "01010101") then
					if ( restart = '1' ) then
						score_left <= 0;
						score_right <= 0;
					end if;
					
				else
				
					if(counter = 150000) then
						random <= (bar_top_1 + bar_top_2 + bar_height_1)/2;
					end if;
					
					if(faster = '1' or (not(sig_faster_counter = 0) and sig_faster_counter <50000000)) then
						sig_faster_counter <= sig_faster_counter + 1;
						x_speed <= 4;
						y_speed <= 4;
					else
						sig_faster_counter <= 0;
						x_speed <= 2;
						y_speed <= 2;
					end if;
					
					if(invisible = '1' or (not(sig_invisible_counter = 0) and sig_invisible_counter <25000000)) then
						sig_invisible_counter <= sig_invisible_counter + 1;
					else						
						sig_invisible_counter <= 0;
					end if;
							

--					if(VGA_IN_1 = "00110011" or VGA_IN_2 = "00110011") then
--						pause <= '1';
--					end if;

--					if(VGA_IN_1 = "11001100" or VGA_IN_2 = "11001100") then
--						pause <= '0';
--					end if;
					
					if(counter = 250000 and sig_game_over = '0' and pause = '0') then
					
								counter <= 0;
					
		--BAR1 animation
--								if VGA_IN_1 = "10000001" and bar_top_1 > (bar_speed_1 + wall_thickness_1) then
								if vga_test_1 = '1' and bar_top_1 > (bar_speed_1 + wall_thickness_1) then
										bar_top_1 <= bar_top_1  - bar_speed_1 ;
--								elsif VGA_IN_1 = "01111110" and bar_top_1 < (480 - bar_height_1 - wall_thickness_2 - bar_speed_1) then
								elsif vga_test_1 = '0' and bar_top_1 < (480 - bar_height_1 - wall_thickness_2 - bar_speed_1) then
										bar_top_1 <= bar_top_1  + bar_speed_1 ;
								end if;
		--BAR2 animation
--								if VGA_IN_2 = "10000001" and bar_top_2 > (bar_speed_2 + wall_thickness_1) then
								if vga_test_2 = '1' and bar_top_2 > (bar_speed_2 + wall_thickness_1) then
										bar_top_2 <= bar_top_2  - bar_speed_2 ;
--								elsif VGA_IN_2 = "01111110" and bar_top_2 < (480 - bar_height_2 - wall_thickness_2 - bar_speed_2) then
								elsif vga_test_2 = '0' and bar_top_2 < (480 - bar_height_2 - wall_thickness_2 - bar_speed_2) then
										bar_top_2 <= bar_top_2  + bar_speed_2 ;
								end if;
								 
		--BALL ANIMATION
								if ball_left < 10 and (bar_top_1 < (ball_top + (ball_height)) and (bar_top_1 + bar_height_1) > (ball_top) ) then
								 negative_x <= '0';
								end if;
							
							if ball_left < 5 and not(bar_top_1 < (ball_top + (ball_height)) and (bar_top_1 + bar_height_1) > (ball_top) ) then
								 if ( score_right < 9 and score_increased = '0' ) then
									  score_right <= score_right + 1;
									  score_increased <= '1';
									  restart_manual <= '1';
								 elsif(score_right >=  9 ) then
									  sig_game_over <= '1' ;
									  bar_top_1     <= 182 ;
									  bar_top_2     <= 182 ;
									  ball_left     <= 315 ;
									  ball_top      <= 235 ;
									  score_left    <= 0 ;
									  score_right   <= 0 ;
									  negative_x    <= '0';
									  negative_y    <= '0';
								 end if;
							end if;
							
							if ball_left > 620 and (bar_top_2 < (ball_top + (ball_height)) and (bar_top_2 + bar_height_2) > (ball_top) ) then
								 negative_x <= '1';
							end if;
							
							if ball_left > 625 and not(bar_top_2 < (ball_top + (ball_height)) and (bar_top_2 + bar_height_2) > (ball_top)  ) then
								 if ( score_left < 9 and score_increased = '0') then
										score_left <= score_left + 1 ;
										score_increased <= '1';										
								      restart_manual <= '1';
								  elsif(score_left >= 9 ) then
										sig_game_over <= '1' ;
										bar_top_1     <= 182 ;
									   bar_top_2     <= 182 ;
									   ball_left     <= 315 ;
									   ball_top      <= 235 ;
									   score_left    <= 0 ;
									   score_right   <= 0 ;
									   negative_x    <= '0';
									   negative_y    <= '0';
								  end if;
							end if;
											
							if ball_top < wall_thickness_1 then
								 negative_y <= '0'; 
							end if;
							
							if (ball_top > (480 - wall_thickness_2 - ball_height)) then
									negative_y <= '1'; 
							end if;
							  
							  if(negative_x = '0') then
									ball_left <= ball_left + x_speed;
							  else
									ball_left <= ball_left - x_speed;
							  end if;
							  
							  if(negative_y = '0') then
									ball_top <= ball_top + y_speed;
							  else
									ball_top <= ball_top - y_speed;
							  end if;
							 
							 
				--Score RGB 
							 
							  case score_left is
							  
							  when 0 =>
									score_L_0_rgb <= "001" ; --blue
									score_L_1_rgb <= "001" ; --blue
									score_L_2_rgb <= "000" ; --black
									score_L_3_rgb <= "001" ; --blue
									score_L_4_rgb <= "001" ; --blue
									score_L_5_rgb <= "001" ; --blue
									score_L_6_rgb <= "001" ; --blue    
							  when 1 =>
									score_L_0_rgb <= "000" ; --black
									score_L_1_rgb <= "000" ; --black
									score_L_3_rgb <= "001" ; --blue
									score_L_4_rgb <= "000" ; --black
									score_L_5_rgb <= "000" ; --black
									score_L_6_rgb <= "001" ; --blue 
							  
							  when 2 =>
									score_L_0_rgb <= "001" ; --blue
									score_L_1_rgb <= "000" ; --black
									score_L_2_rgb <= "001" ; --blue
									score_L_3_rgb <= "001" ; --blue
									score_L_4_rgb <= "001" ; --blue
									score_L_5_rgb <= "001" ; --blue
									score_L_6_rgb <= "000" ; --black 
								 
							  when 3 =>
									score_L_0_rgb <= "001" ; --blue
									score_L_1_rgb <= "000" ; --black
									score_L_2_rgb <= "001" ; --blue
									score_L_3_rgb <= "001" ; --blue
									score_L_4_rgb <= "000" ; --black
									score_L_5_rgb <= "001" ; --blue
									score_L_6_rgb <= "001" ; --blue
								
							  when 4 =>
									score_L_0_rgb <= "000" ; --black
									score_L_1_rgb <= "001" ; --blue
									score_L_2_rgb <= "001" ; --blue
									score_L_3_rgb <= "001" ; --blue
									score_L_4_rgb <= "000" ; --black
									score_L_5_rgb <= "000" ; --black
									score_L_6_rgb <= "001" ; --blue 
									
							  when 5 =>
									score_L_0_rgb <= "001" ; --blue
									score_L_1_rgb <= "001" ; --blue
									score_L_2_rgb <= "001" ; --blue
									score_L_3_rgb <= "000" ; --black
									score_L_4_rgb <= "000" ; --black
									score_L_5_rgb <= "001" ; --blue
									score_L_6_rgb <= "001" ; --blue
									
							  when 6 =>
									score_L_0_rgb <= "001" ; --blue
									score_L_1_rgb <= "001" ; --blue
									score_L_2_rgb <= "001" ; --blue
									score_L_3_rgb <= "000" ; --black
									score_L_4_rgb <= "001" ; --blue
									score_L_5_rgb <= "001" ; --blue
									score_L_6_rgb <= "001" ; --blue
									
							  when 7 =>
									score_L_0_rgb <= "001" ; --blue
									score_L_1_rgb <= "000" ; --black
									score_L_2_rgb <= "000" ; --black
									score_L_3_rgb <= "001" ; --blue
									score_L_4_rgb <= "000" ; --black
									score_L_5_rgb <= "000" ; --black
									score_L_6_rgb <= "001" ; --blue
							  
							  when 8 =>
									score_L_0_rgb <= "001" ; --blue
									score_L_1_rgb <= "001" ; --blue
									score_L_2_rgb <= "001" ; --blue
									score_L_3_rgb <= "001" ; --blue
									score_L_4_rgb <= "001" ; --blue
									score_L_5_rgb <= "001" ; --blue
									score_L_6_rgb <= "001" ; --blue
									
							  when 9 =>
									score_L_0_rgb <= "001" ; --blue
									score_L_1_rgb <= "001" ; --blue
									score_L_2_rgb <= "001" ; --blue
									score_L_3_rgb <= "001" ; --blue
									score_L_4_rgb <= "000" ; --black
									score_L_5_rgb <= "000" ; --black
									score_L_6_rgb <= "001" ; --blue
									
							  when others =>
									score_L_0_rgb <= "001" ; --blue
									score_L_1_rgb <= "001" ; --blue
									score_L_2_rgb <= "000" ; --black
									score_L_3_rgb <= "001" ; --blue
									score_L_4_rgb <= "001" ; --blue
									score_L_5_rgb <= "001" ; --blue
									score_L_6_rgb <= "001" ; --blue   ----------------------------------------------- 
										 
							  end case;
								
												 
							  case score_right is
							  
							  when 0 =>
									score_R_0_rgb <= "001" ; --blue
									score_R_1_rgb <= "001" ; --blue
									score_R_2_rgb <= "000" ; --black
									score_R_3_rgb <= "001" ; --blue
									score_R_4_rgb <= "001" ; --blue
									score_R_5_rgb <= "001" ; --blue
									score_R_6_rgb <= "001" ; --blue    
							  
							  when 1 =>
									score_R_0_rgb <= "000" ; --black
									score_R_1_rgb <= "000" ; --black
									score_R_3_rgb <= "001" ; --blue
									score_R_4_rgb <= "000" ; --black
									score_R_5_rgb <= "000" ; --black
									score_R_6_rgb <= "001" ; --blue 
							  
							  when 2 =>
									score_R_0_rgb <= "001" ; --blue
									score_R_1_rgb <= "000" ; --black
									score_R_2_rgb <= "001" ; --blue
									score_R_3_rgb <= "001" ; --blue
									score_R_4_rgb <= "001" ; --blue
									score_R_5_rgb <= "001" ; --blue
									score_R_6_rgb <= "000" ; --black 
								 
							  when 3 =>
									score_R_0_rgb <= "001" ; --blue
									score_R_1_rgb <= "000" ; --black
									score_R_2_rgb <= "001" ; --blue
									score_R_3_rgb <= "001" ; --blue
									score_R_4_rgb <= "000" ; --black
									score_R_5_rgb <= "001" ; --blue
									score_R_6_rgb <= "001" ; --blue
								
							  when 4 =>
									score_R_0_rgb <= "000" ; --black
									score_R_1_rgb <= "001" ; --blue
									score_R_2_rgb <= "001" ; --blue
									score_R_3_rgb <= "001" ; --blue
									score_R_4_rgb <= "000" ; --black
									score_R_5_rgb <= "000" ; --black
									score_R_6_rgb <= "001" ; --blue
									
							  when 5 =>
									score_R_0_rgb <= "001" ; --blue
									score_R_1_rgb <= "001" ; --blue
									score_R_2_rgb <= "001" ; --blue
									score_R_3_rgb <= "000" ; --black
									score_R_4_rgb <= "000" ; --black
									score_R_5_rgb <= "001" ; --blue
									score_R_6_rgb <= "001" ; --blue
									
							  when 6 =>
									score_R_0_rgb <= "001" ; --blue
									score_R_1_rgb <= "001" ; --blue
									score_R_2_rgb <= "001" ; --blue
									score_R_3_rgb <= "000" ; --black
									score_R_4_rgb <= "001" ; --blue
									score_R_5_rgb <= "001" ; --blue
									score_R_6_rgb <= "001" ; --blue
									
							  when 7 =>
									score_R_0_rgb <= "001" ; --blue
									score_R_1_rgb <= "000" ; --black
									score_R_2_rgb <= "000" ; --black
									score_R_3_rgb <= "001" ; --blue
									score_R_4_rgb <= "000" ; --black
									score_R_5_rgb <= "000" ; --black
									score_R_6_rgb <= "001" ; --blue
							  
							  when 8 =>
									score_R_0_rgb <= "001" ; --blue
									score_R_1_rgb <= "001" ; --blue
									score_R_2_rgb <= "001" ; --blue
									score_R_3_rgb <= "001" ; --blue
									score_R_4_rgb <= "001" ; --blue
									score_R_5_rgb <= "001" ; --blue
									score_R_6_rgb <= "001" ; --blue
									
							  when 9 =>
									score_R_0_rgb <= "001" ; --blue
									score_R_1_rgb <= "001" ; --blue
									score_R_2_rgb <= "001" ; --blue
									score_R_3_rgb <= "001" ; --blue
									score_R_4_rgb <= "000" ; --black
									score_R_5_rgb <= "000" ; --black
									score_R_6_rgb <= "001" ; --blue
									
							  when others =>
									score_R_0_rgb <= "001" ; --blue
									score_R_1_rgb <= "001" ; --blue
									score_R_2_rgb <= "000" ; --black
									score_R_3_rgb <= "001" ; --blue
									score_R_4_rgb <= "001" ; --blue
									score_R_5_rgb <= "001" ; --blue
									score_R_6_rgb <= "001" ; --blue    
										 
							  end case;
							  
				  else
						counter <= counter + 1;
						
				  end if;
      
				end if;		
     end if;
 end process;
 

 
 --WALL1 OBJECT
 wall_on_1 <= '1' when y <= wall_thickness_1 else
            '0' ;
 wall_rgb_1 <= "010" ;--green

 --WALL2 OBJECT 
  wall_on_2 <= '1' when y >= (480 - wall_thickness_2) else
            '0' ;
 wall_rgb_2 <= "010" ;--green
 
 --BAR1 OBJECT
bar_on_1 <= '1' when x <= 10 and y >= bar_top_1 and y <= (bar_top_1 + bar_height_1) else 
            '0' ;
 bar_rgb_1 <= "100" ;  --red

            
 --BAR2 OBJECT
bar_on_2 <= '1' when x >= 630  and y >= bar_top_2 and y <= (bar_top_2 + bar_height_2) else
            '0' ; 
 bar_rgb_2 <= "110" ;  --yellow
 
 
             
--BALL OBJECT
ball_on <= '1' when x >= ball_left and x <= (ball_left + ball_width) and y >= ball_top and y <= ( ball_top + ball_height ) else
           '0' ;
			  		  
ball_rgb <= "011" when (not(sig_faster_counter = 0) and sig_faster_counter <50000000) else				
				"000"	when (not(sig_invisible_counter = 0) and sig_invisible_counter <25000000) else
				"111";

--SCORE_LINE
score_line_on <= '1' when y >= score_line_top and y <= (score_line_top + score_line_height) and x >= score_line_left and x <= ( score_line_left + score_line_width ) else
                '0' ;
score_line_rgb <= "001" ; --blue

--SCORE_L_0
score_L_0_on <= '1' when y >= score_L_0_top and y <= (score_L_0_top + score_L_0_height) and x >= (score_L_0_left ) and x <= ( score_L_0_left + score_L_0_width ) else
                '0' ;
--SCORE_L_1
score_L_1_on <= '1' when y >= score_L_1_top and y <= (score_L_1_top + score_L_1_height) and x >= score_L_1_left and x <= ( score_L_1_left + score_L_1_width) else
                '0' ;
                
--SCORE_L_2
score_L_2_on <= '1' when y >= score_L_2_top and y <= (score_L_2_top + score_L_2_height) and x >= score_L_2_left and x <= ( score_L_2_left + score_L_2_width ) else
                '0' ;
                
--SCORE_L_3
score_L_3_on <= '1' when y >= score_L_3_top and y <= (score_L_3_top + score_L_3_height) and x >= score_L_3_left and x <= ( score_L_3_left + score_L_3_width) else
                '0' ;
--SCORE_L_4                
score_L_4_on <= '1' when y >= score_L_4_top and y <= (score_L_4_top + score_L_4_height) and x >= score_L_4_left and x <= ( score_L_4_left + score_L_4_width) else                
                '0' ;

--SCORE_L_5                
score_L_5_on <= '1' when y >= score_L_5_top and y <= (score_L_5_top + score_L_5_height) and x >= score_L_5_left and x <= ( score_L_5_left + score_L_5_width) else 
                '0' ;
                
--SCORE_L_6                
score_L_6_on <= '1' when y >= score_L_6_top and y <= (score_L_6_top + score_L_6_height) and x >= score_L_6_left and x <= ( score_L_6_left + score_L_6_width) else                 
                '0' ;
                
                
--SCORE_R_0
score_R_0_on <= '1' when y >= score_R_0_top and y <= (score_R_0_top + score_R_0_height) and x >= score_R_0_left and x <= ( score_R_0_left + score_R_0_width) else
                '0' ;
--SCORE_R_1
score_R_1_on <= '1' when y >= score_R_1_top and y <= (score_R_1_top + score_R_1_height) and x >= score_R_1_left and x <= ( score_R_1_left + score_R_1_width) else
                '0' ;
                
--SCORE_R_2
score_R_2_on <= '1' when y >= score_R_2_top and y <= (score_R_2_top + score_R_2_height) and x >= score_R_2_left and x <= ( score_R_2_left + score_R_2_width) else
                '0' ;
                
--SCORE_R_3
score_R_3_on <= '1' when y >= score_R_3_top and y <= (score_R_3_top + score_R_3_height) and x >= score_R_3_left and x <= ( score_R_3_left + score_R_3_width) else
                '0' ;
--SCORE_R_4                
score_R_4_on <= '1' when y >= score_R_4_top and y <= (score_R_4_top + score_R_4_height) and x >= score_R_4_left and x <= ( score_R_4_left + score_R_4_width) else                
                '0' ;

--SCORE_R_5                
score_R_5_on <= '1' when y >= score_R_5_top and y <= (score_R_5_top + score_R_5_height) and x >= score_R_5_left and x <= ( score_R_5_left + score_R_5_width) else 
                '0' ;
                
--SCORE_R_6                
score_R_6_on <= '1' when y >= score_R_6_top and y <= (score_R_6_top + score_R_6_height) and x >= score_R_6_left and x <= ( score_R_6_left + score_R_6_width) else                 
                '0' ;
                

             


--mux
mux_select <= VIDEO_ON & wall_on_1 & wall_on_2 & bar_on_1 & bar_on_2 & ball_on &
              score_L_0_on & score_L_1_on & score_L_2_on & score_L_3_on & score_L_4_on & score_L_5_on & score_L_6_on &
              score_R_0_on & score_R_1_on & score_R_2_on & score_R_3_on & score_R_4_on & score_R_5_on & score_R_6_on & score_line_on & pause_on & end_on;  
with mux_select  select
         rgb_reg  <= "000"  when "10000000000000000000000",--Background of the screen  is  black 
         wall_rgb_1 			 when "11000000000000000000000",
         wall_rgb_1  		 when "11000100000000000000000",
         wall_rgb_2 			 when "10100000000000000000000",
         wall_rgb_2  	    when "10100100000000000000000",
         bar_rgb_1  			 when "10010000000000000000000",
         bar_rgb_1 		    when "10010100000000000000000",
         bar_rgb_2 			 when "10001000000000000000000",
         bar_rgb_2 			 when "10001100000000000000000",
         ball_rgb  			 when "10000100000000000000000",
			score_line_rgb 	 when "10000000000000000000100",			
			ball_rgb			 	 when "10000100000000000000100",
			pause_rgb			 when "10000100000000000000010",
			end_rgb			    when "10000100000000000000001",
         
			pause_rgb			 when "10000000000000000000010",
			end_rgb			    when "10000000000000000000001",
			
         score_L_0_rgb when "10000010000000000000000",
         score_L_1_rgb when "10000001000000000000000",
         score_L_2_rgb when "10000000100000000000000",
         score_L_3_rgb when "10000000010000000000000",
         score_L_4_rgb when "10000000001000000000000",
         score_L_5_rgb when "10000000000100000000000",
         score_L_6_rgb when "10000000000010000000000",
         score_R_0_rgb when "10000000000001000000000",
         score_R_1_rgb when "10000000000000100000000",
         score_R_2_rgb when "10000000000000010000000",
         score_R_3_rgb when "10000000000000001000000",
         score_R_4_rgb when "10000000000000000100000",
         score_R_5_rgb when "10000000000000000010000",
         score_R_6_rgb when "10000000000000000001000",
         
         ball_rgb when "10000110000000000000000",
         ball_rgb when "10000101000000000000000",
         ball_rgb when "10000100100000000000000",
         ball_rgb when "10000100010000000000000",
         ball_rgb when "10000100001000000000000",
         ball_rgb when "10000100000100000000000",
         ball_rgb when "10000100000010000000000",
         ball_rgb when "10000100000001000000000",
         ball_rgb when "10000100000000100000000",
         ball_rgb when "10000100000000010000000",
         ball_rgb when "10000100000000001000000",
         ball_rgb when "10000100000000000100000",
         ball_rgb when "10000100000000000010000",
         ball_rgb when "10000100000000000001000",
           "000" when others;
           
--output
rgb<=rgb_reg;            
GAME_OVER <= sig_game_over ; 
end Behavioral;
