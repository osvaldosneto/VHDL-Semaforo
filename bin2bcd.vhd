library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bin2bcd is
	port (c : in std_logic_vector (6 downto 0);
			sd, su : out std_logic_vector (3 downto 0));
end entity;

architecture conversao1 of bin2bcd is
	signal c_unisgned : unsigned (6 downto 0);
	signal sd_unsigned, su_unsigned : unsigned (3 downto 0);

begin
	c_unisgned <= unsigned(c);
	sd_unsigned <= resize(c_unisgned/10, 4);
	su_unsigned <= resize(c_unisgned rem 10, 4);
	
	sd <= std_logic_vector(sd_unsigned);
	su <= std_logic_vector(su_unsigned);
	
end architecture;