library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm4 is
	generic
	( 	tmax	: natural := 90;
		t5s : natural := 5;
		t50s : natural := 50;
		t10s : natural := 10;
		t30s : natural := 30);

	port (
		clk, rst, b1, b2, b3 : in STD_LOGIC;
		tempo : out std_logic_vector(6 downto 0);
		r1, r2, y1, y2, g1, g2, load: out STD_LOGIC);
end entity ;

architecture ifsc_v1 of fsm4 is
	type state is (yy, g1r2, y1r2, r1g2, r1y2, wait1, wait2, wait3, wait4, guarda1, guarda2, yy1, yy2);
	signal pr_state, nxstate : state;
	signal timer : integer range 0 to tmax;
	signal counter_aux : integer range 0 to tmax;
	--attribute ENUM_ENCODING : string; --optional attribute
	--attribute ENUM_ENCODING of state : type is "sequential";
	
begin

	process (clk, rst)
	variable cont : integer range 0 to tmax;
	begin
		if (rst = '1') then
			pr_state <= yy;
			cont := 0;
		elsif (rising_edge(clk)) then
			cont := cont + 1;
			if(cont>=timer) then
				pr_state <= nxstate;
				cont := 0;
			end if;
		end if;
		counter_aux <= cont;
	end process;
	
	tempo <= std_logic_vector(to_unsigned((timer - counter_aux), 7));
	
	process (pr_state, b1, b2, b3)
		begin
			r1 <= '0'; r2 <= '0'; g1 <= '0'; g2 <= '0'; y1 <= '0'; y2 <= '0'; load <= '0';
			
			case pr_state is	
				when yy =>
					y1 <= '1';
					y2 <= '1';
					timer <= 2;
					nxstate <= g1r2;
			
				when g1r2 =>
					g1 <= '1';
					r2 <= '1';
					load <= '1';
					if(b1 = '1')then
						nxstate <= wait1;
						timer <= 1;						
					elsif(b2 = '1') then
						nxstate <= wait2;
						timer <= 1;						
					else
						timer <= t50s;
						nxstate <= y1r2;
					end if;
			
				when y1r2 => 
					y1 <= '1';
					r2 <= '1';
					
					if(b1 = '1')then
						nxstate <= wait1;
						timer <= 1;						
					elsif(b2 = '1') then
						nxstate <= wait2;
						timer <= 1;						
					else
						timer <= t5s;
						nxstate <= r1g2;
					end if;
					
				when r1g2 => 
					r1 <= '1';
					g2 <= '1';
					load <= '1';
					if(b1 = '1')then
						nxstate <= wait1;
						timer <= 1;						
					elsif(b2 = '1') then
						nxstate <= wait2;
						timer <= 1;						
					else
						timer <= t30s;
						nxstate <= r1y2;
					end if;
					
				when r1y2	=>
					r1 <= '1';
					y2 <= '1';
					
					if(b1 = '1')then
						nxstate <= wait1;
						timer <= 1;						
					elsif(b2 = '1') then
						nxstate <= wait2;
						timer <= 1;						
					else
						timer <= t5s;
						nxstate <= g1r2;
					end if;
					
				when wait1 =>
					y1 <= '1';
					y2 <= '1';
					if(b1 = '1') then
						nxstate <= wait1;
						timer <= 1;
					else
						nxstate <= yy1;
						timer <= 1;
					end if;
		
				when yy1 =>
					y1 <= '1';
					y2 <= '1';
					timer <= t5s;
					nxstate <= guarda1;
					
				when guarda1 =>
					g1 <= '1';
					r2 <= '1';

					if(b3 = '1') then
						nxstate <= wait3;
						timer <= 1;
					else
						nxstate <= guarda1;
						timer <= 1;
					end if;

				when wait3 =>
					y1 <= '1';
					y2 <= '1';
					if (b3 = '1') then
						nxstate <= wait3;
						timer <= 1;
					else
						nxstate <= y1r2;
						timer <= 1;
					end if;
					
				when wait2 =>
					y1 <= '1';
					y2 <= '1';
					if(b2 = '1') then
						nxstate <= wait2;
						timer <= 1;
					else
						nxstate <= yy2;
						timer <= 1;
					end if;
				
				when yy2 =>
					y1 <= '1';
					y2 <= '1';
					timer <= t5s;
					nxstate <= guarda2;
					
				when guarda2 =>
					g2 <= '1';
					r1 <= '1';

					if(b3 = '1') then
						nxstate <= wait4;
						timer <= 1;
					else
						nxstate <= guarda2;
						timer <= 1;
					end if;
				
				when wait4 =>
					if (b3 = '1') then
						nxstate <= wait4;
						timer <= 1;
					else
						nxstate <= r1y2;
						timer <= 1;
					end if;
			end case;	
		end process;
	end architecture ;