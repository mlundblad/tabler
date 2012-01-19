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

public abstract class Tabler.Table : GLib.Object {
	protected uint capacity { get; private set; }
	protected string name { get; set; }
	protected Guest[] guests;

	public class Iterator {
		uint index;
		uint size;
		Guest[] guests;

		internal Iterator (Guest[] guests, uint size) {
			this.guests = guests;
			this.size = size;
		}

		public bool next () {
			return index < size;
		}

		public Guest? get () {
			index++;
			return guests[index - 1];
		}
	}
			
	
	public Table (uint capacity) {
		this.capacity = capacity;
		this.guests = new Guest[capacity];
	}

	public Iterator iterator () {
		return new Iterator (this.guests, this.capacity);
	}

	public abstract void get_extents (out uint w, out uint h);
}
