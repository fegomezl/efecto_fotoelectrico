#include <iostream>
#include <vector>
#include <cmath>
#include <vector>
#include <string>
#include <fstream>
#include <sstream>
#include <gsl/gsl_statistics_double.h>
#include <gsl/gsl_fit.h>

int read(std::string fname, std::vector<double> &x, std::vector<double> &y);
void I_0 (const double ydata[], int init, double i_0[2]);
void method_1 (const double xdata[], const double ydata[], 
                const double i_0[2], int size, int init); 
void print (std::string fname, const double dydata[], const double dxdata[], int size);
void method_3 (std::string fname, const double xdata[], const double ydata[],
                int size);

int main (int argc, char **argv){
        std::vector<double> x;
        std::vector<double> y;
        std::string fname_1 = "Data/365_0.txt";
        std::string fname_2 = "Data/d_365_0.txt";
        const int size = read(fname_1, x, y);

        double xdata[size] = {};
        double ydata[size] = {};
        for (int ii = 0; ii < size; ii++){
                xdata[ii] = x[ii];
                ydata[ii] = y[ii];
        }

        int init = atoi(argv[1]);
        double i_0[2] = {};
        I_0 (ydata, init, i_0);
        method_1 (xdata, ydata, i_0, size, init);
        method_3 (fname_2, xdata, ydata, size);
        std::cout << "Proccess completed!!\n";
        return 0;
}

int read(std::string fname, std::vector<double> &x, std::vector<double> &y){
        std::ifstream infile(fname);
        std::string line;
        int ii=0;

        while(std::getline(infile, line)){
                std::stringstream ss(line);
                double a, b;
                if(ss >> a >> b){
                        x.push_back(a);
                        y.push_back(b);
                        ii++;
                }
        }
        return ii;
}

void I_0 (const double ydata[], int init, double i_0[2]){
        i_0[0] = gsl_stats_mean(ydata, 1, init);
        i_0[1] = 3*gsl_stats_sd_m(ydata, 1, init, i_0[0]);
        std::cout << "I_0 = " << i_0[0] << "\nI_0_err = " << i_0[1] << "\n"; 
}

void method_1 (const double xdata[], const double ydata[], 
                const double i_0[2], int size, int init){ 
        const int limit = 4;
        int counter = 0;
        double rdata[limit] = {};
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
        
        double u = gsl_stats_mean(rdata, 1, limit);
        double u_err = gsl_stats_sd_m(rdata, 1, limit, u);
        std::cout << "Method 1: \nU = " << u << "\nU_err = " << u_err << "\n";
}

void print (std::string fname, const double dxdata[], const double dydata[], 
                const double dxerror[], const double dyerror[], int size){
        std::ofstream file;
        file.open(fname);
        for(int ii = 0; ii < size; ii++){
        file << dxdata[ii] << "\t"
             << dydata[ii] << "\t"
             << dxerror[ii] << "\t"
             << dyerror[ii] << "\n";
        }
        file.close();
}

void method_3 (std::string fname, const double xdata[], const double ydata[],
                int size){
        const int part_size = 5;
        int new_size = size/part_size;
        double dxdata[new_size] = {};
        double dydata[new_size] = {};
        double dxerror[new_size] = {};
        double dyerror[new_size] = {};

        double c1 = 0, c11 = 0, null = 0;
        double xlocal[part_size] = {};
        double ylocal[part_size] = {};
        for (int ii = 0; ii < size; ii++){
                xlocal[ii%part_size] = xdata[ii];
                ylocal[ii%part_size] = ydata[ii];
                if ((ii+1)%part_size == 0){
                        gsl_fit_linear(xlocal, 1, ylocal, 1, part_size, 
                                        &null, &c1, &null, &null, &c11, &null);
                        dydata[ii/part_size] = c1;
                        dyerror[ii/part_size] = std::sqrt(c11);
                        dxdata[ii/part_size] = gsl_stats_mean(xlocal, 1, part_size);
                        dxerror[ii/part_size] = gsl_stats_sd(xlocal, 1, part_size);
                }
        } 

        print(fname, dxdata, dydata, dxerror, dyerror, new_size);
}
