library ieee;
use ieee.std_logic_1164.all;

entity moor is
	port(x,reset,clk: 	in std_logic;
	y:					out std_logic);
end moor;

architecture arch of moor is
type state_type is (A,B,C,D,E,F);
signal PS: state_type;
begin
		process(reset, clk)
		begin
			if reset='1' then PS<=A;
			elsif(clk'event and clk='1') then
				case PS is
					when A => if(x='0') then PS<=B; else PS<=A; 
					when B => if(x='0') then PS<=C; else PS<=A;
					when C => if(x='0') then PS<=C; else PS<=D;
					when D => if(x='0') then PS<=B; else PS<=E;
					when E => if(x='0') then PS<=B; else PS<=F;
					when F => if(x='0') then PS<=B; else PS<=A;
				end case;
			end if;
		end process;
		y<='1' when PS=F else '0';						
end arch;