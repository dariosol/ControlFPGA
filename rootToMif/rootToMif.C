// @(#)root/fpga
// Author: Alberto Perro 2019
// TO RUN compile library: gSystem->CompileMacro("TPrimitive.cc","kg")
#include <stdio.h>
#include "TFile.h"
#include "TTree.h"
#include "TBranch.h"
#include "TTreeReader.h"
#include "TTreeReaderValue.h"
#include "TString.h"
#include "TPrimitive.hh"
using namespace std;

int rootToMif(TString file_path, UInt_t offset){
  TFile* file = new TFile(file_path);
  TTree* IRC = 0;
  file->GetObject("IRC",IRC);
  if(IRC){
    FILE * mifDump = fopen("./exportHIGH.mif","w");
    fprintf(mifDump,"DEPTH = 32768;\n");
    fprintf(mifDump,"WIDTH = 64;\n");
    fprintf(mifDump,"ADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\nCONTENT\nBEGIN\n");
    TPrimitive* Primitive = new TPrimitive();
    TBranch *test = IRC->GetBranch("fPrimitive");
    test->SetAddress(&Primitive);
    printf("Total number of primitives: %lld",test->GetEntries());
    IRC->GetEntry(offset);
    UInt_t timeOff = (Primitive->GetTimeStamp()) >> 8;
    printf("\n Time offset: %0.6X",timeOff);
    for (UInt_t iEntry=0; iEntry<=0x7FFF; iEntry++) {
      IRC->GetEntry(iEntry+offset);
      UInt_t timestampL = ((Primitive->GetTimeStamp()) & 0x00FF);
      UInt_t timestamp = Primitive->GetTimeStamp() - (timeOff << 8);
      fprintf(mifDump,"%X : %.4X%.2X%.2X%.8X;\n",iEntry,Primitive->GetPrimitiveID(),timestampL,Primitive->GetFineTime(), timestamp);
    }
    fprintf(mifDump,"END;");
    fclose(mifDump);
    printf("\nMemory init file has been written");
    return 0;
  }else{
    printf("Can't find IRC tree");
    return -1;
  }
}
