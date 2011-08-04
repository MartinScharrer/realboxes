TEXMF=${HOME}/texmf
INSTALLDIR=${TEXMF}/tex/latex/realboxes
DOCINSTALLDIR=${TEXMF}/doc/latex/realboxes
CP=cp
RMDIR=rm -rf
PDFLATEX=pdflatex -interaction=batchmode
LATEXMK=latexmk -pdf -silent

PACKEDFILES=realboxes.sty
DOCFILES=realboxes.pdf 
#realboxes-de.pdf
SRCFILES=realboxes.dtx realboxes.ins README Makefile

all: unpack doc

package: unpack
class: unpack

${PACKEDFILES}: realboxes.dtx realboxes.ins
	yes | pdflatex realboxes.ins

unpack: ${PACKEDFILES}

doc: ${DOCFILES}

pdfopt: doc
	@-pdfopt realboxes.pdf .temp.pdf && mv .temp.pdf realboxes.pdf
	@-pdfopt realboxes-de.pdf .temp.pdf && mv .temp.pdf realboxes-de.pdf

realboxes.pdf: realboxes.dtx
	${LATEXMK} $<

realboxes-de.pdf: realboxes-de.tex realboxes.dtx
	${LATEXMK} $<

realboxes.tex: unpack

.PHONY: test

test: unpack
	for T in test*.tex; do echo "$$T"; pdflatex -interaction=batchmode $$T && echo "OK" || echo "Failure"; done

clean:
	-latexmk -C realboxes.dtx
	-latexmk -C realboxes-de.tex
	${RM} ${PACKEDFILES} *.zip *.log *.aux *.toc *.vrb *.nav *.pdf *.snm *.out *.fdb_latexmk *.glo *.gls *.hd *.sta *.stp *.cod
	${RMDIR} tds

install: unpack doc ${INSTALLDIR} ${DOCINSTALLDIR}
	${CP} ${PACKEDFILES} ${INSTALLDIR}
	${CP} ${DOCFILES} ${DOCINSTALLDIR}
	texhash ${TEXMF}

${INSTALLDIR}:
	mkdir -p $@

${DOCINSTALLDIR}:
	mkdir -p $@

build: realboxes.dtx realboxes.ins README
	rm -rf build/
	mkdir build
	perl dtx.pl realboxes.dtx build/realboxes.dtx
	${CP} realboxes.ins README build/
	cd build && yes | tex realboxes.ins
	cd build && latexmk -pdf realboxes.dtx
	cd build && pdfopt realboxes.pdf opt.pdf && mv opt.pdf realboxes.pdf
	cd build && ctanify realboxes.dtx realboxes.ins README
	cd build && ${CP} realboxes.tar.gz /tmp


