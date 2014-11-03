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

using Gtk;

[GtkTemplate (ui = "/org/tabler/main-window.ui")]
public class Tabler.MainWindow : Gtk.ApplicationWindow {
	private Arrangement arrangement;
	public string file_uri { get; private set; }

	[GtkChild]
	private Gtk.TreeView guestlist_view;

	[GtkChild]
	private Gtk.ToolButton guest_remove;

	[GtkChild]
	private Gtk.Box guest_edit_box;

	[GtkChild]
	private Gtk.Entry guest_name_entry;
	
	private Guest? selected_guest;
	
    // Constructor
    public MainWindow (Gtk.Application app, Arrangement arrangement) {
		Object (application: app);
		this.arrangement = arrangement;

		// setup the guest list
		setup_guest_list (guestlist_view);
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
	}

	[GtkCallback]
	private void on_guest_selection_changed (Gtk.TreeSelection selection) {
		if (selection.count_selected_rows () == 1) {
			selected_guest = get_selected_guest ();
			load_selected_guest ();
			// set delete button active
			guest_remove.sensitive = true;
			guest_edit_box.visible = true;
			
		} else {
			guest_remove.sensitive = false;
			guest_edit_box.visible = false;
			selected_guest = null;
		}	
	}

	[GtkCallback]
	private void on_guest_add_clicked (Gtk.ToolButton button) {
		// TODO: show add dialog
	}

	private Guest get_selected_guest () {
		var selection = guestlist_view.get_selection ();
		var listmodel = guestlist_view.get_model () as Gtk.ListStore;
		Gtk.TreeIter tree_iter;
		Guest guest;
		
		selection.get_selected (null, out tree_iter);
		
		listmodel.get (tree_iter, 1, out guest);

		return guest;
	}

	private void load_selected_guest () {
		guest_name_entry.text = selected_guest.name;
	}

	[GtkCallback]
	private void on_guest_remove_clicked (Gtk.ToolButton button) {
		var selection = guestlist_view.get_selection ();
		var listmodel = guestlist_view.get_model () as Gtk.ListStore;
		Gtk.TreeIter tree_iter;
		Guest guest;
		
		selection.get_selected (null, out tree_iter);
		
		listmodel.get (tree_iter, 1, out guest);
		arrangement.remove_guest (guest);
		listmodel.remove (tree_iter);
	}

	[GtkCallback]
	private void on_save_clicked (Gtk.Button button) {
		if (file_uri == null) {
			// show file save dialog
			var save_dialog =
				new Gtk.FileChooserDialog (_("Save arrangement"), this,
			                               Gtk.FileChooserAction.SAVE,
				                           _("Cancel"), Gtk.ResponseType.CANCEL,
				                           _("Save"), Gtk.ResponseType.ACCEPT);

			if (save_dialog.run () == Gtk.ResponseType.ACCEPT) {
				file_uri = save_dialog.get_filename ();

				if (Tabler.file_exists (file_uri)) {
					// TODO: ask for overwrite confirmation
				}

				Tabler.save_to_file (arrangement, file_uri);
			}

			save_dialog.destroy ();
		}
	}
}
