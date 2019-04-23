library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_BIT.all;
use work.userlib.all;
use work.component_ethlink.all;


entity Controller is
  generic (Ndet : integer := 14);
  port (OSCILL_50 : in  std_logic;
        resetn    : in  std_logic;
        CHOKE     : out std_logic_vector(Ndet - 1 downto 0);  --one for each detector
        error     : out std_logic_vector(Ndet - 1 downto 0);  --one for each detector                       

        --Start of Burst (ECRST = 1; BCRST = 1)
        --End of Burst(ECRST 1; BCRST = 0)
        BCRST : out std_logic;
        ECRST : out std_logic;

        --Trigger from L0TP to detectors:
        --Trigger Type (o TriggerWord)
        LTU0        : in std_logic;
        LTU1        : in std_logic;
        LTU2        : in std_logic;
        LTU3        : in std_logic;
        LTU4        : in std_logic;
        LTU5        : in std_logic;
        LTU_TRIGGER : in std_logic;

        Led1 : out std_logic;

        --Clock 40 MHz:
        SMA_clkout_p : out std_logic;

        sw0 : in std_logic;
        sw1 : in std_logic;
        sw2 : in std_logic;
        sw3 : in std_logic;

        BUTTON0 : in std_logic;

        SW : in std_logic_vector(7 downto 0);  --   

        ETH_RST_n : out std_logic;      --

        ETH_RX_p : in  std_logic_vector(0 to 3);  --
        ETH_TX_p : out std_logic_vector(0 to 3);  --

        ETH_MDC  : out   std_logic_vector(0 to 3);  --
        ETH_MDIO : inout std_logic_vector(0 to 3)   --


        );
end Controller;

architecture rtl of Controller is

  component pll is
    port
      (
        areset : in  std_logic;
        inclk0 : in  std_logic;
        c0     : out std_logic;
        locked : out std_logic
        );
  end component;

  component Trigger_input is
    port
      (
        clk40           : in  std_logic;
        clk50           : in  std_logic;
        LTU0            : in  std_logic;
        LTU1            : in  std_logic;
        LTU2            : in  std_logic;
        LTU3            : in  std_logic;
        LTU4            : in  std_logic;
        LTU5            : in  std_logic;
        LTU_TRIGGER     : in  std_logic;
        RUN             : in  std_logic;
        timestamp       : out std_logic_vector(31 downto 0);
        triggerword     : out std_logic_vector(5 downto 0);
        numberoftrigger : out std_logic_vector(24 downto 0);
        received        : out std_logic
        );
  end component;

--PLL SIGNALS-----------------
  signal s_clk40           : std_logic;
  signal s_locked40        : std_logic;
  signal s_clk125          : std_logic;
  signal s_locked125       : std_logic;
  
------------------------------
  signal counter_RUN      : unsigned(31 downto 0);
  signal counter_INTERRUN : unsigned(31 downto 0);

  type FSM_tstmp is (idle, sob, run, eob);
  signal state             : FSM_tstmp;
  signal s_readdata        : std_logic;
  signal s_RUN             : std_logic;
------------------------------------------------
  signal mdio_sin          : std_logic_vector(0 to 3);
  signal mdio_sena         : std_logic_vector(0 to 3);
  signal mdio_sout         : std_logic_vector(0 to 3);
-------------------------------------------------
--trigger_input
  signal s_timestamp       : std_logic_vector(31 downto 0);
  signal s_triggerword     : std_logic_vector(5 downto 0);
  signal s_numberoftrigger : std_logic_vector(24 downto 0);
  signal s_received        : std_logic;


  component altiobuf1
    port
      (
        datain  : in    std_logic_vector (0 downto 0);
        oe      : in    std_logic_vector (0 downto 0);
        dataio  : inout std_logic_vector (0 downto 0);
        dataout : out   std_logic_vector (0 downto 0)
        );
  end component;


  component random is
    port (
      clk           : in  std_logic;
      reset         : in  std_logic;
      RUN           : in  std_logic;
      validateCHOKE : out std_logic_vector (Ndet - 1 downto 0);  --output CHOKE
      validateERROR : out std_logic_vector (Ndet - 1 downto 0)   --output ERROR
      );
  end component;

     --Handle Timestamp @40 MHz and 125 MHz with crossing domain using a dual
   --port fifo:
   component altcountertimestamp IS
      port (
	 clock40   : in STD_LOGIC;
	 clock125  : in STD_LOGIC;
	 BURST       : in STD_LOGIC;
	 internal_timestamp : out STD_LOGIC_VECTOR(29 downto 0);
	 internal_timestamp125 : out STD_LOGIC_VECTOR(29 downto 0)
	 ); end component;


---------


begin

  PLL40_inst : pll port map
    (
      areset => not(resetn),
      inclk0 => OSCILL_50,
      c0     => s_clk40,                 --40 MHz
      locked => s_locked40
      );

--Internal PLL
   PLL125_inst : altpll_refclk2 port map(
      inclk0   => OSC_50_B2, --from DE4
      areset   => '0',
      Locked   => s_locked125,
      c0       => s_clk125
   );

  
  RANDOM_INST : random port map
    (
      clk           => s_clk40,          --40 MHz
      reset         => not(resetn),
      RUN           => s_RUN,
      validateCHOKE => CHOKE,
      validateERROR => error
      );

  CTSTMP: altcountertimestamp port map (
      clock40               => s_clk40,
      clock125              => s_clk125,
      BURST                 => s_RUN,
      internal_timestamp    => s_internal_timestamp,
      internal_timestamp125 => s_internal_timestamp125  
      );
  
-- This module receives triggers from the FLAT cable and sample it in order to
-- know the trigger timestamp sent to the LTU. the output is sent to the
-- ethlink module which sends the results to a workstation via UDP.

  TRIGGER_INST : trigger_input port map
    (
      clk40           => s_clk40,
      clk50           => OSCILL_50,
      LTU0            => LTU0,
      LTU1            => LTU1,
      LTU2            => LTU2,
      LTU3            => LTU3,
      LTU4            => LTU4,
      LTU5            => LTU5,
      LTU_TRIGGER     => LTU_TRIGGER,
      RUN             => s_RUN,
      timestamp       => s_timestamp,
      triggerword     => s_triggerword,
      numberoftrigger => s_numberoftrigger,
      received        => s_received
      );

--This module manages the ethernet output to the L0TP or to a workstation.
--The first 3 ethernet ports send primitives to L0TP reading them from
--preset-RAMs. The third sends the sampled triggers to the workstation
--It includes also and internal PLL for the 125 MHz clock domain. I never moved
--it to the top level of the project.


--LINK 0: IP Sorgente: 192.168.1.16
--         MAC Sorgente: 00:01:02:03:04:10
--         IP Destinatario: 192.168.1.5 
--         MAC Destinatario: 00:01:02:03:04:05
--LINK 0 has to be plug in Link 1 of L0TP

--LINK 1: IP Sorgente: 192.168.1.17
--         MAC Sorgente: 00:01:02:03:04:11
--         IP Destinatario: 192.168.1.11 
--         MAC Destinatario: 00:01:02:03:04:0b
--LINK 1 has to be plug in Link 8 of L0TP

--Trigger are sent from LINK 3

  ethlink_inst : ethlink port map
    (
      inputs.clkin_50   => OSCILL_50,
      inputs.clkin_125  => s_clk125,
      
      inputs.cpu_resetn => resetn,
      inputs.enet_rxp   => ETH_RX_p(0 to ethlink_NODES-1),
      inputs.mdio_sin   => mdio_sin(0 to ethlink_NODES-1),
      inputs.USER_DIPSW => SW,
      inputs.startdata  => s_RUN,
      inputs.sw0        => sw0,
      inputs.sw1        => sw1,
      inputs.sw2        => sw2,
      inputs.sw3        => sw3,

      inputs.timestamp       => s_timestamp,
      inputs.numberoftrigger => s_numberoftrigger,
      inputs.triggerword     => s_triggerword,
      inputs.received        => s_received,

      outputs.enet_resetn => ETH_RST_n,
      outputs.enet_txp    => ETH_TX_p(0 to ethlink_NODES-1),
      outputs.enet_mdc    => ETH_MDC(0 to ethlink_NODES-1),
      outputs.mdio_sout   => mdio_sout(0 to ethlink_NODES-1),
      outputs.mdio_sena   => mdio_sena(0 to ethlink_NODES-1)
      );


  IOBUF : for index in 0 to ethlink_NODES-1 generate
    IOBUF : altiobuf1 port map
      (
        datain(0)  => mdio_sout(index),
        oe(0)      => mdio_sena(index),
        dataout(0) => mdio_sin(index),
        dataio(0)  => ETH_MDIO(index)
        );
  end generate;



  process(resetn, s_clk40)
  begin

    sma_clkout_p <= s_clk40;             -- clock to L0TP

    if resetn = '0' then
      counter_INTERRUN <= (others => '0');
      counter_RUN      <= (others => '0');
      state            <= idle;
      s_readdata       <= '0';
    elsif rising_edge(s_clk40) then
      case state is
        when idle =>
          counter_INTERRUN <= counter_INTERRUN +1;
          counter_RUN      <= (others => '0');
          if counter_INTERRUN > 400000000 then  --10 sec 
            s_readdata <= '1';
            state      <= sob;
          else
            s_readdata <= '0';
            state      <= idle;
          end if;

        when sob =>
          counter_INTERRUN <= (others => '0');
          state            <= run;
          s_readdata       <= '0';


        when run =>
          s_readdata  <= '0';
          counter_RUN <= counter_RUN +1;
          if counter_RUN > 200000000 then  --5 sec
            state <= eob;
          else
            state <= run;
          end if;

        when eob =>
          s_readdata  <= '0';
          counter_RUN <= (others => '0');
          state       <= idle;
      end case;
    end if;
  end process;


-- Output depends on the current state
-- BCRST and ECRST to determine SOB / EOB
--
--BCRST=1 and ECRST='1' => SOB signal
--BCRST=0 and ECRST='1' => EOB signal
--BCRST=0 and ECRST='0' => previous state
--BCRST=1 and ECRST='0' => Not Permitted
--
--

  process (state)
  begin
    s_RUN <= '0';
    case state is
      when idle =>
        Led1  <= '1';                   -- inverse logic
        BCRST <= '0';
        ECRST <= '0';
      when sob =>
        Led1  <= '0';
        ECRST <= '1';
        BCRST <= '1';

      when run =>
        s_RUN <= '1';
        Led1  <= '0';
        BCRST <= '0';
        ECRST <= '0';
      when eob =>
        Led1  <= '1';
        ECRST <= '1';
        BCRST <= '0';
    end case;
  end process;


end rtl;
