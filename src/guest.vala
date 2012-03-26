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

public class Tabler.Guest : GLib.Object, Tabler.XmlSerializable {

	private static uint next_id = 1;
	
	public uint id { get; private set; }
	public string name { get; set; }
	public Gender gender { get; set; }
	public bool vip { get; set; }
	public bool rsvp { get; set; }
	private Gee.HashMap<Guest, Relation> relations =
		new Gee.HashMap<Guest, Relation> ();
	
    // Constructor
    public Guest (string name, Gender gender = Gender.UNKNOWN,
                  bool vip = false, bool rsvp = false) {
		Object (id: next_id, name: name, gender: gender, vip: vip, rsvp: rsvp);
		next_id++;
    }

	public Guest.with_id (uint id, string name, Gender gender = Gender.UNKNOWN,
	                      bool vip = false, bool rsvp = false) {
		Object (id: id, name: name, gender: gender, vip: vip, rsvp: rsvp);
		next_id++;
	}

	public void set_relation_to (Guest to, Relation relation) {
		relations.set (to, relation);
	}

	public Relation? get_relation_to (Guest to) {
		return relations.get (to);
	}

	public Xml.Node* to_xml () {
		Xml.Node* node = new Xml.Node (null, "guest");

		node->new_prop ("id", id.to_string ());
		node->new_prop ("name", name);
		node->new_prop ("gender",
		                gender == Gender.MALE ? "male" :
			            gender == Gender.FEMALE ? "female" : "unknown");
		node->new_prop ("vip", vip.to_string ());
		node->new_prop ("rsvp", rsvp.to_string ());

		return node;
	}
}
