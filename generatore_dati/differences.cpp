#include <fstream>
#include <iostream>
#include <string>
#include <unistd.h>
#include <cmath>
#include <iomanip>
#include <TGraph.h>
#include <TFile.h>
using namespace std;

const int nprimitives=16384*2;
const int downscaling_set=1;  

int downscaling;

int main() {
  string timestamp_str;
  string triggerword_str;
  string data_type_str;
  string timestamp_str_prec;
  char tstmp_teorico[8];
  int tstmp_teorico_int;
  int timestamp_n;
  int triggerword_n;
  int data_type_n;
  int timestamp_n_prec;

  int timestamp_trovati[10000]={};
  int timestamp_teorici[10000]={};
  string primitive;
  int j=0;
  ifstream myfile2 ("Coincidences_primitives3_3754_burst0085.txt");
 
  ifstream myfile1 ("/Users/dario/Desktop/Trigger/UDP_analysis/prova.txt");

  while (getline(myfile2, primitive)){
    sprintf(tstmp_teorico,"%c%c%c%c%c%c%c%c",primitive[0],primitive[1],primitive[2],primitive[3],primitive[4],primitive[5],primitive[6],primitive[7]);
 sscanf(tstmp_teorico, "%x",  &tstmp_teorico_int);
    timestamp_teorici[j] = tstmp_teorico_int;
    j++;
}

  j=0;
  primitive="";
  while (getline(myfile1, primitive)){
    sprintf(tstmp_teorico,"%c%c%c%c%c%c%c%c",primitive[0],primitive[1],primitive[2],primitive[3],primitive[4],primitive[5],primitive[6],primitive[7]);
    sscanf(tstmp_teorico, "%x",  &tstmp_teorico_int);
    timestamp_trovati[j] = tstmp_teorico_int;
    j++;
  }
  
  int trovato=0;
  int nontrovati=0;

  for (int i =0; i<10000; i++){
    
    int timestamp_1 =  timestamp_trovati[i];
    
    for (int k=0; k<10000; k++){
    
      if(timestamp_1==timestamp_teorici[k]) trovato=1;
    }

    if (trovato==0){
      cout<<hex<<timestamp_1<<endl;
      nontrovati++;
    }

    trovato=0;

  }
  TGraph *comparison = new TGraph(8000, timestamp_trovati, timestamp_teorici);
  comparison->Draw("AC*");
  TFile *differences = new TFile("differences.root","recreate");
  comparison->Write("AC");
  cout<<"NON TROVATI: "<<dec<<nontrovati<<endl;
  return 0;
}
