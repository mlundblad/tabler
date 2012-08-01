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

public class Tabler.MainWindow : Gtk.ApplicationWindow {

	static const int DEFAULT_WIDTH = 800;
	static const int DEFAULT_HEIGHT = 600;
	
    // Constructor
    public MainWindow (Gtk.Application app) {
		Object (application: app);
		// TODO: add localization support...
		title = "Tabler";
		window_position = Gtk.WindowPosition.CENTER;
		set_default_size (DEFAULT_WIDTH, DEFAULT_HEIGHT);
		hide_titlebar_when_maximized = true;

		// setup UI
		var builder = new Gtk.Builder ();
		builder.set_translation_domain (Config.GETTEXT_PACKAGE);
		try {
  			builder.add_from_resource ("/org/tabler/main-window.ui");
		} catch {
			warning (_("Could not load UI."));
			return;
		}

		var toolbar = builder.get_object ("toolbar") as Gtk.Toolbar;
		toolbar.get_style_context ().add_class (Gtk.STYLE_CLASS_PRIMARY_TOOLBAR);
		
		add (builder.get_object ("main-box") as Gtk.Widget);

		// TODO: actually do something real here, like asking to save, etc.
		destroy.connect (Gtk.main_quit);
    }

}
