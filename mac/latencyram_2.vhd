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

package component_latencyram_2 is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- latencyram_2 inputs (constant)
--
type latencyram_2_inputs_t is record

   -- input list
      address_a		:  STD_LOGIC_VECTOR (15 DOWNTO 0);
		address_b		:  STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock_a		:  STD_LOGIC ;
		clock_b		:  STD_LOGIC ;
		data_a		:  STD_LOGIC_VECTOR (5 DOWNTO 0);
		data_b		:  STD_LOGIC_VECTOR (5 DOWNTO 0);
		wren_a		:  STD_LOGIC  ;
		wren_b		:  STD_LOGIC  ;
		rden_a		:  STD_LOGIC  ;
		rden_b		:  STD_LOGIC  ;
end record;

--
--  latencyram_2 outputs (constant)
--
type latencyram_2_outputs_t is record

   -- output list
	q_a		:  STD_LOGIC_VECTOR (5	DOWNTO 0);
	q_b		:  STD_LOGIC_VECTOR (5 DOWNTO 0);

end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- latencyram_2 component common interface (constant)
--
type latencyram_2_t is record
   inputs  : latencyram_2_inputs_t;
   outputs : latencyram_2_outputs_t;
end record;

--
-- latencyram_2 vector type (constant)
--
type latencyram_2_vector_t is array(NATURAL RANGE <>) of latencyram_2_t;

--
--  latencyram_2 component declaration (constant)
--
component latencyram_2
port (
   inputs  : in latencyram_2_inputs_t;
   outputs : out latencyram_2_outputs_t
);
end component;

--
-- latencyram_2 global signal to export params (constant)
--
signal component_latencyram_2 : latencyram_2_t;

end component_latencyram_2;

--
-- latencyram_2 entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_latencyram_2.all;

--  latencyram_2 entity (constant)
entity latencyram_2 is
port (
   inputs  : in latencyram_2_inputs_t;
   outputs : out latencyram_2_outputs_t
);
end latencyram_2;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

architecture rtl of latencyram_2 is

--
-- altdpramDARIO component declaration (constant)
--
component altlatencyram_2
port
(
      address_a		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		address_b	: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock_a		: IN STD_LOGIC  := '1';
		clock_b		: IN STD_LOGIC ;
		data_a		: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		data_b		: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		wren_a		: IN STD_LOGIC  := '0';
		wren_b		: IN STD_LOGIC  := '0';
		rden_a		: IN STD_LOGIC  := '1';
		rden_b		: IN STD_LOGIC  := '1';
		q_a		: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
		q_b		: OUT STD_LOGIC_VECTOR (5 DOWNTO 0)
);
end component;

begin

--
-- component port map (constant)
--
altlatencyram_2_inst : altlatencyram_2 port map
(
   address_a=>inputs.address_a,
	address_b=>inputs.address_b,
	clock_a=>inputs.clock_a,
	clock_b=>inputs.clock_b,
	data_a=>inputs.data_a,
	data_b=>inputs.data_b,
	wren_a=>inputs.wren_a,
	wren_b=>inputs.wren_b,
	rden_a=>inputs.rden_a,
	rden_b=>inputs.rden_b,
	q_a => outputs.q_a,
	q_b =>outputs.q_b
	);

end rtl;
