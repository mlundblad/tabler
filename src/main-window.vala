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

public class Tabler.MainWindow : Gtk.Window {

	static const int DEFAULT_WIDTH = 640;
	static const int DEFAULT_HEIGHT = 480;
	
    // Constructor
    public MainWindow () {
		// TODO: add localization support...
		title = "Tabler";
		window_position = Gtk.WindowPosition.CENTER;
		set_default_size (DEFAULT_WIDTH, DEFAULT_HEIGHT);

		// TODO: actually do something real here, like asking to save, etc.
		destroy.connect (Gtk.main_quit);
    }

}
