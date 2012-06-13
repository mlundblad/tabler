gtk_update_icon_cache = gtk-update-icon-cache -f -t $(datadir)/icons/hicolor

install-data-hook: update-icon-cache
uninstall-hook: update-icon-cache
update-icon-cache:
	@-if test -z "$(DESTDIR)"; then \
	echo "Updating Gtk icon cache."; \
		$(gtk_update_icon_cache); \
	else \
		echo "*** Icon cache not updated.  After (un)install, run this:"; \
		echo "***   $(gtk_update_icon_cache)"; \
	fi


svgicondir = $(datadir)/icons/hicolor/scalable/apps
svgicon_DATA = tabler.svg

mimesvgicondir = $(datadir)/icons/hicolor/scalable/mimetypes
mimesvgicon_DATA = application-x-tabler.svg


EXTRA_DIST = $(svgicon_DATA) $(mimesvgicon_DATA)