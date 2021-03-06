# REQUIREMENTS
#   latex   (use MacTeX, MikTeX, etc)
#	imagemagick (install using brew, etc.)

SHELL=bash
TARGET=$(shell basename "`pwd`")


all: pdf open cleanlogs
verbose: pdf open openlog
clean: cleantemps cleanlogs cleanoutput
run: all


PLATFORM=$(shell ([[ -n "$(OSTYPE)" ]] && echo $(OSTYPE) || echo $(OS) ) | grep -o '[^0-9\-]\+')
ifeq ($(PLATFORM), Windows_NT)
	PLATFORM=cygwin
endif
ifeq ($(PLATFORM), cygwin)
	OPEN=$(shell cygstart --version &>/dev/null && echo cygstart -o || echo start)
else
	OPEN=$(shell xdg-open --version &>/dev/null && echo xdg-open || echo open)
endif


$(TARGET).pdf: $(TARGET).tex
	xelatex $(TARGET).tex

pdf: $(TARGET).pdf cleantemps
	touch $(TARGET).pdf

# produces a series of pngs if multipage document
png: pdf
	convert -density 300 $(TARGET).pdf $(TARGET).png

open:
	$(OPEN) $(shell ls -t $(TARGET).{pdf,html} 2>/dev/null | head -n1)

openlog: $(TARGET).log
	$(OPEN) $(TARGET).log

cleantemps:
	rm -rf *.aux *.out *.synctex.gz

cleanlogs:
	rm -rf *.log

cleanoutput:
	rm -rf *.pdf *.png

