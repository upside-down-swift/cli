prefix ?= /usr/local
bindir = $(prefix)/bin
etcdir = ${prefix}/etc

build:
	swift build -c release --disable-sandbox

install: build
	mkdir -p  "$(bindir)" "${etcdir}"
	install ".build/release/upside-down" "$(bindir)"
	cp "upside-down.Dockerfile" "${etcdir}"

uninstall:
	rm -rf "$(bindir)/upside-down"
	rm "${etcdir}/upside-down.Dockerfile"

clean:
	rm -rf .build

.PHONY: build install uninstall clean