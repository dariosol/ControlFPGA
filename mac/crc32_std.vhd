--**************************************************************
--**************************************************************
--
-- Template file: cint_all.std (RecType --> Std)
--
--**************************************************************
--**************************************************************
--
--
-- Component crc32 interface (entity, architecture)
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
-- crc32_std entity declaration (constant)
--

-- Standard libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_crc32.all;

entity crc32_std is
port
(
   clk1 : in std_logic;
   rst1 : in std_logic;
   datavalid : in std_logic;
   data : in std_logic_vector(7 downto 0);
   init : in std_logic;
   fcs : out std_logic_vector(31 downto 0);
   fcserr : out std_logic
);
end crc32_std;

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

-- Local libraries (constant)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_crc32.all;

architecture rtl of crc32_std is

--
-- crc32 component declaration (constant)
--
--component crc32_std
--port
--(
--   clk1 : in std_logic;
--   rst1 : in std_logic;
--   datavalid : in std_logic;
--   data : in std_logic_vector(7 downto 0);
--   init : in std_logic;
--   fcs : out std_logic_vector(31 downto 0);
--   fcserr : out std_logic
--);
--end component;

begin

--
-- component port map
--
crc32_inst : crc32 port map
(
   inputs.clk1 => clk1,
   inputs.rst1 => rst1,
   inputs.datavalid => datavalid,
   inputs.data => data,
   inputs.init => init,
   outputs.fcs => fcs,
   outputs.fcserr => fcserr
);

end rtl;
