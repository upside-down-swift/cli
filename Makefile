prefix ?= /usr/local
bindir = $(prefix)/bin
etcdir = ${prefix}/etc

build:
	swift build -c release --disable-sandbox

install: build
	mkdir -p  "$(bindir)" "${etcdir}"
	install ".build/release/upside-down" "$(bindir)"
	cp -r "pipelines/" "${etcdir}/pipelines"
	cp "default-config.plist" "${etcdir}"

uninstall:
	rm -rf "$(bindir)/upside-down"
	rm -rf "${etcdir}/pipelines"
	rm "${etcdir}/default-config.plist"

clean:
	rm -rf .build

.PHONY: build install uninstall clean