#include <fstream>
#include <iostream>
#include <string>
#include <unistd.h>
#include <cmath>
#include <iomanip>
#include <vector>       
#include <algorithm>
#include <sstream>
#include <TH1.h>
#include <TFile.h>

//Dario

int run=3754;
int burst=85;
int bitfinetime=0;
using namespace std;

struct data
{
  vector<long long> time;
  vector<long long>  timestamp;
  vector<int>  primitiveID;
  vector<int>  finetime;
};


/*
 * 
 *
 * @var
 * @var 
 * @var amount of bit finetime to condider
 *
 */
long long L0address(unsigned int timestamp, unsigned int finetime, int bitfinetime){

  unsigned int ftMSBmask; //11100000 (binary)
  unsigned int timestampLSBmask;
  long long address;
  unsigned int timestampLSB;
  unsigned int ftMSB;

  if(bitfinetime==3) timestampLSBmask = 2047; //11111111111 (binary)
  if(bitfinetime==2) timestampLSBmask = 4095; 
  if(bitfinetime==1) timestampLSBmask = 8191; 
  if(bitfinetime==0) timestampLSBmask = 16383;
 
  if(bitfinetime==3) ftMSBmask=224;////11100000 (binary)
  if(bitfinetime==2) ftMSBmask=192;////11000000 (binary)
  if(bitfinetime==1) ftMSBmask=128;////10000000 (binary)
  if(bitfinetime==0) ftMSBmask=0;  ////00000000 (binary)
 
  timestampLSB = timestampLSBmask & timestamp;
  ftMSB = ftMSBmask & finetime;
  ftMSB = ftMSB >> ((unsigned int)8-(unsigned int)bitfinetime);
   
  address = timestampLSB;
  address = address <<(unsigned int)bitfinetime;
  address = address |  ftMSB;

  return address;

}

bool sortfunction (int i,int j) {
  return (i<j);
}


unsigned int string_to_hex(string primitive,int nibbles,int firstnibble){
  
  string substring = primitive.substr (firstnibble,nibbles);
  unsigned int value;
  istringstream iss(substring);
  iss >> std::hex >> value;
  return value;
}


/*
 * 
 */
int main(int argc, char *argv[]) {

  cout<<endl<<"Analyzing run number "<<run<<" burst number "<<burst<<endl;
  long long CHODaddress=0;

  long long previousCHODaddress=0;
  long long previousMUVaddress=0;
  
  long long MUVaddress=0;
  long long oldMUVaddress=0;
  int oldMUVaddresscount=0;
  int bitMUVaddress=0;
 
  //histograms
  TH1F *DTCHODMUV = new TH1F("DTCHODMUV","DTCHODMUV",500,-250,250);  
  TH1F *DTCHODMUV_CW = new TH1F("DTCHODMUV_CoincidenceWindow","DTCHODMUV_CoincidenceWindow",2800,-1400,1400);  
  TH1F *DTCHODMUV_CWCloser = new TH1F("DTCHODMUVCloser_CoincidenceWindow","DTCHODMUVCloser_CoincidenceWindow",5000,-2500,2500);  
  TH1F *DTCHODMUV_Trigger = new TH1F("DTCHODMUV_Trigger","DTCHODMUV_Trigger",2800,-1400,1400);  
  TH1F *Differences = new TH1F("Differences","Differences",2800,-1400,1400);  
  TH1F *Address_Trigger = new TH1F("AddressDifferencesTrigger","Differences in address",10,-5,5);  
  TH1F *Address_CW = new TH1F("AddressDifferencesCW","Differences in address",10,-5,5);  
  
  //input files
  ifstream CHODfile;
  ifstream MUVfile;
  CHODfile.open(Form("CHODprimitive_run%d_burst00%d_more.txt",run,burst));
  MUVfile.open(Form("MUV3primitive_run%d_burst00%d_more.txt",run,burst));
  string primitive;
  
  
  //output files
  ofstream myfile (Form("Coincidences_primitives3_%d_burst00%d.txt",run,burst));
  ofstream timediff (Form("time_difference_chod-muv_%d_burst00%d.txt",run,burst));
  ofstream debug1 ("debug1.txt");
  ofstream debug2 ("debug2.txt");

  TFile *file = new TFile("findtrigger3_run3754_burst0085.root","recreate");

  int CHODline=0;
  int MUVline=0;

  int sametimestamp=0;

  //struct and vectors---------
  data  CHODprim;
  data  MUVprim;

  //Results---------------------
  vector<long long>  deltaTime;
  vector<unsigned int>  trigger;
  long long MUVtimeprov=0;
  long long CHODtimeprov=0;

  /*
   *  To convert chat to hexadecimal
   */
  while (getline(CHODfile, primitive)){
    CHODline++;
    if(CHODline%2!=0) {
      CHODprim.primitiveID.push_back(string_to_hex(primitive,4,0)); 
      CHODprim.finetime.push_back(string_to_hex(primitive,2,6)); 
      continue;
    }
    CHODprim.timestamp.push_back(string_to_hex(primitive,8,0)); 
    if(!CHODprim.timestamp.empty()) CHODtimeprov = ( CHODprim.timestamp.back()*0x100 + CHODprim.finetime.back());
    if(!CHODprim.timestamp.empty()) CHODprim.time.push_back( CHODtimeprov);
  }
 
  
  
  while (getline(MUVfile, primitive)){
    MUVline++;
    if(MUVline%2!=0) {
      MUVprim.primitiveID.push_back(string_to_hex(primitive,4,0)); 
      MUVprim.finetime.push_back(string_to_hex(primitive,2,6)); 
      continue;
    }
    MUVprim.timestamp.push_back(string_to_hex(primitive,8,0)); 
    if(!MUVprim.timestamp.empty()) {
      MUVtimeprov = ( MUVprim.timestamp.back()*0x100 + MUVprim.finetime.back());
      MUVprim.time.push_back(MUVtimeprov);
    }
  }
  
 
  cout<<"Vectors loaded "<<endl;
  cout<<"timestamp CHOD vector size: "<<dec<<CHODprim.timestamp.size()<<endl;
  cout<<"timestamp MUV3 vector size: "<<dec<<MUVprim.timestamp.size()<<endl;
  
  //Elimino gli indirizzi uguali 
  //CHOD
  for(int i=0; i< CHODprim.timestamp.size();i++){
    if(i%5000==0)cout<<"primitive number "<<i<<endl;
    CHODaddress = L0address(CHODprim.timestamp.at(i),CHODprim.finetime.at(i),bitfinetime);
    if (argc>1 && strcmp(argv[1], "-v") == 0)cout<<"CHODaddress "<<hex<<CHODaddress<<" Timestamp "<<hex<<CHODprim.timestamp.at(i)<<" finetime "<<hex<<CHODprim.finetime.at(i)<<endl;
    if(CHODaddress-previousCHODaddress == 0) {
      if (argc>1 && strcmp(argv[1], "-v") == 0) cout<<"I'm deleting an event because previous address was "<<previousCHODaddress<<endl;
      if (argc>1 && strcmp(argv[1], "-v") == 0) cout<<"Deleting "<<hex<<CHODprim.timestamp.at((i-1))<<" "<<hex<<CHODprim.finetime.at((i-1))<<endl;
      CHODprim.timestamp.erase(CHODprim.timestamp.begin()+(i-1));
      CHODprim.finetime.erase(CHODprim.finetime.begin()+(i-1));
      CHODprim.primitiveID.erase(CHODprim.primitiveID.begin()+(i-1));
      CHODprim.time.erase(CHODprim.time.begin()+(i-1));
      i=i-1;
      sametimestamp++;
    }  
    previousCHODaddress=CHODaddress;    
  }
  
  cout<<"event with same address CHOD "<<sametimestamp<<endl;
  sametimestamp=0;

  //MUV3
  for(int i=0; i< MUVprim.timestamp.size();i++){
    if(i%5000==0)cout<<"primitive number "<<i<<endl;
    MUVaddress = L0address(MUVprim.timestamp.at(i),MUVprim.finetime.at(i),bitfinetime);
    if (argc>1 && strcmp(argv[1], "-v") == 0)cout<<"MUVaddress "<<hex<<MUVaddress<<" Timestamp "<<hex<<MUVprim.timestamp.at(i)<<" finetime "<<hex<<MUVprim.finetime.at(i)<<endl;
    if(MUVaddress-previousMUVaddress == 0) {
     if (argc>1 && strcmp(argv[1], "-v") == 0)cout<<"I'm deleting an event because previous address was "<<previousMUVaddress<<endl;
     if (argc>1 && strcmp(argv[1], "-v") == 0)cout<<"Deleting "<<hex<<MUVprim.timestamp.at((i-1))<<" "<<hex<<MUVprim.finetime.at((i-1))<<endl;
      MUVprim.timestamp.erase(MUVprim.timestamp.begin()+(i-1));
      MUVprim.finetime.erase(MUVprim.finetime.begin()+(i-1));
      MUVprim.primitiveID.erase(MUVprim.primitiveID.begin()+(i-1));
      MUVprim.time.erase(MUVprim.time.begin()+(i-1));
      i=i-1;
      sametimestamp++;
    }  
    previousMUVaddress=MUVaddress;    
  }
  

  cout<<"event with same address MUV3 "<<sametimestamp<<endl;




  
  for(int i=0; i< CHODprim.timestamp.size();i++){
    
    if(i%5000==0)cout<<"primitive number "<<i<<endl;
    CHODaddress = L0address(CHODprim.timestamp.at(i),CHODprim.finetime.at(i),bitfinetime);
    /*
     *  For on muv timestamps 
     */
    for(int j=0; j <  MUVprim.timestamp.size();j++){
      //devono avere lo stesso timestamp(+/- 1):

      if(abs(CHODprim.timestamp[i] - MUVprim.timestamp[j]) > 1 ) {
	continue;
	}
      
      // time stamp 11 less significative bit (LSB) + fine time (ft) 3 more significative bit (MSB)	  
      MUVaddress = L0address(MUVprim.timestamp.at(j),MUVprim.finetime.at(j),bitfinetime);

          
      bitMUVaddress = MUVprim.finetime.at(j) & ((unsigned int) 1 << (unsigned int) bitfinetime);

      //**************COINCIDENCES:**********************************************************//		 
       if(MUVaddress==CHODaddress || MUVaddress+1==CHODaddress || (MUVaddress-1==CHODaddress)) {
	oldMUVaddress=MUVaddress;
	previousCHODaddress = CHODaddress;
	if(abs(CHODprim.time.at(i)-MUVprim.time.at(j))<0x1f4){
	  if (argc>1 && strcmp(argv[1], "-v") == 0) cout<<"CHOD Address "<<hex<<CHODaddress<<" CHOD timestamp "<<hex<<CHODprim.timestamp.at(i)<<" CHODfinetime "<<hex<<CHODprim.finetime.at(i)<<" MUVAddress "<<hex<<MUVaddress<<" MUV3 timestamp "<<hex<<MUVprim.timestamp.at(j)<<" MUVfineitme "<<hex<<MUVprim.finetime.at(j)<<endl;
	  trigger.push_back(CHODprim.timestamp.at(i));
	if((CHODprim.time.at(i) - MUVprim.time.at(j))==0) debug2<<"Trigger in 0: CHOD Time: " <<hex<<CHODprim.time.at(i)<<" MUV Time "<<MUVprim.time.at(j)<<endl;
	DTCHODMUV_Trigger->Fill(CHODprim.time.at(i)-MUVprim.time.at(j));      
	Address_Trigger->Fill(L0address(CHODprim.timestamp.at(i),CHODprim.finetime.at(i),bitfinetime)-L0address(MUVprim.timestamp.at(j),MUVprim.finetime.at(j),bitfinetime));
	}
      }
    } //end of MUV while
    MUVfile.close();
  }  //end of CHOD while

  CHODfile.close();
  cout<<"Coincidences done, deleting trigger closer than 4 timestamp"<<endl;
  DTCHODMUV_Trigger->GetXaxis()->SetTitle("x 100 ps");
  DTCHODMUV_Trigger->Write();
  Address_Trigger  ->GetXaxis()->SetTitle("Address CHOD - Address MUV");
  Address_Trigger  ->Write();
  sort(trigger.begin(), trigger.end(),sortfunction);

  int oldtrigger=0;

  cout<<"trigger before cutting @ 3 timestamp "<<trigger.size()<<endl;

  /*
   *  I have to reject two trigger closer than 100 ns in order to simulate LTU
   */
  for (int i=0; i<trigger.size();i++){
    if((int)trigger.at(i)-oldtrigger <= 3) {
      trigger.erase(trigger.begin()+(i));
      i=i-1;
      continue;  
    }  
    if(trigger.at(i)-oldtrigger > 3) oldtrigger=trigger.at(i);  
  }

  for(int i=0;i<trigger.size();i++){
    myfile<<setfill('0')<<setw(8)<<hex<<trigger.at(i)<<endl;
  }
  
  myfile.close();

  Differences->Add(DTCHODMUV_CW,1);
  Differences->Add(DTCHODMUV_Trigger,-1);
  Differences->GetXaxis()->SetTitle("x 100 ps");
  Differences->Write();

  cout<<"Number of coincidences with FPGA algorithm: "<<dec<<trigger.size()<<endl;
  cout<<"Number of coincidences in window mode "<<dec<<deltaTime.size()<<endl;
  double Num=(double)trigger.size();
  double Den=(double)deltaTime.size();
  
  cout<<"*******************"<<endl;
  cout<<"     EFFICIENCY      "<<endl;
  cout<<"     "<<100.*(Num/Den)<<"%"<<endl;
  cout<<"*******************"<<endl;
  return 0;
}
