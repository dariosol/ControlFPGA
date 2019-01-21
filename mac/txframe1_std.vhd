--**************************************************************
--**************************************************************
--
-- Template file: cint_all.std (RecType --> Std)
--
--**************************************************************
--**************************************************************
--
--
-- Component txframe1 interface (entity, architecture)
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
-- txframe1_std entity declaration (constant)
--

-- Standard libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_txframe1.all;

entity txframe1_std is
port
(
   clk2 : in std_logic;
   rst2 : in std_logic;
   enable : in std_logic;
   txportreq : in std_logic;
   txportaddr : in std_logic_vector(3 downto 0);
   txdatalen : in std_logic_vector(10 downto 0);
   txframelen : in std_logic_vector(10 downto 0);
   txdestport : in std_logic_vector(3 downto 0);
   txdestaddr : in std_logic_vector(7 downto 0);
   txmulticast : in std_logic;
   txbroadcast : in std_logic;
   txdata : in std_logic_vector(7 downto 0);
   txseqnum : in std_logic_vector(31 downto 0);
   cmdwrite : in std_logic;
   cmddestport : in std_logic_vector(3 downto 0);
   cmddestaddr : in std_logic_vector(7 downto 0);
   cmdcode : in std_logic_vector(7 downto 0);
   cmdports : in std_logic_vector(7 downto 0);
   cmdparams : in txframe1_byte_vector_t(0 to 5);
   cmd_txreq : in std_logic;
   cmd_macread : in std_logic;
   cmd_macwrite : in std_logic;
   txpausereq : in std_logic;
   txpausequanta : in std_logic_vector(15 downto 0);
   pauseload : in std_logic;
   pausequanta : in std_logic_vector(15 downto 0);
   txnodeaddr : in std_logic_vector(7 downto 0);
   txenablests : out std_logic;
   txrdreq : out std_logic;
   txportreqok : out std_logic;
   txframedone : out std_logic;
   txcmddone : out std_logic;
   cmdregfull : out std_logic;
   txpausedone : out std_logic;
   pausetimerdone : out std_logic;
   gtxc : out std_logic;
   gtx_en : out std_logic;
   gtx_er : out std_logic;
   gtxd : out std_logic_vector(7 downto 0)
);
end txframe1_std;

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

-- Local libraries (constant)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_txframe1.all;

architecture rtl of txframe1_std is

--
-- txframe1 component declaration (constant)
--
--component txframe1_std
--port
--(
--   clk2 : in std_logic;
--   rst2 : in std_logic;
--   enable : in std_logic;
--   txportreq : in std_logic;
--   txportaddr : in std_logic_vector(3 downto 0);
--   txdatalen : in std_logic_vector(10 downto 0);
--   txframelen : in std_logic_vector(10 downto 0);
--   txdestport : in std_logic_vector(3 downto 0);
--   txdestaddr : in std_logic_vector(7 downto 0);
--   txmulticast : in std_logic;
--   txbroadcast : in std_logic;
--   txdata : in std_logic_vector(7 downto 0);
--   txseqnum : in std_logic_vector(31 downto 0);
--   cmdwrite : in std_logic;
--   cmddestport : in std_logic_vector(3 downto 0);
--   cmddestaddr : in std_logic_vector(7 downto 0);
--   cmdcode : in std_logic_vector(7 downto 0);
--   cmdports : in std_logic_vector(7 downto 0);
--   cmdparams : in txframe1_byte_vector_t(0 to 5);
--   cmd_txreq : in std_logic;
--   cmd_macread : in std_logic;
--   cmd_macwrite : in std_logic;
--   txpausereq : in std_logic;
--   txpausequanta : in std_logic_vector(15 downto 0);
--   pauseload : in std_logic;
--   pausequanta : in std_logic_vector(15 downto 0);
--   txnodeaddr : in std_logic_vector(7 downto 0);
--   txenablests : out std_logic;
--   txrdreq : out std_logic;
--   txportreqok : out std_logic;
--   txframedone : out std_logic;
--   txcmddone : out std_logic;
--   cmdregfull : out std_logic;
--   txpausedone : out std_logic;
--   pausetimerdone : out std_logic;
--   gtxc : out std_logic;
--   gtx_en : out std_logic;
--   gtx_er : out std_logic;
--   gtxd : out std_logic_vector(7 downto 0)
--);
--end component;

begin

--
-- component port map
--
txframe1_inst : txframe1 port map
(
   inputs.clk2 => clk2,
   inputs.rst2 => rst2,
   inputs.enable => enable,
   inputs.txportreq => txportreq,
   inputs.txportaddr => txportaddr,
   inputs.txdatalen => txdatalen,
   inputs.txframelen => txframelen,
   inputs.txdestport => txdestport,
   inputs.txdestaddr => txdestaddr,
   inputs.txmulticast => txmulticast,
   inputs.txbroadcast => txbroadcast,
   inputs.txdata => txdata,
   inputs.txseqnum => txseqnum,
   inputs.cmdwrite => cmdwrite,
   inputs.cmddestport => cmddestport,
   inputs.cmddestaddr => cmddestaddr,
   inputs.cmdcode => cmdcode,
   inputs.cmdports => cmdports,
   inputs.cmdparams => cmdparams,
   inputs.cmd_txreq => cmd_txreq,
   inputs.cmd_macread => cmd_macread,
   inputs.cmd_macwrite => cmd_macwrite,
   inputs.txpausereq => txpausereq,
   inputs.txpausequanta => txpausequanta,
   inputs.pauseload => pauseload,
   inputs.pausequanta => pausequanta,
   inputs.txnodeaddr => txnodeaddr,
   outputs.txenablests => txenablests,
   outputs.txrdreq => txrdreq,
   outputs.txportreqok => txportreqok,
   outputs.txframedone => txframedone,
   outputs.txcmddone => txcmddone,
   outputs.cmdregfull => cmdregfull,
   outputs.txpausedone => txpausedone,
   outputs.pausetimerdone => pausetimerdone,
   outputs.gtxc => gtxc,
   outputs.gtx_en => gtx_en,
   outputs.gtx_er => gtx_er,
   outputs.gtxd => gtxd
);

end rtl;
