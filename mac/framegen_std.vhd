--**************************************************************
--**************************************************************
--
-- Template file: cint_all.std (RecType --> Std)
--
--**************************************************************
--**************************************************************
--
--
-- Component framegen interface (entity, architecture)
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
-- framegen_std entity declaration (constant)
--

-- Standard libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_framegen.all;
--
use work.globals.all;
use work.component_txport1.all;

entity framegen_std is
port
(
   tx_clk : in std_logic;
   reset_tx_clk : in std_logic;
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
   tport_wready : in std_logic_vector(1 to txport1_NPORTS);
   tport_wempty : in std_logic_vector(1 to txport1_NPORTS);
   tport_wfull : in std_logic_vector(1 to txport1_NPORTS);
   tport_werror : in std_logic_vector(1 to txport1_NPORTS);
   tport_wdatalen : in txport1_framelen_vector_t(1 to txport1_NPORTS);
   tport_wframes : in txport1_frames_vector_t(1 to txport1_NPORTS);
   fgen_wr : in std_logic;
   fgen_ena : in std_logic;
   fgen_loop : in std_logic;
   fgen_trig : in std_logic_vector(1 to txport1_NPORTS);
   fgen_framelen : in std_logic_vector(10 downto 0);
   fgen_destaddr : in std_logic_vector(7 downto 0);
   fgen_destport : in std_logic_vector(3 downto 0);
   fgen_destmode : in std_logic_vector(2 downto 0);
   tport_wena : out std_logic_vector(1 to txport1_NPORTS);
   tport_wreq : out std_logic_vector(1 to txport1_NPORTS);
   tport_wdata : out txport1_wdata_vector_t(1 to txport1_NPORTS);
   tport_wframelen : out txport1_framelen_vector_t(1 to txport1_NPORTS);
   tport_wdestport : out txport1_destport_vector_t(1 to txport1_NPORTS);
   tport_wdestaddr : out txport1_destaddr_vector_t(1 to txport1_NPORTS);
   tport_wmulticast : out std_logic_vector(1 to txport1_NPORTS);
   tport_wtxreq : out std_logic_vector(1 to txport1_NPORTS);
   tport_wtxclr : out std_logic_vector(1 to txport1_NPORTS);
   wready : out std_logic_vector(1 to txport1_NPORTS);
   wempty : out std_logic_vector(1 to txport1_NPORTS);
   wfull : out std_logic_vector(1 to txport1_NPORTS);
   werror : out std_logic_vector(1 to txport1_NPORTS);
   wdatalen : out txport1_framelen_vector_t(1 to txport1_NPORTS);
   wframes : out txport1_frames_vector_t(1 to txport1_NPORTS)
);
end framegen_std;

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

-- Local libraries (constant)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_framegen.all;

architecture rtl of framegen_std is

--
-- framegen component declaration (constant)
--
--component framegen_std
--port
--(
--   tx_clk : in std_logic;
--   reset_tx_clk : in std_logic;
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
--   tport_wready : in std_logic_vector(1 to txport1_NPORTS);
--   tport_wempty : in std_logic_vector(1 to txport1_NPORTS);
--   tport_wfull : in std_logic_vector(1 to txport1_NPORTS);
--   tport_werror : in std_logic_vector(1 to txport1_NPORTS);
--   tport_wdatalen : in txport1_framelen_vector_t(1 to txport1_NPORTS);
--   tport_wframes : in txport1_frames_vector_t(1 to txport1_NPORTS);
--   fgen_wr : in std_logic;
--   fgen_ena : in std_logic;
--   fgen_loop : in std_logic;
--   fgen_trig : in std_logic_vector(1 to txport1_NPORTS);
--   fgen_framelen : in std_logic_vector(10 downto 0);
--   fgen_destaddr : in std_logic_vector(7 downto 0);
--   fgen_destport : in std_logic_vector(3 downto 0);
--   fgen_destmode : in std_logic_vector(2 downto 0);
--   tport_wena : out std_logic_vector(1 to txport1_NPORTS);
--   tport_wreq : out std_logic_vector(1 to txport1_NPORTS);
--   tport_wdata : out txport1_wdata_vector_t(1 to txport1_NPORTS);
--   tport_wframelen : out txport1_framelen_vector_t(1 to txport1_NPORTS);
--   tport_wdestport : out txport1_destport_vector_t(1 to txport1_NPORTS);
--   tport_wdestaddr : out txport1_destaddr_vector_t(1 to txport1_NPORTS);
--   tport_wmulticast : out std_logic_vector(1 to txport1_NPORTS);
--   tport_wtxreq : out std_logic_vector(1 to txport1_NPORTS);
--   tport_wtxclr : out std_logic_vector(1 to txport1_NPORTS);
--   wready : out std_logic_vector(1 to txport1_NPORTS);
--   wempty : out std_logic_vector(1 to txport1_NPORTS);
--   wfull : out std_logic_vector(1 to txport1_NPORTS);
--   werror : out std_logic_vector(1 to txport1_NPORTS);
--   wdatalen : out txport1_framelen_vector_t(1 to txport1_NPORTS);
--   wframes : out txport1_frames_vector_t(1 to txport1_NPORTS)
--);
--end component;

begin

--
-- component port map
--
framegen_inst : framegen port map
(
   inputs.tx_clk => tx_clk,
   inputs.reset_tx_clk => reset_tx_clk,
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
   inputs.tport_wready => tport_wready,
   inputs.tport_wempty => tport_wempty,
   inputs.tport_wfull => tport_wfull,
   inputs.tport_werror => tport_werror,
   inputs.tport_wdatalen => tport_wdatalen,
   inputs.tport_wframes => tport_wframes,
   inputs.fgen_wr => fgen_wr,
   inputs.fgen_ena => fgen_ena,
   inputs.fgen_loop => fgen_loop,
   inputs.fgen_trig => fgen_trig,
   inputs.fgen_framelen => fgen_framelen,
   inputs.fgen_destaddr => fgen_destaddr,
   inputs.fgen_destport => fgen_destport,
   inputs.fgen_destmode => fgen_destmode,
   outputs.tport_wena => tport_wena,
   outputs.tport_wreq => tport_wreq,
   outputs.tport_wdata => tport_wdata,
   outputs.tport_wframelen => tport_wframelen,
   outputs.tport_wdestport => tport_wdestport,
   outputs.tport_wdestaddr => tport_wdestaddr,
   outputs.tport_wmulticast => tport_wmulticast,
   outputs.tport_wtxreq => tport_wtxreq,
   outputs.tport_wtxclr => tport_wtxclr,
   outputs.wready => wready,
   outputs.wempty => wempty,
   outputs.wfull => wfull,
   outputs.werror => werror,
   outputs.wdatalen => wdatalen,
   outputs.wframes => wframes
);

end rtl;
