--**************************************************************
--**************************************************************
--
-- Template file: cint_all.std (RecType --> Std)
--
--**************************************************************
--**************************************************************
--
--
-- Component maclut interface (entity, architecture)
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
-- maclut_std entity declaration (constant)
--

-- Standard libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_maclut.all;

entity maclut_std is
port
(
   clk : in std_logic;
   rst : in std_logic;
   wrreq : in std_logic;
   wrpointer : in std_logic_vector(3 downto 0);
   wrmacaddr : in maclut_byte_vector_t(0 to 5);
   rdinit : in std_logic;
   rdnext : in std_logic;
   rdpointer : in std_logic_vector(3 downto 0);
   writedone : out std_logic;
   qready : out std_logic;
   q : out std_logic_vector(7 downto 0)
);
end maclut_std;

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

-- Local libraries (constant)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.component_maclut.all;

architecture rtl of maclut_std is

--
-- maclut component declaration (constant)
--
--component maclut_std
--port
--(
--   clk : in std_logic;
--   rst : in std_logic;
--   wrreq : in std_logic;
--   wrpointer : in std_logic_vector(3 downto 0);
--   wrmacaddr : in maclut_byte_vector_t(0 to 5);
--   rdinit : in std_logic;
--   rdnext : in std_logic;
--   rdpointer : in std_logic_vector(3 downto 0);
--   writedone : out std_logic;
--   qready : out std_logic;
--   q : out std_logic_vector(7 downto 0)
--);
--end component;

begin

--
-- component port map
--
maclut_inst : maclut port map
(
   inputs.clk => clk,
   inputs.rst => rst,
   inputs.wrreq => wrreq,
   inputs.wrpointer => wrpointer,
   inputs.wrmacaddr => wrmacaddr,
   inputs.rdinit => rdinit,
   inputs.rdnext => rdnext,
   inputs.rdpointer => rdpointer,
   outputs.writedone => writedone,
   outputs.qready => qready,
   outputs.q => q
);

end rtl;
