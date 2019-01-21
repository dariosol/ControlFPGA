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

package component_counter is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- counter inputs (constant)
--
type counter_inputs_t is record

   -- input list
      clk		:  std_logic;
		enable 	:  std_logic;
		reset   :  std_logic;		
		
end record;

--
--  counter outputs (constant)
--
type counter_outputs_t is record
q		:  unsigned(23 downto 0);
end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- counter component common interface (constant)
--
type counter_t is record
   inputs  : counter_inputs_t;
   outputs : counter_outputs_t;
end record;

--
-- counter vector type (constant)
--
type counter_vector_t is array(NATURAL RANGE <>) of counter_t;

--
--  counter component declaration (constant)
--
component counter
port (
   inputs  : in counter_inputs_t;
   outputs : out counter_outputs_t
);
end component;

--
-- counter global signal to export params (constant)
--
signal component_counter : counter_t;

end component_counter;

--
-- counter entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_counter.all;

--  counter entity (constant)
entity counter is
port (
   inputs  : in counter_inputs_t;
   outputs : out counter_outputs_t
);
end counter;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

architecture rtl of counter is

--
-- altdpramDARIO component declaration (constant)
--
component altcounter
port
(
      clk		: in std_logic;
		enable 	: in std_logic;
		reset   : in std_logic;		
		q		: out unsigned (23 downto 0)
);
end component;

begin

--
-- component port map (constant)
--
altcounter_inst :  altcounter port map
(
   clk=>inputs.clk,
	enable=>inputs.enable,
	reset=>inputs.reset,
	q =>outputs.q
	);

end rtl;
