LIBRARY ieee  ; 
LIBRARY std  ; 
LIBRARY work  ; 
USE ieee.NUMERIC_STD.all  ; 
USE ieee.std_logic_1164.all  ; 
USE ieee.std_logic_textio.all  ; 
USE ieee.std_logic_unsigned.all  ; 
USE std.textio.all  ; 
USE work.component_dcfiforx1.all  ; 
USE work.component_dcfiforx2.all  ; 
USE work.component_rxport1.all  ; 
ENTITY \work_rxport1_std.vhd\  IS 
END ; 
 
ARCHITECTURE \work_rxport1_std.vhd_arch\   OF \work_rxport1_std.vhd\   IS
  SIGNAL rframes   :  rxport1_frames_vector_t(1 to rxport1_NPORTS)  ; 
  SIGNAL renasts   :  std_logic_vector (1 to 2)  ; 
  SIGNAL wdatalen   :  std_logic_vector (13 downto 0)  ; 
  SIGNAL reoframe   :  std_logic_vector (1 to 2)  ; 
  SIGNAL rdatacnt   :  rxport1_datalen_vector_t(1 to rxport1_NPORTS)  ; 
  SIGNAL wdata   :  std_logic_vector (7 downto 0)  ; 
  SIGNAL rreq   :  std_logic_vector (1 to 2)  ; 
  SIGNAL rseqnum   :  rxport1_seqnum_vector_t(1 to rxport1_NPORTS)  ; 
  SIGNAL rdatalen   :  rxport1_datalen_vector_t(1 to rxport1_NPORTS)  ; 
  SIGNAL rrst   :  std_logic_vector (1 to 2)  ; 
  SIGNAL wframeok   :  STD_LOGIC  ; 
  SIGNAL wdestport   :  std_logic_vector (3 downto 0)  ; 
  SIGNAL wframes   :  rxport1_frames_vector_t(1 to rxport1_NPORTS)  ; 
  SIGNAL rfull   :  std_logic_vector (1 to 2)  ; 
  SIGNAL wempty   :  std_logic_vector (1 to 2)  ; 
  SIGNAL rena   :  std_logic_vector (1 to 2)  ; 
  SIGNAL enable   :  std_logic_vector (1 to 2)  ; 
  SIGNAL wframedone   :  STD_LOGIC  ; 
  SIGNAL wseqnum   :  std_logic_vector (31 downto 0)  ; 
  SIGNAL rempty   :  std_logic_vector (1 to 2)  ; 
  SIGNAL srcfilteraddr   :  rxport1_srcaddr_vector_t(1 to rxport1_NPORTS) ; 
  SIGNAL rack   :  std_logic_vector (1 to 2)  ; 
  SIGNAL wfull   :  std_logic_vector (1 to 2)  ; 
  SIGNAL rerrempty   :  std_logic_vector (1 to 2)  ; 
  SIGNAL srcfilterena   :  std_logic_vector (1 to 2)  ; 
  SIGNAL seqnumclr   :  std_logic_vector (1 to 2)  ; 
  SIGNAL wsrcaddr   :  std_logic_vector (7 downto 0)  ; 
  SIGNAL werrfull   :  std_logic_vector (1 to 2)  ; 
  SIGNAL rxseqnum   :  rxport1_seqnum_vector_t(1 to rxport1_NPORTS) ; 
  SIGNAL srcfilterport   :  rxport1_srcport_vector_t(1 to rxport1_NPORTS) ; 
  SIGNAL rst2   :  STD_LOGIC  ; 
  SIGNAL wready   :  std_logic_vector (1 to 2)  ; 
  SIGNAL rdata   :  rxport1_rdata_vector_t(1 to rxport1_NPORTS) ; 
  SIGNAL rclk   :  std_logic_vector (1 to 2)  ; 
  SIGNAL clk2   :  STD_LOGIC  ; 
  SIGNAL wsrcport   :  std_logic_vector (3 downto 0)  ; 
  SIGNAL rsrcaddr   :  rxport1_srcaddr_vector_t(1 to rxport1_NPORTS)  ; 
  SIGNAL seqnumena   :  std_logic_vector (1 to 2)  ; 
  SIGNAL rxfifo   :  dcfiforx1_vector_t (1 to 2)  ; 
  SIGNAL rerrfull   :  std_logic_vector (1 to 2)  ; 
  SIGNAL rxparamfifo   :  dcfiforx2_vector_t (1 to 2) ; 
  SIGNAL werrempty   :  std_logic_vector (1 to 2)  ; 
  SIGNAL rsrcport   :  rxport1_srcport_vector_t(1 to rxport1_NPORTS) ; 
  SIGNAL rready   :  std_logic_vector (1 to 2)  ; 
  SIGNAL wreq   :  STD_LOGIC  ; 
  COMPONENT rxport1_std  
  PORT ( 
   rclk : in std_logic_vector(1 to rxport1_NPORTS);
   rrst : in std_logic_vector(1 to rxport1_NPORTS);
   clk2 : in std_logic;
   rst2 : in std_logic;
   rena : in std_logic_vector(1 to rxport1_NPORTS);
   rreq : in std_logic_vector(1 to rxport1_NPORTS);
   rack : in std_logic_vector(1 to rxport1_NPORTS);
   wsrcaddr : in std_logic_vector(7 downto 0);
   wdestport : in std_logic_vector(3 downto 0);
   wsrcport : in std_logic_vector(3 downto 0);
   wseqnum : in std_logic_vector(31 downto 0);
   wdatalen : in std_logic_vector(13 downto 0);
   wdata : in std_logic_vector(7 downto 0);
   wframeok : in std_logic;
   wframedone : in std_logic;
   wreq : in std_logic;
   enable : in std_logic_vector(1 to rxport1_NPORTS);
   seqnumena : in std_logic_vector(1 to rxport1_NPORTS);
   seqnumclr : in std_logic_vector(1 to rxport1_NPORTS);
   srcfilterena : in std_logic_vector(1 to rxport1_NPORTS);
   srcfilteraddr : in rxport1_srcaddr_vector_t(1 to rxport1_NPORTS);
   srcfilterport : in rxport1_srcport_vector_t(1 to rxport1_NPORTS);
   renasts : out std_logic_vector(1 to rxport1_NPORTS);
   rdata : out rxport1_rdata_vector_t(1 to rxport1_NPORTS);
   rready : out std_logic_vector(1 to rxport1_NPORTS);
   rempty : out std_logic_vector(1 to rxport1_NPORTS);
   rfull : out std_logic_vector(1 to rxport1_NPORTS);
   rframes : out rxport1_frames_vector_t(1 to rxport1_NPORTS);
   rsrcaddr : out rxport1_srcaddr_vector_t(1 to rxport1_NPORTS);
   rsrcport : out rxport1_srcport_vector_t(1 to rxport1_NPORTS);
   rdatalen : out rxport1_datalen_vector_t(1 to rxport1_NPORTS);
   rdatacnt : out rxport1_datalen_vector_t(1 to rxport1_NPORTS);
   rseqnum : out rxport1_seqnum_vector_t(1 to rxport1_NPORTS);
   reoframe : out std_logic_vector(1 to rxport1_NPORTS);
   rerrfull : out std_logic_vector(1 to rxport1_NPORTS);
   rerrempty : out std_logic_vector(1 to rxport1_NPORTS);
   wready : out std_logic_vector(1 to rxport1_NPORTS);
   wempty : out std_logic_vector(1 to rxport1_NPORTS);
   wfull : out std_logic_vector(1 to rxport1_NPORTS);
   wframes : out rxport1_frames_vector_t(1 to rxport1_NPORTS);
   rxseqnum : out rxport1_seqnum_vector_t(1 to rxport1_NPORTS);
   werrempty : out std_logic_vector(1 to rxport1_NPORTS);
   werrfull : out std_logic_vector(1 to rxport1_NPORTS);
   rxfifo : out dcfiforx1_vector_t(1 to rxport1_NPORTS);
   rxparamfifo : out dcfiforx2_vector_t(1 to rxport1_NPORTS)  
  );
  END COMPONENT ; 
BEGIN
  DUT  : rxport1_std  
    PORT MAP ( 
      rframes   => rframes  ,
      renasts   => renasts  ,
      wdatalen   => wdatalen  ,
      reoframe   => reoframe  ,
      rdatacnt   => rdatacnt  ,
      wdata   => wdata  ,
      rreq   => rreq  ,
      rseqnum   => rseqnum  ,
      rdatalen   => rdatalen  ,
      rrst   => rrst  ,
      wframeok   => wframeok  ,
      wdestport   => wdestport  ,
      wframes   => wframes  ,
      rfull   => rfull  ,
      wempty   => wempty  ,
      rena   => rena  ,
      enable   => enable  ,
      wframedone   => wframedone  ,
      wseqnum   => wseqnum  ,
      rempty   => rempty  ,
      srcfilteraddr   => srcfilteraddr  ,
      rack   => rack  ,
      wfull   => wfull  ,
      rerrempty   => rerrempty  ,
      srcfilterena   => srcfilterena  ,
      seqnumclr   => seqnumclr  ,
      wsrcaddr   => wsrcaddr  ,
      werrfull   => werrfull  ,
      rxseqnum   => rxseqnum  ,
      srcfilterport   => srcfilterport  ,
      rst2   => rst2  ,
      wready   => wready  ,
      rdata   => rdata  ,
      rclk   => rclk  ,
      clk2   => clk2  ,
      wsrcport   => wsrcport  ,
      rsrcaddr   => rsrcaddr  ,
      seqnumena   => seqnumena  ,
      rxfifo   => rxfifo  ,
      rerrfull   => rerrfull  ,
      rxparamfifo   => rxparamfifo  ,
      werrempty   => werrempty  ,
      rsrcport   => rsrcport  ,
      rready   => rready  ,
      wreq   => wreq   ) ; 



-- "Repeater Pattern" Repeat Forever
-- Start Time = 0 ns, End Time = 1 us, Period = 4 ns
  Process
	Begin
	for Z in 1 to 125
	loop
	    rclk  <= "00"  ;
	   wait for 4 ns ;
	    rclk  <= "11"  ;
	   wait for 4 ns ;
-- 1 us, repeat pattern in loop.
	end  loop;
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 rrst  <= "11"  ;
	wait for 6 ns ;
	 rrst  <= "00"  ;
	wait for 994 ns ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Clock Pattern" : dutyCycle = 50
-- Start Time = 0 ns, End Time = 1 us, Period = 8 ns
  Process
	Begin
	 clk2  <= '0'  ;
	wait for 4 ns ;
-- 4 ns, single loop till start period.
	for Z in 1 to 124
	loop
	    clk2  <= '1'  ;
	   wait for 4 ns ;
	    clk2  <= '0'  ;
	   wait for 4 ns ;
-- 996 ns, repeat pattern in loop.
	end  loop;
	 clk2  <= '1'  ;
	wait for 4 ns ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 rst2  <= '1'  ;
	wait for 6 ns ;
	 rst2  <= '0'  ;
	wait for 994 ns ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 rena  <= "11"  ;
	wait for 1 us ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 rreq  <= "00"  ;
	wait for 1 us ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 rack  <= "00"  ;
	wait for 1 us ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 wsrcaddr  <= "11000000"  ;
	wait for 1 us ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 wdestport  <= "0001"  ;
	wait for 1 us ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 wsrcport  <= "1000"  ;
	wait for 1 us ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 wseqnum  <= "00000000000000000000000000000001"  ;
	wait for 1 us ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 wdatalen  <= "00000000000010"  ;
	wait for 1 us ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 wdata  <= "10101010"  ;
	wait for 1 us ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 wframeok  <= '0'  ;
	wait for 26 ns + 64 ns ;
	 wframeok  <= '1'  ;
	wait for 69 ns ;
	 wframeok  <= '0'  ;
	wait for 905 ns ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 wframedone  <= '0'  ;
	wait for 88 ns + 48 ns ;
	 wframedone  <= '1'  ;
	wait for 10 ns ;
	 wframedone  <= '0'  ;
	wait for 902 ns ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 wreq  <= '0'  ;
	wait for 62 ns + 48 ns ;
	 wreq  <= '1'  ;
	wait for 17 ns ;
	 wreq  <= '0'  ;
	wait for 921 ns ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 enable  <= "11"  ;
	wait for 1 us ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 seqnumena  <= "00"  ;
	wait for 1 us ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 seqnumclr  <= "00"  ;
	wait for 1 us ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 srcfilterena  <= "00"  ;
	wait for 1 us ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 srcfilteraddr  <= (others => "00000000")  ;
	wait for 1 us ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 srcfilterport  <= (others => "0000")  ;
	wait for 1 us ;
-- dumped values till 1 us
	wait;
 End Process;
END;
