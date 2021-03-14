set g
set term pdf
set key opaque
set ls 1 lc rgb 'black' pt 7 ps 0.1
set ls 2 lc rgb '#006400' lt 1 lw 1

file = '365'
set o 'Graphs/graph_'.file.'_0_2.pdf'

Title = 'Curva de I vs V para λ='.file.' nm (Método 2)'
Tx = 'Voltaje (V)'
Ty = 'Corriente electrica (pA)'

set tit Title
set xl Tx
set yl Ty

I = -0.6 
I_err = 0.4
I1 = I-I_err 
I2 = I+I_err

Init = -0.69

set fit errorvar
set fit quiet

f(x) = A*x+B
A = 57
B = 100

fit[Init:] f(x) 'Data/'.file.'_0.txt' u 1:2 via A,B

V = (I-B)/A
V_err = abs(V)*((I_err+B_err)/abs(I-B) + A_err/A)
V1 = V-V_err
V2 = V+V_err

R = 0.9973

Results = sprintf(" R^2 = %.4f\n V_0 = (%.2f ± %.2f) V", R, V, V_err)
set obj 2 rect from graph 0, 1 to graph 0.26, 0.87 fc rgb "white" front
set lab 2 Results at graph 0, 0.96 front

set arrow nohead from first V, graph 0 to first V, graph 1 lt 1 lc rgb "red"
set arrow nohead from first V1, graph 0 to first V1, graph 1 lt 0 lc rgb "red"
set arrow nohead from first V2, graph 0 to first V2, graph 1 lt 0 lc rgb "red"

set arrow nohead from graph 0, first I to graph 1, first I lt 1 lc rgb "blue"
set arrow nohead from graph 0, first I1 to graph 1, first I1 lt 0 lc rgb "blue"
set arrow nohead from graph 0, first I2 to graph 1, first I2 lt 0 lc rgb "blue"

p[-4:0][-10:] 'Data/'.file.'_0.txt' u 1:2 ls 1 t 'Data', f(x) ls 2 t 'Fit'
