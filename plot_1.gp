set g
set term pdf
set key opaque
set ls 1 lc rgb 'black' pt 7 ps 0.1

file = system("sed -n 1p settings.txt")
set o 'Graphs/graph_'.file.'_1.pdf'

Title = system("sed -n 2p settings.txt")
Tx = system("sed -n 3p settings.txt")
Ty = system("sed -n 4p settings.txt")

set tit Title
set xl Tx
set yl Ty

I_s = system("sed -n 8p settings.txt")
I_err_s = system("sed -n 9p settings.txt")
I = I_s + 0
I_err = I_err_s + 0
I1 = I-I_err 
I2 = I+I_err

V_s = system("sed -n 10p settings.txt")
V_err_s = system("sed -n 11p settings.txt")
V = V_s + 0
V_err = V_err_s + 0
V1 = V-V_err
V2 = V+V_err

set arrow nohead from V, graph 0 to V, graph 1 lt 1 lc rgb "red"
set arrow nohead from V1, graph 0 to V1, graph 1 lt 0 lc rgb "red"
set arrow nohead from V2, graph 0 to V2, graph 1 lt 0 lc rgb "red"

set arrow nohead from graph 0, first I to graph 1, first I lt 1 lc rgb "blue"
set arrow nohead from graph 0, first I1 to graph 1, first I1 lt 0 lc rgb "blue"
set arrow nohead from graph 0, first I2 to graph 1, first I2 lt 0 lc rgb "blue"

Results = sprintf(" V_0 = (%.2f ± %.2f) V", V, V_err)
set obj 2 rect from graph 0, 1 to graph 0.28, 0.91 fc rgb "white" front
set lab 2 Results at graph 0, 0.96 front


p[-4:0][-10:] 'Data/'.file.'.txt' u 1:2 ls 1 t 'Data'
