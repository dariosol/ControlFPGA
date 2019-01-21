--**************************************************************
--**************************************************************
--
-- Template file: cint_all.std (RecType --> Std)
--
--**************************************************************
--**************************************************************
--
--
-- Component txport1 interface (entity, architecture)
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
-- txport1_std entity declaration (constant)
--

-- Standard libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_txport1.all;
--
use work.globals.all;
use work.component_dcfifo2.all;

entity txport1_std is
port
(
   wclk : in std_logic_vector(1 to txport1_NPORTS);
   wrst : in std_logic_vector(1 to txport1_NPORTS);
   clk2 : in std_logic;
   rst2 : in std_logic;
   wena : in std_logic_vector(1 to txport1_NPORTS);
   wreq : in std_logic_vector(1 to txport1_NPORTS);
   wdata : in txport1_wdata_vector_t(1 to txport1_NPORTS);
   wframelen : in txport1_framelen_vector_t(1 to txport1_NPORTS);
   wdestport : in txport1_destport_vector_t(1 to txport1_NPORTS);
   wdestaddr : in txport1_destaddr_vector_t(1 to txport1_NPORTS);
   wmulticast : in std_logic_vector(1 to txport1_NPORTS);
   wtxreq : in std_logic_vector(1 to txport1_NPORTS);
   wtxclr : in std_logic_vector(1 to txport1_NPORTS);
   txportreqok : in std_logic;
   txrdreq : in std_logic;
   txdone : in std_logic;
   enable : in std_logic_vector(1 to txport1_NPORTS);
   ackenable : in std_logic_vector(1 to txport1_NPORTS);
   timerenable : in std_logic_vector(1 to txport1_NPORTS);
   cmdseqnumclr : in std_logic_vector(1 to txport1_NPORTS);
   cmdackreceived : in std_logic;
   cmdackportaddr : in std_logic_vector(3 downto 0);
   cmdackseqnum : in std_logic_vector(31 downto 0);
   wready : out std_logic_vector(1 to txport1_NPORTS);
   wempty : out std_logic_vector(1 to txport1_NPORTS);
   wfull : out std_logic_vector(1 to txport1_NPORTS);
   werror : out std_logic_vector(1 to txport1_NPORTS);
   wdatalen : out txport1_framelen_vector_t(1 to txport1_NPORTS);
   wframes : out txport1_frames_vector_t(1 to txport1_NPORTS);
   renable : out std_logic_vector(1 to txport1_NPORTS);
   rempty : out std_logic_vector(1 to txport1_NPORTS);
   rfull : out std_logic_vector(1 to txport1_NPORTS);
   rerror : out std_logic_vector(1 to txport1_NPORTS);
   rframes : out txport1_frames_vector_t(1 to txport1_NPORTS);
   rseqnum : out txport1_seqnum_vector_t(1 to txport1_NPORTS);
   txready : out std_logic;
   txportreq : out std_logic;
   txportaddr : out std_logic_vector(3 downto 0);
   txdatalen : out std_logic_vector(10 downto 0);
   txframelen : out std_logic_vector(10 downto 0);
   txdestport : out std_logic_vector(3 downto 0);
   txdestaddr : out std_logic_vector(7 downto 0);
   txmulticast : out std_logic;
   txdata : out std_logic_vector(7 downto 0);
   txempty : out std_logic;
   txseqnum : out std_logic_vector(31 downto 0);
   txrdaddress : out std_logic_vector(11 downto 0);
   txparamfifo : out dcfifo2_vector_t(1 to txport1_NPORTS)
);
end txport1_std;

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

-- Local libraries (constant)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_txport1.all;

architecture rtl of txport1_std is

--
-- txport1 component declaration (constant)
--
--component txport1_std
--port
--(
--   wclk : in std_logic_vector(1 to txport1_NPORTS);
--   wrst : in std_logic_vector(1 to txport1_NPORTS);
--   clk2 : in std_logic;
--   rst2 : in std_logic;
--   wena : in std_logic_vector(1 to txport1_NPORTS);
--   wreq : in std_logic_vector(1 to txport1_NPORTS);
--   wdata : in txport1_wdata_vector_t(1 to txport1_NPORTS);
--   wframelen : in txport1_framelen_vector_t(1 to txport1_NPORTS);
--   wdestport : in txport1_destport_vector_t(1 to txport1_NPORTS);
--   wdestaddr : in txport1_destaddr_vector_t(1 to txport1_NPORTS);
--   wmulticast : in std_logic_vector(1 to txport1_NPORTS);
--   wtxreq : in std_logic_vector(1 to txport1_NPORTS);
--   wtxclr : in std_logic_vector(1 to txport1_NPORTS);
--   txportreqok : in std_logic;
--   txrdreq : in std_logic;
--   txdone : in std_logic;
--   enable : in std_logic_vector(1 to txport1_NPORTS);
--   ackenable : in std_logic_vector(1 to txport1_NPORTS);
--   timerenable : in std_logic_vector(1 to txport1_NPORTS);
--   cmdseqnumclr : in std_logic_vector(1 to txport1_NPORTS);
--   cmdackreceived : in std_logic;
--   cmdackportaddr : in std_logic_vector(3 downto 0);
--   cmdackseqnum : in std_logic_vector(31 downto 0);
--   wready : out std_logic_vector(1 to txport1_NPORTS);
--   wempty : out std_logic_vector(1 to txport1_NPORTS);
--   wfull : out std_logic_vector(1 to txport1_NPORTS);
--   werror : out std_logic_vector(1 to txport1_NPORTS);
--   wdatalen : out txport1_framelen_vector_t(1 to txport1_NPORTS);
--   wframes : out txport1_frames_vector_t(1 to txport1_NPORTS);
--   renable : out std_logic_vector(1 to txport1_NPORTS);
--   rempty : out std_logic_vector(1 to txport1_NPORTS);
--   rfull : out std_logic_vector(1 to txport1_NPORTS);
--   rerror : out std_logic_vector(1 to txport1_NPORTS);
--   rframes : out txport1_frames_vector_t(1 to txport1_NPORTS);
--   rseqnum : out txport1_seqnum_vector_t(1 to txport1_NPORTS);
--   txready : out std_logic;
--   txportreq : out std_logic;
--   txportaddr : out std_logic_vector(3 downto 0);
--   txdatalen : out std_logic_vector(10 downto 0);
--   txframelen : out std_logic_vector(10 downto 0);
--   txdestport : out std_logic_vector(3 downto 0);
--   txdestaddr : out std_logic_vector(7 downto 0);
--   txmulticast : out std_logic;
--   txdata : out std_logic_vector(7 downto 0);
--   txempty : out std_logic;
--   txseqnum : out std_logic_vector(31 downto 0);
--   txrdaddress : out std_logic_vector(11 downto 0);
--   txparamfifo : out dcfifo2_vector_t(1 to txport1_NPORTS)
--);
--end component;

begin

--
-- component port map
--
txport1_inst : txport1 port map
(
   inputs.wclk => wclk,
   inputs.wrst => wrst,
   inputs.clk2 => clk2,
   inputs.rst2 => rst2,
   inputs.wena => wena,
   inputs.wreq => wreq,
   inputs.wdata => wdata,
   inputs.wframelen => wframelen,
   inputs.wdestport => wdestport,
   inputs.wdestaddr => wdestaddr,
   inputs.wmulticast => wmulticast,
   inputs.wtxreq => wtxreq,
   inputs.wtxclr => wtxclr,
   inputs.txportreqok => txportreqok,
   inputs.txrdreq => txrdreq,
   inputs.txdone => txdone,
   inputs.enable => enable,
   inputs.ackenable => ackenable,
   inputs.timerenable => timerenable,
   inputs.cmdseqnumclr => cmdseqnumclr,
   inputs.cmdackreceived => cmdackreceived,
   inputs.cmdackportaddr => cmdackportaddr,
   inputs.cmdackseqnum => cmdackseqnum,
   outputs.wready => wready,
   outputs.wempty => wempty,
   outputs.wfull => wfull,
   outputs.werror => werror,
   outputs.wdatalen => wdatalen,
   outputs.wframes => wframes,
   outputs.renable => renable,
   outputs.rempty => rempty,
   outputs.rfull => rfull,
   outputs.rerror => rerror,
   outputs.rframes => rframes,
   outputs.rseqnum => rseqnum,
   outputs.txready => txready,
   outputs.txportreq => txportreq,
   outputs.txportaddr => txportaddr,
   outputs.txdatalen => txdatalen,
   outputs.txframelen => txframelen,
   outputs.txdestport => txdestport,
   outputs.txdestaddr => txdestaddr,
   outputs.txmulticast => txmulticast,
   outputs.txdata => txdata,
   outputs.txempty => txempty,
   outputs.txseqnum => txseqnum,
   outputs.txrdaddress => txrdaddress,
   outputs.txparamfifo => txparamfifo
);

end rtl;
