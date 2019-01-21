--**************************************************************
--**************************************************************
--
-- Template file: cint_all.std (RecType --> Std)
--
--**************************************************************
--**************************************************************
--
--
-- Component regsync1 interface (entity, architecture)
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
-- regsync1_std entity declaration (constant)
--

-- Standard libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_regsync1.all;

entity regsync1_std is
port
(
   rclk : in std_logic;
   wclk : in std_logic;
   rrst : in std_logic;
   wrst : in std_logic;
   wreq : in std_logic;
   dreg : in regsync1_ctrlreg_t;
   wfull : out std_logic;
   qreg : out regsync1_ctrlreg_t;
   qupdate : out std_logic
);
end regsync1_std;

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

-- Local libraries (constant)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_regsync1.all;

architecture rtl of regsync1_std is

--
-- regsync1 component declaration (constant)
--
--component regsync1_std
--port
--(
--   rclk : in std_logic;
--   wclk : in std_logic;
--   rrst : in std_logic;
--   wrst : in std_logic;
--   wreq : in std_logic;
--   dreg : in regsync1_ctrlreg_t;
--   wfull : out std_logic;
--   qreg : out regsync1_ctrlreg_t;
--   qupdate : out std_logic
--);
--end component;

begin

--
-- component port map
--
regsync1_inst : regsync1 port map
(
   inputs.rclk => rclk,
   inputs.wclk => wclk,
   inputs.rrst => rrst,
   inputs.wrst => wrst,
   inputs.wreq => wreq,
   inputs.dreg => dreg,
   outputs.wfull => wfull,
   outputs.qreg => qreg,
   outputs.qupdate => qupdate
);

end rtl;
