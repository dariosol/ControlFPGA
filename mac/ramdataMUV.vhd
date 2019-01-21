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

package component_ramdataMUV is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- ramdataMUV inputs (constant)
--
type ramdataMUV_inputs_t is record

   -- input list
      rdaddress		:  STD_LOGIC_VECTOR (14 DOWNTO 0);
		wraddress		:  STD_LOGIC_VECTOR (14	DOWNTO 0);
		clock		   :  STD_LOGIC ;
		data		   :  STD_LOGIC_VECTOR (63 DOWNTO 0);
		wren		:  STD_LOGIC  ;
		rden		:  STD_LOGIC  ;
end record;

--
--  ramdataMUV outputs (constant)
--
type ramdataMUV_outputs_t is record

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
-- ramdataMUV component common interface (constant)
--
type ramdataMUV_t is record
   inputs  : ramdataMUV_inputs_t;
   outputs : ramdataMUV_outputs_t;
end record;

--
-- ramdataMUV vector type (constant)
--
type ramdataMUV_vector_t is array(NATURAL RANGE <>) of ramdataMUV_t;

--
--  ramdataMUV component declaration (constant)
--
component ramdataMUV
port (
   inputs  : in ramdataMUV_inputs_t;
   outputs : out ramdataMUV_outputs_t
);
end component;

--
-- ramdataMUV global signal to export params (constant)
--
signal component_ramdataMUV : ramdataMUV_t;

end component_ramdataMUV;

--
-- ramdataMUV entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_ramdataMUV.all;

--  ramdataMUV entity (constant)
entity ramdataMUV is
port (
   inputs  : in ramdataMUV_inputs_t;
   outputs : out ramdataMUV_outputs_t
);
end ramdataMUV;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

architecture rtl of ramdataMUV is

--
-- altdpramDARIO component declaration (constant)
--
component altramdataMUV
port
(
      clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (63 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (14 DOWNTO 0);
		rden		: IN STD_LOGIC  := '1';
		wraddress		: IN STD_LOGIC_VECTOR (14 DOWNTO 0);
		wren		: IN STD_LOGIC  := '0';
		q		: OUT STD_LOGIC_VECTOR (63 DOWNTO 0)
);
end component;

begin

--
-- component port map (constant)
--
altramdataMUV_inst : altramdataMUV port map
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
