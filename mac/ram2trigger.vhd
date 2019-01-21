--DPRAM 32 bit for data coming from pc trigger
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

package component_ram2trigger is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- ram2trigger inputs (constant)
--
type ram2trigger_inputs_t is record

   -- input list
      rdaddress		:  STD_LOGIC_VECTOR (13 DOWNTO 0);
		wraddress		:  STD_LOGIC_VECTOR (13	DOWNTO 0);
		clock		   :  STD_LOGIC ;
		data		   :  STD_LOGIC_VECTOR (63 DOWNTO 0);
		wren		:  STD_LOGIC  ;
		rden		:  STD_LOGIC  ;
end record;

--
--  ram2trigger outputs (constant)
--
type ram2trigger_outputs_t is record

   -- output list
	q		:  STD_LOGIC_VECTOR (63	DOWNTO 0);

end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- ram2trigger component common interface (constant)
--
type ram2trigger_t is record
   inputs  : ram2trigger_inputs_t;
   outputs : ram2trigger_outputs_t;
end record;

--
-- ram2trigger vector type (constant)
--
type ram2trigger_vector_t is array(NATURAL RANGE <>) of ram2trigger_t;

--
--  ram2trigger component declaration (constant)
--
component ram2trigger
port (
   inputs  : in ram2trigger_inputs_t;
   outputs : out ram2trigger_outputs_t
);
end component;

--
-- ram2trigger global signal to export params (constant)
--
signal component_ram2trigger : ram2trigger_t;

end component_ram2trigger;

--
-- ram2trigger entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_ram2trigger.all;

--  ram2trigger entity (constant)
entity ram2trigger is
port (
   inputs  : in ram2trigger_inputs_t;
   outputs : out ram2trigger_outputs_t
);
end ram2trigger;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

architecture rtl of ram2trigger is

--
-- altdpramDARIO component declaration (constant)
--
component altram2trigger
port
(
      clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (63 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		rden		: IN STD_LOGIC  := '1';
		wraddress		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		wren		: IN STD_LOGIC  := '0';
		q		: OUT STD_LOGIC_VECTOR (63 DOWNTO 0)
);
end component;

begin

--
-- component port map (constant)
--
altram2trigger_inst : altram2trigger port map
(
   wraddress=>inputs.wraddress,
	rdaddress=>inputs.rdaddress,
	clock=>inputs.clock,
	data=>inputs.data,
	wren=>inputs.wren,
	rden=>inputs.rden,
	q =>outputs.q
	);

end rtl;
