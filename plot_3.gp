set g
set term pdf
set key opaque
set ls 1 lc rgb 'black' pt 7 ps 0.1
set ls 2 lc rgb 'gold' pt 7 ps 0.1
set ls 3 lc rgb 'orange' lt 1 lw 1

file = system("sed -n 1p settings.txt")
set o 'Graphs/graph_'.file.'_3.pdf'

Title = system("sed -n 2p settings.txt")
Tx = system("sed -n 3p settings.txt")
Ty = system("sed -n 4p settings.txt")

set tit Title
set xl Tx
set yl Ty

lim = -1.9
set fit errorvar

f(x) = A*x+B
A = 57
B = 100

fit[lim:] f(x) 'Data/d_'.file.'.txt' u 1:2:3:4 xyerrors via A,B

I = -0.797
I_err = 2.804
I1 = I-I_err
I2 = I+I_err

V = (I-B)/A
V_err = V*((I_err+B_err)/abs(I-B) + A_err/A)
V1 = V-V_err
V2 = V+V_err

set arrow nohead from V, graph 0 to V, graph 1 lt 1 lc rgb "red"
set arrow nohead from V1, graph 0 to V1, graph 1 lt 0 lc rgb "red"
set arrow nohead from V2, graph 0 to V2, graph 1 lt 0 lc rgb "red"

Results = sprintf(" V_0 = (%.1f ± %.1f) V", V, V_err)
set obj 2 rect from graph 0, 1 to graph 0.2, 0.9 fc rgb "white" front
set lab 2 Results at graph 0, 0.96 front

p[-4:0] 'Data/'.file.'.txt' u 1:2 ls 1 t 'Data'

set arrow nohead from graph 0, first I to graph 1, first I lt 1 lc rgb "blue"
set arrow nohead from graph 0, first I1 to graph 1, first I1 lt 0 lc rgb "blue"
set arrow nohead from graph 0, first I2 to graph 1, first I2 lt 0 lc rgb "blue"

R_s = system("sed -n 17p settings.txt")
R = R_s + 0

Results = sprintf(" R^2 = %.4f", R)
set obj 2 rect from graph 0, 1 to graph 0.2, 0.85 fc rgb "white" front
set lab 2 Results at graph 0, 0.96 front

set o 'Graphs/graph_d_'.file.'.pdf'
p[-4:0][-10:] 'Data/d_'.file.'.txt' u 1:2:3:4 w xyerrorb ls 2 t 'Data', f(x) ls 3 t 'Fit'
