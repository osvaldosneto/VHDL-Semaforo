library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity entroncamento_3 is
	generic
	( 	tmax_ext	: natural := 90;
		t5s_ext : natural := 5;
		t50s_ext : natural := 50;
		t10s_ext : natural := 10;
		t30s_ext : natural := 30;
		n_clk1 : natural := 2;
		n_clk2 : natural := 1);

	port (
		clk_ext, rst_ext, b1_ext, b2_ext, b3_ext, a1_ext, a2_ext : in STD_LOGIC;
		d_u, d_d : out std_logic_vector(6 downto 0);
		r1_ext, r2_ext, y1_ext, y2_ext, g1_ext, g2_ext: out STD_LOGIC );
end entity ;

architecture ifsc_v1 of entroncamento_3 is
	
	
	component bin2bcd is
		port (c : in std_logic_vector (6 downto 0);
			sd, su : out std_logic_vector (3 downto 0));
	end component;
	
	component display is
		port(
			numero : in std_logic_vector(3 downto 0);
			ssdout : out std_logic_vector(6 downto 0));
	end component;
	
	component div_clk is
		generic(Ncount : natural := 2;
			Ncount2 : natural := 1);
		port(
			rst	  : in  std_logic;
			clk	  : in  std_logic;
			clk_out : out std_logic	);
	end component;
	
	component fsm3 is
	generic
	( 	tmax	: natural := 90;
		t5s : natural := 5;
		t50s : natural := 50;
		t10s : natural := 10;
		t30s : natural := 30);
	port (
		clk, rst, b1, b2, b3, a1, a2 : in STD_LOGIC;
		display_int : out std_logic_vector(6 downto 0);
		r1, r2, y1, y2, g1, g2, load: out STD_LOGIC );
	end component ;
	
	signal tempo : std_logic_vector(6 downto 0);
	signal load_s, clk_1seg, rst_n : std_logic;
	signal dezena, unidade : std_logic_vector(3 downto 0);
	signal d_aux, u_aux : std_logic_vector(6 downto 0);
	
begin

	Divisor_clock: component div_clk
		generic map (Ncount => n_clk1, Ncount2 => n_clk2)
		port map(rst => rst_n, clk => clk_ext, clk_out => clk_1seg);

	bin_2_ssd: component bin2bcd
		port map(c => tempo, sd => dezena, su => unidade);
	
	Display1: component display
		port map(numero => dezena, ssdout => d_aux);

	Display2: component display
		port map(numero => unidade, ssdout => u_aux);
	
	Maq_estado: component fsm3
		generic map( 	tmax => tmax_ext, t5s => t5s_ext, t50s => t50s_ext, t10s => t10s_ext,	t30s => t30s_ext)
		port map ( clk => clk_1seg, rst => rst_n, b1 => b1_ext, b2 => b2_ext, b3 => b3_ext, a1 => a1_ext, a2 => a2_ext,
		display_int => tempo, r1 => r1_ext , r2 => r2_ext, y1 => y1_ext, y2 => y2_ext, g1 => g1_ext, g2 => g2_ext, load => load_s);
	
	d_u <= "0000000" when load_s = '0' else u_aux;
	d_d <= "0000000" when load_s = '0' else d_aux;
	rst_n <= not rst_ext;
	
end architecture ;