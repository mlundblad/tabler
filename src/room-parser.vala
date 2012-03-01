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

public class Tabler.RoomParser : GLib.Object {

	public Room? create_from_xml (Xml.Node* node, Arrangement arrangement)
		requires (node->name == "room") {
		var w = node->get_prop ("width");
		var h = node->get_prop ("height");
		var name = node->get_prop ("name");
			
		if (w == null) {
			stderr.printf ("<room/> tag missing \"width\" attribute\n");
			return null;
		}

		if (h == null) {
			stderr.printf ("<room/> tag missing \"height\" attribute\n");
			return null;
		}

		var room = new Room (int.parse (w), int.parse (h));

		if (name != null) {
			room.name = name;
		}

		// loop over the tables
		for (var iter = node->children ; iter != null ; iter = iter->next) {
			// skip whitespaces
			if (iter->type != Xml.ElementType.ELEMENT_NODE) {
				continue;
			}

			if (iter->name != "table") {
				stderr.printf ("Unknown tag %s found in <room/>\n", iter->name);
				continue;
			}

			var parser = new TableParser ();
			var table = parser.create_from_xml (iter, arrangement);
			var x = iter->get_prop ("x");
			var y = iter->get_prop ("y");
			
			if (table != null) {
				if (!room.add_table (table, int.parse (x), int.parse (y))) {
					stderr.printf ("Unable to add table to room\n");
				}
			}
		}
			
		return room;
	}
}
