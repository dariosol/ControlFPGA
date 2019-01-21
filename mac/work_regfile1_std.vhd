LIBRARY ieee  ; 
LIBRARY std  ; 
LIBRARY work  ; 
USE ieee.NUMERIC_STD.all  ; 
USE ieee.std_logic_1164.all  ; 
USE ieee.std_logic_textio.all  ; 
USE ieee.std_logic_unsigned.all  ; 
USE std.textio.all  ; 
USE work.component_regfile1.all  ; 
ENTITY \work_regfile1_std.vhd\  IS 
END ; 
 
ARCHITECTURE \work_regfile1_std.vhd_arch\   OF \work_regfile1_std.vhd\   IS
  SIGNAL mmaddress   :  std_logic_vector (3 downto 0)  ; 
  SIGNAL mmreaddata   :  std_logic_vector (31 downto 0)  ; 
  SIGNAL mmreaddatavalid   :  STD_LOGIC  ; 
  SIGNAL mmwaitrequest   :  STD_LOGIC  ; 
  SIGNAL dbg_waitrequest   :  STD_LOGIC  ; 
  SIGNAL dbg_readdatavalid   :  STD_LOGIC  ; 
  SIGNAL dbg_readdata   :  std_logic_vector (31 downto 0)  ; 
  SIGNAL dbg_address   :  std_logic_vector (3 downto 0)  ; 
  SIGNAL routwrpulse   :  std_logic_vector (0 to 15)  ; 
  SIGNAL mmread   :  STD_LOGIC  ; 
  SIGNAL mmwritedata   :  std_logic_vector (31 downto 0)  ; 
  SIGNAL dbg_read   :  STD_LOGIC  ; 
  SIGNAL dbg_writedata   :  std_logic_vector (31 downto 0)  ; 
  SIGNAL rst1   :  STD_LOGIC  ; 
  SIGNAL clk1   :  STD_LOGIC  ; 
  SIGNAL rinvect   :  regfile1_ctrlvect_t(0 to 15)  ; 
  SIGNAL routvect   :  regfile1_ctrlvect_t(0 to 15)  ; 
  SIGNAL mmwrite   :  STD_LOGIC  ; 
  SIGNAL dbg_write   :  STD_LOGIC  ; 
  COMPONENT regfile1_std  
    PORT ( 
      mmaddress  : in std_logic_vector (3 downto 0) ; 
      mmreaddata  : out std_logic_vector (31 downto 0) ; 
      mmreaddatavalid  : out STD_LOGIC ; 
      mmwaitrequest  : out STD_LOGIC ; 
      dbg_waitrequest  : out STD_LOGIC ; 
      dbg_readdatavalid  : out STD_LOGIC ; 
      dbg_readdata  : out std_logic_vector (31 downto 0) ; 
      dbg_address  : out std_logic_vector (3 downto 0) ; 
      routwrpulse  : out std_logic_vector (0 to 15) ; 
      mmread  : in STD_LOGIC ; 
      mmwritedata  : in std_logic_vector (31 downto 0) ; 
      dbg_read  : out STD_LOGIC ; 
      dbg_writedata  : out std_logic_vector (31 downto 0) ; 
      rst1  : in STD_LOGIC ; 
      clk1  : in STD_LOGIC ; 
      rinvect  : in regfile1_ctrlvect_t(0 to 15) ; 
      routvect  : out regfile1_ctrlvect_t(0 to 15) ; 
      mmwrite  : in STD_LOGIC ; 
      dbg_write  : out STD_LOGIC ); 
  END COMPONENT ; 
BEGIN
  DUT  : regfile1_std  
    PORT MAP ( 
      mmaddress   => mmaddress  ,
      mmreaddata   => mmreaddata  ,
      mmreaddatavalid   => mmreaddatavalid  ,
      mmwaitrequest   => mmwaitrequest  ,
      dbg_waitrequest   => dbg_waitrequest  ,
      dbg_readdatavalid   => dbg_readdatavalid  ,
      dbg_readdata   => dbg_readdata  ,
      dbg_address   => dbg_address  ,
      routwrpulse   => routwrpulse  ,
      mmread   => mmread  ,
      mmwritedata   => mmwritedata  ,
      dbg_read   => dbg_read  ,
      dbg_writedata   => dbg_writedata  ,
      rst1   => rst1  ,
      clk1   => clk1  ,
      rinvect   => rinvect  ,
      routvect   => routvect  ,
      mmwrite   => mmwrite  ,
      dbg_write   => dbg_write   ) ; 



-- "Clock Pattern" : dutyCycle = 50
-- Start Time = 0 ns, End Time = 1 us, Period = 20 ns
  Process
	Begin
	 clk1  <= '0'  ;
	wait for 10 ns ;
-- 10 ns, single loop till start period.
	for Z in 1 to 49
	loop
	    clk1  <= '1'  ;
	   wait for 10 ns ;
	    clk1  <= '0'  ;
	   wait for 10 ns ;
-- 990 ns, repeat pattern in loop.
	end  loop;
	 clk1  <= '1'  ;
	wait for 10 ns ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 rst1  <= '1'  ;
	wait for 15 ns ;
	 rst1  <= '0'  ;
	wait for 985 ns ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 rinvect  <= (others => "00000000000000000000000000000000")  ;
	wait for 1 us ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 mmaddress  <= "0000"  ;
	wait for 57 ns ;
	 mmaddress  <= "0011"  ;
	wait for 26 ns + 20 ns ;
	 mmaddress  <= "0000"  ;
	wait for 917 ns ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 mmread  <= '0'  ;
	wait for 1 us ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 mmwrite  <= '0'  ;
	wait for 57 ns ;
	 mmwrite  <= '1'  ;
	wait for 26 ns ;
	 mmwrite  <= '0'  ;
	wait for 917 ns ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 mmwritedata  <= "00000000000000000000000000000000"  ;
	wait for 57 ns ;
	 mmwritedata  <= "00000000000000000000111100001111"  ;
	wait for 26 ns + 20 ns ;
	 mmwritedata  <= "00000000000000000000000000000000"  ;
	wait for 917 ns ;
-- dumped values till 1 us
	wait;
 End Process;
END;
