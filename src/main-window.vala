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

	private Arrangement arrangement;
	public string file_uri { get; private set; }

	private Gtk.Builder builder;
	
    // Constructor
    public MainWindow (Gtk.Application app, Arrangement arrangement) {
		Object (application: app);
		this.arrangement = arrangement;
		
		// TODO: add localization support...
		title = "Tabler";
		window_position = Gtk.WindowPosition.CENTER;
		set_default_size (DEFAULT_WIDTH, DEFAULT_HEIGHT);
		hide_titlebar_when_maximized = true;

		// setup UI
		builder = new Gtk.Builder ();
		builder.set_translation_domain (Config.GETTEXT_PACKAGE);
		try {
  			builder.add_from_resource ("/org/tabler/main-window.ui");
			add (builder.get_object ("main-box") as Gtk.Widget);
		} catch (GLib.Error error) {
			// shouldn't happen
			stderr.printf ("Unable to parse UI definition.\n");
		}

		// bound action for the save toolbar button
		var save_button = builder.get_object ("save-button") as Gtk.ToolButton;
		save_button.clicked.connect (on_save_clicked);

		// setup the guest list
		var guest_view = builder.get_object ("guestlist-view") as Gtk.TreeView;
		setup_guest_list (guest_view);
    }

	private void setup_guest_list (Gtk.TreeView guest_view) {
		var listmodel = new Gtk.ListStore (2, typeof (string), typeof (Guest));

		listmodel.set_sort_column_id (0, Gtk.SortType.ASCENDING);
		
		guest_view.set_model (listmodel);
		guest_view.insert_column_with_attributes (-1, _("Name"), 
		                                          new Gtk.CellRendererText (),
		                                          "text", 0);

		// add guests
		Gtk.TreeIter iter;
		foreach (var guest in arrangement.guests.values) {
			listmodel.append (out iter);
			listmodel.set (iter, 0, guest.name, 1, guest);
		}

		var selection = guest_view.get_selection ();
		selection.changed.connect (on_guest_selection_changed);
	}

	private void on_guest_selection_changed (Gtk.TreeSelection selection) {
		var remove_button = builder.get_object ("guest-remove") as Gtk.ToolButton;
		
		if (selection.count_selected_rows () == 1) {
			// set delete button active
			remove_button.sensitive = true;
		} else {
			remove_button.sensitive = false;
		}	
	}

	private void on_save_clicked (Gtk.ToolButton button) {
		if (file_uri == null) {
			// show file save dialog
			var save_dialog =
				new Gtk.FileChooserDialog (_("Save arrangement"), this,
			                               Gtk.FileChooserAction.SAVE,
				                           Gtk.Stock.CANCEL, Gtk.ResponseType.CANCEL,
				                           Gtk.Stock.SAVE, Gtk.ResponseType.ACCEPT);

			if (save_dialog.run () == Gtk.ResponseType.ACCEPT) {
				file_uri = save_dialog.get_filename ();
			} else {
				return;
			}

			save_dialog.destroy ();
		}

		if (Tabler.file_exists (file_uri)) {
			// TODO: ask for overwrite confirmation
		}

		Tabler.save_to_file (arrangement, file_uri);
	}
}
