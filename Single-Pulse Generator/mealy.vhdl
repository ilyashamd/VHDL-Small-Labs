//not tested

library ieee;
use ieee.std_logic_1164.all;

entity mealy is
	port(sync,reset,clk: 	in std_logic;
	     pulse:		  			out std_logic);
end mealy;

architecture arch of mealy is
type state_type is (SEEK, FIND);
signal PS: state_type;
begin
	process(reset, clk)
	begin
		if reset='1' then PS<=SEEK;
		elsif(clk'event and clk='1') then
			case PS is
				when SEEK => if(sync='0') then PS<=FIND; else PS<=SEEK; end if;
				when FIND => if(sync='0') then PS<=FIND; else PS<=SEEK; end if;
			end case;
		end if;
	end process;

	process(PS, sync)
	begin
		case PS is
			when SEEK => if(sync='0') then y<='1' else y<='0'; end if;
			when FIND => if(sync='0') then y<='0' else y<='0';end if;
		end case;
	end process;
end arch;
