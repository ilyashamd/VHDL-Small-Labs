library ieee;
use ieee.std_logic_1164.all;

entity test is
	port(N,D,reset,clk: 	in std_logic;   --N=Naickle, D=Dim
	     R,C:    					out std_logic);  --R=Release candy, C=Change
end test;

architecture arch of test is
type state_type is (S0,S5,S10,S15);
signal PS: state_type;
begin
	process(reset, clk)
	begin
		if reset='1' then PS<=S0;
		elsif(clk'event and clk='1') then
			case PS is
				when S0  => if(D='1') then PS<=S10; elsif (N='1') then PS<=S5; end if;
				when S5  => if(D='1') then PS<=S15; elsif (N='1') then PS<=S10;end if;
				when S10 => if(D='1') then PS<=S0;  elsif (N='1') then PS<=S15;end if;
				when S15 => if(D='1') then PS<=S0;  elsif (N='1') then PS<=S0;end if;
			end case;
		end if;
	end process;

	process(PS,N,D)
	begin
		case PS is
			when S10 => if(D='1') then R<='1'; C<='0'; else R<='0'; C<='0'; end if;
			when S15 => if(D='1') then R<='1'; C<='1'; elsif (N='1') then R<='1'; C<='0'; else R<='0'; C<='0'; end if;
			when others => R<='0'; C<='0';
		end case;
	end process;
end arch;
