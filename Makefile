all: main.pdf

ROOT:=$(shell pwd)

SOURCEFILES = $(find . -name '*.tex')
FIGURES = $(find plots/ -name '*.pdf')
BIBS = $(find . -name '*.bib')


main.pdf: ${SOURCEFILES} ${FIGURES}
	latexmk -bibtex -pdf -pdflatex="pdflatex -interaction=nonstopmode" -use-make main.tex

submit: Makefile put-here-only-what-needs-submission
	mkdir -p submit/plots
	latexpand --expand-bbl main.bbl main.tex > submit/main.tex
	cp plots/*.pdf submit/plots/
	latexmk -pdf -use-make submit/main.tex # compile document to make sure it works, but not within prd directory
	tar -czf submit.tar.gz submit

.PHONY: tidy
tidy:
	$(RM) *.aux
	$(RM) mainNotes.bib
	$(RM) $(addprefix main.,log aux synctex.gz blg toc fls fdb_latexmk)
	$(RM) *~

.PHONY: clean
clean: tidy
	$(RM) main.bbl
	$(RM) main.pdf
