library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity controller is
	port(reset,clk: 	in std_logic;
	     NS:  					out std_logic_vector(6 downto 0);
       EW:  					out std_logic_vector(6 downto 0));
end controller;

architecture arch of controller is
type state_type is (S0,S1,S2,S3);
signal PS: state_type;
signal slow: STD_LOGIC_VECTOR(24 downto 0);
signal slowClk: STD_LOGIC;
signal Q: STD_LOGIC_VECTOR(2 downto 0);
signal TIMER: STD_LOGIC;
signal y: STD_LOGIC_VECTOR(5 downto 0);

begin

--Clock divider
process(clk,reset)
begin
  if reset='1' then slow<=(others=>'0');
  elsif(clk'event and clk='1') then
    slow<=slow+1;
  end if;
end process;
slowClk=slow(24);


--Cycle timer
process(slowClk,reset)
begin
  if reset='1' then Q<=(others=>'0');
  elsif(slowClk'event and slowClk='1') then
    Q<=Q+1;
  end if;
  if(Q="101") then Q<="000";
  end if;
end process;
TIMER<=Q(2);

--FSM Controller
	process(slowClk,reset)
	begin
		if reset='1' then PS<=S0;
		elsif(clk'event and clk='1') then
			case PS is
				when S0 => if(TIMER='1') then PS<=S1; else PS<=S0;
				when S1 =>  PS<=S2;
				when S2 => if(TIMER='1') then PS<=S3; else PS<=S2;
				when S3 => PS<=S0;
			end case;
		end if;
	end process;

	process(PS,TIMER)
	begin
		case PS is
			when S0 => if(TIMER='0') then y<="011_110" else y<="011_101";
			when S1 => y<="110_011";
			when S2 => if(TIMER='0') then y<="110_011" else y<=101_011";
			when S3 => y<="011_110";
		end case;
	end process;

  NS<=(0=>y(0), 3=>y(2), 6=>y(1), others=>'1');
  EW<=(0=>y(3), 3=>y(5), 6=>y(4), others=>'1');
end arch;
