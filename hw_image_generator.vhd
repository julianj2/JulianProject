LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
USE IEEE.std_logic_arith.all;

ENTITY hw_image_generator IS
  --GENERIC(
   -- pixels_y :  INTEGER := 1280;   --row that first color will persist until
    --pixels_x :  INTEGER := 200);  --column that first color will persist until
  PORT(
	 clk, reset		 :  IN STD_LOGIC;
    disp_ena :  IN   STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
    row      :  IN   INTEGER;    --row pixel coordinate
    column   :  IN   INTEGER;    --column pixel coordinate
	 blueScore 	 :  IN 	INTEGER:= 0;
	 redScore	 :  IN 	INTEGER:=0;
	 topL, topR, botL, botR: in std_logic;		--input coming in    --	 btn1  btn2  btn3  btn4    end 
    red      :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
    green    :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
    blue     :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0'); --blue magnitude output to DAC
	 a2, b2, c2, d2, e2, f2, g2: OUT STD_LOGIC;
	 a, b, c, d, e, f, g: OUT STD_LOGIC);
	 	 
END hw_image_generator;


ARCHITECTURE behavior OF hw_image_generator IS
	
	type state is (s0, s1, s2, s3, s4, s5, s6);
	signal state1 : state := s0;
	signal locTop : integer :=540;
	signal locBot : integer :=540;
	signal count : std_LOGIC_VECTOR(40 downto 0);
	signal topLSig : std_logic := '0';
	signal topRSig : std_logic := '0';
	signal topLCount : std_LOGIC_VECTOR(40 downto 0);
	signal lastButtonState : std_logic := '0';
	constant velocity : integer := 1/10;
	
BEGIN
 
  PROCESS(disp_ena, row, column, clk, reset)	--draws everything initially
  BEGIN
  			
			

	 
    IF(disp_ena = '1') THEN        --display time / rising_edge
		
		--varibables in assignment editor don't sync with this file
		--should be HEX0 and HEX2
			IF(blueScore = 0)THEN
				a <= '0';
				b <= '0';
				c <= '0';
				d <= '0';
				e <= '1';
				f <= '1';
				g <= '1';
			ELSIF(blueScore = 1)THEN
				a <= '1';
				b <= '0';
				c <= '0';
				d <= '1';
				e <= '1';
				f <= '1';
				g <= '1';
			ELSIF(blueScore = 2)THEN
				a <= '0';
				b <= '0';
				c <= '1';
				d <= '0';
				e <= '0';
				f <= '1';
				g <= '0';
			ELSE	--game over
				a <= '0';
				b <= '0';
				c <= '0';
				d <= '0';
				e <= '0';
				f <= '0';
				g <= '0';
			END IF;
			
			IF	(redScore = 0)THEN
				a2 <= '0';
				b2 <= '0';
				c2 <= '0';
				d2 <= '0';
				e2 <= '1';
				f2 <= '1';
				g2 <= '1';	
			ELSIF(redScore = 1)THEN
				a <= '1';
				b <= '0';
				c <= '0';
				d <= '1';
				e <= '1';
				f <= '1';
				g <= '1';
			ELSIF(redScore=2)THEN
				a <= '0';
				b <= '0';
				c <= '1';
				d <= '0';
				e <= '0';
				f <= '1';
				g <= '0';
			ELSE	--game over
				a <= '0';
				b <= '0';
				c <= '0';
				d <= '0';
				e <= '0';
				f <= '0';
				g <= '0';
			END IF;
			
			IF(disp_ena = '1') THEN        --display time/rising_edge of clock	
		
				IF(((column > locTop AND column < locTop + 200) AND (row > 0 AND row < 100))) THEN		--displays red ship
				  red <= (OTHERS => '1');
				  green  <= (OTHERS => '0');
				  blue <= (OTHERS => '0');
				ELSIF((column > locBot AND column < locBot + 200) AND (row > 924 AND row < 1024)) THEN --displays purple ship
				  red <= (OTHERS => '1');
				  green  <= (OTHERS => '0');
				  blue <= (OTHERS => '1');
				ELSIF(row=512)THEN																							--displays center line
				  red <= (OTHERS => '1');
				  green  <= (OTHERS => '1');
				  blue <= (OTHERS => '1'); 

				ELSE																												--displays rest of vga screen black
				  red <= (OTHERS => '0');
				  green  <= (OTHERS => '0');
				  blue <= (OTHERS => '0');
				END IF;	--end drawing
		
		
			END IF;	--end colors
			ELSE
			
			
				--Tried to use the buttons to debounce and move a set distance each push, unable to complete
				IF(locTop>10 AND locTop<1070) THEN																		--while top/red ship is in bounds
					if(topL = '1') then																						--if sw[1] down move left (NW)
						locTop<= locTop - velocity;
					ELSE																											--if sw[1] up move right (NW)
						locTop<=locTop + velocity;
					end if;
				end if;
				
				IF(locBot>10 AND locBot<1070) THEN																		--while bot/purple ship is in bounds
					if(botL = '1') then																						--if sw[3] down move right [NW]
						locBot<= locBot + velocity;
					ELSE																											--if sw[3] up move left [NW]
						locBot<=locBot - velocity;
					end if;
				end if;
				
			
		
	
			--test for detections and change redScore and blueScore, which should change hex's
			
			END IF;	




			

END PROCESS;

		
  

END behavior;




