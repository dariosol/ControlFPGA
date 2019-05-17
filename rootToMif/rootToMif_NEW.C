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

int rootToMif_NEW(TString file_path){
  TFile* file = new TFile(file_path);
  TTree* IRC = 0;
  file->GetObject("IRC",IRC);
  if(IRC){
    FILE * mifDump = fopen("./export_NEW.mif","w");
    fprintf(mifDump,"DEPTH = 32768;\n");
    fprintf(mifDump,"WIDTH = 64;\n");
    fprintf(mifDump,"ADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\nCONTENT\nBEGIN\n");
    TPrimitive* Primitive = new TPrimitive();
    TBranch *test = IRC->GetBranch("fPrimitive");
    test->SetAddress(&Primitive);
    UInt_t global_time= 0;
    for (UInt_t iEntry=0; iEntry<0x000F; iEntry++) { // 0xFFFE
      IRC->GetEntry(iEntry);
      UInt_t timestampH = (Primitive->GetTimeStamp())>>8;
      printf("%.8X\n", timestampH);
      UInt_t timestampL = (Primitive->GetTimeStamp()) & 0x00FF;
      if(iEntry % 2 == 0) fprintf(mifDump,"%X : ",iEntry/2);
      if(global_time != timestampH){
        fprintf(mifDump,"00%.6X",timestampH); //print timestamp LSB
        global_time=timestampH;
        if(iEntry %2==0 && iEntry !=0){
          fprintf(mifDump,"%.4X%.2X%.2X",Primitive->GetPrimitiveID(),timestampL,Primitive->GetFineTime());
          iEntry++;
        }
        fprintf(mifDump,";\n");
      }else{
        fprintf(mifDump,"%.4X%.2X%.2X",Primitive->GetPrimitiveID(),timestampL,Primitive->GetFineTime());
        if(iEntry%2!=0) fprintf(mifDump,";\n");
      }
    }
    fprintf(mifDump,"END;");
    fclose(mifDump);
    printf("Memory init file has been written");
    return 0;
  }else{
    printf("Can't find IRC tree");
    return -1;
  }
}
