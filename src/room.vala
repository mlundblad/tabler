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

public class Tabler.Room : GLib.Object {

	private class TableSlot {
		Table table { get; set; }
		uint x { get; set; }
		uint y { get; set; }
	}

	private Gee.List<TableSlot> tables = new Gee.ArrayList<TableSlot>();
	// keep track of occupied slots, to simplify things...
	private bool[,] occupied_slots;
	
	private uint width { get; private set; }
	private uint height { get; private set; }
		
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
		
		return true;
	}

	public bool can_table_fit (Table table, uint x, uint y) {
		uint tw, th;
		bool result = true;

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
}
