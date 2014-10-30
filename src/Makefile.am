## Process this file with automake to produce Makefile.in

## Created by Anjuta


# needed to add GETTEXT_PACKAGE here (even though it goes into config.h) to
# make the compiler happy... not sure why, it doesn't seem to be needed in
# other packages I've looked at...
AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(prefix)/$(DATADIRNAME)/locale"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(datadir)"\" \
	-DGETTEXT_PACKAGE=\"tabler\" \
	$(TABLER_CFLAGS)

AM_CFLAGS =\
	 -Wall\
	 -g

bin_PROGRAMS = tabler

BUILT_SOURCES = \
	tabler-resources.c \
	tabler-resources.h

tabler-resources.h tabler-resources.c: tabler.gresource.xml Makefile $(shell $(GLIB_COMPILE_RESOURCES) --generate-dependencies --sourcedir $(srcdir) $(srcdir)/tabler.gresource.xml)
	$(AM_V_GEN) XMLLINT=$(XMLLINT) $(GLIB_COMPILE_RESOURCES) --target $@ --sourcedir $(srcdir) --generate --c-name tabler $<


tabler_SOURCES = \
	tabler.vala config.vapi table.vala guest.vala room.vala round-table.vala \
	long-table.vala gender.vala xml-serializable.vala arrangement.vala \
	file-utils.vala arrangement-parser.vala room-parser.vala guest-parser.vala \
	table-parser.vala long-table-parser.vala round-table-parser.vala \
	main-window.vala relation.vala application.vala tabler-resources.c

tabler_VALAFLAGS =  \
	--target-glib=2.38 --gresources tabler.gresource.xml --pkg gtk+-3.0 --pkg gee-1.0 --pkg libxml-2.0 --pkg gio-2.0

tabler_LDFLAGS = \
	-Wl,--export-dynamic

tabler_LDADD = $(TABLER_LIBS) -lm


EXTRA_DIST = $(ui_DATA)

# Remove ui directory on uninstall
uninstall-local:
	-rm -r $(uidir)
	-rm -r $(datadir)/tabler
