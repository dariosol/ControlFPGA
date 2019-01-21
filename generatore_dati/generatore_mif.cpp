#include <iostream>
#include <fstream>
using namespace std;

const int depth=16384*2; // size of memory in words
const int with=64; // size of sigle word in bits.
const string address_radix = "HEX"; //-- The radix for address values
const string data_radix = "HEX"; //-- The radix for data values

int main () {
  int address_counter =0;
  ofstream myfile1 ("../CHODprimitives.mif");
  ofstream myfile2 ("../MUVprimitives.mif");
  ofstream myfile3 ("../RICHprimitives.mif");
  ofstream myfile4 ("../LAVprimitives.mif");

  string line;
  ifstream  readfile1 ("CHODprimitive_run3754_burst0085_more.txt");
  ifstream  readfile2 ("MUV3primitive_run3754_burst0085_more.txt");
  ifstream  readfile3 ("CHODprimitive_run3754_burst0085_more.txt");
  ifstream  readfile4 ("CHODprimitive_run3754_burst0085_more.txt");
  
  if (myfile1.is_open())
    {
      myfile1 << "DEPTH = "<<depth<<";\n";
      myfile1 << "WIDTH = "<<with<<";\n";
      myfile1 << "ADDRESS_RADIX = "<<address_radix<<";\n";
      myfile1 << "DATA_RADIX = "<<data_radix<<";\n";
      myfile1 << "CONTENT\n";
      myfile1 << "BEGIN\n";
      if (readfile1.is_open())
	for  (int i=0; i<depth; i++) {
	  getline (readfile1,line);
	  if (i<16) myfile1 <<"0"<<hex<<i<<" : ";
	  else myfile1 <<hex<<i<<" : ";
	  myfile1<<line;
	  getline (readfile1,line);
	  myfile1 <<line<<";\n";
	}
      myfile1<<"END;\n";
      myfile1.close();
    }
  else cout << "Unable to open file";

  if (myfile2.is_open())
    {
      myfile2 << "DEPTH = "<<depth<<";\n";
      myfile2 << "WIDTH = "<<with<<";\n";
      myfile2 << "ADDRESS_RADIX = "<<address_radix<<";\n";
      myfile2 << "DATA_RADIX = "<<data_radix<<";\n";
      myfile2 << "CONTENT\n";
      myfile2 << "BEGIN\n";
      if (readfile2.is_open())
	for  (int i=0; i<depth; i++) {
	  getline (readfile2,line);
	  if (i<16) myfile2 <<"0"<<hex<<i<<" : ";
	  else myfile2 <<hex<<i<<" : ";
	  myfile2<<line;
	  getline (readfile2,line);
	  myfile2 <<line<<";\n";
	}
      myfile2<<"END;\n";
      myfile2.close();
    }
  else cout << "Unable to open file";


if (myfile3.is_open())
    {
      myfile3 << "DEPTH = "<<depth<<";\n";
      myfile3 << "WIDTH = "<<with<<";\n";
      myfile3 << "ADDRESS_RADIX = "<<address_radix<<";\n";
      myfile3 << "DATA_RADIX = "<<data_radix<<";\n";
      myfile3 << "CONTENT\n";
      myfile3 << "BEGIN\n";
      if (readfile3.is_open())
	for  (int i=0; i<depth; i++) {
	  getline (readfile3,line);
	  if (i<16) myfile3 <<"0"<<hex<<i<<" : ";
	  else myfile3 <<hex<<i<<" : ";
	  myfile3<<line;
	  getline (readfile3,line);
	  myfile3 <<line<<";\n";
	}
      myfile3<<"END;\n";
      myfile3.close();
    }
  else cout << "Unable to open file";



if (myfile4.is_open())
    {
      myfile4 << "DEPTH = "<<depth<<";\n";
      myfile4 << "WIDTH = "<<with<<";\n";
      myfile4 << "ADDRESS_RADIX = "<<address_radix<<";\n";
      myfile4 << "DATA_RADIX = "<<data_radix<<";\n";
      myfile4 << "CONTENT\n";
      myfile4 << "BEGIN\n";
      if (readfile4.is_open())
	for  (int i=0; i<depth; i++) {
	  getline (readfile4,line);
	  if (i<16) myfile4 <<"0"<<hex<<i<<" : ";
	  else myfile4 <<hex<<i<<" : ";
	  myfile4<<line;
	  getline (readfile4,line);
	  myfile4 <<line<<";\n";
	}
      myfile4<<"END;\n";
      myfile4.close();
    }
  else cout << "Unable to open file";






  cout<<"number of primitive generated is "<<depth<<endl;
  return 0;
}
