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

package component_dpram4bit is

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
   data : STD_LOGIC_VECTOR (3 DOWNTO 0);
   rd_aclr : STD_LOGIC;
   rdaddress : STD_LOGIC_VECTOR (15 DOWNTO 0);
   rdclock : STD_LOGIC;
   rden		:  STD_LOGIC;
   wraddress : STD_LOGIC_VECTOR (15 DOWNTO 0);
   wrclock : STD_LOGIC;
   wren : STD_LOGIC;

end record;

--
-- dpram1 outputs (constant)
--
type dpram1_outputs_t is record

   -- output list
   q : STD_LOGIC_VECTOR (3 DOWNTO 0);

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
type dpram4bit_t is record
   inputs : dpram1_inputs_t;
   outputs : dpram1_outputs_t;
end record;

--
-- dpram1 vector type (constant)
--
type dpram4bit_vector_t is array(NATURAL RANGE <>) of dpram4bit_t;

--
-- dpram1 component declaration (constant)
--
component dpram4bit
port (
   inputs : in dpram1_inputs_t;
   outputs : out dpram1_outputs_t
);
end component;

--
-- dpram1 global signal to export range/width params (constant)
--
signal component_dpram1 : dpram4bit_t;

end component_dpram4bit;

--
-- dpram1 entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_dpram4bit.all;

-- dpram1 entity (constant)
entity dpram4bit is
port (
   inputs : in dpram1_inputs_t;
   outputs : out dpram1_outputs_t
);
end dpram4bit;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

architecture rtl of dpram4bit is

--
-- altdpram1_64_8 component declaration (constant)
--
component altdpram4bit
port
(
        data		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		rd_aclr		: IN STD_LOGIC  := '0';
		rdaddress		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		rdclock		: IN STD_LOGIC ;
		rden		: IN STD_LOGIC  := '1';
		wraddress		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		wrclock		: IN STD_LOGIC  := '1';
		wren		: IN STD_LOGIC  := '0';
		q		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
);
end component;

begin

--
-- component port map (constant)
--
altdpram4bit_inst : altdpram4bit port map
(
   data => inputs.data,
   rd_aclr => inputs.rd_aclr,
   rdaddress => inputs.rdaddress,
   rdclock => inputs.rdclock,
   rden => inputs.rden,
   wraddress => inputs.wraddress,
   wrclock => inputs.wrclock,
   wren => inputs.wren,
   q => outputs.q
);

end rtl;
