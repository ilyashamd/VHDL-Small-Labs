library ieee;
use ieee.std_logic_1164.all;

entity mealy is
	port(w,reset,clk: 	in std_logic;
	y:					out std_logic);
end mealy;

architecture arch of mealy is
type state_type is (A,B,C,D);
signal PS: state_type;
begin
	process(reset, clk)
	begin
		if reset='1' then PS<=A;
		elsif(clk'event and clk='1') then
			case PS is
				when A => if(w='0') then PS<=A; else PS<=B; 
				when B => if(w='0') then PS<=C; else PS<=B;
				when C => if(w='0') then PS<=A; else PS<=D;
				when D => if(w='0') then PS<=C; else PS<=B;
			end case;
		end if;
	end process;
	
	process(PS, w)
	begin
		case PS is
			when A => if(w='0') then y<='0' else y<='0'; 
			when B => if(w='0') then y<='0' else y<='0';
			when C => if(w='0') then y<='0' else y<='0';
			when D => if(w='0') then y<='1' else y<='0';
		end case;
	end process;
end arch;