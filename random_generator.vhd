library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PRNG22 is
generic ( width : integer := 8 ); 
port (
clk : in std_logic;
random : out std_logic_vector (width-1 downto 0) --output vector 
);
end PRNG22;

architecture Behavioral of PRNG22 is
--Input and Output definitions.
signal clk : std_logic := '0';
signal random_num : std_logic_vector(3 downto 0);
-- Clock period definitions
constant clk_period : time = '1' ;

begin
variable rand_temp : std_logic_vector(width-1 downto 0):=(width-1 => '1',others => '0');
variable temp : std_logic = '0';

-- Instantiate the Unit Under Test (UUT)
uut: entity work.random generic map (width => 4) PORT MAP 
(
clk => clk,
random_num => random_num
);


PROCESS_1: process(clk)
begin
if(rising_edge(clk)) then
temp := rand_temp(width-1) xor rand_temp(width-2);
rand_temp(width-1 downto 1) := rand_temp(width-2 downto 0);
rand_temp(0) := temp;
end if;
random_num <= rand_temp;
end process PROCESS_1;


end behavioral;