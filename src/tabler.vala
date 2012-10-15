/* -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- */
/*
 * main.c
 * Copyright (C) Marcus Lundblad 2012 <ml@update.uu.se>
 * 
tabler is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * tabler is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using GLib;
using Gtk;

public class Main : Object 
{
	static int main (string[] args) 
	{
		Intl.bindtextdomain (Config.GETTEXT_PACKAGE, Config.PACKAGE_LOCALE_DIR);
		Intl.bind_textdomain_codeset (Config.GETTEXT_PACKAGE, "UTF-8");
		Intl.textdomain (Config.GETTEXT_PACKAGE);
		
		Gtk.init (ref args);

		var app = new Tabler.Application ();

		app.run (args);
		app = null;

		return 0;
	}
}
