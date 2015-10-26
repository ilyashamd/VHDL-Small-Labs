library ieee;
use ieee.std_logic_1164.all;

entity moor is
	port(w,reset,clk: 	in std_logic;
	y:					out std_logic);
end moor;

architecture arch of moor is
type state_type is (A,B,C,D,E,F,G);
signal PS: state_type;
begin
		process(reset, clk)
		begin
			if reset='1' then PS<=A;
			elsif(clk'event and clk='1') then
				case PS is
					when A => if(w='0') then PS<=E; else PS<=B; 
					when B => if(w='0') then PS<=E; else PS<=C;
					when C => if(w='0') then PS<=E; else PS<=D;
					when D => if(w='0') then PS<=E; else PS<=D;
					when E => if(w='0') then PS<=F; else PS<=B;
					when F => if(w='0') then PS<=G; else PS<=B;
					when G => if(w='0') then PS<=G; else PS<=B;
				end case;
			end if;
		end process;
		
		process(PS)
		begin
			if (PS=D or PS=G) then y<='1';
			else y<='0';
			end if;
		end process;
end arch;