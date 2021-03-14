set g
set term pdf
set key opaque
set ls 1 lc rgb 'black' pt 7 ps 0.1
set ls 2 lc rgb '#622A0E' pt 7 ps 0.1 lw 0.5
set ls 3 lc rgb '#006400' lt 1 lw 1

file = '365'
set o 'Graphs/graph_'.file.'_0_3.pdf'

Title = 'Curva de I vs V para λ='.file.' nm (Método 3)'
Tx = 'Voltaje (V)'
Ty = 'Corriente electrica (pA)'

set tit Title
set xl Tx
set yl Ty

lim = -1.882
set fit errorvar
set fit quiet

f(x) = A*x+B
B = 100
A = -B/lim

fit[lim:] f(x) 'Data/d_'.file.'_0.txt' u 1:2:3:4 xyerrors via A,B

I = -0.796886
I_err = 2.80388
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
set obj 2 rect from graph 0, 1 to graph 0.24, 0.91 fc rgb "white" front
set lab 2 Results at graph 0, 0.96 front

p[-4:0][-10:] 'Data/'.file.'_0.txt' u 1:2 ls 1 t 'Data'

set arrow nohead from graph 0, first I to graph 1, first I lt 1 lc rgb "blue"
set arrow nohead from graph 0, first I1 to graph 1, first I1 lt 0 lc rgb "blue"
set arrow nohead from graph 0, first I2 to graph 1, first I2 lt 0 lc rgb "blue"

R = 0.9227

Results = sprintf(" R^2 = %.4f", R)
set obj 2 rect from graph 0, 1 to graph 0.16, 0.92 fc rgb "white" front
set lab 2 Results at graph 0, 0.96 front

set tit 'Curva de dI/dV para λ='.file.' nm'
set yl 'Corriente electrica sobre voltaje (pA/V)'

set o 'Graphs/graph_'.file.'_0_3d.pdf'
p[-4:0][-10:] 'Data/d_'.file.'_0.txt' u 1:2:3:4 w xyerrorb ls 2 t 'Derivada', f(x) ls 3 t 'Fit'
