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
	public Main ()
	{
		try 
		{
			var window = new Tabler.MainWindow ();
			window.show_all ();
		} 
		catch (Error e) {
			stderr.printf ("Could not load UI: %s\n", e.message);
		} 

	}

	static int main (string[] args) 
	{
		Gtk.init (ref args);
		var app = new Main ();

		if (args.length >= 2) {
			var filename = args[1];
			var arrangement = Tabler.load_from_file (filename);

			try {
				Tabler.save_to_file (arrangement, "test.tabler");
			} catch (Error e) {
				stderr.printf ("Failed to save file: %s\n", e.message);
			}
		}

		Gtk.main ();
		
		return 0;
	}
}
