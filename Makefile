.DEFAULT: all

demos = just-text \
	window-with-text\
	two-windows \
	doupdate \
	panels \
	panels-switch \
	panels-toggle \
	panels-move \
	panels-resize \
	panels-show-hide \
	colors
demos_files = $(patsubst %, %.exe, $(demos))

.PHONY: all
all: $(demos_files)

%.exe: %.vala
	valac --save-temps -g --vapidir=. --pkg curses --pkg curses-panel --pkg posix -X -lcurses -X -lpanel $(patsubst %.exe, %, $@).vala -o $@

.PHONY: clean
clean:
	rm -rf $(demos_files) *.c *.dSYM
