set g
set term pdf
set key opaque
set key r b
set ls 1 lc rgb 'dark-blue' pt 5 ps 0.5 lw 0.5
set ls 2 lc rgb 'red' pt 7 ps 0.5 lw 0.5
set ls 3 lc rgb 'dark-green' pt 9 ps 0.5 lw 0.5

file = 'Data/Uvsfr.txt'
set o 'Graphs/graph_UF.pdf'

Title = 'Energìa de salida vs frecuencia'
Tx = 'Energìa cinetica (eV)'
Ty = 'Frecuencia (PHz)'

set tit Title
set xl Tx
set yl Ty

set fit errorvar

A1 = 4
A2 = 4
A3 = 4
B1 = -1
B2 = -1
B3 = -1

f1(x) = A1*x+B1
f2(x) = A2*x+B2
f3(x) = A3*x+B3

fit f1(x) file u 1:2:5 yerrors via A1,B1
fit f2(x) file u 1:3:6 yerrors via A2,B2
fit f3(x) file u 1:4:7 yerrors via A3,B3

R1 = 0.9978
R2 = 0.9977
R3 = 0.9967

Results = sprintf(" R²_1 = %.4f\n R²_2 = %.4f\n R²_3 = %.4f", R1, R2, R3)
set obj 2 rect from graph 0, 1 to graph 0.16, 0.82 fc rgb "white" front
set lab 2 Results at graph 0, 0.96 front

p file u 1:2:5 w yerrorb ls 1 not, \
    f1(x) ls 1 t 'Método 1', \
    file u 1:3:6 w yerrorb ls 2 not, \
    f2(x) ls 2 t 'Método 2', \
    file u 1:4:7 w yerrorb ls 3 not, \
    f3(x) ls 3 t 'Método 3'
