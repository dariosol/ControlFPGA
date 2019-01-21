library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity altcounter is
	port
	(
		clk		: in std_logic;
		enable 	: in std_logic;
		reset   : in std_logic;		
		q		: out unsigned (23 downto 0)
	);
end entity;

architecture rtl of altcounter is
begin
	process (clk)
		variable   cnt	: unsigned (23 downto 0);
	begin
		if (rising_edge(clk)) then
			if reset = '1' then
				-- Reset the counter to 0
				cnt := (others=>'0');
			elsif enable = '1' then
				-- Increment the counter if counting is enabled
				cnt := cnt + 1;
			end if;
		end if;
		
		-- Output the current count
		q <= cnt;
	end process;

end rtl;