--This module reads data from a pre-initialized memory and sends
--primitive via eth to another DE4 board

--Problem: it sends primitive to the port 0
--No communication!!!!

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--
use work.globals.all;

package component_ethlink is


  constant ethlink_NODES : natural := 4;


  type ethlink_inputs_t is record

    startData : std_logic;

    clkin_50 : std_logic;

    cpu_resetn : std_logic;

    enet_rxp : std_logic_vector(0 to ethlink_NODES - 1);

    mdio_sin : std_logic_vector(0 to ethlink_NODES - 1);

    USER_DIPSW : std_logic_vector(7 downto 0);

    sw0 : std_logic;
    sw1 : std_logic;
    sw2 : std_logic;
    sw3 : std_logic;

    timestamp       : std_logic_vector(31 downto 0);
    numberoftrigger : std_logic_vector(24 downto 0);
    triggerword     : std_logic_vector(5 downto 0);
    received        : std_logic;
  end record;


  type ethlink_outputs_t is record


    enet_resetn : std_logic;
    enet_txp    : std_logic_vector(0 to ethlink_NODES - 1);
    enet_mdc    : std_logic_vector(0 to ethlink_NODES - 1);
    mdio_sout   : std_logic_vector(0 to ethlink_NODES - 1);
    mdio_sena   : std_logic_vector(0 to ethlink_NODES - 1);
  end record;


  type ethlink_t is record
    inputs  : ethlink_inputs_t;
    outputs : ethlink_outputs_t;
  end record;

--
-- ethlink vector type (constant)
--
  type ethlink_vector_t is array(natural range <>) of ethlink_t;

  component ethlink
    port (
      inputs  : in  ethlink_inputs_t;
      outputs : out ethlink_outputs_t
      );
  end component;

  signal component_ethlink : ethlink_t;
end component_ethlink;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.globals.all;
--
-- use work.component_[name].all;
--
use work.component_ethlink.all;
use work.component_syncrst1.all;
use work.component_mac_sgmii.all;
use work.component_pll_refclk2.all;
use work.component_ram2trigger.all;
use work.component_ramdataCHOD.all;
use work.component_ramdataMUV.all;
use work.component_ramdataLAV.all;
use work.component_SENDFIFO.all;
use work.component_TRIGGERFIFO.all;

entity ethlink is
  port (
    inputs  : in  ethlink_inputs_t;
    outputs : out ethlink_outputs_t
    );
end ethlink;

architecture rtl of ethlink is

  type FSMecho_t is (S0, S1, S2, S3, S4, S5);
  type FSMSendTrigger_t is (S0, S1, S2, S3, S4);
  type FSMReadRam_t is (S0_0, S0, S1, S2, S3, S4, S5, S6);

  type FSMecho_vector_t is array(natural range <>) of FSMecho_t;
  type FSMReadRam_vector_t is array(natural range <>) of FSMReadRam_t;

  type vector4 is array(natural range <>) of std_logic_vector(3 downto 0);
  type vector8 is array(natural range <>) of std_logic_vector(7 downto 0);
  type vector14 is array(natural range <>) of std_logic_vector(13 downto 0);
  type vector15 is array(natural range <>) of std_logic_vector(14 downto 0);
  type vector16 is array(natural range <>) of std_logic_vector(15 downto 0);
  type vector24 is array(natural range <>) of std_logic_vector(23 downto 0);
  type vector32 is array(natural range <>) of std_logic_vector(31 downto 0);
  type vector64 is array(natural range <>) of std_logic_vector(63 downto 0);

  type reglist_clk50_t is record
    wena                   : std_logic_vector(0 to ethlink_NODES-1);
    rena                   : std_logic_vector(0 to ethlink_NODES-1);
    FSMSendTrigger         : FSMSendTrigger_t;
    div2                   : std_logic;
    eol                    : std_logic;
    firstprimitiveinpacket : vector64(0 to ethlink_NODES-1);
    numberofpackets        : integer;
    switchnumber           : std_logic_vector(3 downto 0);
    firstwordset           : std_logic_vector(3 downto 0);
    counter_MEP            : std_logic_vector(31 downto 0);
    counter                : std_logic_vector(31 downto 0);
    timestamp              : std_logic_vector(31 downto 0);
    numberoftrigger        : std_logic_vector(24 downto 0);
    received               : std_logic;
    triggerword            : std_logic_vector(5 downto 0);

  end record;
  constant reglist_clk50_default : reglist_clk50_t :=
    (
      wena                   => (others => '0'),
      rena                   => (others => '0'),
      FSMSendTrigger         => S0,
      div2                   => '0',
      eol                    => '0',
      firstprimitiveinpacket => (others => "0000000000000000000000000000000000000000000000000000000000000000"),
      numberofpackets        => 0,
      switchnumber           => (others => '0'),
      firstwordset           => (others => '1'),
      counter                => (others => '0'),
      counter_MEP            => (others => '0'),
      triggerword            => (others => '0'),
      timestamp              => (others => '0'),
      received               => '0',
      numberoftrigger        => (others => '0')

      );

  type reglist_clk125_t is record
    wena                : std_logic_vector(0 to ethlink_NODES-1);
    rena                : std_logic_vector(0 to ethlink_NODES-1);
    FSMecho             : FSMecho_vector_t(0 to ethlink_NODES-1);
    FSMReadRam          : FSMReadRam_vector_t(0 to ethlink_NODES-1);
    MTPeventNum         : vector32(0 to ethlink_NODES-1);
    MTPheader           : std_logic_vector(3 downto 0);
    MTPsourceID         : vector8(0 to ethlink_NODES-1);
    MTPsourceSubID      : vector8(0 to ethlink_NODES-1);
    MTPnum              : vector8(0 to ethlink_NODES-1);
    MTPLen              : vector16(0 to ethlink_NODES-1);
    counterdata_in      : vector8(0 to ethlink_NODES-1);
    readdataramaddressb : vector15(0 to ethlink_NODES-1);
    sent                : std_logic_vector(0 to ethlink_NODES-1);
    counter_256         : vector32(0 to ethlink_NODES -1);
    wordtoread          : vector8(0 to ethlink_NODES-1);
    sumtimestamp        : vector32(0 to ethlink_NODES-1);
    senddata            : std_logic_vector(3 downto 0);
    counterdata         : vector8(0 to ethlink_NODES-1);
    outcounter          : vector16(0 to ethlink_NODES-1);
    hwaddress           : std_logic_vector(7 downto 0);
    eol                 : std_logic;
    isEnd               : vector8(0 to ethlink_NODES-1);
    RAMbuffer           : std_logic_vector(31 downto 0);
    tsH                 : std_logic_vector(23 downto 0); -- LSB timestamp
    word_send           : std_logic;                     -- packet complete flag
  end record;
  constant reglist_clk125_default : reglist_clk125_t :=
    (
      FSMecho             => (others => S0),
      FSMReadRam          => (others => S0_0),
      counterdata         => (others => "00000000"),
      counterdata_in      => (others => "00000000"),
      readdataramaddressb => (others => "000000000000000"),
      MTPheader           => (others => '0'),
      MTPSourceID         => (others => "00000000"),
      MTPSourceSubID      => (others => "00000000"),
      MTPNum              => (others => "00000000"),
      MTPeventNum         => (others => "00000000000000000000000000000001"),
      MTPLen              => (others => "0000000000000000"),
      outcounter          => (others => "0000000000000000"),
      counter_256         => (others => X"00000000"),
      sent                => (others => '0'),
      sumtimestamp        => (others => (others => '0')),
      wordtoread          => (others => "00000000"),
      senddata            => (others => '0'),
      wena                => (others => '0'),
      rena                => (others => '0'),
      hwaddress           => "00000000",
      eol                 => '0',
      isEnd               => (others => "00000000"),
      RAMbuffer           => (others => '0'),
      tsH                 => (others => '0'),
      word_send           => '0'
      );


  type reglist_t is record

    clk50  : reglist_clk50_t;
    clk125 : reglist_clk125_t;
  end record;


  type resetlist_t is record
    main   : std_logic;
    clk50  : std_logic;
    clk125 : std_logic;
  end record;

  type netlist_t is record
    -- internal clocks
    clk125      : std_logic;
    rst         : resetlist_t;
    SyncRST     : syncrst1_t;
    PLL         : pll_refclk2_t;        --125 MHz clock
    dataRAMMUV  : ramdataMUV_t;         --Preset RAM for MUV3 data
    dataRAMCHOD : ramdataCHOD_t;        --Preset RAM for CHOD data
    SENDFIFO    : sendfifo_vector_t(0 to ethlink_NODES - 1);
    MAC         : mac_sgmii_vector_t(0 to ethlink_NODES - 1);
    TRIGGERFIFO : triggerfifo_t;
  end record;


  subtype inputs_t is ethlink_inputs_t;
  subtype outputs_t is ethlink_outputs_t;

  type allregs_t is record
    din  : reglist_t;
    dout : reglist_t;
  end record;


  signal allregs : allregs_t;
  signal allnets : netlist_t;
  signal allouts : outputs_t;

begin

  SyncRST : syncrst1 port map
    (
      inputs  => allnets.SyncRST.inputs,
      outputs => allnets.SyncRST.outputs
      );

  PLL : pll_refclk2 port map
    (
      inputs  => allnets.PLL.inputs,
      outputs => allnets.PLL.outputs
      );


--It receives the triggers miming the LTU behavior

  Trigger_t : triggerfifo port map
    (
      inputs  => allnets.TRIGGERFIFO.inputs,
      outputs => allnets.TRIGGERFIFO.outputs
      );


--FIFO to generate primitive MTP.
  SENDFIFO_inst : for index in 0 to ethlink_NODES-3 generate
    SENDFIFO_inst : sendfifo port map
      (
        inputs  => allnets.SENDFIFO(index).inputs,
        outputs => allnets.SENDFIFO(index).outputs
        );
  end generate;

----------------------------
  dataRAMCHOD : ramdataCHOD port map
    (
      inputs  => allnets.dataRAMCHOD.inputs,
      outputs => allnets.dataRAMCHOD.outputs
      );

  dataRAMMUV : ramdataMUV port map
    (
      inputs  => allnets.dataRAMMUV.inputs,
      outputs => allnets.dataRAMMUV.outputs
      );


---------------------------------
  MAC : for index in 0 to ethlink_NODES-1 generate
    MAC : mac_sgmii port map
      (
        inputs  => allnets.MAC(index).inputs,
        outputs => allnets.MAC(index).outputs
        );
  end generate;


  process (inputs.clkin_50, allnets.rst.clk50)
  begin
    if (allnets.rst.clk50 = '1') then
      allregs.dout.clk50 <= reglist_clk50_default;
    elsif rising_edge(inputs.clkin_50) then
      allregs.dout.clk50 <= allregs.din.clk50;
    end if;
  end process;


  process (allnets.clk125, allnets.rst.clk125)
  begin
    if (allnets.rst.clk125 = '1') then
      allregs.dout.clk125 <= reglist_clk125_default;
    elsif rising_edge(allnets.clk125) then
      allregs.dout.clk125 <= allregs.din.clk125;
    end if;
  end process;



  process (inputs, allouts, allregs, allnets)
    procedure SubReset
      (
        variable i  : in    inputs_t;
        variable ri : in    reglist_t;
        variable ro : in    reglist_t;
        variable o  : inout outputs_t;
        variable r  : inout reglist_t;
        variable n  : inout netlist_t
        ) is
    begin

      n.clk125                := n.PLL.outputs.c0;
      n.SyncRST.inputs.clk(1) := i.clkin_50;
      n.SyncRST.inputs.clr(1) := not(i.cpu_resetn);
      n.rst.main              := n.SyncRST.outputs.rst(1);


      n.SyncRST.inputs.clk(2) := n.clk125;
      n.SyncRST.inputs.clr(2) := n.rst.main;
      n.rst.clk125            := n.SyncRST.outputs.rst(2);


      n.SyncRST.inputs.clk(3) := i.clkin_50;
      n.SyncRST.inputs.clr(3) := n.rst.clk125;
      n.rst.clk50             := n.SyncRst.outputs.rst(3);

      n.SyncRst.inputs.clk(4) := '0';
      n.SyncRst.inputs.clr(4) := '1';

      n.SyncRst.inputs.clk(5) := '0';
      n.SyncRst.inputs.clr(5) := '1';


      n.SyncRst.inputs.clk(6) := '0';
      n.SyncRst.inputs.clr(6) := '1';


      n.SyncRst.inputs.clk(7) := '0';
      n.SyncRst.inputs.clr(7) := '1';


      n.SyncRst.inputs.clk(8) := '0';
      n.SyncRst.inputs.clr(8) := '1';

    end procedure;


    procedure SubMain                   --Setta tutti i clock e i macaddress
      (
        variable i  : in    inputs_t;
        variable ri : in    reglist_t;
        variable ro : in    reglist_t;
        variable o  : inout outputs_t;
        variable r  : inout reglist_t;
        variable n  : inout netlist_t
        ) is
    begin

      -- Main PLL
      n.PLL.inputs.areset := '0';
      n.PLL.inputs.inclk0 := i.clkin_50;

      r.clk50.div2       := not(ro.clk50.div2);
      r.clk125.hwaddress := i.USER_DIPSW(7 downto 0);

      r.clk50.timestamp       := i.timestamp;
      r.clk50.triggerword     := i.triggerword;
      r.clk50.received        := i.received;
      r.clk50.numberoftrigger := i.numberoftrigger;

      n.dataRAMCHOD.inputs.clock     := n.clk125;
      n.dataRAMCHOD.inputs.wren      := '0';
      n.dataRAMCHOD.inputs.rden      := '1';
      n.dataRAMCHOD.inputs.data      := (others => '0');
      n.dataRAMCHOD.inputs.wraddress := (others => '0');
      n.dataRAMCHOD.inputs.rdaddress := (others => '0');

      n.dataRAMMUV.inputs.clock     := n.clk125;
      n.dataRAMMUV.inputs.wren      := '0';
      n.dataRAMMUV.inputs.rden      := '1';
      n.dataRAMMUV.inputs.data      := (others => '0');
      n.dataRAMMUV.inputs.wraddress := (others => '0');
      n.dataRAMMUV.inputs.rdaddress := (others => '0');

      n.TRIGGERFIFO.inputs.data  := (others => '0');
      n.TRIGGERFIFO.inputs.aclr  := '0';
      n.TRIGGERFIFO.inputs.rdclk := i.clkin_50;
      n.TRIGGERFIFO.inputs.wrclk := i.clkin_50;
      n.TRIGGERFIFO.inputs.rdreq := '0';
      n.TRIGGERFIFO.inputs.wrreq := '0';



      for index in 0 to ethlink_NODES-3 loop

        n.SENDFIFO(index).inputs.data  := (others => '0');
        n.SENDFIFO(index).inputs.aclr  := '0';
        n.SENDFIFO(index).inputs.rdclk := n.clk125;
        n.SENDFIFO(index).inputs.wrclk := n.clk125;
        n.SENDFIFO(index).inputs.rdreq := '0';
        n.SENDFIFO(index).inputs.wrreq := '0';
      end loop;
      --
      for index in 0 to ethlink_NODES-1 loop

        o.enet_mdc(index) := '0';

        o.mdio_sout(index) := '0';
        o.mdio_sena(index) := '0';

        n.MAC(index).inputs.ref_clk := n.clk125;  -- !! Debug !! SGMII/RGMII --> n.clk125;
        n.MAC(index).inputs.rst     := not i.cpu_resetn;  -- async --> syncrst embedded into MAC

        -- MAC Avalon interface (indexed)
        if index = 0 then
          n.MAC(index).inputs.clk         := i.clkin_50;  -- avalon bus clock (also FF_PORT clock)
          n.MAC(index).inputs.mmaddress   := (others => '0');
          n.MAC(index).inputs.mmread      := '0';
          n.MAC(index).inputs.mmwrite     := '0';
          n.MAC(index).inputs.mmwritedata := (others => '0');
        end if;
        if index = 1 then
          n.MAC(index).inputs.clk         := i.clkin_50;  -- avalon bus clock (also FF_PORT clock)
          n.MAC(index).inputs.mmaddress   := (others => '0');
          n.MAC(index).inputs.mmread      := '0';
          n.MAC(index).inputs.mmwrite     := '0';
          n.MAC(index).inputs.mmwritedata := (others => '0');
        end if;
        if index = 2 then
          n.MAC(index).inputs.clk         := i.clkin_50;  -- avalon bus clock (also FF_PORT clock)
          n.MAC(index).inputs.mmaddress   := (others => '0');
          n.MAC(index).inputs.mmread      := '0';
          n.MAC(index).inputs.mmwrite     := '0';
          n.MAC(index).inputs.mmwritedata := (others => '0');
        end if;
        if index = 3 then
          n.MAC(index).inputs.clk         := i.clkin_50;  -- avalon bus clock (also FF_PORT clock)
          n.MAC(index).inputs.mmaddress   := (others => '0');
          n.MAC(index).inputs.mmread      := '0';
          n.MAC(index).inputs.mmwrite     := '0';
          n.MAC(index).inputs.mmwritedata := (others => '0');
        end if;

        -- MAC hardware address (indexed)
        n.MAC(index).inputs.nodeaddr             := ro.clk125.hwaddress;
        n.MAC(index).inputs.nodeaddr(1 downto 0) := SLV(index, 2);  -- !! DEBUG !! constant address indexed (0..3)
        -- MAC multicast address (not used)
        n.MAC(index).inputs.multicastaddr        := "00000000";


        -- enet sgmii inputs
        n.MAC(index).inputs.rxp := i.enet_rxp(index);

        -- enet sgmii outputs
        o.enet_txp(index) := n.MAC(index).outputs.txp;

        -- ethernet phy async reset
        o.enet_resetn := i.cpu_resetn;

      end loop;

      -- MAC inputs not used (wclk,wrst applied for Framegen operations)
      for index in 0 to ethlink_NODES-1 loop
        for p in 1 to RX_NPORTS loop
          n.MAC(index).inputs.rack(p) := '0';
          n.MAC(index).inputs.rreq(p) := '0';
          n.MAC(index).inputs.rena(p) := '0';
          n.MAC(index).inputs.rrst(p) := '0';
          n.MAC(index).inputs.rclk(p) := '0';
        end loop;
        --
        for p in 1 to TX_NPORTS loop
          n.MAC(index).inputs.wtxclr(p)     := '0';
          n.MAC(index).inputs.wtxreq(p)     := '0';
          n.MAC(index).inputs.wmulticast(p) := '0';
          n.MAC(index).inputs.wdestaddr(p)  := "00000000";
          n.MAC(index).inputs.wdestport(p)  := "0000";
          n.MAC(index).inputs.wframelen(p)  := "00000000000";
          n.MAC(index).inputs.wdata(p)      := (others => '0');
          n.MAC(index).inputs.wreq(p)       := '0';
          n.MAC(index).inputs.wena(p)       := '0';
          n.MAC(index).inputs.wclk(p)       := n.clk125;
          n.MAC(index).inputs.wrst(p)       := n.rst.clk125;
        end loop;
      end loop;

    end procedure;


--This procedure receives trigger information after the sampling module and
--store them in a FIFO waiting for the ethernet packet generation
    procedure SubReceive
      (
        variable i  : in    inputs_t;
        variable ri : in    reglist_clk50_t;
        variable ro : in    reglist_clk50_t;
        variable o  : inout outputs_t;
        variable r  : inout reglist_clk50_t;
        variable n  : inout netlist_t
        ) is
    begin

      n.TRIGGERFIFO.inputs.data  := (others => '0');
      n.TRIGGERFIFO.inputs.aclr  := '0';
      n.TRIGGERFIFO.inputs.wrreq := '0';


      if ro.received = '1' then
        n.TRIGGERFIFO.inputs.data(63 downto 32) := ro.timestamp;
        n.TRIGGERFIFO.inputs.data(31 downto 7)  := ro.numberoftrigger;
        n.TRIGGERFIFO.inputs.data(6 downto 1)   := ro.triggerword;
        n.TRIGGERFIFO.inputs.data(0)            := '1';
        n.TRIGGERFIFO.inputs.wrreq              := '1';
      else
        n.TRIGGERFIFO.inputs.data  := (others => '0');
        n.TRIGGERFIFO.inputs.wrreq := '0';
      end if;
    end procedure;

    procedure SubSendTrigger
      (
        variable i  : in    inputs_t;
        variable ri : in    reglist_clk50_t;
        variable ro : in    reglist_clk50_t;
        variable o  : inout outputs_t;
        variable r  : inout reglist_clk50_t;
        variable n  : inout netlist_t
        ) is
    begin
      -- src/dest loopback
      n.MAC(3).outputs.rsrcaddr(FF_PORT) := SLV(19, 8);
      n.MAC(3).inputs.wdestaddr(FF_PORT) := x"14";
      n.MAC(3).inputs.wdestport(FF_PORT) := SLV(1, 4);
      n.MAC(3).outputs.rsrcport(FF_PORT) := SLV(1, 4);
      n.MAC(3).inputs.wtxclr(FF_PORT)    := '0';
      n.MAC(3).inputs.wena(FF_PORT)      := '1';
      n.MAC(3).inputs.wclk(FF_PORT)      := i.clkin_50;
      n.MAC(3).inputs.wrst(FF_PORT)      := n.rst.clk50;
      n.MAC(3).inputs.wdata(FF_PORT)     := (others => '0');
      n.MAC(3).inputs.wreq(FF_PORT)      := '0';
      n.MAC(3).inputs.wtxreq(FF_PORT)    := '0';
      n.MAC(3).inputs.wframelen(FF_PORT) := SLV(800, 11);
      n.TRIGGERFIFO.inputs.rdreq         := '0';
      n.TRIGGERFIFO.inputs.aclr          := '0';


      case ro.FSMSendTrigger is
        when S0 =>
          if i.startData = '1' then
            --I am in burst
            r.FSMSendTrigger := S1;
          else
            r.FSMSendTrigger                := S0;
            n.TRIGGERFIFO.inputs.aclr       := '1';
            n.MAC(3).inputs.wtxclr(FF_PORT) := '1';
            r.counter_MEP                   := (others => '0');
          end if;

        when S1 =>
          -- Send Data
          if i.startData = '1' then
            r.FSMSendTrigger := S2;
            if n.MAC(3).outputs.rempty(FF_PORT) = '0' then
              n.MAC(3).inputs.wtxreq(FF_PORT) := '1';
            end if;

          else
            r.FSMSendTrigger := S0;
          end if;



        when S2 =>
          --
          -- waiting for data
          --
          if i.startData = '1' then
            if n.TRIGGERFIFO.outputs.rdempty = '0' then
              n.TRIGGERFIFO.inputs.rdreq := '1';
              r.FSMSendTrigger           := S3;

            else
              r.FSMSendTrigger := S2;
            end if;
          else
            r.FSMSendTrigger := S0;
          end if;

        when S3 =>
          --
          -- tx echo msg
          --
          if i.startData = '1' then

            if n.MAC(3).outputs.wready(FF_PORT) = '1' and n.MAC(3).outputs.wfull(FF_PORT) = '0' then
              -- txport ready, txport not full: load echo-msg (64bit parallel load)
              n.MAC(3).inputs.wdata(FF_PORT)(7 downto 0)   := n.TRIGGERFIFO.outputs.q(7 downto 0);
              n.MAC(3).inputs.wdata(FF_PORT)(15 downto 8)  := n.TRIGGERFIFO.outputs.q(15 downto 8);
              n.MAC(3).inputs.wdata(FF_PORT)(23 downto 16) := n.TRIGGERFIFO.outputs.q(23 downto 16);
              n.MAC(3).inputs.wdata(FF_PORT)(31 downto 24) := n.TRIGGERFIFO.outputs.q(31 downto 24);
              n.MAC(3).inputs.wdata(FF_PORT)(39 downto 32) := n.TRIGGERFIFO.outputs.q(39 downto 32);
              n.MAC(3).inputs.wdata(FF_PORT)(47 downto 40) := n.TRIGGERFIFO.outputs.q(47 downto 40);
              n.MAC(3).inputs.wdata(FF_PORT)(55 downto 48) := n.TRIGGERFIFO.outputs.q(55 downto 48);
              n.MAC(3).inputs.wdata(FF_PORT)(63 downto 56) := n.TRIGGERFIFO.outputs.q(63 downto 56);
              n.MAC(3).inputs.wreq(FF_PORT)                := '1';
              r.counter_MEP                                := SLV(UINT(ro.counter_MEP) +1, 32);
              -- frame done
              r.FSMSendTrigger                             := S2;

              if UINT(ro.counter_MEP) = 99 then  --I am packing 100 trigger per frame
                n.MAC(3).inputs.wtxreq(FF_PORT) := '1';
                r.counter_MEP                   := (others => '0');
              end if;

            -- note: 'wreq' and 'wtxreq'/'wtxclr' can be applied on the same clock cycle
            elsif n.MAC(3).outputs.wready(FF_PORT) = '1' and n.MAC(3).outputs.wfull(FF_PORT) = '1' then
              -- txport is full: waiting for free space
              r.FSMSendTrigger := S3;
            else
              -- txport not ready: echo not transmitted, rx flush
              r.FSMSendTrigger := S4;
            end if;
          else
            r.FSMSendTrigger := S0;
          end if;

        when S4 =>
          if i.startData = '1' then
            r.FSMSendTrigger := S1;
          else
            r.FSMSendTrigger := S0;
          end if;

      end case;
    end procedure;


-------------READ RAMS and FILL FIFOS---------------------------
    procedure SubReadRam
      (
        variable i  : in    inputs_t;
        variable ri : in    reglist_clk125_t;
        variable ro : in    reglist_clk125_t;
        variable o  : inout outputs_t;
        variable r  : inout reglist_clk125_t;
        variable n  : inout netlist_t
        ) is
    begin

      n.dataRAMCHOD.inputs.clock                  := n.clk125;
      n.dataRAMCHOD.inputs.rden                   := '1';
      n.dataRAMCHOD.inputs.rdaddress(14 downto 0) := ro.readdataramaddressb(0);

      n.dataRAMMUV.inputs.clock                  := n.clk125;
      n.dataRAMMUV.inputs.rden                   := '1';
      n.dataRAMMUV.inputs.rdaddress(14 downto 0) := ro.readdataramaddressb(1);

      for index in 0 to ethlink_NODES-3 loop

        n.SENDFIFO(index).inputs.data  := (others => '0');
        n.SENDFIFO(index).inputs.aclr  := '0';
        n.SENDFIFO(index).inputs.wrclk := n.clk125;
        n.SENDFIFO(index).inputs.wrreq := '0';

        case ro.FSMReadRam(index) is

          when S0_0 =>
            r.tsH                        := (others => '0');
            r.RAMbuffer                  := (others => '0');
            r.word_send                  := '0';
            r.counterdata_in(index)      := (others => '0');
            r.counter_256(index)         := (others => '0');
            r.readdataramaddressb(index) := (others => '0');
            r.sumtimestamp(index)        := (others => '0');
            r.FSMReadRam(index)          := S0;
            r.isEnd(index)               := (others => '0');
          when S0 =>

            if i.startData = '1' then
              r.counter_256(index)    := SLV(UINT(ro.counter_256(index))+256, 32);  --6.4 us
              r.counterdata_in(index) := (others => '0');
              if(ro.isEnd(index) = "00000001") then
                r.FSMReadRam(index) := S0;
              else
                r.FSMReadRam(index) := S1;
              end if;

            else                        --EOB
              r.FSMReadRam(index)           := S0;
              r.isEnd(index)                := (others => '0');
              n.SENDFIFO(index).inputs.aclr := '1';
              r.readdataramaddressb(index)  := (others => '0');
              r.counterdata_in(index)       := (others => '0');
              r.counter_256(index)          := (others => '0');
              r.sumtimestamp(index)         := (others => '0');
            end if;

          when S1 =>
            if i.startData = '1' then
              r.FSMReadRam(index) := S2;
            else
              r.FSMReadRam(index) := S0;
            end if;

          when S2 =>
            if i.startData = '1' then
              r.FSMReadRam(index) := S3;
            else
              r.FSMReadRam(index) := S0;
            end if;


          when S3 =>                    --   32768 parole totali
            if i.startData = '1' then
              n.dataRAMCHOD.inputs.rdaddress(14 downto 0) := ro.readdataramaddressb(0);  --
              n.dataRAMMUV.inputs.rdaddress(14 downto 0)  := ro.readdataramaddressb(1);  -- 2 clock per leggere 1 posizione
              r.FSMReadRam(index)                         := S4;
            else
              r.readdataramaddressb(index) := (others => '0');
              r.FSMReadRam(index)          := S0_0;
            end if;

          when S4 =>

            if i.startData = '1' then

              if index = 0 then
                if UINT(ro.readdataramaddressb(0)) = 32767 then  -- ALL MEMORY HAS BEEN READ -- more than 6.4 us (256 clocks)
                  if i.sw0 = '0' then
                    r.sumtimestamp(0) := SLV(UINT(ro.sumtimestamp(0)) + UINT(X"00029d00"), 32);  --depending on the last word of the ram!
                    if SLV(UINT(n.dataRAMCHOD.outputs.q(31 downto 0)) + UINT(ro.sumtimestamp(0)(31 downto 0)), 32) < ro.counter_256(0) then  -- more than 6.4 us (256 clocks)

                      if ro.word_send = '0' then
                        if ro.tsH = n.dataRAMCHOD.outputs.q(31 downto 8) then -- check if timestamp changed (LSB)
                          r.readdataramaddressb(0)                := SLV(UINT(ro.readdataramaddressb(0)) + 1, 15); --update ram address
                          --r.counterdata_in(0)                     := SLV(UINT(ro.counterdata_in(0)) + 1, 8);
                          r.RAMbuffer(31 downto 0)                := n.dataRAMCHOD.outputs.q(63 downto 32); --write to buffer reg
                          r.FSMReadRam(0)                         := S3;
                        else
                          r.RAMbuffer(31 downto 0)               := (others => '0');                      -- write to buffer reg
                          r.RAMbuffer(23 downto 0)                := n.dataRAMCHOD.outputs.q(31 downto 8); --LSB timestamp
                          r.FSMReadRam(0)                         := S4;
                          r.tsH                                   := n.dataRAMCHOD.outputs.q(31 downto 8); -- update timestamp
                        end if;
                        r.word_send := '1'; --send another word to complete the package

                      else
                        n.SENDFIFO(0).inputs.data(63 downto 32)   := ro.RAMbuffer(31 downto 0); -- get first 32bit word from buffer register
                        if ro.tsH = n.dataRAMCHOD.outputs.q(31 downto 8) then
                          r.readdataramaddressb(0)                := SLV(UINT(ro.readdataramaddressb(0)) + 1, 15); --update ram address
                          r.counterdata_in(0)                     := SLV(UINT(ro.counterdata_in(0)) + 1, 8);
                          n.SENDFIFO(0).inputs.data(31 downto 0)  := n.dataRAMCHOD.outputs.q(63 downto 32);
                          r.FSMReadRam(0)                         := S3;
                        else
                          n.SENDFIFO(0).inputs.data(32 downto 24) := (others => '0');
                          n.SENDFIFO(0).inputs.data(23 downto 0) := n.dataRAMCHOD.outputs.q(31 downto 8); --LSB timestamp
                          r.FSMReadRam(0)                         := S4;
                          r.tsH                                   := n.dataRAMCHOD.outputs.q(31 downto 8); -- update timestamp
                        end if;
                        r.word_send := '0';
                        n.SENDFIFO(0).inputs.wrreq              := '1';
                      end if;
                    else
                      if ro.word_send = '1' and UINT(ro.RAMbuffer(31 downto 0)) > 0 then
                        n.SENDFIFO(0).inputs.data(63 downto 32)   := ro.RAMbuffer(31 downto 0);
                        n.SENDFIFO(0).inputs.data(31 downto 0)    := (others => '0');
                        n.SENDFIFO(0).inputs.wrreq                := '1';
                        r.RAMbuffer(31 downto 0)                  := (others => '0');
                        r.word_send                               := '0';
                        r.counterdata_in(0)                     := SLV(UINT(ro.counterdata_in(0)) + 1, 8);
                      end if;
                      r.FSMReadRam(0) := S5;
                    end if;  --firstword
                  elsif i.sw0 = '1' then
                    r.sumtimestamp(0) := (others => '0');
                    r.FSMReadRam(0)   := S5;
                    r.isEnd(0)        := "00000001";
                  end if;

                else

                  if SLV(UINT(n.dataRAMCHOD.outputs.q(31 downto 0)) + UINT(ro.sumtimestamp(0)(31 downto 0)), 32) < ro.counter_256(0) then  -- more than 6.4 us (256 clocks)
                    if ro.word_send = '0' then
                      if ro.tsH = n.dataRAMCHOD.outputs.q(31 downto 8) then -- check if timestamp changed (LSB)
                        r.readdataramaddressb(0)                := SLV(UINT(ro.readdataramaddressb(0)) + 1, 15); --update ram address
                        --r.counterdata_in(0)                     := SLV(UINT(ro.counterdata_in(0)) + 1, 8);
                        r.RAMbuffer(31 downto 0)                := n.dataRAMCHOD.outputs.q(63 downto 32); --write to buffer reg
                        r.FSMReadRam(0)                         := S3;
                      else
                        r.RAMbuffer(31 downto 0)               := (others => '0');                      -- write to buffer reg
                        r.RAMbuffer(23 downto 0)                := n.dataRAMCHOD.outputs.q(31 downto 8); --LSB timestamp
                        r.FSMReadRam(0)                         := S4;
                        r.tsH                                   := n.dataRAMCHOD.outputs.q(31 downto 8); -- update timestamp
                      end if;
                      r.word_send := '1'; --send another word to complete the package

                    else
                      n.SENDFIFO(0).inputs.data(63 downto 32)   := ro.RAMbuffer(31 downto 0); -- get first 32bit word from buffer register
                      if ro.tsH = n.dataRAMCHOD.outputs.q(31 downto 8) then
                        r.readdataramaddressb(0)                := SLV(UINT(ro.readdataramaddressb(0)) + 1, 15); --update ram address
                        r.counterdata_in(0)                     := SLV(UINT(ro.counterdata_in(0)) + 1, 8);
                        n.SENDFIFO(0).inputs.data(31 downto 0)  := n.dataRAMCHOD.outputs.q(63 downto 32);
                        r.FSMReadRam(0)                         := S3;
                      else
                        n.SENDFIFO(0).inputs.data(32 downto 24) := (others => '0');
                        n.SENDFIFO(0).inputs.data(23 downto 0) := n.dataRAMCHOD.outputs.q(31 downto 8); --LSB timestamp
                        r.FSMReadRam(0)                         := S4;
                        r.tsH                                   := n.dataRAMCHOD.outputs.q(31 downto 8); -- update timestamp
                      end if;
                      r.word_send := '0';
                      n.SENDFIFO(0).inputs.wrreq              := '1';
                    end if;
                  else
                    if ro.word_send = '1' and UINT(ro.RAMbuffer(31 downto 0)) > 0 then
                      n.SENDFIFO(0).inputs.data(63 downto 32)   := ro.RAMbuffer(31 downto 0);
                      n.SENDFIFO(0).inputs.data(31 downto 0)    := (others => '0');
                      n.SENDFIFO(0).inputs.wrreq                := '1';
                      r.RAMbuffer(31 downto 0)                  := (others => '0');
                      r.counterdata_in(0)                     := SLV(UINT(ro.counterdata_in(0)) + 1, 8);
                      r.word_send                               := '0';
                    end if;
                    r.FSMReadRam(0) := S5;
                  end if;  --firstword
                end if;  --last word
              end if;  --index 0
---------------------------------------------------------------------------------------------------------------------------------------------
              if index = 1 then
                if UINT(ro.readdataramaddressb(1)) = 32767 then  -- more than 6.4 us (256 clocks)
                  if i.sw1 = '0' then
                    r.sumtimestamp(1) := SLV(UINT(ro.sumtimestamp(1)) + UINT(X"00030be3"), 32);
                    if SLV(UINT(n.dataRAMMUV.outputs.q(31 downto 0)) + UINT(ro.sumtimestamp(1)(31 downto 0)), 32) < ro.counter_256(1) then  -- more than 6.4 us (256 clocks)
                      r.readdataramaddressb(1)                := SLV(UINT(ro.readdataramaddressb(1)) + 1, 15);
                      r.counterdata_in(1)                     := SLV(UINT(ro.counterdata_in(1)) + 1, 8);
                      n.SENDFIFO(1).inputs.data(63 downto 32) := n.dataRAMMUV.outputs.q(63 downto 32);
                      n.SENDFIFO(1).inputs.data(31 downto 0)  := SLV(UINT(n.dataRAMMUV.outputs.q(31 downto 0))+UINT(ro.sumtimestamp(1)(31 downto 0)), 32);
                      n.SENDFIFO(1).inputs.wrreq              := '1';
                      r.FSMReadRam(1)                         := S3;
                    else
                      r.FSMReadRam(1) := S5;
                    end if;

                  elsif i.sw1 = '1' then
                    r.sumtimestamp(1) := (others => '0');
                    r.isEnd(1)        := "00000001";
                    r.FSMReadRam(1)   := S5;
                  end if;

                else

                  if SLV(UINT(n.dataRAMMUV.outputs.q(31 downto 0)) + UINT(ro.sumtimestamp(1)(31 downto 0)), 32) < ro.counter_256(1) then  -- more than 6.4 us (256 clocks)
                    r.readdataramaddressb(1)                := SLV(UINT(ro.readdataramaddressb(1)) + 1, 15);
                    r.counterdata_in(1)                     := SLV(UINT(ro.counterdata_in(1))+1, 8);
                    n.SENDFIFO(1).inputs.data(63 downto 32) := n.dataRAMMUV.outputs.q(63 downto 32);
                    n.SENDFIFO(1).inputs.data(31 downto 0)  := SLV(UINT(n.dataRAMMUV.outputs.q(31 downto 0))+UINT(ro.sumtimestamp(1)(31 downto 0)), 32);
                    n.SENDFIFO(1).inputs.wrreq              := '1';
                    r.FSMReadRam(1)                         := S3;
                  else
                    r.FSMReadRam(1) := S5;
                  end if;
                end if;  --last word
              end if;  --index 1

            else                        --EOB
              r.FSMReadRam(index) := S0_0;
            end if;

          when s5 =>
            -------------------------------------------------
            if i.startData = '1' then
              r.senddata(index)   := '1';  --le ho scritte nella fifo;
              r.wordtoread(index) := ro.counterdata_in(index);
              r.FSMReadRam(index) := S6;
            else
              r.FSMReadRam(index) := S0_0;
            end if;

          when S6 =>
            if i.startData = '1' then
              r.senddata(index)       := '0';
              r.counterdata_in(index) := (others => '0');
              if ro.sent(index) = '1' then
                r.FSMReadRam(index) := S0;
              else
                r.FSMReadRam(index) := S6;
              end if;

            else
              r.FSMReadRam(index) := S0_0;
            end if;
        ---------------------------------------------
        end case;
      end loop;
    end procedure;





-------------SEND DATA TO ANOTHER DE4 BOARD SIMULATING TEL62---------------------------
    procedure SubSendPrimitive
      (
        variable i  : in    inputs_t;
        variable ri : in    reglist_clk125_t;
        variable ro : in    reglist_clk125_t;
        variable o  : inout outputs_t;
        variable r  : inout reglist_clk125_t;
        variable n  : inout netlist_t
        ) is
    begin



      for index in 0 to ethlink_NODES-3 loop

        n.SENDFIFO(index).inputs.rdclk := n.clk125;
        n.SENDFIFO(index).inputs.rdreq := '0';
--
        r.MTPSourceID(index)           := x"18";
        r.MTPsourceSubID(index)        := x"18";

        -- Tx FF_PORT defaults
        n.MAC(index).inputs.wtxclr(FF_PORT)     := '0';
        n.MAC(index).inputs.wtxreq(FF_PORT)     := '0';
        n.MAC(index).inputs.wmulticast(FF_PORT) := '0';

        --SEND DATA TO DE4_0-----------------------------------
        n.MAC(index).inputs.wdestport(FF_PORT) := SLV(2, 4);
        if index = 0 then
          n.MAC(index).inputs.wdestaddr(FF_PORT) := SLV(5, 8);  -- data to second
                                        -- input of L0TP
        end if;
        if index = 1 then
          n.MAC(index).inputs.wdestaddr(FF_PORT) := SLV(11, 8);  --data to last
                                        --input of L0TP
        end if;


        n.MAC(index).inputs.wdata(FF_PORT) := (others => '0');
        n.MAC(index).inputs.wreq(FF_PORT)  := '0';
        n.MAC(index).inputs.wena(FF_PORT)  := ro.wena(index);
        n.MAC(index).inputs.wclk(FF_PORT)  := n.clk125;
        n.MAC(index).inputs.wrst(FF_PORT)  := n.rst.clk125;
        -- Rx FF_PORT defaults
        n.MAC(index).inputs.rack(FF_PORT)  := '0';
        n.MAC(index).inputs.rreq(FF_PORT)  := '0';
        n.MAC(index).inputs.rena(FF_PORT)  := ro.rena(index);
        n.MAC(index).inputs.rclk(FF_PORT)  := n.clk125;
        n.MAC(index).inputs.rrst(FF_PORT)  := n.rst.clk125;

        r.wena(index) := '1';
        r.rena(index) := '1';

        case ro.FSMecho(index) is

          when S0 =>
            if i.startData = '1' then
              r.FSMecho(index)     := S1;
              r.counterdata(index) := (others => '0');  --parole da scrivere nel MAC
              r.outcounter(index)  := SLV(UINT(ro.outcounter(index))-1, 16);
              r.sent(index)        := '0';
            else
              n.MAC(index).inputs.wtxclr(FF_PORT) := '0';
              r.FSMecho(index)                    := S0;
              r.MTPeventNum(index)                := ("00000000000000000000000000000001");
              r.sent(index)                       := '0';
              r.outcounter(index)                 := SLV(799, 16);  --latenza. Ogni 800* 8 ns = 6400 ns spedisco una primitiva
            end if;

          when S1 =>
            if i.startData = '1' then

              r.sent(index)       := '0';
              r.outcounter(index) := SLV(UINT(ro.outcounter(index))-1, 16);

              if ro.senddata(index) = '1' then  --6.4 us
                r.MTPheader(index) := '1';
                r.FSMecho(index)   := S2;
              else
                r.FSMecho(index) := S1;
              end if;
            else
              r.FSMecho(index) := S0;
            end if;

          when S2 =>
            if i.startData = '1' then
              r.outcounter(index) := SLV(UINT(ro.outcounter(index))-1, 16);
              if ro.MTPheader(index) = '1' then
                r.MTPheader(index) := '0';
                if n.MAC(index).outputs.wready(FF_PORT) = '1' and n.MAC(index).outputs.wfull(FF_PORT) = '0' then
                  n.MAC(index).inputs.wdata(FF_PORT)(31 downto 0)  := ro.MTPeventNum(index);
                  n.MAC(index).inputs.wdata(FF_PORT)(39 downto 32) := ro.MTPSourceSubID(index);
                  n.MAC(index).inputs.wdata(FF_PORT)(47 downto 40) := (others => '1');
                  n.MAC(index).inputs.wdata(FF_PORT)(55 downto 48) := SLV(UINT(ro.wordtoread(index)), 8);
                  n.MAC(index).inputs.wdata(FF_PORT)(63 downto 56) := (others => '1');
                  n.MAC(index).inputs.wreq(FF_PORT)                := '1';

                else
                  null;
                end if;
              end if;

              r.FSMEcho(index) := S3;
            else
              r.FSMecho(index) := S0;
            end if;

          when S3 =>
            if i.startData = '1' then   --6.4 us
              r.outcounter(index) := SLV(UINT(ro.outcounter(index))-1, 16);
              if UINT(ro.counterdata(index)) = UINT(ro.wordtoread(index)) then
                r.FSMecho(index) := S5;
              else
                r.counterdata(index)           := SLV(UINT(ro.counterdata(index))+1, 8);
                n.SENDFIFO(index).inputs.rdreq := '1';
                r.FSMecho(index)               := S4;
              end if;
            else
              r.FSMEcho(index) := S0;
            end if;


          when S4 =>
            if i.startData = '1' then   --6.4 us
              r.outcounter(index) := SLV(UINT(ro.outcounter(index))-1, 16);
              if (n.MAC(index).outputs.wready(FF_PORT) = '1' and n.MAC(index).outputs.wfull(FF_PORT) = '0') then
                n.MAC(index).inputs.wdata(FF_PORT)(31 downto 0)  := n.SENDFIFO(index).outputs.q(63 downto 32);
                n.MAC(index).inputs.wdata(FF_PORT)(63 downto 32) := n.SENDFIFO(index).outputs.q(31 downto 0);  --TIMESTAMP
                n.MAC(index).inputs.wreq(FF_PORT)                := '1';
                r.FSMecho(index)                                 := S3;
              elsif (n.MAC(index).outputs.wready(FF_PORT) = '1' and n.MAC(index).outputs.wfull(FF_PORT) = '1')then
                null;                   -- pieno
              else
                r.FSMecho(index) := S5;
              end if;
            else
              r.FSMecho(index) := S0;
            end if;

          when s5 =>

            if UINT(ro.outcounter(index)) = 0 then
              r.outcounter(index)                    := SLV(799, 16);  --latenza. Ogni 800*8 ns = 6400 ns spedisco una primitiva
              n.MAC(index).inputs.wframelen(FF_PORT) := SLV(28+8+UINT(ro.counterdata(index))*8, 11);
              n.MAC(index).inputs.wtxreq(FF_PORT)    := '1';
              r.MTPeventNum(index)                   := SLV(UINT(ro.MTPeventNum(index))+1, 32);
              r.FSMecho(index)                       := S0;
              r.sent(index)                          := '1';
            else
              r.outcounter(index) := SLV(UINT(ro.outcounter(index))-1, 16);
              r.FSMecho(index)    := S5;
            end if;

        end case;
      end loop;
    end procedure;


    variable i  : inputs_t;
    variable ri : reglist_t;
    variable ro : reglist_t;
    variable o  : outputs_t;
    variable r  : reglist_t;
    variable n  : netlist_t;
  begin
    -- read only variables
    i  := inputs;
    ri := allregs.din;
    ro := allregs.dout;
    -- read/write variables
    o  := allouts;
    r  := allregs.dout;
    n  := allnets;


    -- all clock domains
    SubMain(i, ri, ro, o, r, n);
    SubReset(i, ri, ro, o, r, n);

    -- clock domain: clk50
    --SubCounter(i, ri.clk50, ro.clk50, o, r.clk50, n);
    SubReadRam(i, ri.clk125, ro.clk125, o, r.clk125, n);
    SubSendPrimitive(i, ri.clk125, ro.clk125, o, r.clk125, n);
    SubReceive(i, ri.clk50, ro.clk50, o, r.clk50, n);
    SubSendTrigger(i, ri.clk50, ro.clk50, o, r.clk50, n);

    -- allouts/regs/nets updates
    allouts     <= o;
    allregs.din <= r;
    allnets     <= n;

  end process;

  outputs <= allouts;

end rtl;
