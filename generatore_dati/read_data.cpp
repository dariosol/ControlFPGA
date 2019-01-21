#include <fstream>
#include <iostream>
#include <iomanip>
#include <sstream>
#include <string>
#include <unistd.h>
#include "TH1F.h"
#include "TCanvas.h"
#include "TFile.h"

using namespace std;


int main() {
  char* file= "/Users/dario/Desktop/DE4_read_data/13MHz_6_4us_new.txt";
  //char* file= "/Users/dario/Desktop/DE4_read_data/versione9periodico.txt";  
FILE *fd;
  char buf[500];
  char *res;
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
  int count=0;
  int count_out=0;
  ifstream Coincidencefile;
  ofstream Teoreticalfile;
  ofstream Datafile;

  long int timestamp_trovati[400000];
  long int timestamp_teorici[400000];

  int i=0,j=0;
  string primitive;


  TFile *data = new TFile("DE4ReadData_expo.root","recreate");

   Coincidencefile.open("Coincidences_primitives.txt");

   Datafile.open("Data_primitives.txt");
   Teoreticalfile.open("Teoretical_primitives.txt");

while (getline(Coincidencefile, primitive)){
    sprintf(tstmp_teorico,"%c%c%c%c%c%c%c%c",primitive[0],primitive[1],primitive[2],primitive[3],primitive[4],primitive[5],primitive[6],primitive[7]);
    sscanf(tstmp_teorico, "%x",  &tstmp_teorico_int);
    timestamp_teorici[j] = tstmp_teorico_int;
    Teoreticalfile<<setfill('0')<<setw(8)<<hex<< tstmp_teorico_int<<endl;
    j++;
  }
  

  
  TH1F *DTtimestamp = new TH1F("DT","DT",5001,0,5000);
  TH1F *h_data_type = new TH1F("data_type","data_type",51,0,50);
  TH1F *h_triggerword = new TH1F("triggerword","triggerword",51,0,50);

  fd=fopen(file, "r");
  if( fd==NULL ) {
    perror("Errore in apertura del file");
    exit(1);
  }
  while(1) {
    res=fgets(buf, 500, fd);

    if( res==NULL )
      break;

    if (buf[2]=='3'){
      timestamp_str = string(1, buf[33])+string(1,buf[34])+string(1,buf[30])+string(1,buf[31])+string(1,buf[27])+string(1,buf[28])+string(1,buf[24])+string(1,buf[25]);
      
      data_type_str = string(1, buf[39])+string(1,buf[40]);
      data_type_n = (int)strtol(data_type_str.c_str(), NULL, 16);

      timestamp_n = (int)strtol(timestamp_str.c_str(), NULL, 16);
      if (timestamp_n ==0) continue;

      timestamp_trovati[i]=timestamp_n;
      Datafile<<setfill('0')<<setw(8)<<hex<<timestamp_n<<endl;
      i++;

      count++;

      h_data_type->Fill(data_type_n);
      DTtimestamp->Fill(timestamp_n-timestamp_n_prec);
      if (timestamp_n-timestamp_n_prec<3) cout<<"ERROR "<<timestamp_n<<endl;
    }

    if (buf[2]=='4'){
      triggerword_str = string(1,buf[48]) + string(1,buf[49]);     
      triggerword_n = (int)strtol(triggerword_str.c_str(), NULL, 16);
      h_triggerword->Fill(triggerword_n);
    }
 
    timestamp_n_prec = timestamp_n;
    timestamp_str_prec=timestamp_str;
  }
  fclose(fd);

  
  
  int trovato=0;
  int countnontrovati=0;

  for (int z=0;z<i-1;z++){//dati
    trovato=0;
    for (int k = 0; k<j; k++){//teorici
      if (timestamp_trovati[z]==timestamp_teorici[k]) {
	trovato++;
	break;
      }
    }
    if (trovato==0) 
      {
	cout<<"timestamp not found: "<<hex<<timestamp_trovati[z]<<endl;
	cout<<"timestamp precedente "<<hex<<timestamp_trovati[z-1]<<endl;
	cout<<"DT "<<dec<<TMath::Abs(timestamp_trovati[z]-timestamp_trovati[z-1])<<endl;
	cout<<endl;	
	countnontrovati++;	  
      }
    
  }
  Coincidencefile.close();
  Teoreticalfile.close();
  Datafile.close();
  cout<<"events found: "<<dec<<count-1<<endl;//tolgo l'eob
  cout<<"events not found: "<< dec<<countnontrovati<<endl;
  cout<<"EOB Timestamp: "<< timestamp_trovati[i-1]<<endl;
  
  TCanvas *c1= new TCanvas();
  TCanvas *c2= new TCanvas();
  TCanvas *c3= new TCanvas();
  
  c1->cd();
  DTtimestamp->Draw();    
  DTtimestamp->Write("DT");
  
  c2->cd();
  h_data_type->Draw();    
  h_data_type->Write("data_type");    
  c2->SetLogy();
  
  c3->cd();
  h_triggerword-> Draw();    
  h_triggerword -> Write("triggerword"); 
  c3->SetLogy(); 
  
  return 0;
}
  


