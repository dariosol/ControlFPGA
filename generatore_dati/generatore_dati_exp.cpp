#include <iostream>
#include <iomanip>
#include <fstream>
#include "TRandom3.h"
#include "TFile.h"
#include "TH1D.h"
#include "TMath.h"
#include "TString.h"

//-- It generates primitives
//-- with an exponential distribution
//-- of the distance between timestamps.
//-- Can be used in simulation to test
//-- the L0TP trigger with Modelsim or
//-- with the test bench.

using namespace std;
const string detector= "MUV";
const long int burst=5/0.000000025; //colpi di clock
const float frequency = 8;    //mean DT  (clock hits) //4: uno ogni 0.1 us => 10.000 kHz
const int num_primitives=16384;

int main () {
  int primitiveID;
  int reserved;
  int seed;

  if (detector=="CHOD"){
    primitiveID=30;
    reserved =0;
    seed = 1;
  }
  else if (detector=="MUV"){
    primitiveID=2;
    reserved =0;
    seed = 54321;
  }

else if (detector=="RICH"){
    primitiveID=17;
    reserved =0;
    seed = 54322;
  }

else if (detector=="LAV"){
    primitiveID=14;
    reserved =0;
    seed = 54323;
  }

  TFile *file = new TFile(Form("%sprimitive_%d_%fKHz.root",detector.c_str(),num_primitives,(1./frequency)/0.000025),"recreate");
  ofstream myfile (Form("%sprimitive_%d_%fKHz.txt",detector.c_str(),num_primitives,round((1./frequency)/0.000025)));
  string line;
  double timestamp_array[num_primitives];
  double finetime_array[num_primitives];
  //double timestamp=40000000; // first second: nothing
  double timestamp=1;
  double finetime;
  double oldtimestamp=0;
  double oldtimestamp_NODownscaling=0;

  TRandom3* ran = new TRandom3(seed);
  TH1D *h_finetime = new TH1D("finetime","finetime",256, 0, 255);
  TH1D *h_timestamp = new TH1D("timestamp","timestamp",5000001, 0, 5); // 1 sec
  TH1F *h_DTtimestamp = new TH1F("DTtimestamp","DTtimestamp",5000,0,0.000005);  
  TH1F *h_DTtimestamp_NODownscaling = new TH1F("DTtimestampNODownscaling","DTtimestampNODownscaling",5000,0,0.000005);  

  for (int i =0; i<num_primitives; i++ ){ 
    double finetime = ran->Rndm();   //256 divisions da 100ps          // uniform in ]0,1]
    timestamp += -frequency * TMath::Log(1-(finetime)); //exponential distro
    timestamp_array[i] = round(timestamp);
    finetime_array[i] =round(finetime*255);
    cout<<round(timestamp)<<endl;
    h_finetime->Fill(finetime*255);
    h_timestamp->Fill(timestamp*0.000000025); //secondi
   
    h_DTtimestamp_NODownscaling->Fill(timestamp_array[i]*0.000000025-oldtimestamp_NODownscaling*0.000000025);
    oldtimestamp_NODownscaling=timestamp_array[i];
   
 if(i%20==0)    {h_DTtimestamp->Fill(timestamp_array[i]*0.000000025-oldtimestamp*0.000000025);
      oldtimestamp=timestamp_array[i];
    }
  }
 
  for (int j=0; j<num_primitives; ++j){ 
    myfile<<setfill('0')<<setw(4)<<hex<<primitiveID;
    myfile<<setfill('0')<<setw(2)<<hex<<reserved;
    myfile<<setfill('0')<<setw(2)<<hex<< (unsigned int)finetime_array[j];
    myfile<<"\n";
    myfile<<setfill('0')<<setw(8)<<hex<<(unsigned int)timestamp_array[j]<<"\n";
  }
  myfile.close();

  // Store all histograms in the output file and close up

  h_finetime->Write();
  h_timestamp->Write();
  h_DTtimestamp->Write();
  h_DTtimestamp_NODownscaling->Write();

  cout << "generated "<<num_primitives<<" primitives of "<<detector<<" mean frequency "<<round((1./frequency)/0.000025)<< "kHz seed "<<seed<<endl;
  return 0;
}
