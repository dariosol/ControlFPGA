--**************************************************************
--**************************************************************
--
-- Template file: cint_all.std (RecType --> Std)
--
--**************************************************************
--**************************************************************
--
--
-- Component regfile1 interface (entity, architecture)
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

--
-- regfile1_std entity declaration (constant)
--

-- Standard libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_regfile1.all;

entity regfile1_std is
port
(
   clk1 : in std_logic;
   rst1 : in std_logic;
   rinvect : in regfile1_ctrlvect_t(0 to 15);
   mmaddress : in std_logic_vector(3 downto 0);
   mmread : in std_logic;
   mmwrite : in std_logic;
   mmwritedata : in std_logic_vector(31 downto 0);
   routvect : out regfile1_ctrlvect_t(0 to 15);
   routwrpulse : out std_logic_vector(0 to 15);
   mmreaddata : out std_logic_vector(31 downto 0);
   mmreaddatavalid : out std_logic;
   mmwaitrequest : out std_logic;
   dbg_address : out std_logic_vector(3 downto 0);
   dbg_read : out std_logic;
   dbg_write : out std_logic;
   dbg_writedata : out std_logic_vector(31 downto 0);
   dbg_readdata : out std_logic_vector(31 downto 0);
   dbg_readdatavalid : out std_logic;
   dbg_waitrequest : out std_logic
);
end regfile1_std;

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

-- Local libraries (constant)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_regfile1.all;

architecture rtl of regfile1_std is

--
-- regfile1 component declaration (constant)
--
--component regfile1_std
--port
--(
--   clk1 : in std_logic;
--   rst1 : in std_logic;
--   rinvect : in regfile1_ctrlvect_t(0 to 15);
--   mmaddress : in std_logic_vector(3 downto 0);
--   mmread : in std_logic;
--   mmwrite : in std_logic;
--   mmwritedata : in std_logic_vector(31 downto 0);
--   routvect : out regfile1_ctrlvect_t(0 to 15);
--   routwrpulse : out std_logic_vector(0 to 15);
--   mmreaddata : out std_logic_vector(31 downto 0);
--   mmreaddatavalid : out std_logic;
--   mmwaitrequest : out std_logic;
--   dbg_address : out std_logic_vector(3 downto 0);
--   dbg_read : out std_logic;
--   dbg_write : out std_logic;
--   dbg_writedata : out std_logic_vector(31 downto 0);
--   dbg_readdata : out std_logic_vector(31 downto 0);
--   dbg_readdatavalid : out std_logic;
--   dbg_waitrequest : out std_logic
--);
--end component;

begin

--
-- component port map
--
regfile1_inst : regfile1 port map
(
   inputs.clk1 => clk1,
   inputs.rst1 => rst1,
   inputs.rinvect => rinvect,
   inputs.mmaddress => mmaddress,
   inputs.mmread => mmread,
   inputs.mmwrite => mmwrite,
   inputs.mmwritedata => mmwritedata,
   outputs.routvect => routvect,
   outputs.routwrpulse => routwrpulse,
   outputs.mmreaddata => mmreaddata,
   outputs.mmreaddatavalid => mmreaddatavalid,
   outputs.mmwaitrequest => mmwaitrequest,
   outputs.dbg_address => dbg_address,
   outputs.dbg_read => dbg_read,
   outputs.dbg_write => dbg_write,
   outputs.dbg_writedata => dbg_writedata,
   outputs.dbg_readdata => dbg_readdata,
   outputs.dbg_readdatavalid => dbg_readdatavalid,
   outputs.dbg_waitrequest => dbg_waitrequest
);

end rtl;
