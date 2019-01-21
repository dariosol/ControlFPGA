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

package component_latencyram is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- latencyram inputs (constant)
--
type latencyram_inputs_t is record

   -- input list
      address_a		:  STD_LOGIC_VECTOR (14 DOWNTO 0);
		address_b		:  STD_LOGIC_VECTOR (14 DOWNTO 0);
		clock_a		:  STD_LOGIC ;
		clock_b		:  STD_LOGIC ;
		data_a		:  STD_LOGIC_VECTOR (7 DOWNTO 0);
		data_b		:  STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren_a		:  STD_LOGIC  ;
		wren_b		:  STD_LOGIC  ;
end record;

--
--  latencyram outputs (constant)
--
type latencyram_outputs_t is record

   -- output list
	q_a		:  STD_LOGIC_VECTOR (7	DOWNTO 0);
	q_b		:  STD_LOGIC_VECTOR (7 DOWNTO 0);

end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- latencyram component common interface (constant)
--
type latencyram_t is record
   inputs  : latencyram_inputs_t;
   outputs : latencyram_outputs_t;
end record;

--
-- latencyram vector type (constant)
--
type latencyram_vector_t is array(NATURAL RANGE <>) of latencyram_t;

--
--  latencyram component declaration (constant)
--
component latencyram
port (
   inputs  : in latencyram_inputs_t;
   outputs : out latencyram_outputs_t
);
end component;

--
-- latencyram global signal to export params (constant)
--
signal component_latencyram : latencyram_t;

end component_latencyram;

--
-- latencyram entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_latencyram.all;

--  latencyram entity (constant)
entity latencyram is
port (
   inputs  : in latencyram_inputs_t;
   outputs : out latencyram_outputs_t
);
end latencyram;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

architecture rtl of latencyram is

--
-- altdpramDARIO component declaration (constant)
--
component altlatencyram
port
(
      address_a		: IN STD_LOGIC_VECTOR (14 DOWNTO 0);
		address_b	: IN STD_LOGIC_VECTOR (14 DOWNTO 0);
		clock_a		: IN STD_LOGIC  := '1';
		clock_b		: IN STD_LOGIC ;
		data_a		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data_b		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren_a		: IN STD_LOGIC  := '0';
		wren_b		: IN STD_LOGIC  := '0';
		q_a		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		q_b		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
);
end component;

begin

--
-- component port map (constant)
--
altlatencyram_inst : altlatencyram port map
(
   address_a=>inputs.address_a,
	address_b=>inputs.address_b,
	clock_a=>inputs.clock_a,
	clock_b=>inputs.clock_b,
	data_a=>inputs.data_a,
	data_b=>inputs.data_b,
	wren_a=>inputs.wren_a,
	wren_b=>inputs.wren_b,
	q_a => outputs.q_a,
	q_b =>outputs.q_b
	);

end rtl;
