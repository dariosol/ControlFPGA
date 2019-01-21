--**************************************************************
--**************************************************************
--
-- Template file: comp_ck1.rec (new component, single clk)
--
--**************************************************************
--**************************************************************
--
--
-- Component mac_rgmii
--
--
--
--
--
--
-- Notes:
--
-- (edit)     --> custom description (component edit)
-- (constant) --> common description (do not modify)
--
--**************************************************************
--**************************************************************

--**************************************************************
--
--
-- Component Interface
--
--
--**************************************************************

-- libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--
use work.globals.all;
use work.component_txport1.all;
use work.component_rxport1.all;
-- note: components txport1,rxport1 are included at package level because 
-- some I/O definitions use constants 'txport1_NPORTS','rxport1_NPORTS'

package component_mac_rgmii is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- mac_rgmii constants (edit)
--
-- constant mac_rgmii_[constant_name] : [type] := [value];
--

--
-- mac_rgmii typedefs (edit)
--
-- subtype mac_rgmii_[name]_t is [type];
-- type mac_rgmii_[name]_t is [type];
--

--
-- mac_rgmii inputs (edit)
--
type mac_rgmii_inputs_t is record

   -- clock list
   clk : std_logic;       -- Avalon-MM clock
   ref_clk : std_logic;   -- rgmii reference clock (125 MHz local reference clock) 
   
   -- reset list
   rst  : std_logic;   
   -- note: async reset 

   -- Rx-interface: rgmii input (4bit, rxc dual edge) 
   rxc    : std_logic;
   rx_ctl : std_logic;
   rd     : std_logic_vector(3 downto 0);
   --
   -- note: dual edge logic, rxrst should be async asserted, sync deasserted using rxc negedge
   --

   -- RegFile interface (Avalon-MM slave)
   mmaddress : std_logic_vector(3 downto 0);
   mmread : std_logic;
   mmwrite : std_logic;
   mmwritedata : std_logic_vector(31 downto 0);
   
   -- node params (quasi-static params, assumed synchronized to ref_clk)
   nodeaddr : std_logic_vector(7 downto 0);
   multicastaddr : std_logic_vector(7 downto 0);
   
   -- write interface: TX_NPORTS clock domains
   wclk : std_logic_vector(1 to txport1_NPORTS);
   wrst : std_logic_vector(1 to txport1_NPORTS);

   -- write interface inputs (clock domain wclk(),wrst()) 
   wena : std_logic_vector(1 to txport1_NPORTS);               
   wreq : std_logic_vector(1 to txport1_NPORTS);               
   wdata : txport1_wdata_vector_t(1 to txport1_NPORTS);        
   wframelen : txport1_framelen_vector_t(1 to txport1_NPORTS);
   wdestport : txport1_destport_vector_t(1 to txport1_NPORTS); 
   wdestaddr : txport1_destaddr_vector_t(1 to txport1_NPORTS);
   wmulticast : std_logic_vector(1 to txport1_NPORTS);
   wtxreq : std_logic_vector(1 to txport1_NPORTS);   
   wtxclr : std_logic_vector(1 to txport1_NPORTS);        

   -- read interface: RX_NPORTS clock domains
   rclk : std_logic_vector(1 to rxport1_NPORTS);
   rrst : std_logic_vector(1 to rxport1_NPORTS);

   -- read interface inputs (clock domain rclk(),rrst()) 
   rena : std_logic_vector(1 to rxport1_NPORTS);
   rreq : std_logic_vector(1 to rxport1_NPORTS);
   rack : std_logic_vector(1 to rxport1_NPORTS);

end record;

--
-- mac_rgmii outputs (edit)
--
type mac_rgmii_outputs_t is record

   -- Tx-interface: rgmii output (4bit, txc dual edge) 
   txc    : std_logic;
   tx_ctl : std_logic;
   td     : std_logic_vector(3 downto 0);

   -- RegFile interface (Avalon-MM slave)
   mmreaddata : std_logic_vector(31 downto 0);
   mmreaddatavalid : std_logic;
   mmwaitrequest : std_logic;

   -- write interface outputs (clock domain wclk(),wrst()) 
   wready : std_logic_vector(1 to txport1_NPORTS);
   wempty : std_logic_vector(1 to txport1_NPORTS); 
   wfull : std_logic_vector(1 to txport1_NPORTS); 
   werror : std_logic_vector(1 to txport1_NPORTS);
   wdatalen : txport1_framelen_vector_t(1 to txport1_NPORTS);
   wframes : txport1_frames_vector_t(1 to txport1_NPORTS);

   -- read interface outputs (clock domain rclk(),rrst()) 
   renasts : std_logic_vector(1 to rxport1_NPORTS);
   rdata : rxport1_rdata_vector_t(1 to rxport1_NPORTS);
   rready : std_logic_vector(1 to rxport1_NPORTS);
   rempty : std_logic_vector(1 to rxport1_NPORTS); 
   rfull : std_logic_vector(1 to rxport1_NPORTS);
   rframes : rxport1_frames_vector_t(1 to rxport1_NPORTS);
   rsrcaddr : rxport1_srcaddr_vector_t(1 to rxport1_NPORTS);
   rsrcport : rxport1_srcport_vector_t(1 to rxport1_NPORTS);
   rdatalen : rxport1_datalen_vector_t(1 to rxport1_NPORTS);
   rdatacnt : rxport1_datalen_vector_t(1 to rxport1_NPORTS);
   rseqnum  : rxport1_seqnum_vector_t(1 to rxport1_NPORTS);
   reoframe : std_logic_vector(1 to rxport1_NPORTS);
   --
   rerrfull : std_logic_vector(1 to rxport1_NPORTS); 
   rerrempty : std_logic_vector(1 to rxport1_NPORTS); 

end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- mac_rgmii component common interface (constant)
--
type mac_rgmii_t is record
   inputs : mac_rgmii_inputs_t;
   outputs : mac_rgmii_outputs_t;
end record;

--
-- mac_rgmii vector type (constant)
--
type mac_rgmii_vector_t is array(NATURAL RANGE <>) of mac_rgmii_t;

--
-- mac_rgmii component declaration (constant)
--
component mac_rgmii
port (
   inputs : in mac_rgmii_inputs_t;
   outputs : out mac_rgmii_outputs_t
);
end component;

--
-- mac_rgmii global signal to export range/width params (constant)
--
signal component_mac_rgmii : mac_rgmii_t;

end component_mac_rgmii;

--
-- mac_rgmii entity declaration
--

-- libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
--
-- use work.component_[name].all;
--
use work.component_mac_rgmii.all;
use work.component_rgmii1.all;
use work.component_syncrst1.all;
use work.component_mac_gmii.all;
--
use work.component_txport1.all;
use work.component_rxport1.all;
-- note: components are included because some I/O definitions 
-- use constants 'txport1_NPORTS','rxport1_NPORTS' ....si potrebbero usare solo le TX/RX_NPORTS....
 
-- mac_rgmii entity (constant)
entity mac_rgmii is
port (
   inputs : in mac_rgmii_inputs_t;
   outputs : out mac_rgmii_outputs_t
);
end mac_rgmii;

--**************************************************************
--**************************************************************

--**************************************************************
--
--
-- Component Architecture
--
--
--**************************************************************

architecture rtl of mac_rgmii is

--**************************************************************
--
-- Architecture declaration begin 
--
--**************************************************************

--
-- local constants (edit)
--
-- constant [name] : [type] := [value];
--

--
-- state machines (edit)
--
-- type [FSMname]_t is (S0, S1, S2, S3 ...);
-- 

--
-- local registers (edit)
--
--
-- Notes: one record-type for each clock domain
--

--
-- clock domain: clk (note: regs are not used, reglist is empty)  
--
type reglist_clk_t is record

   -- end of list
   eol : std_logic;

end record;
constant reglist_clk_default : reglist_clk_t :=
(
   eol => '0'
);

--
-- clock domain: tx_clk
--
type reglist_tx_clk_t is record

   -- end of list
   eol : std_logic;

end record;
constant reglist_tx_clk_default : reglist_tx_clk_t :=
(
   eol => '0'
);

--
-- all local registers (edit)
--
-- Notes: one record-element for each clock domain
--
type reglist_t is record
   clk    : reglist_clk_t;
   tx_clk : reglist_tx_clk_t;
end record;

--
-- all local resets (edit)
--
-- Notes: one record-element for each clock domain
--
type resetlist_t is record
   clk : std_logic;
   tx_clk : std_logic;
   tx_clk_negedge : std_logic;
   rx_clk : std_logic;   
   rx_clk_negedge : std_logic;
end record;

--
-- all local nets (edit)
--
type netlist_t is record

   -- internal clocks
   tx_clk : std_logic;
   rx_clk : std_logic;

   -- internal resets (all clock domains: async asserted, sync deasserted)
   rst : resetlist_t;

   --
   -- component interface signals (edit)
   --
   -- [instance_name] : [component_name]_t;
   -- [instance_name] : [component_name]_vector_t([instance_range]);
   --
   syncrst : syncrst1_t;
   rgmii   : rgmii1_t;
   mac     : mac_gmii_t;

end record;

--**************************************************************
--
-- Architecture declaration end 
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- inputs/outputs record-type alias (constant)
--
subtype inputs_t is mac_rgmii_inputs_t;
subtype outputs_t is mac_rgmii_outputs_t;

--
-- all local registers (constant)
--
type allregs_t is record
   din : reglist_t;
   dout : reglist_t;
end record;
signal allregs : allregs_t;

--
-- all local nets (constant)
--
signal allnets : netlist_t;
signal allcmps : netlist_t;

--
-- outputs driver (internal signal for read access) (constant)
--
signal allouts : outputs_t;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- architecture rtl of mac_rgmii
--
--**************************************************************
begin

--**************************************************************
--
-- components instances (edit)
--
--**************************************************************

--[instance_name/label] : [component_name] port map
--(
--   inputs => allnets.[instance_name].inputs,
--   outputs => allcmps.[instance_name].outputs
--);

syncrst : syncrst1 port map
(
   inputs => allnets.syncrst.inputs,
   outputs => allcmps.syncrst.outputs
);

mac : mac_gmii port map
(
   inputs => allnets.mac.inputs,
   outputs => allcmps.mac.outputs
);

rgmii : rgmii1 port map
(
   inputs => allnets.rgmii.inputs,
   outputs => allcmps.rgmii.outputs
);

--**************************************************************
--
-- sequential logic
--
--
-- Notes: one record-type for each clock domain
--
--**************************************************************

--
-- clock domain: clk,rst (edit)
--
process (inputs.clk, allnets.rst.clk)
begin
   if (allnets.rst.clk = '1') then
      allregs.dout.clk <= reglist_clk_default;
   elsif rising_edge(inputs.clk) then
      allregs.dout.clk <= allregs.din.clk;
   end if;
end process;

--
-- clock domain: tx_clk,rst (edit)
--
process (allnets.tx_clk, allnets.rst.tx_clk)
begin
   if (allnets.rst.tx_clk = '1') then
      allregs.dout.tx_clk <= reglist_tx_clk_default;
   elsif rising_edge(allnets.tx_clk) then
      allregs.dout.tx_clk <= allregs.din.tx_clk;
   end if;
end process;

--**************************************************************
--
-- combinatorial logic
--
--
-- Notes: single process with combinatorial procedures.
--
--**************************************************************

process (inputs, allouts, allregs, allnets, allcmps)

--**************************************************************
--
-- Combinatorial description begin
--
--**************************************************************

--
-- Reset signals (all clock domains, async asserted, sync deasserted)
--
procedure SubReset
(
   variable i : in inputs_t;
   variable ri: in reglist_t;
   variable ro: in reglist_t;
   variable o : inout outputs_t;
   variable r : inout reglist_t;
   variable n : inout netlist_t
) is
begin

   -- 
   -- Internal clocks
   --
   n.tx_clk := i.ref_clk;
   n.rx_clk := n.rgmii.outputs.grxc;
   -- note: 'common tx/rx clock domain' corresponds to 'tx_clk' = 'ref_clk';
   -- 'rx_clk' generated by rgmii interface. 
 
   --
   -- Internal resets generated by reset synchronizer (async asserted, sync deasserted)
   --

   --
   -- level 1 (max priority: deasserted first)
   --
   
   -- clock domain tx_clk
   n.syncrst.inputs.clk(1) := n.tx_clk;
   n.syncrst.inputs.clr(1) := i.rst;
   n.rst.tx_clk := n.syncrst.outputs.rst(1);
   
   --
   -- level 2 (min priority: deasserted last)
   --

   -- clock domain tx_clk_negedge
   n.syncrst.inputs.clk(2) := not n.tx_clk; -- for tx_clk negedge registers (rgmii)
   n.syncrst.inputs.clr(2) := n.rst.tx_clk;
   n.rst.tx_clk_negedge := n.SyncRST.outputs.rst(2);

   -- clock domain rx_clk
   n.syncrst.inputs.clk(3) := n.rx_clk; 
   n.syncrst.inputs.clr(3) := n.rst.tx_clk;
   n.rst.rx_clk := n.syncrst.outputs.rst(3);

   -- clock domain rx_clk_negedge
   n.syncrst.inputs.clk(4) := not n.rx_clk; -- for rx_clk negedge registers (rgmii)
   n.syncrst.inputs.clr(4) := n.rst.tx_clk;
   n.rst.rx_clk_negedge := n.syncrst.outputs.rst(4);

   -- clock domain clk
   n.syncrst.inputs.clk(5) := i.clk;
   n.syncrst.inputs.clr(5) := n.rst.tx_clk;
   n.rst.clk := n.syncrst.outputs.rst(5);

   -- unused section
   n.syncrst.inputs.clk(6) := '0';
   n.syncrst.inputs.clr(6) := n.rst.tx_clk;
   -- n.rst.RRRRR := n.syncrst.outputs.rst(6);

   -- unused section
   n.syncrst.inputs.clk(7) := '0';
   n.syncrst.inputs.clr(7) := n.rst.tx_clk;
   -- n.rst.RRRRR := n.syncrst.outputs.rst(7);

   -- unused section
   n.syncrst.inputs.clk(8) := '0';
   n.syncrst.inputs.clr(8) := n.rst.tx_clk;
   -- n.rst.RRRRR := n.syncrst.outputs.rst(8);

   -- rgmii resets
   n.rgmii.inputs.rxrst := n.rst.rx_clk_negedge;
   n.rgmii.inputs.txrst := n.rst.tx_clk_negedge;

end procedure;


--
-- Main combinatorial procedure (edit)
--
-- all clock domains
--
procedure SubMain
(
   variable i : in inputs_t;
   variable ri: in reglist_t;
   variable ro: in reglist_t;
   variable o : inout outputs_t;
   variable r : inout reglist_t;
   variable n : inout netlist_t
) is
begin

   --
   -- MAC interface
   --

   -- Avalon-MM clock,reset 
   n.mac.inputs.clk := i.clk;
   n.mac.inputs.reset_clk := n.rst.clk;

   -- common tx/rx_clock domain
   n.mac.inputs.tx_clk := n.tx_clk;
   n.mac.inputs.reset_tx_clk := n.rst.tx_clk;
   -- note: tx_clk is the main 'common tx/rx clock domain' --> gmii tx interface
   -- is clocked by tx_clk

   -- gmii rx clock domain
   n.mac.inputs.rx_clk := n.rx_clk;
   n.mac.inputs.reset_rx_clk := n.rst.rx_clk;
   -- note: gmii rx interface is clocked by dedicated rx_clk (rgmii 'grxc output')  

   --
   -- Inputs
   --

   -- RegFile interface (Avalon-MM slave)
   n.mac.inputs.mmaddress   := i.mmaddress(3 downto 0);
   n.mac.inputs.mmread      := i.mmread;
   n.mac.inputs.mmwrite     := i.mmwrite;
   n.mac.inputs.mmwritedata := i.mmwritedata(31 downto 0);
   
   -- node params (quasi-static params, assumed synchronized to ref_clk)
   n.mac.inputs.nodeaddr      := i.nodeaddr(7 downto 0);
   n.mac.inputs.multicastaddr := i.multicastaddr(7 downto 0);
   
   -- write interface: TX_NPORTS clock domains
   n.mac.inputs.wclk := i.wclk(1 to txport1_NPORTS);
   n.mac.inputs.wrst := i.wrst(1 to txport1_NPORTS);

   -- write interface inputs (clock domain wclk(),wrst()) 
   n.mac.inputs.wena       := i.wena(1 to txport1_NPORTS);               
   n.mac.inputs.wreq       := i.wreq(1 to txport1_NPORTS);               
   n.mac.inputs.wdata      := i.wdata(1 to txport1_NPORTS);        
   n.mac.inputs.wframelen  := i.wframelen(1 to txport1_NPORTS);
   n.mac.inputs.wdestport  := i.wdestport(1 to txport1_NPORTS); 
   n.mac.inputs.wdestaddr  := i.wdestaddr(1 to txport1_NPORTS);
   n.mac.inputs.wmulticast := i.wmulticast(1 to txport1_NPORTS);
   n.mac.inputs.wtxreq     := i.wtxreq(1 to txport1_NPORTS);   
   n.mac.inputs.wtxclr     := i.wtxclr(1 to txport1_NPORTS);        

   -- read interface: RX_NPORTS clock domains
   n.mac.inputs.rclk := i.rclk(1 to rxport1_NPORTS);
   n.mac.inputs.rrst := i.rrst(1 to rxport1_NPORTS);

   -- read interface inputs (clock domain rclk(),rrst()) 
   n.mac.inputs.rena := i.rena(1 to rxport1_NPORTS);
   n.mac.inputs.rreq := i.rreq(1 to rxport1_NPORTS);
   n.mac.inputs.rack := i.rack(1 to rxport1_NPORTS);

   --
   -- Outputs
   --

   -- RegFile interface (Avalon-MM slave)
   o.mmreaddata := n.mac.outputs.mmreaddata(31 downto 0);
   o.mmreaddatavalid := n.mac.outputs.mmreaddatavalid;
   o.mmwaitrequest := n.mac.outputs.mmwaitrequest;

   -- write interface outputs (clock domain wclk(),wrst()) 
   o.wready := n.mac.outputs.wready(1 to txport1_NPORTS);
   o.wempty := n.mac.outputs.wempty(1 to txport1_NPORTS); 
   o.wfull := n.mac.outputs.wfull(1 to txport1_NPORTS); 
   o.werror := n.mac.outputs.werror(1 to txport1_NPORTS);
   o.wdatalen := n.mac.outputs.wdatalen(1 to txport1_NPORTS);
   o.wframes := n.mac.outputs.wframes(1 to txport1_NPORTS);

   -- read interface outputs (clock domain rclk(),rrst()) 
   o.renasts := n.mac.outputs.renasts(1 to rxport1_NPORTS);
   o.rdata := n.mac.outputs.rdata(1 to rxport1_NPORTS);
   o.rready := n.mac.outputs.rready(1 to rxport1_NPORTS);
   o.rempty := n.mac.outputs.rempty(1 to rxport1_NPORTS); 
   o.rfull := n.mac.outputs.rfull(1 to rxport1_NPORTS);
   o.rframes := n.mac.outputs.rframes(1 to rxport1_NPORTS);
   o.rsrcaddr := n.mac.outputs.rsrcaddr(1 to rxport1_NPORTS);
   o.rsrcport := n.mac.outputs.rsrcport(1 to rxport1_NPORTS);
   o.rdatalen := n.mac.outputs.rdatalen(1 to rxport1_NPORTS);
   o.rdatacnt := n.mac.outputs.rdatacnt(1 to rxport1_NPORTS);
   o.rseqnum  := n.mac.outputs.rseqnum(1 to rxport1_NPORTS);
   o.reoframe := n.mac.outputs.reoframe(1 to rxport1_NPORTS);
   --
   o.rerrfull := n.mac.outputs.rerrfull(1 to rxport1_NPORTS); 
   o.rerrempty := n.mac.outputs.rerrempty(1 to rxport1_NPORTS);

   --
   -- RGMII tx interface
   --

   -- rgmii inputs (gmii interface)
   n.rgmii.inputs.gtxc   := n.tx_clk;   
   n.rgmii.inputs.gtx_en := n.mac.outputs.gtx_en;
   n.rgmii.inputs.gtx_er := n.mac.outputs.gtx_er;
   n.rgmii.inputs.gtxd   := n.mac.outputs.gtxd(7 downto 0);

   -- rgmii outputs (tx interface)
   o.txc    := n.rgmii.outputs.txc;
   o.tx_ctl := n.rgmii.outputs.tx_ctl;
   o.td     := n.rgmii.outputs.td(3 downto 0);
   
   --
   -- RGMII rx interface
   --

   -- rgmii inputs (rx interface)
   n.rgmii.inputs.rxc    := i.rxc;
   n.rgmii.inputs.rx_ctl := i.rx_ctl;
   n.rgmii.inputs.rd     := i.rd(3 downto 0);

   -- rgmii outputs (gmii interface)
   n.mac.inputs.grx_en := n.rgmii.outputs.grx_dv;
   n.mac.inputs.grx_er := n.rgmii.outputs.grx_er;
   n.mac.inputs.grxd   := n.rgmii.outputs.grxd(7 downto 0);

end procedure;


--
-- Debug combinatorial procedure (edit)
--
-- all clock domains
--
procedure SubDebug
(
   variable i : in inputs_t;
   variable ri: in reglist_t;
   variable ro: in reglist_t;
   variable o : inout outputs_t;
   variable r : inout reglist_t;
   variable n : inout netlist_t
) is
begin

   null;

end procedure;

--**************************************************************
--
-- combinatorial description end
--
--**************************************************************

--
-- combinatorial process
--
variable i : inputs_t;
variable ri: reglist_t;
variable ro: reglist_t;
variable o : outputs_t;
variable r : reglist_t;
variable n : netlist_t;
begin
   -- read only variables
   i := inputs;
   ri := allregs.din;
   ro := allregs.dout;
   -- read/write variables
   o := allouts;
   r := allregs.dout;
   n := allnets;
   -- components outputs
   n.syncrst.outputs := allcmps.syncrst.outputs;
   n.rgmii.outputs := allcmps.rgmii.outputs;
   n.mac.outputs := allcmps.mac.outputs;

   --
   -- all procedures call (edit)
   --
   -- all clock domains
   SubReset(i, ri, ro, o, r, n);
   SubMain(i, ri, ro, o, r, n);
   SubDebug(i, ri, ro, o, r, n);

   -- allouts/regs/nets updates
   allouts <= o;
   allregs.din <= r;
   allnets <= n;

end process;

--**************************************************************
--**************************************************************

--
-- output connections (edit)
--
outputs <= allouts;

end rtl;
--**************************************************************
--
-- architecture rtl of mac_rgmii
--
--**************************************************************
