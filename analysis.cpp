#include <iostream>
#include <vector>
#include <cmath>
#include <vector>
#include <string>
#include <fstream>
#include <sstream>
#include <gsl/gsl_statistics_float.h>
#include <gsl/gsl_math.h>
#include <gsl/gsl_deriv.h>

int read(std::string fname, std::vector<float> &x, std::vector<float> &y);
void I_0 (const float ydata[], int init, float i_0[2]);
void method_1 (const float xdata[], const float ydata[], const float i_0[2], int size, int init); 

int main (void){
        std::vector<float> x;
        std::vector<float> y;
        std::string fname = "Data/365_0.txt";
        const int size = read(fname, x, y);

        float xdata[size] = {};
        float ydata[size] = {};
        for (int ii = 0; ii < size; ii++){
                xdata[ii] = x[ii];
                ydata[ii] = y[ii];
        }

        int init = 150;
        float i_0[2] = {};
        I_0 (ydata, init, i_0);
        method_1 (xdata, ydata, i_0, size, init);
        std::cout << "Proccess completed!!\n";
        return 0;
}

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

void I_0 (const float ydata[], int init, float i_0[2]){
        i_0[0] = gsl_stats_float_mean(ydata, 1, init);
        i_0[1] = 3*gsl_stats_float_sd_m(ydata, 1, init, i_0[0]);
        std::cout << "I_0 = " << i_0[0] << "\nI_0_err = " << i_0[1] << "\n"; 
}

void method_1 (const float xdata[], const float ydata[], const float i_0[2], int size, int init){ 
        const int limit = 5;
        int counter = 0;
        float rdata[limit] = {};
        for (int ii = init; ii < size; ii++){
                if (std::abs(ydata[ii]-i_0[0]) > i_0[1]){
                        rdata[counter] = xdata[ii];
                        counter += 1;
                }else{
                        counter = 0;
                }
                if (counter == limit) break; 
        }
        if (counter =! limit) std::cout << "There was a problem with method 1.\n";
        
        float u = gsl_stats_float_mean(rdata, 1, limit);
        float u_err = gsl_stats_float_sd_m(rdata, 1, limit, u);
        std::cout << "Method 1: \nU = " << u << "\nU_err = " << u_err << "\n";
}
