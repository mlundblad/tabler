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

public class Tabler.Relation : GLib.Object {

	public enum Type {
		NEXT_TO,
		NEAR_TO,
		NOT_NEXT_TO,
		NOT_NEAR_TO
	}

	public Guest to { get; set; }
	public Guest from { get; set; }
	public Type relation_type { get; set; }
	
	// Constructor
	public Relation (Guest from, Guest to, Type type) {
		this.from = from;
		this.to = to;
		this.relation_type = type;
    }

}
