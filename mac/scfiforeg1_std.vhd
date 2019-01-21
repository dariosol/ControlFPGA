--**************************************************************
--**************************************************************
--
-- Template file: cint_all.std (RecType --> Std)
--
--**************************************************************
--**************************************************************
--
--
-- Component scfiforeg1 interface (entity, architecture)
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
-- scfiforeg1_std entity declaration (constant)
--

-- Standard libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_scfiforeg1.all;

entity scfiforeg1_std is
port
(
   aclr : in STD_LOGIC;
   clock : in STD_LOGIC;
   data : in STD_LOGIC_VECTOR (7 DOWNTO 0);
   rdreq : in STD_LOGIC;
   sclr : in STD_LOGIC;
   wrreq : in STD_LOGIC;
   empty : out STD_LOGIC;
   full : out STD_LOGIC;
   q : out STD_LOGIC_VECTOR (7 DOWNTO 0)
);
end scfiforeg1_std;

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

-- Local libraries (constant)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_scfiforeg1.all;

architecture rtl of scfiforeg1_std is

--
-- scfiforeg1 component declaration (constant)
--
--component scfiforeg1_std
--port
--(
--   aclr : in STD_LOGIC;
--   clock : in STD_LOGIC;
--   data : in STD_LOGIC_VECTOR (7 DOWNTO 0);
--   rdreq : in STD_LOGIC;
--   sclr : in STD_LOGIC;
--   wrreq : in STD_LOGIC;
--   empty : out STD_LOGIC;
--   full : out STD_LOGIC;
--   q : out STD_LOGIC_VECTOR (7 DOWNTO 0)
--);
--end component;

begin

--
-- component port map
--
scfiforeg1_inst : scfiforeg1 port map
(
   inputs.aclr => aclr,
   inputs.clock => clock,
   inputs.data => data,
   inputs.rdreq => rdreq,
   inputs.sclr => sclr,
   inputs.wrreq => wrreq,
   outputs.empty => empty,
   outputs.full => full,
   outputs.q => q
);

end rtl;
