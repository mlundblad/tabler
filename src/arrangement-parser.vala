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

public errordomain Tabler.ParserError {
	INVALID
}


public class Tabler.ArrangementParser : GLib.Object {

	public Arrangement create_from_xml (Xml.Node* node) throws ParserError
		requires (node->name == "arrangement") {
		var arrangement = new Arrangement ();

		var name = node->get_prop ("name");

		if (name != null) {
			arrangement.name = name;
		}
			
		// we need to parse the guests node before the rooms, so store them
		// to be able to parse them in a defined order below
		Xml.Node* rooms_node = null;
		Xml.Node* guests_node = null;
		
		// loop over the node's children
		for (Xml.Node* iter = node->children ; iter != null ; iter = iter->next) {
			// skip whitespaces
			if (iter->type != Xml.ElementType.ELEMENT_NODE) {
				continue;
			}

			switch (iter->name) {
				case "rooms":
					if (rooms_node == null)
						rooms_node = iter;
					else
						stderr.printf ("Only one instance of the <rooms/> tag" +
						               " is allowed in the <arrangement/> tag" +
						               " ignoring.\n");
					break;
				case "guests":
					if (guests_node == null)
						guests_node = iter;
					else
						stderr.printf ("Only one instance of the <guests/> tag" +
						               " is allowed in the <arrangement/> tag" +
						               " ignoring.\n");
					break;
				default:
					stderr.printf ("Unexpected tag: %s in the <arrangement/> 
					               tag\n", iter->name);
					break;
			}
		}

		// loop over the child nodes of the <guests/> node
		if (guests_node != null) {
			var guest_parser = new GuestParser ();

			for (Xml.Node* iter = guests_node->children ; iter != null ;
			     iter = iter->next) {
				if (iter->type != Xml.ElementType.ELEMENT_NODE) {
					continue;
				}

				if (iter->name != "guest") {
					stderr.printf ("Unexpected tag: %s in the <guests/> tag\n",
					               iter->name);
					continue;
				}

				var guest = guest_parser.create_from_xml (iter);

				if (guest != null) {
					arrangement.add_guest (guest);
				}
			}

			// loop over the guests once again to set up the relations
			// (we need to fully parse the guests first to be able to do the
			//  ID lookup)
			for (Xml.Node* iter = guests_node->children ; iter != null ;
			     iter = iter->next) {
				if (iter->type != Xml.ElementType.ELEMENT_NODE) {
					continue;
				}

				if (iter->name == "guest") {
					for (Xml.Node* iter2 = iter->children ; iter2 != null ;
					     iter2 = iter2->next) {
						if (iter2->type != Xml.ElementType.ELEMENT_NODE) {
							continue;
						}

						var guest = Guest.find_by_id (int.parse (iter->get_prop ("id")));

						if (iter2->name != "relations") {
							stderr.printf ("Unexpected tag: %s in the <guest/> tag\n",
							               iter2->name);
							continue;
						}

						for (Xml.Node* iter3 = iter2->children ; iter3 != null ;
						     iter3 = iter3->next) {
							if (iter3->type != Xml.ElementType.ELEMENT_NODE) {
								continue;
							}

							if (iter3->name != "relation") {
								stderr.printf ("Unexpected tag: %s in the <relations/> tag\n",
								               iter3->name);
								continue;
							}

							var to = Guest.find_by_id (int.parse (iter3->get_prop ("to")));
							                           
							switch (iter3->get_prop ("type")) {
								case "next_to":
									guest.set_relation_to (to, Relation.NEXT_TO);
									break;
								case "near_to":
									guest.set_relation_to (to, Relation.NEAR_TO);
									break;
								case "not_next_to":
									guest.set_relation_to (to, Relation.NOT_NEXT_TO);
									break;
								case "not_near_to":
									guest.set_relation_to (to, Relation.NOT_NEAR_TO);
									break;
								default:
									stderr.printf ("Unknown relation type: %s\n",
									               iter3->get_prop ("type"));
									break;
							}
						}
					}
				}
			}
		}
			
		// loop over the child nodes of the <rooms/> node
		if (rooms_node != null) {
			var room_parser = new RoomParser (); 
			
			for (Xml.Node* iter = rooms_node->children ; iter != null ;
			     iter = iter->next) {
				if (iter->type != Xml.ElementType.ELEMENT_NODE) {
					continue;
				}

				if (iter->name != "room") {
					stderr.printf ("Unexpected tag: %s in the <rooms/> tag\n",
					               iter->name);
					continue;
				}

				var room = room_parser.create_from_xml (iter);

				if (room != null) {
					arrangement.add_room (room);
				}
			}
		}
					

		return arrangement;
	}
}
