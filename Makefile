# st - simple terminal
# See LICENSE file for copyright and license details.
.POSIX:

include config.mk

SRC = st.c x.c hb.c boxdraw.c
OBJ = $(SRC:.c=.o)

all: options st

options:
	@echo st build options:
	@echo "CFLAGS  = $(STCFLAGS)"
	@echo "LDFLAGS = $(STLDFLAGS)"
	@echo "CC      = $(CC)"

config.h:
	cp config.def.h config.h

.c.o:
	$(CC) $(STCFLAGS) -c $<

st.o: config.h st.h win.h
x.o: arg.h config.h st.h win.h hb.h
hb.o: st.h
boxdraw.o: config.h st.h boxdraw_data.h

$(OBJ): config.h config.mk

st: $(OBJ)
	$(CC) -o $@ $(OBJ) $(STLDFLAGS)

clean:
	rm -f st $(OBJ) st-$(VERSION).tar.gz config.h

scroll:
ifeq (,$(wildcard /usr/bin/scroll))
	$(error "suckless scroll not installed!")
endif

install: st scroll
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f st $(DESTDIR)$(PREFIX)/bin
	cp -f st-copyout $(DESTDIR)$(PREFIX)/bin
	cp -f st-urlhandler $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/st
	chmod 755 $(DESTDIR)$(PREFIX)/bin/st-copyout
	chmod 755 $(DESTDIR)$(PREFIX)/bin/st-urlhandler
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < st.1 > $(DESTDIR)$(MANPREFIX)/man1/st.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/st.1
	tic -sx st.info
	@echo Please see the README file regarding the terminfo entry of st.
	mkdir -p $(DESTDIR)$(PREFIX)/share/applications
	cp -f st.desktop $(DESTDIR)$(PREFIX)/share/applications
	chmod 644 $(DESTDIR)$(PREFIX)/share/applications/st.desktop
	mkdir -p $(DESTDIR)$(PREFIX)/share/pixmaps
	cp -f st.svg $(DESTDIR)$(PREFIX)/share/pixmaps
	chmod 644 $(DESTDIR)$(PREFIX)/share/pixmaps/st.svg

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/st
	rm -f $(DESTDIR)$(PREFIX)/bin/st-copyout
	rm -f $(DESTDIR)$(PREFIX)/bin/st-urlhandler
	rm -f $(DESTDIR)$(MANPREFIX)/man1/st.1
	rm -f $(DESTDIR)$(PREFIX)/share/applications/st.desktop
	rm -f $(DESTDIR)$(PREFIX)/share/pixmaps/st.svg

.PHONY: all options clean install uninstall scroll
