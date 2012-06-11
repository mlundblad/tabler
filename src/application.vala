/* -*- Mode: vala; tab-width: 4; intend-tabs-mode: t -*- */
/* tabler
 *
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

public class Tabler.Application : Gtk.Application {

	private MainWindow window;
	private Arrangement arrangement;
	
    // Constructor
    public Application () {
		Object (application_id: "org.tabler",
		        flags: ApplicationFlags.HANDLES_OPEN);
    }

	public override void activate () {
		if (window == null) {
			create_window ();
		}
		window.show ();
	}

	public override void open (GLib.File[] files, string hint) {
		if (files.length >= 1) {
			var file = files[0];
			stderr.printf ("Reading from file: %s\n", file.get_uri ());
			arrangement = Tabler.load_from_file (file.get_uri ());
			if (window == null) {
				create_window ();
			}
			window.show ();
		}
		
	}

	public void show_about () {
		string[] authors = {
  			"Marcus Lundblad <ml@update.uu.se>"
		};

		Gtk.show_about_dialog (window,
			   "authors", authors,
			   "translator-credits", _("translator-credits"),
			   "program-name", _("Tabler"),
			   "title", _("About Tabler"),
			   "comments", _("Tabler Seating Planning Program"),
			   "copyright", "Copyright 2012 Marcus Lundblad",
			   "license-type", Gtk.License.GPL_3_0,
			   "version", Config.PACKAGE_VERSION,
			   "website", "http://github.com/mlundblad/tabler",
			   "wrap-license", true);
	}
	
	private void create_window () {
		window = new MainWindow (this);

		var action = new GLib.SimpleAction ("quit", null);
		action.activate.connect (() => { window.destroy (); });
		this.add_action (action);

		action = new GLib.SimpleAction ("about", null);
		action.activate.connect (() => { show_about (); });
		this.add_action (action);

		var builder = new Gtk.Builder ();
		builder.set_translation_domain (Config.GETTEXT_PACKAGE);
		try {
  			builder.add_from_resource ("/org/tabler/appmenu.ui");
  			set_app_menu ((MenuModel)builder.get_object ("appmenu"));
		} catch {
  			warning ("Failed to parsing ui file");
		}
	}
}
