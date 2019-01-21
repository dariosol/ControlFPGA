library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.userlib.all;

entity random is
    generic ( width : integer :=  32; Ndet : integer := 14 );
		
port (
      clk            : in std_logic;
		reset          : in std_logic;
		RUN            : in std_logic;	
      validateCHOKE : out std_logic_vector (Ndet - 1 downto 0);   --output CHOKE
		validateERROR  : out std_logic_vector (Ndet - 1 downto 0)   --output ERROR
		
    );
end random;

architecture rtl of random is
signal random_num     :  std_logic_vector (width-1 downto 0);   --output vector            
signal CHOKEdetector :  std_logic_vector (Ndet - 1 downto 0);
signal ERRORdetector  :  std_logic_vector (Ndet - 1 downto 0);
signal counter        : integer;
type FSM_CHOKE_t is (S00,S0,S1,S2,S3);
signal state: FSM_CHOKE_t;

begin
	
process (clk, reset)
	begin	
	if reset = '1' or RUN ='0' then
			state <= s00;
			CHOKEdetector  <= (others =>'0');
			ERRORdetector  <= (others =>'0');
		elsif (rising_edge(clk)) and RUN='1' then
			case state is
			when S00=>
			counter <=0;
			state <=s0;
			CHOKEdetector  <= (others =>'0');
			ERRORdetector  <= (others =>'0');
				when s0=>
					if counter = 50000000  then -- 1.25s
					   CHOKEdetector  <= (others =>'0');
			         ERRORdetector  <= (others =>'0');
						state <= s1;
						else 
						counter <=counter+1;
						state <= s0;						
					end if;
					
				when s1=>
				      counter <=0;
						state <= s2;
				
				when s2=>
				if counter = 50000000 then -- 1.25 s
				 state <=s3;
				else 
				CHOKEdetector(0)           <= '1'           ;
			   CHOKEdetector(13 downto 1) <= (others =>'0');
		      ERRORdetector(13 downto 0) <= (others =>'0');
				counter <=counter+1;
				state <=s2;
				end if;
				
				when s3=>
				CHOKEdetector  <= (others =>'0');
			   ERRORdetector  <= (others =>'0');
				counter <=0;
				state <=s3;	
			end case;
		end if;
	end process;
	
	validateCHOKE <= CHOKEdetector;
	validateERROR <= ERRORdetector;
	
	
end rtl;