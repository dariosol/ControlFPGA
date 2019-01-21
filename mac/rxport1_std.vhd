--**************************************************************
--**************************************************************
--
-- Template file: cint_all.std (RecType --> Std)
--
--**************************************************************
--**************************************************************
--
--
-- Component rxport1 interface (entity, architecture)
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
-- rxport1_std entity declaration (constant)
--

-- Standard libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_rxport1.all;
-- !! Debug !!
use work.component_dcfiforx1.all;
use work.component_dcfiforx2.all;
-- !! Debug !!

entity rxport1_std is
port
(
   rclk : in std_logic_vector(1 to rxport1_NPORTS);
   rrst : in std_logic_vector(1 to rxport1_NPORTS);
   clk2 : in std_logic;
   rst2 : in std_logic;
   rena : in std_logic_vector(1 to rxport1_NPORTS);
   rreq : in std_logic_vector(1 to rxport1_NPORTS);
   rack : in std_logic_vector(1 to rxport1_NPORTS);
   wsrcaddr : in std_logic_vector(7 downto 0);
   wdestport : in std_logic_vector(3 downto 0);
   wsrcport : in std_logic_vector(3 downto 0);
   wseqnum : in std_logic_vector(31 downto 0);
   wdatalen : in std_logic_vector(13 downto 0);
   wdata : in std_logic_vector(7 downto 0);
   wframeok : in std_logic;
   wframedone : in std_logic;
   wreq : in std_logic;
   enable : in std_logic_vector(1 to rxport1_NPORTS);
   seqnumena : in std_logic_vector(1 to rxport1_NPORTS);
   seqnumclr : in std_logic_vector(1 to rxport1_NPORTS);
   srcfilterena : in std_logic_vector(1 to rxport1_NPORTS);
   srcfilteraddr : in rxport1_srcaddr_vector_t(1 to rxport1_NPORTS);
   srcfilterport : in rxport1_srcport_vector_t(1 to rxport1_NPORTS);
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
   wready : out std_logic_vector(1 to rxport1_NPORTS);
   wempty : out std_logic_vector(1 to rxport1_NPORTS);
   wfull : out std_logic_vector(1 to rxport1_NPORTS);
   wframes : out rxport1_frames_vector_t(1 to rxport1_NPORTS);
   rxseqnum : out rxport1_seqnum_vector_t(1 to rxport1_NPORTS);
   werrempty : out std_logic_vector(1 to rxport1_NPORTS);
   werrfull : out std_logic_vector(1 to rxport1_NPORTS);
   rxfifo : out dcfiforx1_vector_t(1 to rxport1_NPORTS);
   rxparamfifo : out dcfiforx2_vector_t(1 to rxport1_NPORTS)
);
end rxport1_std;

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

-- Local libraries (constant)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_rxport1.all;

architecture rtl of rxport1_std is

--
-- rxport1 component declaration (constant)
--
--component rxport1_std
--port
--(
--   rclk : in std_logic_vector(1 to rxport1_NPORTS);
--   rrst : in std_logic_vector(1 to rxport1_NPORTS);
--   clk2 : in std_logic;
--   rst2 : in std_logic;
--   rena : in std_logic_vector(1 to rxport1_NPORTS);
--   rreq : in std_logic_vector(1 to rxport1_NPORTS);
--   rack : in std_logic_vector(1 to rxport1_NPORTS);
--   wsrcaddr : in std_logic_vector(7 downto 0);
--   wdestport : in std_logic_vector(3 downto 0);
--   wsrcport : in std_logic_vector(3 downto 0);
--   wseqnum : in std_logic_vector(31 downto 0);
--   wdatalen : in std_logic_vector(13 downto 0);
--   wdata : in std_logic_vector(7 downto 0);
--   wframeok : in std_logic;
--   wframedone : in std_logic;
--   wreq : in std_logic;
--   enable : in std_logic_vector(1 to rxport1_NPORTS);
--   seqnumena : in std_logic_vector(1 to rxport1_NPORTS);
--   seqnumclr : in std_logic_vector(1 to rxport1_NPORTS);
--   srcfilterena : in std_logic_vector(1 to rxport1_NPORTS);
--   srcfilteraddr : in rxport1_srcaddr_vector_t(1 to rxport1_NPORTS);
--   srcfilterport : in rxport1_srcport_vector_t(1 to rxport1_NPORTS);
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
--   wready : out std_logic_vector(1 to rxport1_NPORTS);
--   wempty : out std_logic_vector(1 to rxport1_NPORTS);
--   wfull : out std_logic_vector(1 to rxport1_NPORTS);
--   wframes : out rxport1_frames_vector_t(1 to rxport1_NPORTS);
--   rxseqnum : out rxport1_seqnum_vector_t(1 to rxport1_NPORTS);
--   werrempty : out std_logic_vector(1 to rxport1_NPORTS);
--   werrfull : out std_logic_vector(1 to rxport1_NPORTS);
--   rxfifo : out dcfiforx1_vector_t(1 to rxport1_NPORTS);
--   rxparamfifo : out dcfiforx2_vector_t(1 to rxport1_NPORTS)
--);
--end component;

begin

--
-- component port map
--
rxport1_inst : rxport1 port map
(
   inputs.rclk => rclk,
   inputs.rrst => rrst,
   inputs.clk2 => clk2,
   inputs.rst2 => rst2,
   inputs.rena => rena,
   inputs.rreq => rreq,
   inputs.rack => rack,
   inputs.wsrcaddr => wsrcaddr,
   inputs.wdestport => wdestport,
   inputs.wsrcport => wsrcport,
   inputs.wseqnum => wseqnum,
   inputs.wdatalen => wdatalen,
   inputs.wdata => wdata,
   inputs.wframeok => wframeok,
   inputs.wframedone => wframedone,
   inputs.wreq => wreq,
   inputs.enable => enable,
   inputs.seqnumena => seqnumena,
   inputs.seqnumclr => seqnumclr,
   inputs.srcfilterena => srcfilterena,
   inputs.srcfilteraddr => srcfilteraddr,
   inputs.srcfilterport => srcfilterport,
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
   outputs.wready => wready,
   outputs.wempty => wempty,
   outputs.wfull => wfull,
   outputs.wframes => wframes,
   outputs.rxseqnum => rxseqnum,
   outputs.werrempty => werrempty,
   outputs.werrfull => werrfull,
   outputs.rxfifo => rxfifo,
   outputs.rxparamfifo => rxparamfifo
);

end rtl;
