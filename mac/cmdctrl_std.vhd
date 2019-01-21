--**************************************************************
--**************************************************************
--
-- Template file: cint_all.std (RecType --> Std)
--
--**************************************************************
--**************************************************************
--
--
-- Component cmdctrl interface (entity, architecture)
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
-- cmdctrl_std entity declaration (constant)
--

-- Standard libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_cmdctrl.all;
-- 
use work.component_txport1.all;
use work.component_rxport1.all;
-- note: components txport1,rxport1 are included at package level because 
-- some I/O definitions use constants 'txport1_NPORTS','rxport1_NPORTS'

entity cmdctrl_std is
port
(
   clk2 : in std_logic;
   rst2 : in std_logic;
   tport_renable : in std_logic_vector(1 to txport1_NPORTS);
   tport_rerror : in std_logic_vector(1 to txport1_NPORTS);
   tport_rseqnum : in cmdctrl_seqnum_vector_t(1 to txport1_NPORTS);
   rport_wready : in std_logic_vector(1 to rxport1_NPORTS);
   rport_rxseqnum : in cmdctrl_seqnum_vector_t(1 to rxport1_NPORTS);
   rport_werrempty : in std_logic_vector(1 to rxport1_NPORTS);
   rport_werrfull : in std_logic_vector(1 to rxport1_NPORTS);
   tx_enablests : in std_logic;
   tx_cmddone : in std_logic;
   tx_cmdregfull : in std_logic;
   rx_enablests : in std_logic;
   rx_cmdready : in std_logic;
   rx_cmdsrcport : in std_logic_vector(3 downto 0);
   rx_cmddestaddr : in std_logic_vector(7 downto 0);
   rx_cmdsrcaddr : in std_logic_vector(7 downto 0);
   rx_cmdcode : in std_logic_vector(7 downto 0);
   rx_cmdports : in std_logic_vector(7 downto 0);
   rx_cmdparams : in cmdctrl_byte_vector_t(0 to 5);
   rx_cmddone : in std_logic;
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
   tport_enable : out std_logic_vector(1 to txport1_NPORTS);
   tport_ackenable : out std_logic_vector(1 to txport1_NPORTS);
   tport_timerenable : out std_logic_vector(1 to txport1_NPORTS);
   tport_cmdseqnumclr : out std_logic_vector(1 to txport1_NPORTS);
   tport_cmdackreceived : out std_logic;
   tport_cmdackportaddr : out std_logic_vector(3 downto 0);
   tport_cmdackseqnum : out std_logic_vector(31 downto 0);
   rport_enable : out std_logic_vector(1 to rxport1_NPORTS);
   rport_seqnumena : out std_logic_vector(1 to rxport1_NPORTS);
   rport_seqnumclr : out std_logic_vector(1 to rxport1_NPORTS);
   rport_srcfilterena : out std_logic_vector(1 to rxport1_NPORTS);
   rport_srcfilteraddr : out cmdctrl_byte_vector_t(1 to rxport1_NPORTS);
   rport_srcfilterport : out cmdctrl_nibble_vector_t(1 to rxport1_NPORTS);
   tx_cmdwrite : out std_logic;
   tx_cmddestport : out std_logic_vector(3 downto 0);
   tx_cmddestaddr : out std_logic_vector(7 downto 0);
   tx_cmdcode : out std_logic_vector(7 downto 0);
   tx_cmdports : out std_logic_vector(7 downto 0);
   tx_cmdparams : out cmdctrl_byte_vector_t(0 to 5);
   tx_cmd_txreq : out std_logic;
   tx_cmd_macread : out std_logic;
   tx_cmd_macwrite : out std_logic;
   rx_cmdread : out std_logic;
   fgen_wr : out std_logic;
   fgen_ena : out std_logic;
   fgen_loop : out std_logic;
   fgen_trig : out std_logic_vector(1 to txport1_NPORTS);
   fgen_framelen : out std_logic_vector(10 downto 0);
   fgen_destaddr : out std_logic_vector(7 downto 0);
   fgen_destport : out std_logic_vector(3 downto 0);
   fgen_destmode : out std_logic_vector(2 downto 0);
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
end cmdctrl_std;

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

-- Local libraries (constant)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_cmdctrl.all;

architecture rtl of cmdctrl_std is

--
-- cmdctrl component declaration (constant)
--
--component cmdctrl_std
--port
--(
--   clk2 : in std_logic;
--   rst2 : in std_logic;
--   tport_renable : in std_logic_vector(1 to txport1_NPORTS);
--   tport_rerror : in std_logic_vector(1 to txport1_NPORTS);
--   tport_rseqnum : in cmdctrl_seqnum_vector_t(1 to txport1_NPORTS);
--   rport_wready : in std_logic_vector(1 to rxport1_NPORTS);
--   rport_rxseqnum : in cmdctrl_seqnum_vector_t(1 to rxport1_NPORTS);
--   rport_werrempty : in std_logic_vector(1 to rxport1_NPORTS);
--   rport_werrfull : in std_logic_vector(1 to rxport1_NPORTS);
--   tx_enablests : in std_logic;
--   tx_cmddone : in std_logic;
--   tx_cmdregfull : in std_logic;
--   rx_enablests : in std_logic;
--   rx_cmdready : in std_logic;
--   rx_cmdsrcport : in std_logic_vector(3 downto 0);
--   rx_cmddestaddr : in std_logic_vector(7 downto 0);
--   rx_cmdsrcaddr : in std_logic_vector(7 downto 0);
--   rx_cmdcode : in std_logic_vector(7 downto 0);
--   rx_cmdports : in std_logic_vector(7 downto 0);
--   rx_cmdparams : in cmdctrl_byte_vector_t(0 to 5);
--   rx_cmddone : in std_logic;
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
--   tport_enable : out std_logic_vector(1 to txport1_NPORTS);
--   tport_ackenable : out std_logic_vector(1 to txport1_NPORTS);
--   tport_timerenable : out std_logic_vector(1 to txport1_NPORTS);
--   tport_cmdseqnumclr : out std_logic_vector(1 to txport1_NPORTS);
--   tport_cmdackreceived : out std_logic;
--   tport_cmdackportaddr : out std_logic_vector(3 downto 0);
--   tport_cmdackseqnum : out std_logic_vector(31 downto 0);
--   rport_enable : out std_logic_vector(1 to rxport1_NPORTS);
--   rport_seqnumena : out std_logic_vector(1 to rxport1_NPORTS);
--   rport_seqnumclr : out std_logic_vector(1 to rxport1_NPORTS);
--   rport_srcfilterena : out std_logic_vector(1 to rxport1_NPORTS);
--   rport_srcfilteraddr : out cmdctrl_byte_vector_t(1 to rxport1_NPORTS);
--   rport_srcfilterport : out cmdctrl_nibble_vector_t(1 to rxport1_NPORTS);
--   tx_cmdwrite : out std_logic;
--   tx_cmddestport : out std_logic_vector(3 downto 0);
--   tx_cmddestaddr : out std_logic_vector(7 downto 0);
--   tx_cmdcode : out std_logic_vector(7 downto 0);
--   tx_cmdports : out std_logic_vector(7 downto 0);
--   tx_cmdparams : out cmdctrl_byte_vector_t(0 to 5);
--   tx_cmd_txreq : out std_logic;
--   tx_cmd_macread : out std_logic;
--   tx_cmd_macwrite : out std_logic;
--   rx_cmdread : out std_logic;
--   fgen_wr : out std_logic;
--   fgen_ena : out std_logic;
--   fgen_loop : out std_logic;
--   fgen_trig : out std_logic_vector(1 to txport1_NPORTS);
--   fgen_framelen : out std_logic_vector(10 downto 0);
--   fgen_destaddr : out std_logic_vector(7 downto 0);
--   fgen_destport : out std_logic_vector(3 downto 0);
--   fgen_destmode : out std_logic_vector(2 downto 0);
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
cmdctrl_inst : cmdctrl port map
(
   inputs.clk2 => clk2,
   inputs.rst2 => rst2,
   inputs.tport_renable => tport_renable,
   inputs.tport_rerror => tport_rerror,
   inputs.tport_rseqnum => tport_rseqnum,
   inputs.rport_wready => rport_wready,
   inputs.rport_rxseqnum => rport_rxseqnum,
   inputs.rport_werrempty => rport_werrempty,
   inputs.rport_werrfull => rport_werrfull,
   inputs.tx_enablests => tx_enablests,
   inputs.tx_cmddone => tx_cmddone,
   inputs.tx_cmdregfull => tx_cmdregfull,
   inputs.rx_enablests => rx_enablests,
   inputs.rx_cmdready => rx_cmdready,
   inputs.rx_cmdsrcport => rx_cmdsrcport,
   inputs.rx_cmddestaddr => rx_cmddestaddr,
   inputs.rx_cmdsrcaddr => rx_cmdsrcaddr,
   inputs.rx_cmdcode => rx_cmdcode,
   inputs.rx_cmdports => rx_cmdports,
   inputs.rx_cmdparams => rx_cmdparams,
   inputs.rx_cmddone => rx_cmddone,
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
   outputs.tport_enable => tport_enable,
   outputs.tport_ackenable => tport_ackenable,
   outputs.tport_timerenable => tport_timerenable,
   outputs.tport_cmdseqnumclr => tport_cmdseqnumclr,
   outputs.tport_cmdackreceived => tport_cmdackreceived,
   outputs.tport_cmdackportaddr => tport_cmdackportaddr,
   outputs.tport_cmdackseqnum => tport_cmdackseqnum,
   outputs.rport_enable => rport_enable,
   outputs.rport_seqnumena => rport_seqnumena,
   outputs.rport_seqnumclr => rport_seqnumclr,
   outputs.rport_srcfilterena => rport_srcfilterena,
   outputs.rport_srcfilteraddr => rport_srcfilteraddr,
   outputs.rport_srcfilterport => rport_srcfilterport,
   outputs.tx_cmdwrite => tx_cmdwrite,
   outputs.tx_cmddestport => tx_cmddestport,
   outputs.tx_cmddestaddr => tx_cmddestaddr,
   outputs.tx_cmdcode => tx_cmdcode,
   outputs.tx_cmdports => tx_cmdports,
   outputs.tx_cmdparams => tx_cmdparams,
   outputs.tx_cmd_txreq => tx_cmd_txreq,
   outputs.tx_cmd_macread => tx_cmd_macread,
   outputs.tx_cmd_macwrite => tx_cmd_macwrite,
   outputs.rx_cmdread => rx_cmdread,
   outputs.fgen_wr => fgen_wr,
   outputs.fgen_ena => fgen_ena,
   outputs.fgen_loop => fgen_loop,
   outputs.fgen_trig => fgen_trig,
   outputs.fgen_framelen => fgen_framelen,
   outputs.fgen_destaddr => fgen_destaddr,
   outputs.fgen_destport => fgen_destport,
   outputs.fgen_destmode => fgen_destmode,
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
