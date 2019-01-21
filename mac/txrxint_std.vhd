--**************************************************************
--**************************************************************
--
-- Template file: cint_all.std (RecType --> Std)
--
--**************************************************************
--**************************************************************
--
--
-- Component txrxint interface (entity, architecture)
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

--
-- txrxint_std entity declaration (constant)
--

-- Standard libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_txrxint.all;
--
use work.globals.all;
use work.component_txport1.all;
use work.component_rxport1.all;
use work.component_cmdctrl.all;

entity txrxint_std is
port
(
   clk2 : in std_logic;
   rst2 : in std_logic;
   wclk : in std_logic_vector(1 to txport1_NPORTS);
   wrst : in std_logic_vector(1 to txport1_NPORTS);
   nodeaddr : in std_logic_vector(7 downto 0);
   multicastaddr : in std_logic_vector(7 downto 0);
   wena : in std_logic_vector(1 to txport1_NPORTS);
   wreq : in std_logic_vector(1 to txport1_NPORTS);
   wdata : in txport1_wdata_vector_t(1 to txport1_NPORTS);
   wframelen : in txport1_framelen_vector_t(1 to txport1_NPORTS);
   wdestport : in txport1_destport_vector_t(1 to txport1_NPORTS);
   wdestaddr : in txport1_destaddr_vector_t(1 to txport1_NPORTS);
   wmulticast : in std_logic_vector(1 to txport1_NPORTS);
   wtxreq : in std_logic_vector(1 to txport1_NPORTS);
   wtxclr : in std_logic_vector(1 to txport1_NPORTS);
   rclk : in std_logic_vector(1 to rxport1_NPORTS);
   rrst : in std_logic_vector(1 to rxport1_NPORTS);
   rena : in std_logic_vector(1 to rxport1_NPORTS);
   rreq : in std_logic_vector(1 to rxport1_NPORTS);
   rack : in std_logic_vector(1 to rxport1_NPORTS);
   ext_tport_enable_wr : in std_logic;
   ext_tport_ackenable_wr : in std_logic;
   ext_tport_timerenable_wr : in std_logic;
   ext_tport_seqnumclr_wr : in std_logic;
   ext_tport_enable : in std_logic_vector(15 downto 0);
   ext_tport_ackenable : in std_logic_vector(15 downto 0);
   ext_tport_timerenable : in std_logic_vector(15 downto 0);
   ext_tport_seqnumclr : in std_logic_vector(15 downto 0);
   ext_rport_enable_wr : in std_logic;
   ext_rport_seqnumena_wr : in std_logic;
   ext_rport_seqnumclr_wr : in std_logic;
   ext_rport_enable : in std_logic_vector(15 downto 0);
   ext_rport_seqnumena : in std_logic_vector(15 downto 0);
   ext_rport_seqnumclr : in std_logic_vector(15 downto 0);
   ext_tport_srcfilterena : in std_logic_vector(15 downto 0);
   ext_tport_srcfilterena_wr : in std_logic;
   ext_tport_srcfilter : in std_logic_vector(3 downto 0);
   ext_tport_srcfilteraddr : in std_logic_vector(7 downto 0);
   ext_tport_srcfilterport : in std_logic_vector(3 downto 0);
   ext_tport_srcfilter_wr : in std_logic;
   ext_rport_srcfilterena : in std_logic_vector(15 downto 0);
   ext_rport_srcfilterena_wr : in std_logic;
   ext_rport_srcfilter : in std_logic_vector(3 downto 0);
   ext_rport_srcfilteraddr : in std_logic_vector(7 downto 0);
   ext_rport_srcfilterport : in std_logic_vector(3 downto 0);
   ext_rport_srcfilter_wr : in std_logic;
   ext_fgen_ena : in std_logic;
   ext_fgen_loop : in std_logic;
   ext_fgen_trig : in std_logic_vector(15 downto 0);
   ext_fgen_wr : in std_logic;
   ext_fgen_destaddr : in std_logic_vector(7 downto 0);
   ext_fgen_destport : in std_logic_vector(3 downto 0);
   ext_fgen_destaddr_wr : in std_logic;
   ext_fgen_destmode : in std_logic_vector(2 downto 0);
   ext_fgen_destmode_wr : in std_logic;
   ext_fgen_framelen : in std_logic_vector(10 downto 0);
   ext_fgen_framelen_wr : in std_logic;
   grxc : in std_logic;
   grx_rst : in std_logic;
   grx_en : in std_logic;
   grx_er : in std_logic;
   grxd : in std_logic_vector(7 downto 0);
   wready : out std_logic_vector(1 to txport1_NPORTS);
   wempty : out std_logic_vector(1 to txport1_NPORTS);
   wfull : out std_logic_vector(1 to txport1_NPORTS);
   werror : out std_logic_vector(1 to txport1_NPORTS);
   wdatalen : out txport1_framelen_vector_t(1 to txport1_NPORTS);
   wframes : out txport1_frames_vector_t(1 to txport1_NPORTS);
   renasts : out std_logic_vector(1 to rxport1_NPORTS);
   rdata : out rxport1_rdata_vector_t(1 to rxport1_NPORTS);
   rready : out std_logic_vector(1 to rxport1_NPORTS);
   rempty : out std_logic_vector(1 to rxport1_NPORTS);
   rfull : out std_logic_vector(1 to rxport1_NPORTS);
   rframes : out rxport1_frames_vector_t(1 to rxport1_NPORTS);
   rsrcaddr : out rxport1_srcaddr_vector_t(1 to rxport1_NPORTS);
   rsrcport : out rxport1_srcport_vector_t(1 to rxport1_NPORTS);
   rdatalen : out rxport1_datalen_vector_t(1 to rxport1_NPORTS);
   rdatacnt : out rxport1_datalen_vector_t(1 to rxport1_NPORTS);
   rseqnum : out rxport1_seqnum_vector_t(1 to rxport1_NPORTS);
   reoframe : out std_logic_vector(1 to rxport1_NPORTS);
   rerrfull : out std_logic_vector(1 to rxport1_NPORTS);
   rerrempty : out std_logic_vector(1 to rxport1_NPORTS);
   gtxc : out std_logic;
   gtx_rst : out std_logic;
   gtx_en : out std_logic;
   gtx_er : out std_logic;
   gtxd : out std_logic_vector(7 downto 0);
   txseqnum : out txport1_seqnum_vector_t(1 to txport1_NPORTS);
   rxseqnum : out rxport1_seqnum_vector_t(1 to rxport1_NPORTS);
   ext_tport_enable_sts : out std_logic_vector(15 downto 0);
   ext_tport_ackenable_sts : out std_logic_vector(15 downto 0);
   ext_tport_timerenable_sts : out std_logic_vector(15 downto 0);
   ext_tport_renable_sts : out std_logic_vector(15 downto 0);
   ext_tport_rerror_sts : out std_logic_vector(15 downto 0);
   ext_rport_enable_sts : out std_logic_vector(15 downto 0);
   ext_rport_seqnumena_sts : out std_logic_vector(15 downto 0);
   ext_rport_wready_sts : out std_logic_vector(15 downto 0);
   ext_rport_werrempty_sts : out std_logic_vector(15 downto 0);
   ext_rport_werrfull_sts : out std_logic_vector(15 downto 0);
   ext_tport_srcfilterena_sts : out std_logic_vector(15 downto 0);
   ext_tport_srcfilteraddr_sts : out cmdctrl_byte_vector_t(1 to txport1_NPORTS);
   ext_tport_srcfilterport_sts : out cmdctrl_nibble_vector_t(1 to txport1_NPORTS);
   ext_rport_srcfilterena_sts : out std_logic_vector(15 downto 0);
   ext_rport_srcfilteraddr_sts : out cmdctrl_byte_vector_t(1 to rxport1_NPORTS);
   ext_rport_srcfilterport_sts : out cmdctrl_nibble_vector_t(1 to rxport1_NPORTS);
   ext_fgen_ena_sts : out std_logic;
   ext_fgen_loop_sts : out std_logic;
   ext_fgen_trig_sts : out std_logic_vector(15 downto 0);
   ext_fgen_framelen_sts : out std_logic_vector(10 downto 0);
   ext_fgen_destaddr_sts : out std_logic_vector(7 downto 0);
   ext_fgen_destport_sts : out std_logic_vector(3 downto 0);
   ext_fgen_destmode_sts : out std_logic_vector(2 downto 0)
);
end txrxint_std;

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

-- Local libraries (constant)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_txrxint.all;

architecture rtl of txrxint_std is

--
-- txrxint component declaration (constant)
--
--component txrxint_std
--port
--(
--   clk2 : in std_logic;
--   rst2 : in std_logic;
--   wclk : in std_logic_vector(1 to txport1_NPORTS);
--   wrst : in std_logic_vector(1 to txport1_NPORTS);
--   nodeaddr : in std_logic_vector(7 downto 0);
--   multicastaddr : in std_logic_vector(7 downto 0);
--   wena : in std_logic_vector(1 to txport1_NPORTS);
--   wreq : in std_logic_vector(1 to txport1_NPORTS);
--   wdata : in txport1_wdata_vector_t(1 to txport1_NPORTS);
--   wframelen : in txport1_framelen_vector_t(1 to txport1_NPORTS);
--   wdestport : in txport1_destport_vector_t(1 to txport1_NPORTS);
--   wdestaddr : in txport1_destaddr_vector_t(1 to txport1_NPORTS);
--   wmulticast : in std_logic_vector(1 to txport1_NPORTS);
--   wtxreq : in std_logic_vector(1 to txport1_NPORTS);
--   wtxclr : in std_logic_vector(1 to txport1_NPORTS);
--   rclk : in std_logic_vector(1 to rxport1_NPORTS);
--   rrst : in std_logic_vector(1 to rxport1_NPORTS);
--   rena : in std_logic_vector(1 to rxport1_NPORTS);
--   rreq : in std_logic_vector(1 to rxport1_NPORTS);
--   rack : in std_logic_vector(1 to rxport1_NPORTS);
--   ext_tport_enable_wr : in std_logic;
--   ext_tport_ackenable_wr : in std_logic;
--   ext_tport_timerenable_wr : in std_logic;
--   ext_tport_seqnumclr_wr : in std_logic;
--   ext_tport_enable : in std_logic_vector(15 downto 0);
--   ext_tport_ackenable : in std_logic_vector(15 downto 0);
--   ext_tport_timerenable : in std_logic_vector(15 downto 0);
--   ext_tport_seqnumclr : in std_logic_vector(15 downto 0);
--   ext_rport_enable_wr : in std_logic;
--   ext_rport_seqnumena_wr : in std_logic;
--   ext_rport_seqnumclr_wr : in std_logic;
--   ext_rport_enable : in std_logic_vector(15 downto 0);
--   ext_rport_seqnumena : in std_logic_vector(15 downto 0);
--   ext_rport_seqnumclr : in std_logic_vector(15 downto 0);
--   ext_tport_srcfilterena : in std_logic_vector(15 downto 0);
--   ext_tport_srcfilterena_wr : in std_logic;
--   ext_tport_srcfilter : in std_logic_vector(3 downto 0);
--   ext_tport_srcfilteraddr : in std_logic_vector(7 downto 0);
--   ext_tport_srcfilterport : in std_logic_vector(3 downto 0);
--   ext_tport_srcfilter_wr : in std_logic;
--   ext_rport_srcfilterena : in std_logic_vector(15 downto 0);
--   ext_rport_srcfilterena_wr : in std_logic;
--   ext_rport_srcfilter : in std_logic_vector(3 downto 0);
--   ext_rport_srcfilteraddr : in std_logic_vector(7 downto 0);
--   ext_rport_srcfilterport : in std_logic_vector(3 downto 0);
--   ext_rport_srcfilter_wr : in std_logic;
--   ext_fgen_ena : in std_logic;
--   ext_fgen_loop : in std_logic;
--   ext_fgen_trig : in std_logic_vector(15 downto 0);
--   ext_fgen_wr : in std_logic;
--   ext_fgen_destaddr : in std_logic_vector(7 downto 0);
--   ext_fgen_destport : in std_logic_vector(3 downto 0);
--   ext_fgen_destaddr_wr : in std_logic;
--   ext_fgen_destmode : in std_logic_vector(2 downto 0);
--   ext_fgen_destmode_wr : in std_logic;
--   ext_fgen_framelen : in std_logic_vector(10 downto 0);
--   ext_fgen_framelen_wr : in std_logic;
--   grxc : in std_logic;
--   grx_rst : in std_logic;
--   grx_en : in std_logic;
--   grx_er : in std_logic;
--   grxd : in std_logic_vector(7 downto 0);
--   wready : out std_logic_vector(1 to txport1_NPORTS);
--   wempty : out std_logic_vector(1 to txport1_NPORTS);
--   wfull : out std_logic_vector(1 to txport1_NPORTS);
--   werror : out std_logic_vector(1 to txport1_NPORTS);
--   wdatalen : out txport1_framelen_vector_t(1 to txport1_NPORTS);
--   wframes : out txport1_frames_vector_t(1 to txport1_NPORTS);
--   renasts : out std_logic_vector(1 to rxport1_NPORTS);
--   rdata : out rxport1_rdata_vector_t(1 to rxport1_NPORTS);
--   rready : out std_logic_vector(1 to rxport1_NPORTS);
--   rempty : out std_logic_vector(1 to rxport1_NPORTS);
--   rfull : out std_logic_vector(1 to rxport1_NPORTS);
--   rframes : out rxport1_frames_vector_t(1 to rxport1_NPORTS);
--   rsrcaddr : out rxport1_srcaddr_vector_t(1 to rxport1_NPORTS);
--   rsrcport : out rxport1_srcport_vector_t(1 to rxport1_NPORTS);
--   rdatalen : out rxport1_datalen_vector_t(1 to rxport1_NPORTS);
--   rdatacnt : out rxport1_datalen_vector_t(1 to rxport1_NPORTS);
--   rseqnum : out rxport1_seqnum_vector_t(1 to rxport1_NPORTS);
--   reoframe : out std_logic_vector(1 to rxport1_NPORTS);
--   rerrfull : out std_logic_vector(1 to rxport1_NPORTS);
--   rerrempty : out std_logic_vector(1 to rxport1_NPORTS);
--   gtxc : out std_logic;
--   gtx_rst : out std_logic;
--   gtx_en : out std_logic;
--   gtx_er : out std_logic;
--   gtxd : out std_logic_vector(7 downto 0);
--   txseqnum : out txport1_seqnum_vector_t(1 to txport1_NPORTS);
--   rxseqnum : out rxport1_seqnum_vector_t(1 to rxport1_NPORTS);
--   ext_tport_enable_sts : out std_logic_vector(15 downto 0);
--   ext_tport_ackenable_sts : out std_logic_vector(15 downto 0);
--   ext_tport_timerenable_sts : out std_logic_vector(15 downto 0);
--   ext_tport_renable_sts : out std_logic_vector(15 downto 0);
--   ext_tport_rerror_sts : out std_logic_vector(15 downto 0);
--   ext_rport_enable_sts : out std_logic_vector(15 downto 0);
--   ext_rport_seqnumena_sts : out std_logic_vector(15 downto 0);
--   ext_rport_wready_sts : out std_logic_vector(15 downto 0);
--   ext_rport_werrempty_sts : out std_logic_vector(15 downto 0);
--   ext_rport_werrfull_sts : out std_logic_vector(15 downto 0);
--   ext_tport_srcfilterena_sts : out std_logic_vector(15 downto 0);
--   ext_tport_srcfilteraddr_sts : out cmdctrl_byte_vector_t(1 to txport1_NPORTS);
--   ext_tport_srcfilterport_sts : out cmdctrl_nibble_vector_t(1 to txport1_NPORTS);
--   ext_rport_srcfilterena_sts : out std_logic_vector(15 downto 0);
--   ext_rport_srcfilteraddr_sts : out cmdctrl_byte_vector_t(1 to rxport1_NPORTS);
--   ext_rport_srcfilterport_sts : out cmdctrl_nibble_vector_t(1 to rxport1_NPORTS);
--   ext_fgen_ena_sts : out std_logic;
--   ext_fgen_loop_sts : out std_logic;
--   ext_fgen_trig_sts : out std_logic_vector(15 downto 0);
--   ext_fgen_framelen_sts : out std_logic_vector(10 downto 0);
--   ext_fgen_destaddr_sts : out std_logic_vector(7 downto 0);
--   ext_fgen_destport_sts : out std_logic_vector(3 downto 0);
--   ext_fgen_destmode_sts : out std_logic_vector(2 downto 0)
--);
--end component;

begin

--
-- component port map
--
txrxint_inst : txrxint port map
(
   inputs.clk2 => clk2,
   inputs.rst2 => rst2,
   inputs.wclk => wclk,
   inputs.wrst => wrst,
   inputs.nodeaddr => nodeaddr,
   inputs.multicastaddr => multicastaddr,
   inputs.wena => wena,
   inputs.wreq => wreq,
   inputs.wdata => wdata,
   inputs.wframelen => wframelen,
   inputs.wdestport => wdestport,
   inputs.wdestaddr => wdestaddr,
   inputs.wmulticast => wmulticast,
   inputs.wtxreq => wtxreq,
   inputs.wtxclr => wtxclr,
   inputs.rclk => rclk,
   inputs.rrst => rrst,
   inputs.rena => rena,
   inputs.rreq => rreq,
   inputs.rack => rack,
   inputs.ext_tport_enable_wr => ext_tport_enable_wr,
   inputs.ext_tport_ackenable_wr => ext_tport_ackenable_wr,
   inputs.ext_tport_timerenable_wr => ext_tport_timerenable_wr,
   inputs.ext_tport_seqnumclr_wr => ext_tport_seqnumclr_wr,
   inputs.ext_tport_enable => ext_tport_enable,
   inputs.ext_tport_ackenable => ext_tport_ackenable,
   inputs.ext_tport_timerenable => ext_tport_timerenable,
   inputs.ext_tport_seqnumclr => ext_tport_seqnumclr,
   inputs.ext_rport_enable_wr => ext_rport_enable_wr,
   inputs.ext_rport_seqnumena_wr => ext_rport_seqnumena_wr,
   inputs.ext_rport_seqnumclr_wr => ext_rport_seqnumclr_wr,
   inputs.ext_rport_enable => ext_rport_enable,
   inputs.ext_rport_seqnumena => ext_rport_seqnumena,
   inputs.ext_rport_seqnumclr => ext_rport_seqnumclr,
   inputs.ext_tport_srcfilterena => ext_tport_srcfilterena,
   inputs.ext_tport_srcfilterena_wr => ext_tport_srcfilterena_wr,
   inputs.ext_tport_srcfilter => ext_tport_srcfilter,
   inputs.ext_tport_srcfilteraddr => ext_tport_srcfilteraddr,
   inputs.ext_tport_srcfilterport => ext_tport_srcfilterport,
   inputs.ext_tport_srcfilter_wr => ext_tport_srcfilter_wr,
   inputs.ext_rport_srcfilterena => ext_rport_srcfilterena,
   inputs.ext_rport_srcfilterena_wr => ext_rport_srcfilterena_wr,
   inputs.ext_rport_srcfilter => ext_rport_srcfilter,
   inputs.ext_rport_srcfilteraddr => ext_rport_srcfilteraddr,
   inputs.ext_rport_srcfilterport => ext_rport_srcfilterport,
   inputs.ext_rport_srcfilter_wr => ext_rport_srcfilter_wr,
   inputs.ext_fgen_ena => ext_fgen_ena,
   inputs.ext_fgen_loop => ext_fgen_loop,
   inputs.ext_fgen_trig => ext_fgen_trig,
   inputs.ext_fgen_wr => ext_fgen_wr,
   inputs.ext_fgen_destaddr => ext_fgen_destaddr,
   inputs.ext_fgen_destport => ext_fgen_destport,
   inputs.ext_fgen_destaddr_wr => ext_fgen_destaddr_wr,
   inputs.ext_fgen_destmode => ext_fgen_destmode,
   inputs.ext_fgen_destmode_wr => ext_fgen_destmode_wr,
   inputs.ext_fgen_framelen => ext_fgen_framelen,
   inputs.ext_fgen_framelen_wr => ext_fgen_framelen_wr,
   inputs.grxc => grxc,
   inputs.grx_rst => grx_rst,
   inputs.grx_en => grx_en,
   inputs.grx_er => grx_er,
   inputs.grxd => grxd,
   outputs.wready => wready,
   outputs.wempty => wempty,
   outputs.wfull => wfull,
   outputs.werror => werror,
   outputs.wdatalen => wdatalen,
   outputs.wframes => wframes,
   outputs.renasts => renasts,
   outputs.rdata => rdata,
   outputs.rready => rready,
   outputs.rempty => rempty,
   outputs.rfull => rfull,
   outputs.rframes => rframes,
   outputs.rsrcaddr => rsrcaddr,
   outputs.rsrcport => rsrcport,
   outputs.rdatalen => rdatalen,
   outputs.rdatacnt => rdatacnt,
   outputs.rseqnum => rseqnum,
   outputs.reoframe => reoframe,
   outputs.rerrfull => rerrfull,
   outputs.rerrempty => rerrempty,
   outputs.gtxc => gtxc,
   outputs.gtx_rst => gtx_rst,
   outputs.gtx_en => gtx_en,
   outputs.gtx_er => gtx_er,
   outputs.gtxd => gtxd,
   outputs.txseqnum => txseqnum,
   outputs.rxseqnum => rxseqnum,
   outputs.ext_tport_enable_sts => ext_tport_enable_sts,
   outputs.ext_tport_ackenable_sts => ext_tport_ackenable_sts,
   outputs.ext_tport_timerenable_sts => ext_tport_timerenable_sts,
   outputs.ext_tport_renable_sts => ext_tport_renable_sts,
   outputs.ext_tport_rerror_sts => ext_tport_rerror_sts,
   outputs.ext_rport_enable_sts => ext_rport_enable_sts,
   outputs.ext_rport_seqnumena_sts => ext_rport_seqnumena_sts,
   outputs.ext_rport_wready_sts => ext_rport_wready_sts,
   outputs.ext_rport_werrempty_sts => ext_rport_werrempty_sts,
   outputs.ext_rport_werrfull_sts => ext_rport_werrfull_sts,
   outputs.ext_tport_srcfilterena_sts => ext_tport_srcfilterena_sts,
   outputs.ext_tport_srcfilteraddr_sts => ext_tport_srcfilteraddr_sts,
   outputs.ext_tport_srcfilterport_sts => ext_tport_srcfilterport_sts,
   outputs.ext_rport_srcfilterena_sts => ext_rport_srcfilterena_sts,
   outputs.ext_rport_srcfilteraddr_sts => ext_rport_srcfilteraddr_sts,
   outputs.ext_rport_srcfilterport_sts => ext_rport_srcfilterport_sts,
   outputs.ext_fgen_ena_sts => ext_fgen_ena_sts,
   outputs.ext_fgen_loop_sts => ext_fgen_loop_sts,
   outputs.ext_fgen_trig_sts => ext_fgen_trig_sts,
   outputs.ext_fgen_framelen_sts => ext_fgen_framelen_sts,
   outputs.ext_fgen_destaddr_sts => ext_fgen_destaddr_sts,
   outputs.ext_fgen_destport_sts => ext_fgen_destport_sts,
   outputs.ext_fgen_destmode_sts => ext_fgen_destmode_sts
);

end rtl;
