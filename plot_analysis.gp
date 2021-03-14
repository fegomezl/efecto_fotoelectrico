file = system("sed -n 1p settings.txt")

I_s = system("sed -n 1p data_aux.txt")
I_err_s = system("sed -n 2p data_aux.txt")
lim_s = system("sed -n 3p data_aux.txt")

I = I_s + 0
I_err = I_err_s + 0
lim = lim_s + 0

set fit quiet
set fit errorvar

f(x) = A*x+B
B = 100
A = -B/lim

fit[lim:] f(x) 'Data/d_'.file.'.txt' u 1:2:3:4 xyerrors via A,B

V = (I-B)/A
V_err = V*((I_err+B_err)/abs(I-B) + A_err/A)

Results = sprintf("V = %f\nV_err = %f", V, V_err)
print Results
