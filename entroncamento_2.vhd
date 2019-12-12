library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity entroncamento_2 is
	generic
	( 	tmax_ext	: natural := 112;
		t2s_ext : natural := 2;
		t3s_ext : natural := 3;
		t5s_ext : natural := 5;
		t90s_ext : natural := 90;
		t30s_ext : natural := 30;
		ncount : natural := 2;
		ncount2 : natural := 1);

	port (
		clk_ext, rst_ext, b_ext, escuro_ext : in std_logic;
		rp_ext, rc_ext, yc_ext, gc_ext, gp_ext, led_p_ext, lampada_ext : out std_logic;
		d_u, d_d : out std_logic_vector(6 downto 0) 
		);
end entity ;

architecture ifsc_v1 of entroncamento_2 is
 
	signal load_s, clk_1seg, rst_n : std_logic;
	signal dezena, unidade : std_logic_vector(3 downto 0);
	signal tempo : std_logic_vector(6 downto 0);
	signal d_aux, u_aux : std_logic_vector(6 downto 0);
	
	component fsm2 is
		generic(	tmax	: natural := 112;
			t2s : natural := 2;
			t3s : natural := 3;
			t5s : natural := 5;
			t90s : natural := 90;
			t30s : natural := 30);
		port (clk, rst, b, escuro : in std_logic;
			rp, rc, yc, gc, gp, led_p, lampada, load : out std_logic;
			tempo : out std_logic_vector(6 downto 0));
	end component ;
	
	component bin2bcd is
		port (c : in std_logic_vector (6 downto 0);
			sd, su : out std_logic_vector (3 downto 0));
	end component;
	
	component display is
		port(numero : in std_logic_vector(3 downto 0);
			ssdout : out std_logic_vector(6 downto 0));
	end component;
	
	component div_clk is
		generic(	Ncount: natural := 2;
			Ncount2 : natural := 1);
		port(	rst : in  std_logic;
			clk : in  std_logic;
			clk_out : out std_logic	);
	end component;
	
begin

	Maquina_estado: component fsm2
		generic map(	tmax => tmax_ext, t2s => t2s_ext,	t3s => t3s_ext, t5s => t5s_ext, t90s => t90s_ext,	t30s => t30s_ext)
		port map(clk => clk_1seg, rst => rst_n, b => b_ext, escuro => escuro_ext, rp => rp_ext, rc => rc_ext, yc => yc_ext,
		gc => gc_ext, gp => gp_ext, led_p => led_p_ext, lampada => lampada_ext, load => load_s, tempo => tempo);

	bin_2_ssd: component bin2bcd
		port map(c => tempo, sd => dezena, su => unidade);
	
	Display1: component display
		port map(numero => dezena, ssdout => d_aux);

	Display2: component display
		port map(numero => unidade, ssdout => u_aux);
		
	Divisor_clock: component div_clk
		generic map(Ncount => ncount, Ncount2 => ncount2)
		port map(rst => rst_n,	clk => clk_ext,	clk_out => clk_1seg);
		
	d_u <= "1111111" when load_s = '0' else (u_aux);
	d_d <= "1111111" when load_s = '0' else (d_aux);
	rst_n <= not rst_ext;
	
end architecture ;