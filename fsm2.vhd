library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm2 is
	generic
	( 	tmax	: natural := 112;
		t2s : natural := 2;
		t3s : natural := 3;
		t5s : natural := 5;
		t90s : natural := 90;
		t30s : natural := 30);

	port (
		clk, rst, b, escuro : in std_logic; --, enable 
		rp, rc, yc, gc, gp, led_p, lampada, load : out std_logic;
		tempo : out std_logic_vector(6 downto 0));
end entity ;

architecture ifsc_v1 of fsm2 is
	type state is (sem_pedestre, wait1, amarelo, atencao, com_pedestre, vermelho);
	signal pr_state, nxstate : state;
	signal timer : integer range 0 to tmax;
	signal counter_aux : integer range 0 to tmax;
	
begin

	process (clk, rst)--, enable)
	variable cont : integer range 0 to tmax;
	begin
		if (rst = '1') then
			pr_state <= sem_pedestre;
			cont := 0;
		elsif (rising_edge(clk)) then
			cont := cont + 1;
			if(cont >= timer) then
				pr_state <= nxstate;
				cont := 0;
			end if;		
			counter_aux <= cont;
		end if;
	end process;
	
	tempo <= std_logic_vector(to_unsigned((timer - counter_aux), 7));
	
	process (pr_state, b)
	begin		
		rp <= '0'; rc <= '0'; yc <= '0'; gc <= '0'; gp <= '0'; led_p <= '0'; load <= '0'; lampada <= '0';
		case pr_state is		
			when sem_pedestre =>
				rp <= '1';
				gc <= '1';
				if(b = '1') then
					nxstate <= wait1;
					led_p <= '1';
					timer <= 1;
				else
					nxstate <= sem_pedestre;
					timer <= t90s;
				end if;
				
			when wait1 =>
				rp <= '1';
				gc <= '1';
				if (b = '0') then 
					if(escuro = '1') then
						lampada <= '1';
						led_p <= '1';
					else
						led_p <= '1';
					end if;
					nxstate <= amarelo;
					timer <= 1;
				else
					nxstate <= wait1;
					timer <= 1;
				end if;
				
			when amarelo =>
				yc <= '1';
				rp <= '1';
				timer <= t2s;
				led_p <= '1';
				nxstate <= atencao;
				
			when atencao => 
				rc <= '1';
				rp <= '1';
				timer <= 1;
				led_p <= '1';
				nxstate <= com_pedestre;
				
			when com_pedestre => 
				rc <= '1';
				gp <= '1';
				timer <= t30s;
				load <= '1';
				nxstate <= vermelho;
				if(escuro = '1') then
					lampada <= '1';
					led_p <= '1';
				else
					led_p <= '1';
				end if;
				
			when vermelho =>
				rc <= '1';
				rp <= '1';
				timer <= t5s;
				nxstate <= sem_pedestre;
		end case;
	end process;
	
end architecture ;