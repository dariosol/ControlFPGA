--**************************************************************
--**************************************************************
--
-- Template file: compmap1.rec (Std --> RecType)
--
--**************************************************************
--**************************************************************
--
--
-- Component triggerfifo  
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

package component_triggerfifo is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- triggerfifo inputs (constant)
--
type triggerfifo_inputs_t is record

   -- input list
   aclr : STD_LOGIC;
   data : STD_LOGIC_VECTOR (63 DOWNTO 0);
   rdclk : STD_LOGIC;
   rdreq : STD_LOGIC;
   wrclk : STD_LOGIC;
   wrreq : STD_LOGIC;

end record;

--
-- triggerfifo outputs (constant)
--
type triggerfifo_outputs_t is record

   -- output list
   q : STD_LOGIC_VECTOR (63 DOWNTO 0);
   rdempty : STD_LOGIC;
   rdfull : STD_LOGIC;
   rdusedw : STD_LOGIC_VECTOR (9 DOWNTO 0);
   wrempty : STD_LOGIC;
   wrfull : STD_LOGIC;
   wrusedw : STD_LOGIC_VECTOR (9 DOWNTO 0);

end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- triggerfifo component common interface (constant)
--
type triggerfifo_t is record
   inputs : triggerfifo_inputs_t;
   outputs : triggerfifo_outputs_t;
end record;

--
-- triggerfifo vector type (constant)
--
type triggerfifo_vector_t is array(NATURAL RANGE <>) of triggerfifo_t;

--
-- triggerfifo component declaration (constant)
--
component triggerfifo
port (
   inputs : in triggerfifo_inputs_t;
   outputs : out triggerfifo_outputs_t
);
end component;

--
-- triggerfifo global signal to export range/width params (constant)
--
signal component_triggerfifo : triggerfifo_t;

end component_triggerfifo;

--
-- triggerfifo entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_triggerfifo.all;

-- triggerfifo entity (constant)
entity triggerfifo is
port (
   inputs : in triggerfifo_inputs_t;
   outputs : out triggerfifo_outputs_t
);
end triggerfifo;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

architecture rtl of triggerfifo is

--
-- alttriggerfifo component declaration (constant)
--
component alttriggerfifo
port
(
   aclr : in STD_LOGIC  := '0';
   data : in STD_LOGIC_VECTOR (63 DOWNTO 0);
   rdclk : in STD_LOGIC;
   rdreq : in STD_LOGIC;
   wrclk : in STD_LOGIC;
   wrreq : in STD_LOGIC;
   q : out STD_LOGIC_VECTOR (63 DOWNTO 0);
   rdempty : out STD_LOGIC;
   rdfull : out STD_LOGIC;
   rdusedw : out STD_LOGIC_VECTOR (9 DOWNTO 0);
   wrempty : out STD_LOGIC;
   wrfull : out STD_LOGIC;
   wrusedw : out STD_LOGIC_VECTOR (9 DOWNTO 0)
);
end component;

begin

--
-- component port map (constant)
--
alttriggerfifo_inst : alttriggerfifo port map
(
   aclr => inputs.aclr,
   data => inputs.data,
   rdclk => inputs.rdclk,
   rdreq => inputs.rdreq,
   wrclk => inputs.wrclk,
   wrreq => inputs.wrreq,
   q => outputs.q,
   rdempty => outputs.rdempty,
   rdfull => outputs.rdfull,
   rdusedw => outputs.rdusedw,
   wrempty => outputs.wrempty,
   wrfull => outputs.wrfull,
   wrusedw => outputs.wrusedw
);

end rtl;
