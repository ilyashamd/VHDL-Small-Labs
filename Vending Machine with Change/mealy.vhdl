library ieee;
use ieee.std_logic_1164.all;

entity mealy is
	port(N,D,reset,clk: 	in std_logic;   --N=Naickle, D=Dim
	     R,C:    					out std_logic);  --R=Release candy, C=Change
end mealy;

architecture arch of mealy is
type state_type is (0,5,10,15);
signal PS: state_type;
begin
	process(reset, clk)
	begin
		if reset='1' then PS<=0;
		elsif(clk'event and clk='1') then
			case PS is
				when 0  => if(D='1') then PS<=10; elsif (N='1') PS<=5;
				when 5  => if(D='1') then PS<=15; elsif (N='1') PS<=10;
				when 10 => if(D='1') then PS<=0;  elsif (N='1') PS<=15;
				when 15 => if(D='1') then PS<=0;  elsif (N='1') PS<=0;
			end case;
		end if;
	end process;

	process(PS,N,D)
	begin
		case PS is
			when 10 => if(D='1') then R<='1'; C<='0';
      when 15 => if(D='1') then R<='1'; C<='1';
      when 15 => if(N='1') then R<='1'; C<='0';
		end case;
	end process;
end arch;
