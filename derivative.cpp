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
void print (std::string fname, const double dydata[], const double dxdata[], int size);
void derivate (std::string fname, const double xdata[], const double ydata[], int size, const int size_part);

int main (int argc, char **argv){
        std::vector<double> x;
        std::vector<double> y;
        std::string fname = argv[1];
        std::string fname_1 = "Data/"+fname+".txt";
        std::string fname_2 = "Data/d_"+fname+".txt";
        const int size = read(fname_1, x, y);

        double xdata[size] = {};
        double ydata[size] = {};
        for (int ii = 0; ii < size; ii++){
                xdata[ii] = x[ii];
                ydata[ii] = y[ii];
        }

        const int part_size = atoi(argv[2]);
        derivate (fname_2, xdata, ydata, size, part_size);
        std::cout << "Function derivated!!\n";
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

void derivate (std::string fname, const double xdata[], const double ydata[], int size, const int part_size){
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
