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

package component_ramdataLAV is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- ramdataLAV inputs (constant)
--
type ramdataLAV_inputs_t is record

   -- input list
      rdaddress		:  STD_LOGIC_VECTOR (14 DOWNTO 0);
		wraddress		:  STD_LOGIC_VECTOR (14	DOWNTO 0);
		clock		   :  STD_LOGIC ;
		data		   :  STD_LOGIC_VECTOR (63 DOWNTO 0);
		wren		:  STD_LOGIC  ;
		rden		:  STD_LOGIC  ;
end record;

--
--  ramdataLAV outputs (constant)
--
type ramdataLAV_outputs_t is record

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
-- ramdataLAV component common interface (constant)
--
type ramdataLAV_t is record
   inputs  : ramdataLAV_inputs_t;
   outputs : ramdataLAV_outputs_t;
end record;

--
-- ramdataLAV vector type (constant)
--
type ramdataLAV_vector_t is array(NATURAL RANGE <>) of ramdataLAV_t;

--
--  ramdataLAV component declaration (constant)
--
component ramdataLAV
port (
   inputs  : in ramdataLAV_inputs_t;
   outputs : out ramdataLAV_outputs_t
);
end component;

--
-- ramdataLAV global signal to export params (constant)
--
signal component_ramdataLAV : ramdataLAV_t;

end component_ramdataLAV;

--
-- ramdataLAV entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_ramdataLAV.all;

--  ramdataLAV entity (constant)
entity ramdataLAV is
port (
   inputs  : in ramdataLAV_inputs_t;
   outputs : out ramdataLAV_outputs_t
);
end ramdataLAV;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

architecture rtl of ramdataLAV is

--
-- altdpramDARIO component declaration (constant)
--
component altramdataLAV
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
altramdataLAV_inst : altramdataLAV port map
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
