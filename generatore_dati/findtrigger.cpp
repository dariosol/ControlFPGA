#include <fstream>
#include <iostream>
#include <string>
#include <unistd.h>
#include <cmath>
#include <iomanip>
#include <vector>       
#include <algorithm>   
//Dario

using namespace std;

const int downscaling_set=1;  

int downscaling;

/*
 * 
 *
 * @var
 * @var 
 * @var amount of bit finetime to condider
 *
 */
unsigned int L0address(unsigned int timestamp, unsigned int finetime, int bitfinetime){

  unsigned int ftMSBmask; //11100000 (binary)
  unsigned int timestampLSBmask;
  unsigned int address;
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




/*
 * 
 */
int main() {
  char ftCHOD_char[2];
  char tstmpCHOD_char[8];
  char primitiveIDCHOD[4];
  int start=0;
  char ftMUV_char[2];
  char tstmpMUV_char[8];
  char primitiveIDMUV[4];

  unsigned int ftMSBmask        = 224; //11100000 (binary)
  unsigned int timestampLSBmask = 2047; //11111111111 (binary)

  unsigned int ftCHOD_int;
  unsigned int tstmpCHOD_int;
  unsigned int old_tstmpCHOD_int=0;
  unsigned int timestampCHODLSB;
  unsigned int ftCHODMSB;
  unsigned int CHODaddress=0;
  unsigned int previousCHODaddress=0;

  unsigned int CHODprimitiveIDmask =30;
  unsigned int primitiveIDCHOD_int;  
  unsigned int ftMUV_int;
  unsigned int tstmpMUV_int;
  unsigned int timestampMUVLSB;
  unsigned int ftMUVMSB;
  unsigned int MUVaddress=0;
  unsigned int oldMUVaddress=0;
  int oldMUVaddresscount=0;
  unsigned int MUVprimitiveIDmask=2;
  unsigned int primitiveIDMUV_int;  
  unsigned int bitMUVaddress=0;

  unsigned int coincidence=0;
  unsigned int coincidence_no_old=0;

  int CHODline=0;
  int MUVline=0;
  string primitive;
  ifstream CHODfile;
  ifstream MUVfile;
  int sametimestamp=0;
  int j1=0;
  int tststart=0;

  vector<unsigned int>  ftMUV_intV;
  vector<unsigned int>  tstmpMUV_intV;
  vector<unsigned int>  ftCHOD_intV;
  vector<unsigned int>  tstmpCHOD_intV;
  vector<unsigned int>  trigger;

  vector<long>  timeMUV;
  vector<long>  timeCHOD;
  vector<long>  deltaTime;

  //  CHODfile.open("CHODprimitive_16384_4000.000000KHz.txt");
  CHODfile.open("CHODprimitive_run3754_burst0085_noshift.txt");
  ofstream myfile ("Coincidences_primitives_3754_0085_noshift.txt");
  ofstream timediff ("time_difference_chod-muv.txt");
  downscaling=0;

  /*
   *  To convert chat to hexadecimal
   */
  while (getline(CHODfile, primitive)){
   
    CHODline++;
     
    if(CHODline%2!=0) {
      sprintf(primitiveIDCHOD,"%c%c%c%c",primitive[0],primitive[1],primitive[2],primitive[3]);
      sscanf(primitiveIDCHOD, "%x",  &primitiveIDCHOD_int);
      sprintf(ftCHOD_char,"%c%c",primitive[6],primitive[7]);
      sscanf(ftCHOD_char, "%x",  &ftCHOD_int);
      ftCHOD_intV.push_back(ftCHOD_int);
      continue;
    } 
    sprintf(tstmpCHOD_char,"%c%c%c%c%c%c%c%c",primitive[0],primitive[1],primitive[2],primitive[3],primitive[4],primitive[5],primitive[6],primitive[7]);
    sscanf(tstmpCHOD_char, "%x",  &tstmpCHOD_int);
    tstmpCHOD_intV.push_back(tstmpCHOD_int);

    timeCHOD.push_back( (tstmpCHOD_int << 8) | ftCHOD_int  );

  }

  MUVline=0;
  MUVfile.open("MUV3primitive_run3754_burst0085_noshift.txt");

  while (getline(MUVfile, primitive)){
    MUVline+=1;

    if(MUVline%2!=0) {
      sprintf(primitiveIDMUV,"%c%c%c%c",primitive[0],primitive[1],primitive[2],primitive[3]);
      sscanf(primitiveIDMUV, "%x",  &primitiveIDMUV_int);
      sprintf(ftMUV_char,"%c%c",primitive[6],primitive[7]);
      sscanf(ftMUV_char, "%x",  &ftMUV_int);
      ftMUV_intV.push_back(ftMUV_int);
      continue;
    }
       
    sprintf(tstmpMUV_char,"%c%c%c%c%c%c%c%c",primitive[0],primitive[1],primitive[2],primitive[3],primitive[4],primitive[5],primitive[6],primitive[7]);
    sscanf(tstmpMUV_char, "%x",  &tstmpMUV_int);
    tstmpMUV_intV.push_back(tstmpMUV_int);

    timeMUV.push_back( (tstmpMUV_int << 8) | ftMUV_int  );
  }
  cout<<"Ho caricato i vettori: "<<endl;
  cout<<"timestamp CHOD vector size: "<<tstmpCHOD_intV.size()<<endl;
  cout<<"timestamp MUV3 vector size: "<<tstmpMUV_intV.size()<<endl;

  /*
   * Find primitive closer less than 32*3
   * timestamp unit multiple of 100ps
   */
  for(int i=0; i < tstmpCHOD_intV.size(); i++){
    for(int j=0; j < tstmpMUV_intV.size(); j++){
      long delta = abs(timeMUV[j] - timeCHOD[i]);
      if (delta < 32*3 ) {
        //cout <<"delta: "<< delta << endl;
        deltaTime.push_back(tstmpCHOD_intV[i]);
      } 
    }
  }
  sort(deltaTime.begin(), deltaTime.end(),sortfunction);

  /*
   *  I have to reject two trigger closer than 100 ns in order to simulate LTU
   */
  int olddeltaTime=0;
  int deleted=0;
  for (int i=0; i < deltaTime.size(); i++){
    if((int) deltaTime.at(i) - olddeltaTime <= 3) {
      cout<<"deltaT"<<endl;
      cout<<"to delete "<<hex<<deltaTime.at(i)<<endl;
      cout<<"olddeltaTime "<<hex<<olddeltaTime<<endl;
      deleted = deltaTime.at(i);
      deltaTime.erase(deltaTime.begin() + (i) );
      cout<<"******"<<endl;
      //Deleting a value from the vector it shrink
      --i;
      continue;
    }
    if(deltaTime.at(i)-olddeltaTime > 3) olddeltaTime=deltaTime.at(i);
  }

  for (int i=0; i < deltaTime.size(); i++) {
    timediff <<setfill('0')<<setw(8)<<hex<< deltaTime[i] << endl;
  }

  /*
   *  For on chod timestamps 
   */
  for(int i=0; i< tstmpCHOD_intV.size();i++){
    
    if(i%5000==0)cout<<"primitive number "<<i<<endl;
    // time stamp 11 less significative bit (LSB) + fine time (ft) 3 more significative bit (MSB)      
    CHODaddress = L0address(tstmpCHOD_intV.at(i),ftCHOD_intV.at(i),3);
    
    if(CHODaddress == previousCHODaddress) {
      sametimestamp++;
      continue;}
    
    /*
     *  For on muv timestamps 
     */
    for(int j=0; j< tstmpMUV_intV.size();j++){
     
      //devono avere lo stesso timestamp(+/- 1):
     
      if(abs((int)tstmpCHOD_intV.at(i) - (int)tstmpMUV_intV.at(j))>1) continue;

      // time stamp 11 less significative bit (LSB) + fine time (ft) 3 more significative bit (MSB)	  
      MUVaddress = L0address(tstmpMUV_intV.at(j),ftMUV_intV.at(j),3);
      if (MUVaddress==oldMUVaddress) {
	oldMUVaddresscount++;
	continue;}
          
      bitMUVaddress = ftMUV_intV.at(j) & ((unsigned int) 1 << (unsigned int) 4);


      //**************COINCIDENCES:**********************************************************//		 
      if(MUVaddress==CHODaddress || MUVaddress+1==CHODaddress || (MUVaddress-1==CHODaddress)) {
	coincidence_no_old++;
	   	  
	if (downscaling<downscaling_set) downscaling++;
	
	  old_tstmpCHOD_int = tstmpCHOD_intV.at(i);
	  downscaling=0;
	  oldMUVaddress=MUVaddress;
	  previousCHODaddress = CHODaddress;
	  trigger.push_back(tstmpCHOD_intV.at(i));

	  break;
      }
    } //end of MUV while
    MUVfile.close();
  }  //end of CHOD while

  CHODfile.close();
  cout<<"finito di trovare le coincidenze, elimino quelli vicini"<<endl;

  sort(trigger.begin(), trigger.end(),sortfunction);

  int oldtrigger=0;

  cout<<"trigger.size() "<<trigger.size()<<endl;

  /*
   *  I have to reject two trigger closer than 100 ns in order to simulate LTU
   */
  for (int i=0; i<trigger.size();i++){

    cout<<"sto valutando "<<trigger.at(i)<<endl;

    if((int)trigger.at(i)-oldtrigger <= 3) {
      cout<<"deltaT"<<endl;
      cout<<"to delete "<<hex<<trigger.at(i)<<endl;
      cout<<"oldtrigger "<<hex<<oldtrigger<<endl;
      deleted=trigger.at(i);
      trigger.erase(trigger.begin()+(i));
      cout<<"******"<<endl;
      i=i-1;
      continue;
      
    }
    cout<<endl;
    
    if(trigger.at(i)-oldtrigger > 3) oldtrigger=trigger.at(i);

    /*    cout<<i<<" actual situation :"<<endl;
    cout<<"last deleted "<<hex<<deleted<<endl;
    cout<<"oldtrigger   "<<hex<<oldtrigger<<endl;
    cout<<"trigger      "<<hex<<trigger.at(i)<<endl<<endl;
    */  
}

  for(int i=0;i<trigger.size();i++){
    myfile<<setfill('0')<<setw(8)<<hex<<trigger.at(i)<<endl;
    coincidence++;
  }
  
  myfile.close();

  cout<<"event with the same timestamp "<<dec<<sametimestamp<<endl;
  cout<<"eventi muv con lo stesso address "<<dec<<oldMUVaddresscount<<endl;
  cout<<"Number of coincidences: "<<dec<<trigger.size()<<endl;

  return 0;
}
