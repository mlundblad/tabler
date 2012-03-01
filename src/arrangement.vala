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

public class Tabler.Arrangement : GLib.Object, Tabler.XmlSerializable {

	public Gee.HashMap<string, Guest> guests { get; private set; }
	public Gee.List<Room> rooms { get; private set; }

	public string name { get; set; }
	
	public Arrangement () {
		guests = new Gee.HashMap<string, Guest> ();
		rooms = new Gee.ArrayList<Room> ();
	}

	public void add_guest (Guest guest) {
		guests.set (guest.name, guest);
	}

	public void add_room (Room room) {
		rooms.add (room);
	}

	public Xml.Node* to_xml () {
		//TODO: generate real XML here...
		Xml.Node* node = new Xml.Node (null, "arrangement");

		if (name != null && name.length > 0)
			node->new_prop ("name", name);

		// put guest list in a <guests/> element
		Xml.Node* guests_node = node->new_child (null, "guests");

		foreach (var guest in guests.values) {
			guests_node->add_child (guest.to_xml ());
		}

		Xml.Node* rooms_node = node->new_child (null, "rooms");

		foreach (var room in rooms) {
			rooms_node->add_child (room.to_xml ());
		}
		
		return node;
	}
}
