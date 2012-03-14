dnl Process this file with autoconf to produce a configure script.
dnl Created by Anjuta application wizard.

AC_INIT(tabler, 0.0)

AC_CONFIG_SRCDIR([src/tabler.vala])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([1.11])

AM_SILENT_RULES([yes])
AM_MAINTAINER_MODE([enable])
AC_PROG_CC


LT_INIT

# i18n stuff
IT_PROG_INTLTOOL([0.40])

AM_GNU_GETTEXT([external])
AM_GNU_GETTEXT_VERSION([0.17])

GETTEXT_PACKAGE=tabler
AC_DEFINE_UNQUOTED([GETTEXT_PACKAGE], ["$GETTEXT_PACKAGE"], [Gettext Package])
AC_SUBST(GETTEXT_PACKAGE)

dnl Check for vala
AM_PROG_VALAC([0.10.0])

PKG_CHECK_MODULES(TABLER, [gtk+-3.0 gee-1.0 libxml-2.0 gio-2.0])


AC_OUTPUT([
Makefile
data/Makefile
data/tabler.desktop.in
src/Makefile
po/Makefile.in
])

