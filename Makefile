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
	menu \
	menu-with-window \
	menu-multicolumn \
	menu-options \
	menu-user-pointer

demos_files = $(patsubst %, %.exe, $(demos))

.PHONY: all
all: $(demos_files)

# -L-stuff is needed only for OSX, on linux looks like ignored
# -lmenu, according to curses documentation should precede -lcurses
%.exe: %.vala
	valac -v --save-temps -g \
	  --vapidir=vapi --pkg curses-fixes --pkg curses-panel --pkg curses-menu --pkg posix \
	  -X -L/usr/local/opt/ncurses/lib -X -I/usr/local/opt/ncurses/include \
	  -X -lmenu -X -lcurses -X -lpanel \
	  $(patsubst %.exe, %, $@).vala -o $@

.PHONY: clean
clean:
	rm -rf $(demos_files) *.c *.dSYM
