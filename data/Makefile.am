
@INTLTOOL_DESKTOP_RULE@

desktopdir = $(datadir)/applications
desktop_in_files = tabler.desktop.in.in
desktop_DATA = $(desktop_in_files:.desktop.in.in=.desktop)

UPDATE_DESKTOP = \
	if [ -f $(DESTDIR)$(datadir)/applications/defaults.list ] ; then \
		if which update-desktop-database>/dev/null 2>&1 ; then \
			update-desktop-database; \
		fi \
	fi

install-data-hook:
	$(UPDATE_DESKTOP)

uninstall-hook:
	$(UPDATE_DESKTOP)

EXTRA_DIST = \
	$(desktop_in_files) \
	$(NULL)

DISTCLEANFILES = \
	$(desktop_DATA) \
	$(NULL)
