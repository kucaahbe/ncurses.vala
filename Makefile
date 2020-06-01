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
	colors \
	keyboard-and-mouse \
	menu
demos_files = $(patsubst %, %.exe, $(demos))

.PHONY: all
all: $(demos_files)

%.exe: %.vala
	valac -v --save-temps -g --vapidir=. --pkg curses-fixes --pkg curses-panel --pkg curses-menu --pkg posix -X -L/usr/local/Cellar/ncurses/6.1/lib -X -I/usr/local/Cellar/ncurses/6.1/include -X -lmenu -X -lcurses -X -lpanel $(patsubst %.exe, %, $@).vala -o $@

.PHONY: clean
clean:
	rm -rf $(demos_files) *.c *.dSYM
