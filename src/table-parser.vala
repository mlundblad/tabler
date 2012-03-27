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

public class Tabler.TableParser : GLib.Object {

	public Table? create_from_xml (Xml.Node* node)
		requires (node->name == "table") {
		var type = node->get_prop ("type");

		if (type == null) {
			stderr.printf ("<room/> must have a \"type\" attribute\n");
			return null;
		}

		Table? table = null;
			
		switch (type) {
			case "long":
				var parser = new LongTableParser ();
				table = parser.create_from_xml (node);
				break;
			case "round":
				var parser = new RoundTableParser ();
				table = parser.create_from_xml (node);
				break;
			default:
				stderr.printf ("Unknow table type: %s\n", type);
				break;
		}

		if (table != null) {
			var name = node->get_prop ("name");

			if (name != null) {
				table.name = name;
			}

			// loop over child nodes
			for (var iter = node->children ; iter != null ; iter = iter->next) {
				if (iter->type != Xml.ElementType.ELEMENT_NODE) {
					continue;
				}

				if (iter->name == "guest") {
					var id = iter->get_prop ("id");
					if (id == null) {
						stderr.printf ("<guest/> node must have an \"id\" attribute\n");
						continue;
					}

					var guest = Guest.find_by_id (int.parse (id));
					if (guest == null) {
						stderr.printf ("Guest with id %s not defined in arrangement\n",
						               id);
						continue;
					}

					var position = iter->get_prop ("position");
					if (position == null) {
						stderr.printf ("A guest must have a position on a table\n");
						continue;
					}

					table.insert_guest (guest, int.parse (position));
				}
			}
		}

		return table;
	}

}
