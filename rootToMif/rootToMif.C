// @(#)root/fpga
// Author: Alberto Perro 2019
// TO RUN compile library: gSystem->CompileMacro("TPrimitive.cc","kg")
#include <iostream>
#include "TFile.h"
#include "TTree.h"
#include "TBranch.h"
#include "TTreeReader.h"
#include "TTreeReaderValue.h"
#include "TString.h"
#include "TPrimitive.hh"
using namespace std;

int rootToMif(TString file_path){
  TFile* file = new TFile(file_path);
  TTree* IRC = 0;
  file->GetObject("IRC",IRC);
  if(IRC){
    IRC->Print();
    TPrimitive* Primitive = new TPrimitive();
    TBranch *test = IRC->GetBranch("fPrimitive");
    test->SetAddress(&Primitive);
    for (Long64_t iEntry=0; iEntry<IRC->GetEntries(); iEntry++) {
      tree->GetEntry(iEntry);
    return 0;
  }else{
    printf("Can't find IRC tree");
    return -1;
  }
}
