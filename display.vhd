library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display is

	port(
		numero : in std_logic_vector(3 downto 0);
		ssdout : out std_logic_vector(6 downto 0)	
	);
	
end entity;


architecture ifsc of display is

	signal q : integer range 0 to 9;

begin

	q <= to_integer(unsigned(numero));
	
	process(q) is
	begin
		case q is
			when 0 => ssdout <= "1000000";
			when 1 => ssdout <= "1111001";
			when 2 => ssdout <= "0100100";
			when 3 => ssdout <= "0110000";
			when 4 => ssdout <= "0011001";
			when 5 => ssdout <= "0010010";
			when 6 => ssdout <= "0000010";
			when 7 => ssdout <= "1111000";
			when 8 => ssdout <= "0000000";
			when 9 => ssdout <= "0010000";
			when others => ssdout <= "0001110";
		end case;
	end process;
end architecture;

	
	