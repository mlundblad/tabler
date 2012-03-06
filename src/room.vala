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

using Gee;

public class Tabler.Room : GLib.Object, Tabler.XmlSerializable {

	public class TableSlot {
		public Table table { get; set; }
		public uint x { get; set; }
		public uint y { get; set; }

		public TableSlot (Table table, uint x, uint y) {
			this.table = table;
			this.x = x;
			this.y = y;
		}
	}

	private Gee.List<TableSlot> tables = new Gee.ArrayList<TableSlot>();
	// keep track of occupied slots, to simplify things...
	private bool[,] occupied_slots;
	
	private uint width { get; private set; }
	private uint height { get; private set; }

	public string name { get; set; }
	
	public Room (uint width, uint height) {
		resize (width, height);
	}

	public bool is_occupied (uint x, uint y) {
		return occupied_slots[x, y];
	}
	
	public bool resize (uint width, uint height) {
		if (occupied_slots == null) {
			// if this is called the first time, create the occupation array
			occupied_slots = new bool[width, height];
			this.width = width;
			this.height = height;
			return true;
		}

		// check if grid can be resized to the new size
		// check that the "clipped" area is unoccupied

		for (uint x = width ; x < this.width ; x++) {
			for (uint y = 0 ; y < this.height ; y++) {
				if (is_occupied (x, y)) {
					return false;
				}
			}
		}

		for (uint x = 0 ; x < this.width ; x++) {
			for (uint y = height ; y < this.height ; y++) {
				if (is_occupied (x, y)) {
					return false;
				}
			}
		}

		bool[,] occ_temp = new bool[width, height];

		for (int x = 0 ; x < (this.width < width ? this.width : width) ; x++) {
			for (int y = 0 ; y < (this.height < height ? this.height : height) ;
			     y++) {
				occ_temp[x, y] = occupied_slots[x, y];
			}
		}
		occupied_slots = occ_temp;
		this.width = width;
		this.height = height;
		
		return true;
	}

	public bool can_table_fit (Table table, uint x, uint y) {
		uint tw, th;

		table.get_extents (out tw, out th);

		// table won't fit if too close to one of the edges
		if (x + tw > width || y + th > height) {
			return false;
		}
		
		// check needed slots
		for (uint x1 = x ; x1 < x + tw ; x1++) {
			for (uint y1 = y ; y1 < y + th ; y1++) {
				if (is_occupied (x1, y1)) {
					return false;
				}
			}
		}

		return true;
	}

	public bool add_table (Table table, uint x, uint y) {
		if (can_table_fit (table, x, y)) {
			uint tw, th;

			tables.add (new TableSlot (table, x, y));
			table.get_extents (out tw, out th);

			for (uint x1 = x ; x1 < x + tw ; x1++) {
				for (uint y1 = y ; y1 < y + th ; y1++) {
					occupied_slots[x1, y1] = true;
				}
			}

			return true;
		} else {
			stderr.printf ("Failed to place table at (%u, %u)\n", x, y);
			return false;
		}
	}

	public Iterator iterator () {
		return tables.iterator ();
	}

	public bool remove_table (Table table) {
		foreach (var slot in tables) {
			if (slot.table == table) {
				uint w, h;
				table.get_extents (out w, out h);

				for (var x = slot.x ; x < slot.x + w ; x++) {
					for (var y = slot.y ; y < slot.y + h ; y++) {
						occupied_slots[x, y] = false;
					}
				}

				tables.remove (slot);
				return true;
			}
		}

		return false;
	}

	public Xml.Node* to_xml () {
		Xml.Node* node = new Xml.Node (null, "room");

		node->new_prop ("width", width.to_string ());
		node->new_prop ("height", height.to_string ());
		
		if (name != null && name.length > 0) {
			node->new_prop ("name", name);
		}

		foreach (var slot in tables) {
			Xml.Node* table_node = slot.table.to_xml ();
			table_node->new_prop ("x", slot.x.to_string ());
			table_node->new_prop ("y", slot.y.to_string ());
			node->add_child (table_node);
		}

		return node;
	}
}
