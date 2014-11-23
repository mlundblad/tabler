/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * relations-editor.vala
 * Copyright (C) 2014 Marcus Lundblad <ml@update.uu.se>
 *
 * tabler is free software: you can redistribute it and/or modify it
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

public class Tabler.RelationsEditor : Gtk.Grid {
	 
	public Arrangement arrangement { get; set; }

	public RelationsEditor () {
	}
	 
	// update the grid widget widget with a new arrangement
	public void update_arrangement () {
		stdout.printf ("new arrangement set in relations editor\n");

		arrangement.guest_added.connect (on_guest_added);
		arrangement.guest_removed.connect (on_guest_removed);
		
		int i = 1;
		foreach (var guest in arrangement.guests.values) {
			var horizontal_label = new Gtk.Label (guest.name);
			var vertical_label = new Gtk.Label (guest.name);

			horizontal_label.xalign = 0;
			
			vertical_label.angle = 90;
			vertical_label.yalign = 1.0f;
			
			attach (horizontal_label, 0, i, 1, 1);
			attach (vertical_label, i, 0, 1, 1);
			horizontal_label.visible = true;
			vertical_label.visible = true;
			i++;
		}
	}

	private void on_guest_added (Guest guest) {
		stderr.printf ("Guest added %s\n", guest.name);
	}

	private void on_guest_removed (Guest guest) {
	    stderr.printf ("Guest removed\n");
	}
	 
}

