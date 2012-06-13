## Process this file with automake to produce Makefile.in
## Created by Anjuta

SUBDIRS = data icons src po

tablerdocdir = ${prefix}/doc/tabler
tablerdoc_DATA = \
	README\
	COPYING\
	AUTHORS\
	ChangeLog\
	INSTALL\
	NEWS


EXTRA_DIST = $(tablerdoc_DATA)


# Remove doc directory on uninstall
uninstall-local:
	-rm -r $(tablerdocdir)
