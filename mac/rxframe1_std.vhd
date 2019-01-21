--**************************************************************
--**************************************************************
--
-- Template file: cint_all.std (RecType --> Std)
--
--**************************************************************
--**************************************************************
--
--
-- Component rxframe1 interface (entity, architecture)
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
-- rxframe1_std entity declaration (constant)
--

-- Standard libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_rxframe1.all;

entity rxframe1_std is
port
(
   clk1 : in std_logic;
   clk2 : in std_logic;
   rst1 : in std_logic;
   rst2 : in std_logic;
   enable : in std_logic;
   maxframelen : in std_logic_vector(13 downto 0);
   nodeaddr : in std_logic_vector(7 downto 0);
   multicastaddr : in std_logic_vector(7 downto 0);
   mode_destaddr_unicast : in std_logic;
   mode_destaddr_multicast : in std_logic;
   mode_destaddr_broadcast : in std_logic;
   mode_pause : in std_logic;
   mode_data : in std_logic;
   mode_cmd : in std_logic;
   cmdread : in std_logic;
   grx_en : in std_logic;
   grx_er : in std_logic;
   grxd : in std_logic_vector(7 downto 0);
   rxenablests : out std_logic;
   rxdata : out std_logic_vector(7 downto 0);
   rxdatalen : out std_logic_vector(13 downto 0);
   rxdestaddr : out std_logic_vector(7 downto 0);
   rxmulticast : out std_logic;
   rxsrcaddr : out std_logic_vector(7 downto 0);
   rxdestport : out std_logic_vector(3 downto 0);
   rxsrcport : out std_logic_vector(3 downto 0);
   rxseqnum : out std_logic_vector(31 downto 0);
   rxldata : out std_logic_vector(15 downto 0);
   rxwrreq : out std_logic;
   rxframeok : out std_logic;
   rxframedone : out std_logic;
   pausequanta : out std_logic_vector(15 downto 0);
   pausedone : out std_logic;
   cmdready : out std_logic;
   cmdsrcport : out std_logic_vector(3 downto 0);
   cmddestaddr : out std_logic_vector(7 downto 0);
   cmdsrcaddr : out std_logic_vector(7 downto 0);
   cmdcode : out std_logic_vector(7 downto 0);
   cmdports : out std_logic_vector(7 downto 0);
   cmdparams : out rxframe1_byte_vector_t(0 to 5);
   cmddone : out std_logic
);
end rxframe1_std;

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

-- Local libraries (constant)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_rxframe1.all;

architecture rtl of rxframe1_std is

--
-- rxframe1 component declaration (constant)
--
--component rxframe1_std
--port
--(
--   clk1 : in std_logic;
--   clk2 : in std_logic;
--   rst1 : in std_logic;
--   rst2 : in std_logic;
--   enable : in std_logic;
--   maxframelen : in std_logic_vector(13 downto 0);
--   nodeaddr : in std_logic_vector(7 downto 0);
--   multicastaddr : in std_logic_vector(7 downto 0);
--   mode_destaddr_unicast : in std_logic;
--   mode_destaddr_multicast : in std_logic;
--   mode_destaddr_broadcast : in std_logic;
--   mode_pause : in std_logic;
--   mode_data : in std_logic;
--   mode_cmd : in std_logic;
--   cmdread : in std_logic;
--   grx_en : in std_logic;
--   grx_er : in std_logic;
--   grxd : in std_logic_vector(7 downto 0);
--   rxenablests : out std_logic;
--   rxdata : out std_logic_vector(7 downto 0);
--   rxdatalen : out std_logic_vector(13 downto 0);
--   rxdestaddr : out std_logic_vector(7 downto 0);
--   rxmulticast : out std_logic;
--   rxsrcaddr : out std_logic_vector(7 downto 0);
--   rxdestport : out std_logic_vector(3 downto 0);
--   rxsrcport : out std_logic_vector(3 downto 0);
--   rxseqnum : out std_logic_vector(31 downto 0);
--   rxldata : out std_logic_vector(15 downto 0);
--   rxwrreq : out std_logic;
--   rxframeok : out std_logic;
--   rxframedone : out std_logic;
--   pausequanta : out std_logic_vector(15 downto 0);
--   pausedone : out std_logic;
--   cmdready : out std_logic;
--   cmdsrcport : out std_logic_vector(3 downto 0);
--   cmddestaddr : out std_logic_vector(7 downto 0);
--   cmdsrcaddr : out std_logic_vector(7 downto 0);
--   cmdcode : out std_logic_vector(7 downto 0);
--   cmdports : out std_logic_vector(7 downto 0);
--   cmdparams : out rxframe1_byte_vector_t(0 to 5);
--   cmddone : out std_logic
--);
--end component;

begin

--
-- component port map
--
rxframe1_inst : rxframe1 port map
(
   inputs.clk1 => clk1,
   inputs.clk2 => clk2,
   inputs.rst1 => rst1,
   inputs.rst2 => rst2,
   inputs.enable => enable,
   inputs.maxframelen => maxframelen,
   inputs.nodeaddr => nodeaddr,
   inputs.multicastaddr => multicastaddr,
   inputs.mode_destaddr_unicast => mode_destaddr_unicast,
   inputs.mode_destaddr_multicast => mode_destaddr_multicast,
   inputs.mode_destaddr_broadcast => mode_destaddr_broadcast,
   inputs.mode_pause => mode_pause,
   inputs.mode_data => mode_data,
   inputs.mode_cmd => mode_cmd,
   inputs.cmdread => cmdread,
   inputs.grx_en => grx_en,
   inputs.grx_er => grx_er,
   inputs.grxd => grxd,
   outputs.rxenablests => rxenablests,
   outputs.rxdata => rxdata,
   outputs.rxdatalen => rxdatalen,
   outputs.rxdestaddr => rxdestaddr,
   outputs.rxmulticast => rxmulticast,
   outputs.rxsrcaddr => rxsrcaddr,
   outputs.rxdestport => rxdestport,
   outputs.rxsrcport => rxsrcport,
   outputs.rxseqnum => rxseqnum,
   outputs.rxldata => rxldata,
   outputs.rxwrreq => rxwrreq,
   outputs.rxframeok => rxframeok,
   outputs.rxframedone => rxframedone,
   outputs.pausequanta => pausequanta,
   outputs.pausedone => pausedone,
   outputs.cmdready => cmdready,
   outputs.cmdsrcport => cmdsrcport,
   outputs.cmddestaddr => cmddestaddr,
   outputs.cmdsrcaddr => cmdsrcaddr,
   outputs.cmdcode => cmdcode,
   outputs.cmdports => cmdports,
   outputs.cmdparams => cmdparams,
   outputs.cmddone => cmddone
);

end rtl;
