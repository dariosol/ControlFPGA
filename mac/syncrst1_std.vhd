--**************************************************************
--**************************************************************
--
-- Template file: cint_all.std (RecType --> Std)
--
--**************************************************************
--**************************************************************
--
--
-- Component syncrst1 interface (entity, architecture)
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
-- syncrst1_std entity declaration (constant)
--

-- Standard libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_syncrst1.all;

entity syncrst1_std is
port
(
   clk : in std_logic_vector(1 to syncrst1_SIZE);
   clr : in std_logic_vector(1 to syncrst1_SIZE);
   rst : out std_logic_vector(1 to syncrst1_SIZE)
);
end syncrst1_std;

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

-- Local libraries (constant)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_syncrst1.all;

architecture rtl of syncrst1_std is

--
-- syncrst1 component declaration (constant)
--
--component syncrst1_std
--port
--(
--   clk : in std_logic_vector(1 to syncrst1_SIZE);
--   clr : in std_logic_vector(1 to syncrst1_SIZE);
--   rst : out std_logic_vector(1 to syncrst1_SIZE)
--);
--end component;

begin

--
-- component port map
--
syncrst1_inst : syncrst1 port map
(
   inputs.clk => clk,
   inputs.clr => clr,
   outputs.rst => rst
);

end rtl;
