#include <iostream>
#include <vector>
#include <cmath>
#include <gsl/gsl_statistics_float.h>
#include <gsl/gsl_math.h>
#include <gsl/gsl_deriv.h>

void I_0 (const float ydata[], int init, float i_0[2]);
void method_1 (const float xdata[], const float ydata[], const float i_0[2], int size, int init); 

int main (void){
        return 0;
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
