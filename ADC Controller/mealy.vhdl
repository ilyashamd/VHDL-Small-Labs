library ieee;
use ieee.std_logic_1164.all;

entity ADC is
	port(go,eoc,reset,clk: 	in std_logic;
	                sc,oe:	out std_logic);
end ADC;

architecture arch of ADC is
type state_type is (IDLE,START,W1, W2, READ);
signal PS: state_type;
begin
	process(reset, clk)
	begin
		if reset='1' then PS<=IDLE;
		elsif(clk'event and clk='1') then
			case PS is
				when IDLE  => if(go='0') then PS<=START; else PS<=IDLE;  end if;
				when START => PS<=W1;
				when W1    => if(eoc='0') then PS<=W2; else PS<=W1;   end if;
				when W2    => if(eoc='1') then PS<=READ; else PS<=W2; end if;
				when READ  => PS<=IDLE;
			end case;
		end if;
	end process;

	process(PS, go, eoc)
	begin
		case PS is
			when IDLE => if(go='0') then sc<='1'; oe<='0'; else sc<='0'; oe<='0'; end if;
			when START => sc<='0'; oe<='0';
			when W1 => sc<='0'; oe<='0';
			when W2 => if(eoc='1') then sc<='0'; oe<='1'; else sc<='0'; oe<='0';end if;
			when READ => sc<='0'; oe<='0';
		end case;
	end process;
end arch;
