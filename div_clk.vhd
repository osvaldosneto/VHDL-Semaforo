library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity div_clk is
	generic(
		Ncount: natural := 50000000;
		Ncount2 : natural := 25000000
	);
	port(
		rst	  : in  std_logic;
		clk	  : in  std_logic;
		clk_out : out std_logic	);
end entity;


architecture div_clk_v1 of div_clk is
	signal count_s : integer range 0 to Ncount-1;
begin
	conta : 
	process (rst, clk) is
		variable count : integer range 0 to Ncount-1;
	begin
		if (rst = '1') then
			count := 0;
		elsif (rising_edge(clk)) then
			if count = Ncount-1 then
				count := 0;
			else
				count := count + 1;
			end if;
		end if;
		count_s <= count;
	end process;
	
	process (count_s)
	begin
	
	if count_s < ncount2 then
		clk_out <= '1';
	else
		clk_out <= '0';
	
	end if;
	end process;
	
end architecture;