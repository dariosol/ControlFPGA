--**************************************************************
--**************************************************************
--
-- Template file: compmap1.rec (Std --> RecType)
--
--**************************************************************
--**************************************************************
--
--
-- Component dpram1  
--
--
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

--**************************************************************
--
--
-- Component Interface
--
--
--**************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package component_dpram1 is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- dpram1 inputs (constant)
--
type dpram1_inputs_t is record

   -- input list
   data : STD_LOGIC_VECTOR (63 DOWNTO 0);
   rdaddress : STD_LOGIC_VECTOR (11 DOWNTO 0);
   rdclock : STD_LOGIC;
   wraddress : STD_LOGIC_VECTOR (8 DOWNTO 0);
   wrclock : STD_LOGIC;
   wren : STD_LOGIC;

end record;

--
-- dpram1 outputs (constant)
--
type dpram1_outputs_t is record

   -- output list
   q : STD_LOGIC_VECTOR (7 DOWNTO 0);

end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- dpram1 component common interface (constant)
--
type dpram1_t is record
   inputs : dpram1_inputs_t;
   outputs : dpram1_outputs_t;
end record;

--
-- dpram1 vector type (constant)
--
type dpram1_vector_t is array(NATURAL RANGE <>) of dpram1_t;

--
-- dpram1 component declaration (constant)
--
component dpram1
port (
   inputs : in dpram1_inputs_t;
   outputs : out dpram1_outputs_t
);
end component;

--
-- dpram1 global signal to export range/width params (constant)
--
signal component_dpram1 : dpram1_t;

end component_dpram1;

--
-- dpram1 entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_dpram1.all;

-- dpram1 entity (constant)
entity dpram1 is
port (
   inputs : in dpram1_inputs_t;
   outputs : out dpram1_outputs_t
);
end dpram1;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

architecture rtl of dpram1 is

--
-- altdpram1_64_8 component declaration (constant)
--
component altdpram1_64_8
port
(
   data : in STD_LOGIC_VECTOR (63 DOWNTO 0);
   rdaddress : in STD_LOGIC_VECTOR (11 DOWNTO 0);
   rdclock : in STD_LOGIC;
   wraddress : in STD_LOGIC_VECTOR (8 DOWNTO 0);
   wrclock : in STD_LOGIC  := '1';
   wren : in STD_LOGIC  := '0';
   q : out STD_LOGIC_VECTOR (7 DOWNTO 0)
);
end component;

begin

--
-- component port map (constant)
--
altdpram1_64_8_inst : altdpram1_64_8 port map
(
   data => inputs.data,
   rdaddress => inputs.rdaddress,
   rdclock => inputs.rdclock,
   wraddress => inputs.wraddress,
   wrclock => inputs.wrclock,
   wren => inputs.wren,
   q => outputs.q
);

end rtl;
