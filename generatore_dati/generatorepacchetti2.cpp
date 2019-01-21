#include <iostream>
#include <iomanip>
#include <fstream>
#include <iomanip>
#include <fstream>
#include <stdlib.h>
#include <sstream>

using namespace std;



const int npacket_set=50;  
const string detector= "MUV";


unsigned int tohex(string line)
{
  unsigned int intline=0;
  stringstream converter(line.c_str());
    converter >> std::hex >> intline;

    return intline;
}



int main () {
  int reserved;
  int seed;
  int sourceID;

  if (detector=="CHOD"){
    reserved =0;
    seed = 54320;
    sourceID=0x18;
  }
  else if (detector=="MUV"){
    reserved =0;
    seed = 54321;
    sourceID= 0x30;
  }


  
    ofstream myfile[npacket_set];
    
    string openfile;
    if(detector=="MUV") openfile= "packet/MUV3primitive_run3754_burst0085_";
    if(detector=="CHOD") openfile= "packet/CHODprimitive_run3754_burst0085_";

    for (int i=0;i<npacket_set;i++){ 
      std::ostringstream oss;
      oss<<i;
      openfile+=oss.str();
      openfile+=".bin";
      myfile[i].open(openfile.c_str(), ios::out | ios::binary);
      if(detector=="MUV") openfile= "packet/MUV3primitive_run3754_burst0085_";
      if(detector=="CHOD") openfile= "packet/CHODprimitive_run3754_burst0085_";

    }
 ifstream  readfile1("/Users/dario/Desktop/Trigger/ControlFPGA/generatore_dati/MUV3primitive_run3754_burst0085.txt");
 //if(detector=="MUV")   readfile1 ("/Users/dario/Desktop/Trigger/ControlFPGA/generatore_dati/MUV3primitive_run3754_burst0085.txt");

  string line;
  int timestamp_array[255]  ={};
  int finetime_array[255]   ={};
  int primitiveID_array[255]={};

  double timestamp=100;
  double finetime;
  double oldtimestamp=0;
  double oldtimestamp_NODownscaling=0;
  int nprim,nprim2=0;
  bool endpacket=0;
  int i=0;
  int npacket=0;
  int firsttimestamp=0;

unsigned int intline=0;

  while(1){
    getline (readfile1,line);
   
    intline= tohex(line.c_str());

    primitiveID_array[nprim] = (intline & 0xffff0000)>>16;
    
    finetime_array[nprim] =(intline & 0xff);
     
    getline(readfile1,line);
    intline= tohex(line.c_str());
    timestamp_array[nprim] =(intline);
      

    if (timestamp_array[nprim]-firsttimestamp>255) {
      endpacket=1;
      cout<<"packet "<<npacket<<" ended with "<<nprim<<" primitives"<<endl;

      nprim2=nprim;
      nprim=0;
    }

    if(endpacket==0) nprim++;

	  
    if(endpacket==1){
      firsttimestamp=timestamp_array[nprim2];
      endpacket=0;
      npacket++;
      cout<<"nprim2 "<<nprim2<<endl;
      	myfile[npacket-1].put((timestamp_array[0]));  
	myfile[npacket-1].put((timestamp_array[0])>>8);   
	myfile[npacket-1].put((timestamp_array[0])>>16); 
	myfile[npacket-1].put(sourceID);
	myfile[npacket-1].put((8+nprim2*8));
	myfile[npacket-1].put((8+nprim2*8)>>8);
	myfile[npacket-1].put((nprim2));
	myfile[npacket-1].put((sourceID));
      for (int j=0; j<nprim2; j++){ 
	myfile[npacket-1].put(finetime_array[j]);   
	myfile[npacket-1].put(reserved);  
	myfile[npacket-1].put(primitiveID_array[j]);   
	myfile[npacket-1].put((primitiveID_array[j])>>8); 
	myfile[npacket-1].put((timestamp_array[j]));  
	myfile[npacket-1].put((timestamp_array[j])>>8);   
	myfile[npacket-1].put((timestamp_array[j])>>16); 
	myfile[npacket-1].put((timestamp_array[j])>>24);
      }
      timestamp_array[0]=timestamp_array[nprim2];
    }
    if(npacket==npacket_set) break;
  }
  for (int i=0; i<npacket;i++){
  myfile[npacket-1].close();
  }

  // Store all histograms in the output file and close up

  cout << "generated "<<npacket<<" packets of "<<detector<<endl;
  return 0;
}
