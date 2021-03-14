set g
set term pdf
set key opaque
set ls 1 lc rgb 'black' pt 7 ps 0.1
set ls 2 lc rgb 'orange' lt 1 lw 1

file = system("sed -n 1p settings.txt")
set o 'Graphs/graph_'.file.'_2.pdf'

Title = system("sed -n 2p settings.txt")
Tx = system("sed -n 3p settings.txt")
Ty = system("sed -n 4p settings.txt")

I_s = system("sed -n 8p settings.txt")
I_err_s = system("sed -n 9p settings.txt")
I = I_s + 0
I_err = I_err_s + 0
I1 = I-I_err 
I2 = I+I_err

Init_s = system("sed -n 13p settings.txt")
Init = Init_s + 0

set tit Title
set xl Tx
set yl Ty

set fit errorvar

f(x) = A*x+B
A = 100
B = 100

fit[Init:] f(x) 'Data/'.file.'.txt' u 1:2 via A,B

V = (I-B)/A
V_err = V*((I_err+B_err)/abs(I-B) + A_err/A)
V1 = V-V_err
V2 = V+V_err

R_s = system("sed -n 15p settings.txt")
R = R_s + 0

Results = sprintf(" R^2 = %.4f\n V_0 = (%.2f ± %.2f) V", R, V, V_err)
set obj 2 rect from graph 0, 1 to graph 0.27, 0.85 fc rgb "white" front
set lab 2 Results at graph 0, 0.96 front

set arrow nohead from V, graph 0 to V, graph 1 lt 1 lc rgb "red"
set arrow nohead from V1, graph 0 to V1, graph 1 lt 0 lc rgb "red"
set arrow nohead from V2, graph 0 to V2, graph 1 lt 0 lc rgb "red"

set arrow nohead from graph 0, first I to graph 1, first I lt 1 lc rgb "blue"
set arrow nohead from graph 0, first I1 to graph 1, first I1 lt 0 lc rgb "blue"
set arrow nohead from graph 0, first I2 to graph 1, first I2 lt 0 lc rgb "blue"

p[-4:0][-10:] 'Data/'.file.'.txt' u 1:2 ls 1 t 'Data', f(x) ls 2 t 'Fit'
