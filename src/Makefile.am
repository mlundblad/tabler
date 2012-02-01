## Process this file with automake to produce Makefile.in

## Created by Anjuta


uidir = $(datadir)/tabler/ui
ui_DATA = tabler.ui


AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(prefix)/$(DATADIRNAME)/locale"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(datadir)"\" \
	$(TABLER_CFLAGS)

AM_CFLAGS =\
	 -Wall\
	 -g

bin_PROGRAMS = tabler

tabler_SOURCES = \
	tabler.vala config.vapi table.vala guest.vala room.vala round-table.vala long-table.vala gender.vala xml-serializable.vala arrangement.vala

tabler_VALAFLAGS =  \
	--pkg gtk+-3.0 --pkg gee-1.0 --pkg libxml-2.0

tabler_LDFLAGS = \
	-Wl,--export-dynamic

tabler_LDADD = $(TABLER_LIBS)


EXTRA_DIST = $(ui_DATA)

# Remove ui directory on uninstall
uninstall-local:
	-rm -r $(uidir)
	-rm -r $(datadir)/tabler
