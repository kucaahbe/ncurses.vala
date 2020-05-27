.DEFAULT: all

demos = just-text \
	window-with-text\
	two-windows \
	doupdate \
	panels
demos_files = $(patsubst %, %.exe, $(demos))

.PHONY: all
all: $(demos_files)

%.exe: %.vala
	valac -g --vapidir=. --pkg curses --pkg curses-panel --pkg posix -X -lcurses -X -lpanel $(patsubst %.exe, %, $@).vala -o $@

.PHONY: clean
clean:
	rm -f $(demos_files)
