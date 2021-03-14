set g
set term pdf
set key opaque
set ls 1 lc rgb 'gold' pt 7 ps 0.1
set ls 2 lc rgb 'blue' lt 1 lw 1
set ls 3 lc rgb 'orange' lt 1 lw 1
set ls 4 lc rgb 'black' pt 7 ps 0.1

file = system("sed -n 1p settings.txt")
set o 'Graphs/graph_d_'.file.'.pdf'

Title = system("sed -n 2p settings.txt")
Tx = system("sed -n 3p settings.txt")
Ty = system("sed -n 4p settings.txt")

set tit Title
set xl Tx
set yl Ty

lim = -1.875
set fit errorvar

f_1(x) = A*x+B
A = 1e-5
B = 1e-5

fit[:lim] f_1(x) 'Data/d_'.file.'.txt' u 1:2 via A,B

f_2(x) = C*x+D
C = 57
D = 100

fit[lim:] f_2(x) 'Data/d_'.file.'.txt' u 1:2:3:4 xyerrors via C,D

R1_s = system("sed -n 17p settings.txt")
R1 = R1_s + 0
R2_s = system("sed -n 18p settings.txt")
R2 = R2_s + 0

Results = sprintf(" R_{<-}^2 = %.4f\n R_{->}^2 = %.4f", R1, R2)
set obj 2 rect from graph 0, 1 to graph 0.2, 0.85 fc rgb "white" front
set lab 2 Results at graph 0, 0.96 front

p[-4:0][-10:10] 'Data/d_'.file.'.txt' u 1:2:3:4 w xyerrorb ls 1 t 'Data', f_1(x) ls 2 t 'Fit 1', f_2(x) ls 3 t 'Fit 2'

V = (D-B)/(A-C)
V_err = V*((A_err+C_err)/abs(A-C)+(D_err+B_err)/abs(D-B))
V1 = V-V_err
V2 = V+V_err

Results = sprintf(" V_0 = (%.4f ± %.4f) V", V, V_err)
set obj 2 rect from graph 0, 1 to graph 0.2, 0.9 fc rgb "white" front
set lab 2 Results at graph 0, 0.96 front

set arrow nohead from V, graph 0 to V, graph 1 lt 1 lc rgb "red"
set arrow nohead from V1, graph 0 to V1, graph 1 lt 0 lc rgb "red"
set arrow nohead from V2, graph 0 to V2, graph 1 lt 0 lc rgb "red"

set o 'Graphs/graph_'.file.'_3.pdf'
p[-4:0] 'Data/'.file.'.txt' u 1:2 ls 4 t 'Data'



