LIB= -lgsl -lgslcblas -lm

analysis: analysis.x
	./$< $$(sed -n 6p settings.txt)

analysis.x: analysis.cpp settings.txt
	g++ $< $(LIB) -o $@  

clean:
	rm -f *.pdf data.tsv fit.log
