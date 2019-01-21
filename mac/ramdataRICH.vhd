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

package component_ramdataRICH is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- ramdataRICH inputs (constant)
--
type ramdataRICH_inputs_t is record

   -- input list
      rdaddress		:  STD_LOGIC_VECTOR (14 DOWNTO 0);
		wraddress		:  STD_LOGIC_VECTOR (14	DOWNTO 0);
		clock		   :  STD_LOGIC ;
		data		   :  STD_LOGIC_VECTOR (63 DOWNTO 0);
		wren		:  STD_LOGIC  ;
		rden		:  STD_LOGIC  ;
end record;

--
--  ramdataRICH outputs (constant)
--
type ramdataRICH_outputs_t is record

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
-- ramdataRICH component common interface (constant)
--
type ramdataRICH_t is record
   inputs  : ramdataRICH_inputs_t;
   outputs : ramdataRICH_outputs_t;
end record;

--
-- ramdataRICH vector type (constant)
--
type ramdataRICH_vector_t is array(NATURAL RANGE <>) of ramdataRICH_t;

--
--  ramdataRICH component declaration (constant)
--
component ramdataRICH
port (
   inputs  : in ramdataRICH_inputs_t;
   outputs : out ramdataRICH_outputs_t
);
end component;

--
-- ramdataRICH global signal to export params (constant)
--
signal component_ramdataRICH : ramdataRICH_t;

end component_ramdataRICH;

--
-- ramdataRICH entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_ramdataRICH.all;

--  ramdataRICH entity (constant)
entity ramdataRICH is
port (
   inputs  : in ramdataRICH_inputs_t;
   outputs : out ramdataRICH_outputs_t
);
end ramdataRICH;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

architecture rtl of ramdataRICH is

--
-- altdpramDARIO component declaration (constant)
--
component altramdataRICH
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
altramdataRICH_inst : altramdataRICH port map
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
