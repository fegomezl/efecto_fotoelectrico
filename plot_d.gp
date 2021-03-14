set g
set term pdf
set key opaque
set ls 1 lc rgb 'gold' pt 7 ps 0.1

file = system("sed -n 1p settings.txt")
set o 'Graphs/graph_d_'.file.'.pdf'

Title = 'Curva de dI/dV vs V para λ='.file.' nm'
Tx = 'Voltaje (V)'
Ty = 'Corriente electrica sobre voltaje (pA/V)'

set tit Title
set xl Tx
set yl Ty

p[-4:0][-10:] 'Data/d_'.file.'.txt' u 1:2:3:4 w xyerrorb ls 1 t 'Data'
