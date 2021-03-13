#include<fstream>
#include<iostream>
#include <string>
#include <vector>
#include <sstream>

int read(std::string fname, std::vector<float> &x, std::vector<float> &y){
  std::ifstream infile(fname);

  std::string line;
  int ii=0;
  while(std::getline(infile, line)){
    std::stringstream ss(line);
    float a, b;
    if(ss >> a >> b){
      x.push_back(a);
      y.push_back(b);
      ii++;
      }
  }
  return ii;
}
