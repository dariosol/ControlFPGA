--**************************************************************
--**************************************************************
--
-- Template file: cint_all.std (RecType --> Std)
--
--**************************************************************
--**************************************************************
--
--
-- Component mac_gmii interface (entity, architecture)
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
-- mac_gmii_std entity declaration (constant)
--

-- Standard libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_mac_gmii.all;
--
use work.globals.all;
use work.component_txport1.all;
use work.component_rxport1.all;

entity mac_gmii_std is
port
(
   clk : in std_logic;
   tx_clk : in std_logic;
   rx_clk : in std_logic;
   reset_clk : in std_logic;
   reset_tx_clk : in std_logic;
   reset_rx_clk : in std_logic;
   grx_en : in std_logic;
   grx_er : in std_logic;
   grxd : in std_logic_vector(7 downto 0);
   mmaddress : in std_logic_vector(3 downto 0);
   mmread : in std_logic;
   mmwrite : in std_logic;
   mmwritedata : in std_logic_vector(31 downto 0);
   nodeaddr : in std_logic_vector(7 downto 0);
   multicastaddr : in std_logic_vector(7 downto 0);
   wclk : in std_logic_vector(1 to txport1_NPORTS);
   wrst : in std_logic_vector(1 to txport1_NPORTS);
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
   gtx_en : out std_logic;
   gtx_er : out std_logic;
   gtxd : out std_logic_vector(7 downto 0);
   mmreaddata : out std_logic_vector(31 downto 0);
   mmreaddatavalid : out std_logic;
   mmwaitrequest : out std_logic;
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
   rerrempty : out std_logic_vector(1 to rxport1_NPORTS)
);
end mac_gmii_std;

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

-- Local libraries (constant)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_mac_gmii.all;

architecture rtl of mac_gmii_std is

--
-- mac_gmii component declaration (constant)
--
--component mac_gmii_std
--port
--(
--   clk : in std_logic;
--   tx_clk : in std_logic;
--   rx_clk : in std_logic;
--   reset_clk : in std_logic;
--   reset_tx_clk : in std_logic;
--   reset_rx_clk : in std_logic;
--   grx_en : in std_logic;
--   grx_er : in std_logic;
--   grxd : in std_logic_vector(7 downto 0);
--   mmaddress : in std_logic_vector(3 downto 0);
--   mmread : in std_logic;
--   mmwrite : in std_logic;
--   mmwritedata : in std_logic_vector(31 downto 0);
--   nodeaddr : in std_logic_vector(7 downto 0);
--   multicastaddr : in std_logic_vector(7 downto 0);
--   wclk : in std_logic_vector(1 to txport1_NPORTS);
--   wrst : in std_logic_vector(1 to txport1_NPORTS);
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
--   gtx_en : out std_logic;
--   gtx_er : out std_logic;
--   gtxd : out std_logic_vector(7 downto 0);
--   mmreaddata : out std_logic_vector(31 downto 0);
--   mmreaddatavalid : out std_logic;
--   mmwaitrequest : out std_logic;
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
--   rerrempty : out std_logic_vector(1 to rxport1_NPORTS)
--);
--end component;

begin

--
-- component port map
--
mac_gmii_inst : mac_gmii port map
(
   inputs.clk => clk,
   inputs.tx_clk => tx_clk,
   inputs.rx_clk => rx_clk,
   inputs.reset_clk => reset_clk,
   inputs.reset_tx_clk => reset_tx_clk,
   inputs.reset_rx_clk => reset_rx_clk,
   inputs.grx_en => grx_en,
   inputs.grx_er => grx_er,
   inputs.grxd => grxd,
   inputs.mmaddress => mmaddress,
   inputs.mmread => mmread,
   inputs.mmwrite => mmwrite,
   inputs.mmwritedata => mmwritedata,
   inputs.nodeaddr => nodeaddr,
   inputs.multicastaddr => multicastaddr,
   inputs.wclk => wclk,
   inputs.wrst => wrst,
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
   outputs.gtx_en => gtx_en,
   outputs.gtx_er => gtx_er,
   outputs.gtxd => gtxd,
   outputs.mmreaddata => mmreaddata,
   outputs.mmreaddatavalid => mmreaddatavalid,
   outputs.mmwaitrequest => mmwaitrequest,
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
   outputs.rerrempty => rerrempty
);

end rtl;
