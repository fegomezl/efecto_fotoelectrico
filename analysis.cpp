#include <iostream>
#include <vector>
#include <cmath>
#include <vector>
#include <string>
#include <fstream>
#include <sstream>
#include <gsl/gsl_statistics_double.h>
#include <gsl/gsl_fit.h>
//aja
int read(std::string fname, std::vector<double> &x, std::vector<double> &y);
void write(const std::vector<double> x, const std::vector<double> y, 
                double xdata[], double ydata[], const int size);
void I_0 (const double ydata[], double i_0[2], 
                const int init);
double fit (const double xdata[], double ydata[], double par[4], 
                const int size, const int end); 
void method_1 (const double xdata[], const double ydata[], 
                const int size, const int init); 
void method_2 (const double xdata[], const double ydata[], 
                const int size, const int init, const int end);
void method_2 (const double xdata[], const double ydata[], 
                const int size, const int init, const int end);
void method_3 (const double dxdata[], const double dydata[], 
                const int dsize, const int mid);

int main (int argc, char **argv){
        std::string fname = argv[1];
        std::string fname_1 = "Data/"+fname+".txt";
        std::string fname_2 = "Data/d_"+fname+".txt";

        std::vector<double> x;
        std::vector<double> y;
        std::vector<double> dx;
        std::vector<double> dy;
        const int size = read(fname_1, x, y);
        const int dsize = read(fname_2, dx, dy);
        
        double xdata[size] = {};
        double ydata[size] = {};
        double dxdata[size] = {};
        double dydata[size] = {};
        write(x, y, xdata, ydata, size);
        write(dx, dy, dxdata, dydata, dsize);
        
        int init = atoi(argv[2]);
        if (init != 0){
                std::cout << "Method 1: \n";
                method_1(xdata, ydata, size, init);
        }

        int end = atoi(argv[3]);
        if (init*end != 0){
                std::cout << "Method 2: \n";
                method_2(xdata, ydata, size, init, end);
        }

        int mid = atoi(argv[4]);
        if (mid != 0){
                std::cout << "Method 3: \n";
                method_2(dxdata, dydata, dsize, mid, mid+1);
                method_3(dxdata, dydata, dsize, mid);
                std::cout << "Final results in gnuplot.\n";
        }
        
        std::cout << "Proccess completed!!\n";
        return 0;
}

int read (std::string fname, std::vector<double> &x, std::vector<double> &y){
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

void write(const std::vector<double> x, const std::vector<double> y, 
                double xdata[], double ydata[], const int size){
        for (int ii = 0; ii < size; ii++){
                xdata[ii] = x[ii];
                ydata[ii] = y[ii];
        }
}

void I_0 (const double ydata[], double i_0[2], const int init){
        i_0[0] = gsl_stats_mean(ydata, 1, init);
        i_0[1] = 3*gsl_stats_sd_m(ydata, 1, init, i_0[0]);
}

double fit (const double xdata[], const double ydata[], double par[4], 
                const int size, const int end){ 
        double xfit[size-end+1] = {};
        double yfit[size-end+1] = {};
        for (int ii = 0; ii <= size - end; ii++){
                xfit[ii] = xdata[end+ii-1];
                yfit[ii] = ydata[end+ii-1];
        }
        
        double c0=0, c1=0, c00=0, c11=0, null=0;
        gsl_fit_linear(xfit, 1, yfit, 1, size-end+1, &c0, &c1, &c00, &null, &c11, &null);
        par[0] = c0;             par[1] = c1;
        par[2] = std::sqrt(c00); par[3] = std::sqrt(c11);
        double r_2 = gsl_stats_correlation(xfit, 1, yfit, 1, size-end+1);
        return r_2;
}

void method_1 (const double xdata[], const double ydata[], 
                const int size, const int init){  
        double i_0[2] = {};
        I_0(ydata, i_0, init);

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
        
        double v = gsl_stats_mean(rdata, 1, limit);
        double v_err = gsl_stats_sd_m(rdata, 1, limit, v);
        std::cout << "V = " << v << "\nV_err = " << v_err << "\n\n";
}

void method_2 (const double xdata[], const double ydata[], 
                const int size, const int init, const int end){
        double i_0[2] = {};
        I_0(ydata, i_0, init);
        
        double par[4] = {};
        double r_2 = fit (xdata, ydata, par, size, end);

        double v = (i_0[0]-par[0])/par[1];
        double v_err = std::abs(v)*((i_0[1]+par[2])/std::abs(i_0[0]-par[0])+par[3]/par[1]);
        std::cout << "V = " << v << "\nV_err = " << v_err << "\nR² = " << r_2 << "\n\n";
}

void method_3 (const double dxdata[], const double dydata[], 
                const int dsize, const int mid){
        double di_0[2] = {};
        I_0(dydata, di_0, mid);
        double dx_0 = dxdata[mid];

        std::string fname = "data_aux.txt";
        std::ofstream file;
        file.open(fname);
        file << di_0[0] << "\n"
                << di_0[1]/3 << "\n"
                << dx_0;
        file.close();
}
