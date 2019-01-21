--**************************************************************
--**************************************************************
--
-- Template file: compmap1.rec (Std --> RecType)
--
--**************************************************************
--**************************************************************
--
--
-- Component sendfifo  
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

package component_sendfifo is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- sendfifo inputs (constant)
--
type sendfifo_inputs_t is record

   -- input list
   aclr : STD_LOGIC;
   data : STD_LOGIC_VECTOR (63 DOWNTO 0);
   rdclk : STD_LOGIC;
   rdreq : STD_LOGIC;
   wrclk : STD_LOGIC;
   wrreq : STD_LOGIC;

end record;

--
-- sendfifo outputs (constant)
--
type sendfifo_outputs_t is record

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
-- sendfifo component common interface (constant)
--
type sendfifo_t is record
   inputs : sendfifo_inputs_t;
   outputs : sendfifo_outputs_t;
end record;

--
-- sendfifo vector type (constant)
--
type sendfifo_vector_t is array(NATURAL RANGE <>) of sendfifo_t;

--
-- sendfifo component declaration (constant)
--
component sendfifo
port (
   inputs : in sendfifo_inputs_t;
   outputs : out sendfifo_outputs_t
);
end component;

--
-- sendfifo global signal to export range/width params (constant)
--
signal component_sendfifo : sendfifo_t;

end component_sendfifo;

--
-- sendfifo entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_sendfifo.all;

-- sendfifo entity (constant)
entity sendfifo is
port (
   inputs : in sendfifo_inputs_t;
   outputs : out sendfifo_outputs_t
);
end sendfifo;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

architecture rtl of sendfifo is

--
-- altsendfifo component declaration (constant)
--
component altsendfifo
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
altsendfifo_inst : altsendfifo port map
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
