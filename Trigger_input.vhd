library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.userlib.all;

entity Trigger_input is
		
port (
      clk50  : in std_logic;
      clk40  : in std_logic;
      LTU0 : in std_logic;
      LTU1 : in std_logic;
      LTU2 : in std_logic;
      LTU3 : in std_logic;
      LTU4 : in std_logic;
      LTU5 : in std_logic;  
      LTU_TRIGGER : in std_logic;
      RUN : in std_logic;
      timestamp   : out std_logic_vector(31 downto 0);  
      triggerword : out std_logic_vector(5 downto 0);
      numberoftrigger    : out std_logic_vector(24 downto 0); 
      received : out std_logic

      );
end Trigger_input;

architecture rtl of Trigger_input is

signal s_countertimestamp : std_logic_vector(31 downto 0);
type FSMstate_t is (S0,S1,S2,wait1clk);
type FSMreceive_t is (S0,S1,S2);

signal FSMstate : FSMstate_t;
signal FSMreceive : FSMreceive_t;

signal s_numberoftrigger: std_logic_vector(24 downto 0);


signal s_rdreq   : std_logic;
signal s_wrreq   : std_logic;
signal s_data    : std_logic_vector(63 downto 0);
signal s_q       : std_logic_vector(63 downto 0);
signal s_rdempty : std_logic;
signal s_rdfull  : std_logic;
signal s_rdusedw : std_logic_vector(9 downto 0);
signal s_wrempty : std_logic;
signal s_wrfull  : std_logic;
signal s_wrusedw : std_logic_vector(9 downto 0);
signal s_aclr    : std_logic;


component alttriggerfifo IS 
  port
    (
  
      aclr		: IN STD_LOGIC  := '0';
      data		: IN STD_LOGIC_VECTOR (63 DOWNTO 0);
      rdclk		: IN STD_LOGIC ;
      rdreq		: IN STD_LOGIC ;
      wrclk		: IN STD_LOGIC ;
      wrreq		: IN STD_LOGIC ;
      q	                : OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
      rdempty           : OUT STD_LOGIC ;
      rdfull	        : OUT STD_LOGIC ;
      rdusedw	        : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
      wrempty	        : OUT STD_LOGIC ;
      wrfull	        : OUT STD_LOGIC ;
      wrusedw	        : OUT STD_LOGIC_VECTOR (9 DOWNTO 0)
);      	  
end component;


begin
	
	
TRIGGERFIFO_inst : alttriggerfifo port map
  (
    aclr	=> s_aclr,
    data	=> s_data,
    rdclk	=> clk50,
    rdreq	=> s_rdreq,     
    wrclk       => clk40 ,
    wrreq	=> s_wrreq ,
    q           => s_q,
    rdempty     => s_rdempty,
    rdfull      => s_rdfull,
    rdusedw     => s_rdusedw,
    wrempty     => s_wrempty,
    wrfull      => s_wrfull,
    wrusedw	=> s_wrusedw
);
	
	
	
--PIN monitoring	
--LTU_TRIGGER signal always positive when a trigger is sent by L0TP

process (clk40,RUN)
begin	
  
  if RUN ='0' then --Out of BURST
    
    s_numberoftrigger <=(others=>'0');
    s_countertimestamp <=(others=>'0');
    
    
 --Sampling @ 40 MHz. It works very well, there is no edge effect between data
 --sent to L0TP and data received by this process.
 --Data are written in the dual port trigger FIFO (in 40 MHz, out 50 MHz).
    
  elsif (rising_edge(clk40)) and RUN='1' then
    
    s_countertimestamp <= SLV(UINT(s_countertimestamp) +1,32);
    
    if LTU_TRIGGER = '1'  then
      s_data(63 downto 32) <= s_countertimestamp;
      s_data(31 downto 7)  <= s_numberoftrigger;
      s_data(6 downto 1)   <= LTU5 & LTU4 & LTU3 & LTU2 & LTU1 & LTU0;--Triggerword
      s_data(0)            <='1';
      s_numberoftrigger    <= SLV(UINT(s_numberoftrigger)+1,25);
      s_wrreq <='1';
    else
      s_wrreq <='0';
      s_data<=(others=>'0');
    end if;
  end if;
end process;


PROCESS(clk50, RUN)
begin
  if (RUN='0') then --Out of burst
    
    s_aclr          <='1';
    
    --output reset------------
    timestamp       <= (others=>'0');
    numberoftrigger <= (others=>'0');
    received        <= '0';
    triggerword     <= (others=>'0');
    FSMstate        <= S0;
  ---------------------------	 
  else 
    if rising_edge(clk50) then
      
      case FSMstate is
        
        when S0=>		
          
          s_aclr          <='0';
          timestamp       <=(others=>'0');
          numberoftrigger <=(others=>'0');
          received        <='0';
          triggerword     <=(others=>'0');
          
          if s_rdempty ='0' then -- as soon as I have a trigger, I read it.
            s_rdreq       <='1';
            FSMstate      <= wait1clk;
          else
            s_rdreq       <='0';
            FSMstate      <= S0;					
          end if;
          
        when wait1clk=>
          --setting registers
          FSMstate <= S1;
          
        when S1 =>
          
          s_rdreq<='0';
          --outputs----------------------------
          timestamp       <= s_q(63 downto 32); 
          numberoftrigger <= s_q(31 downto 7); 
          triggerword     <= s_q(6 downto 1); 
          received        <= s_q(0); 
          -------------------------------------
          FSMstate        <= S2;	
          
          
        when S2 =>
          received        <='0';
          s_rdreq         <='0';
          timestamp       <=(others=>'0');
          numberoftrigger <=(others=>'0');
          triggerword     <=(others=>'0');
          FSMstate        <= S0;
          
        end case;
      end if;--clock
    end if; --run
  end process;
  
		
end rtl;
