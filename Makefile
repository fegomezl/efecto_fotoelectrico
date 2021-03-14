LIB= -lgsl -lgslcblas -lm

derivate: derivative.x settings.txt
	@./$< $$(sed -n 1p settings.txt) 5
	@gnuplot plot_d.gp
	@foxitreader $$(echo 'Graphs/graph_d_')$$(sed -n 1p settings.txt)$$(echo '.pdf') &

analysis: analysis.x
	@./$< $$(sed -n 1p settings.txt; sed -n 2p settings.txt; sed -n 3p settings.txt; sed -n 4p settings.txt)
	@gnuplot plot_analysis.gp
	@rm data_aux.txt

derivative.x: derivative.cpp
	g++ $< $(LIB) -o $@  

analysis.x: analysis.cpp settings.txt
	g++ $< $(LIB) -o $@  

clean:
	@rm -f *.x fit.log data_aux.txt Graphs/*.pdf
