set g
set term pdf
set key opaque
set ls 1 lc rgb 'black' pt 7 ps 0.1

file = system("sed -n 1p settings.txt")

set o 'Graphs/graph_'.file.'.pdf'

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
V_err = abs(V)*((I_err+B_err)/abs(I-B) + A_err/A)
V1 = V-V_err
V2 = V+V_err

set arrow nohead from V, graph 0 to V, graph 1 lt 1 lc rgb "red"
set arrow nohead from V1, graph 0 to V1, graph 1 lt 0 lc rgb "red"
set arrow nohead from V2, graph 0 to V2, graph 1 lt 0 lc rgb "red"

Results = sprintf("V = %f\nV_err = %f", V, V_err)
print Results

p[-4:0] 'Data/'.file.'.txt' u 1:2 ls 1 t 'Data'
