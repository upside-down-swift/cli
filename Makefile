prefix ?= /usr/local
bindir = $(prefix)/bin

build:
	swift build -c release --disable-sandbox

install: build
	mkdir -p "$(bindir)"
	install ".build/release/upside-down" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/upside-down"

clean:
	rm -rf .build

.PHONY: build install uninstall clean