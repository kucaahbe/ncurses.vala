.DEFAULT: all

demos = just-text \
	window-with-text
demos_files = $(patsubst %, %.exe, $(demos))

.PHONY: all
all: $(demos_files)

%.exe: %.vala
	valac -g --pkg curses --pkg posix -X -lcurses $(patsubst %.exe, %, $@).vala -o $@

.PHONY: clean
clean:
	rm -f $(demos_files)
