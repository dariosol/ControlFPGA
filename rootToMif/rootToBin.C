// @(#)root/fpga
// Author: Alberto Perro 10/11/2019
// Email: alberto.perro57@edu.unito.it
#include <stdio.h>
#include <vector>
#include <algorithm>
#include "TSystem.h"
#include "TFile.h"
#include "TTree.h"
#include "TBranch.h"
#include "TTreeReader.h"
#include "TTreeReaderValue.h"
#include "TString.h"
#include "TPrimitive.hh"
using namespace std;

int rootToBin(TString file_path, TString branchName, uint32_t startTime, uint32_t nOfPrim){
  gSystem->CompileMacro("TPrimitive.cc","kg");
  TFile* file = new TFile(file_path);
  TTree* tree = 0;
  file->GetObject(branchName,tree);
  if(tree){
    FILE* binDump = fopen("./export_file.bin","wb"); //binary write
    TPrimitive* Primitive = new TPrimitive();
    TBranch* test = tree->GetBranch("fPrimitive");
    test->SetAddress(&Primitive);
    uint32_t global_time= 0;
    std::vector<uint32_t> LUT;
    std::vector<uint32_t> data;
    uint32_t addr = 0;
    uint32_t startEntry = 0;
    tree->GetEntry(startEntry);
    while(static_cast<uint32_t>(Primitive->GetTimeStamp()) <= startTime) tree->GetEntry(++startEntry);
    printf("timestamp at entry: %u\n",startEntry);
    for (uint32_t iEntry = startEntry; iEntry<startEntry+nOfPrim; iEntry++) { // 0xFFFE
      tree->GetEntry(iEntry);
      uint32_t timestampH = (Primitive->GetTimeStamp()-startTime)>>8;
      uint8_t timestampL = static_cast<uint8_t>((Primitive->GetTimeStamp()-startTime) & 0x00FF);
      if(global_time != timestampH){
        LUT.push_back(addr);
        uint32_t temp = (static_cast<uint16_t>(Primitive->GetPrimitiveID())<<16)+(timestampL<<8)+static_cast<uint8_t>(Primitive->GetFineTime());
        global_time = timestampH;
        data.push_back(timestampH);
        data.push_back(temp);
        addr += 8;
      }else{
        uint32_t temp = (static_cast<uint16_t>(Primitive->GetPrimitiveID())<<16)+(timestampL<<8)+static_cast<uint8_t>(Primitive->GetFineTime());
        data.push_back(temp);
        addr+=4;
      }
    }
    uint32_t size = LUT.size()*4+4; //compensate for LUT size and zeros size
    auto offset = [size](uint32_t &n){ n+= size; };
    std::for_each(LUT.begin(), LUT.end(), offset);
    fwrite(&LUT[0],sizeof(uint32_t), LUT.size(), binDump);
    uint32_t zeros = 0;
    uint32_t* zptr = &zeros;
    fwrite(zptr,sizeof(uint32_t),1,binDump);
    fwrite(&data[0],sizeof(uint32_t), data.size(), binDump);
    fclose(binDump);
    printf("Memory bin file has been written");
    printf("\n%u 32-bit words\nTotal bin size %.2f MB\n", addr/4, (addr+size)/1e6);
    return 0;
  }else{
    printf("Can't find %s tree",branchName.Data());
    return -1;
  }
}
