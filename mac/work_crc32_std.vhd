LIBRARY ieee  ; 
LIBRARY std  ; 
LIBRARY work  ; 
USE ieee.NUMERIC_STD.all  ; 
USE ieee.std_logic_1164.all  ; 
USE ieee.std_logic_textio.all  ; 
USE ieee.std_logic_unsigned.all  ; 
USE std.textio.all  ; 
USE work.component_crc32.all  ; 
ENTITY \work_crc32_std.vhd\  IS 
END ; 
 
ARCHITECTURE \work_crc32_std.vhd_arch\   OF \work_crc32_std.vhd\   IS
  SIGNAL fcs   :  std_logic_vector (31 downto 0)  ; 
  SIGNAL init   :  STD_LOGIC  ; 
  SIGNAL fcserr   :  STD_LOGIC  ; 
  SIGNAL data   :  std_logic_vector (7 downto 0)  ; 
  SIGNAL datavalid   :  STD_LOGIC  ; 
  SIGNAL rst1   :  STD_LOGIC  ; 
  SIGNAL clk1   :  STD_LOGIC  ; 
  COMPONENT crc32_std  
    PORT ( 
      fcs  : out std_logic_vector (31 downto 0) ; 
      init  : in STD_LOGIC ; 
      fcserr  : out STD_LOGIC ; 
      data  : in std_logic_vector (7 downto 0) ; 
      datavalid  : in STD_LOGIC ; 
      rst1  : in STD_LOGIC ; 
      clk1  : in STD_LOGIC ); 
  END COMPONENT ; 
BEGIN
  DUT  : crc32_std  
    PORT MAP ( 
      fcs   => fcs  ,
      init   => init  ,
      fcserr   => fcserr  ,
      data   => data  ,
      datavalid   => datavalid  ,
      rst1   => rst1  ,
      clk1   => clk1   ) ; 



-- "Clock Pattern" : dutyCycle = 50
-- Start Time = 0 ns, End Time = 1 us, Period = 10 ns
  Process
	Begin
	 clk1  <= '0'  ;
	wait for 5 ns ;
-- 5 ns, single loop till start period.
	for Z in 1 to 99
	loop
	    clk1  <= '1'  ;
	   wait for 5 ns ;
	    clk1  <= '0'  ;
	   wait for 5 ns ;
-- 995 ns, repeat pattern in loop.
	end  loop;
	 clk1  <= '1'  ;
	wait for 5 ns ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 rst1  <= '1'  ;
	wait for 12 ns ;
	 rst1  <= '0'  ;
	wait for 988 ns ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 datavalid  <= '1'  ;
	wait for 1 us ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 data  <= "00000000"  ;
	wait for 1 us ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 init  <= '0'  ;
	wait for 22 ns ;
	 init  <= '1'  ;
	wait for 6 ns ;
	 init  <= '0'  ;
	wait for 972 ns ;
-- dumped values till 1 us
	wait;
 End Process;
END;
