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

	/* 
	 * Uncomment this line when you are done testing and building a tarball
	 * or installing
	 */
	//const string UI_FILE = Config.PACKAGE_DATA_DIR + "/" + "tabler.ui";
	const string UI_FILE = "src/tabler.ui";


	public Main ()
	{

		try 
		{
			var builder = new Builder ();
			builder.add_from_file (UI_FILE);
			builder.connect_signals (this);

			var window = builder.get_object ("window") as Window;
			window.show_all ();
		} 
		catch (Error e) {
			stderr.printf ("Could not load UI: %s\n", e.message);
		} 

	}

	[CCode (instance_pos = -1)]
	public void on_destroy (Widget window) 
	{
		Gtk.main_quit();
	}

	static int main (string[] args) 
	{
		Gtk.init (ref args);
		var app = new Main ();

		// test code...
		var arrangement = new Tabler.Arrangement ();
		var room = new Tabler.Room (32, 32);
		var table = new Tabler.LongTable (10,
		                                  Tabler.LongTable.Orientation.HORIZONTAL,
		                                  new Tabler.LongTable.Setting ());
    
		arrangement.add_guest (new Tabler.Guest ("Foo Bar", Tabler.Gender.MALE));
		arrangement.add_room (room);
		room.add_table (table, 2, 2);

		try {
			Tabler.save_to_file (arrangement, "test.tabler");
		} catch (Error e) {
			stderr.printf ("Failed to save file: %s\n", e.message);
		}
			
		Gtk.main ();
		
		return 0;
	}
}
